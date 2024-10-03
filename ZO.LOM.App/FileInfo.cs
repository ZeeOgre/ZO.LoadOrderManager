using System.Data.SQLite;
using System.IO;
using System.Net.NetworkInformation;
using System.Security.Cryptography;
using System.Windows;

namespace ZO.LoadOrderManager
{

    [Flags]
    public enum FileFlags
    {
        None = 0,
        IsArchive = 1,
        IsMonitored = 2,
        IsJunction = 4
    }

    public class FileInfo
    {
        public long FileID { get; set; }
        public string Filename { get; set; }
        public string? RelativePath { get; set; }
        public string DTStamp { get; set; }
        public string? HASH { get; set; }
        public FileFlags Flags { get; set; }
        public string AbsolutePath { get; set; }

        public FileInfo()
        {
            Filename = string.Empty; // Initialize with default value
            DTStamp = DateTime.Now.ToString("o"); // Initialize with current timestamp
            AbsolutePath = string.Empty;
        }

        public FileInfo(string filename)
        {
            Filename = filename.ToLowerInvariant();
            RelativePath = null;
            DTStamp = DateTime.Now.ToString("o");
            HASH = null;
            Flags = FileFlags.None;
            AbsolutePath = filename;
        }

        public FileInfo(System.IO.FileInfo fileInfo, string gameFolderPath)
        {
            Filename = fileInfo.Name.ToLowerInvariant();
            RelativePath = Path.GetRelativePath(Path.Combine(gameFolderPath, "data"), fileInfo.FullName);
            DTStamp = fileInfo.LastWriteTime.ToString("o");
            HASH = ComputeHash(fileInfo.FullName);
            Flags = CheckFileFlags(fileInfo);
            AbsolutePath = Flags.HasFlag(FileFlags.IsJunction) ? GetJunctionTarget(fileInfo.FullName) : fileInfo.FullName;
        }

        private FileFlags CheckFileFlags(System.IO.FileInfo fileInfo)
        {
            FileFlags flags = FileFlags.None;

            if (CheckIfArchive(fileInfo.Name))
            {
                flags |= FileFlags.IsArchive;
            }

            if (CheckIfJunction(fileInfo.FullName))
            {
                flags |= FileFlags.IsJunction;
            }

            // Add logic to check if the file is monitored and set the flag accordingly
            // if (IsMonitoredFile(fileInfo.FullName))
            // {
            //     flags |= FileFlags.IsMonitored;
            // }

            return flags;
        }

        private bool CheckIfArchive(string filename)
        {
            string extension = Path.GetExtension(filename).ToLowerInvariant();
            return extension == ".rar" || extension == ".zip" || extension == ".7z" || extension == ".ba2";
        }

        private bool CheckIfJunction(string filePath)
        {
            var fileInfo = new System.IO.FileInfo(filePath);
            return fileInfo.Attributes.HasFlag(FileAttributes.ReparsePoint);
        }

        private string GetJunctionTarget(string junctionPath)
        {
            const int FILE_FLAG_BACKUP_SEMANTICS = 0x02000000;
            const int OPEN_EXISTING = 3;
            const int FILE_SHARE_READ = 1;
            const int FILE_SHARE_WRITE = 2;
            const int FILE_SHARE_DELETE = 4;

            IntPtr handle = CreateFile(junctionPath, 0, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, IntPtr.Zero, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, IntPtr.Zero);
            if (handle == INVALID_HANDLE_VALUE)
            {
                throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
            }

            try
            {
                StringBuilder path = new StringBuilder(512);
                int result = GetFinalPathNameByHandle(handle, path, path.Capacity, 0);
                if (result == 0)
                {
                    throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
                }

                // Remove the "\\?\" prefix
                if (path.Length > 4 && path.ToString().StartsWith(@"\\?\"))
                {
                    return path.ToString().Substring(4);
                }

                return path.ToString();
            }
            finally
            {
                CloseHandle(handle);
            }
        }

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern IntPtr CreateFile(
            string lpFileName,
            uint dwDesiredAccess,
            uint dwShareMode,
            IntPtr lpSecurityAttributes,
            uint dwCreationDisposition,
            uint dwFlagsAndAttributes,
            IntPtr hTemplateFile);

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern bool CloseHandle(IntPtr hObject);

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern int GetFinalPathNameByHandle(IntPtr hFile, StringBuilder lpszFilePath, int cchFilePath, int dwFlags);

        private static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);

        public static string ComputeHash(string filePath)
        {
            using var sha256 = SHA256.Create();
            using var stream = System.IO.File.OpenRead(filePath);
            var hashBytes = sha256.ComputeHash(stream);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
        }

        public override string ToString()
        {
            return $"FileID: {FileID}, Filename: {Filename}, RelativePath: {RelativePath}, DTStamp: {DTStamp}, HASH: {HASH}, Flags: {Flags}, AbsolutePath: {AbsolutePath}";
        }

        public List<FileInfo> LoadFilesByPlugin(long pluginId)
        {
            var fileInfos = new List<FileInfo>();

            using var connection = DbManager.Instance.GetConnection();
            connection.Open();

            using (var pragmaCommand = new SQLiteCommand("PRAGMA read_uncommitted = true;", connection))
            {
                pragmaCommand.ExecuteNonQuery();
            }

            using var command = new SQLiteCommand(
                "SELECT FileID, Filename, RelativePath, DTStamp, HASH, Flags, AbsolutePath " +
                "FROM vwPluginFiles WHERE PluginID = @PluginID", connection);

            _ = command.Parameters.AddWithValue("@PluginID", pluginId);

            using var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var fileInfo = new FileInfo
                {
                    FileID = reader.GetInt64(0),
                    Filename = reader.GetString(1),
                    RelativePath = reader.IsDBNull(2) ? null : reader.GetString(2),
                    DTStamp = reader.GetString(3),
                    HASH = reader.IsDBNull(4) ? null : reader.GetString(4),
                    Flags = (FileFlags)reader.GetInt32(5),
                    AbsolutePath = reader.GetString(6)
                };
                fileInfos.Add(fileInfo);
            }

            return fileInfos;
        }

        public static void InsertFileInfo(FileInfo fileInfo, long pluginId)
        {
            using var connection = DbManager.Instance.GetConnection();

#if WINDOWS
            App.LogDebug($"Fileinfo Begin Transaction");
#endif

            using var transaction = connection.BeginTransaction();

            try
            {
                using var command = new SQLiteCommand(connection);
                if (fileInfo.FileID == 0)
                {
                    command.CommandText = @"
                            INSERT INTO FileInfo (PluginID, Filename, RelativePath, DTStamp, HASH, Flags, AbsolutePath)
                            VALUES (@PluginID, @Filename, @RelativePath, @DTStamp, @HASH, @Flags, @AbsolutePath)
                            ON CONFLICT(Filename) DO UPDATE 
                            SET RelativePath = COALESCE(excluded.RelativePath, FileInfo.RelativePath), 
                                DTStamp = COALESCE(excluded.DTStamp, FileInfo.DTStamp), 
                                HASH = COALESCE(excluded.HASH, FileInfo.HASH), 
                                Flags = excluded.Flags,
                                AbsolutePath = excluded.AbsolutePath";

                    command.Parameters.AddWithValue("@PluginID", pluginId);
                    command.Parameters.AddWithValue("@Filename", fileInfo.Filename);
                    command.Parameters.AddWithValue("@RelativePath", fileInfo.RelativePath ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@DTStamp", fileInfo.DTStamp);
                    command.Parameters.AddWithValue("@HASH", fileInfo.HASH ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Flags", (int)fileInfo.Flags);
                    command.Parameters.AddWithValue("@AbsolutePath", fileInfo.AbsolutePath);

                    fileInfo.FileID = Convert.ToInt64(command.ExecuteScalar());
                }
                else
                {
                    command.CommandText = @"
                        UPDATE FileInfo
                        SET PluginID = @PluginID,
                            Filename = @Filename,
                            RelativePath = @RelativePath,
                            DTStamp = COALESCE(@DTStamp, DTStamp),
                            HASH = COALESCE(@HASH, HASH),
                            Flags = @Flags,
                            AbsolutePath = @AbsolutePath
                        WHERE FileID = @FileID";

                    command.Parameters.AddWithValue("@FileID", fileInfo.FileID);
                    command.Parameters.AddWithValue("@PluginID", pluginId);
                    command.Parameters.AddWithValue("@Filename", fileInfo.Filename);
                    command.Parameters.AddWithValue("@RelativePath", fileInfo.RelativePath ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@DTStamp", fileInfo.DTStamp);
                    command.Parameters.AddWithValue("@HASH", fileInfo.HASH ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Flags", (int)fileInfo.Flags);
                    command.Parameters.AddWithValue("@AbsolutePath", fileInfo.AbsolutePath);

                    command.ExecuteNonQuery();
                }

#if WINDOWS
                App.LogDebug($"Fileinfo Commit Transaction");
#endif

                transaction.Commit();
            }
            catch (Exception ex)
            {
#if WINDOWS
                App.LogDebug($"Error inserting/updating file info: {ex.Message}");
#endif
                transaction.Rollback();
                throw;
            }
        }

        public override bool Equals(object obj)
        {
            if (obj is FileInfo other)
            {
                return this.FileID == other.FileID || this.Filename == other.Filename || this.HASH == other.HASH;
            }

            return false;
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hash = 17;
                hash = hash * 23 + FileID.GetHashCode();
                hash = hash * 23 + Filename.GetHashCode();
                hash = hash * 23 + (HASH?.GetHashCode() ?? 0);
                return hash;
            }
        }
    }
}

