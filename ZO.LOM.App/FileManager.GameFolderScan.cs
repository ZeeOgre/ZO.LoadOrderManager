﻿using System.IO;

namespace ZO.LoadOrderManager
{
    public static partial class FileManager
    {
        public static void ScanGameDirectoryForStrays()
        {
            App.LogDebug("Scan Game Directory For Strays");
            var gameFolder = FileManager.GameFolder;
            var dataFolder = Path.Combine(gameFolder, "data");
            var pluginFiles = Directory.GetFiles(dataFolder, "*.esp")
                .Concat(Directory.GetFiles(dataFolder, "*.esm"))
                .ToList();

            // Dictionary to track the highest ordinal for each group
            var groupOrdinalTracker = new Dictionary<long, long>();

            // HashSet to track processed filenames
            var processedFilenames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            foreach (var pluginFile in pluginFiles)
            {
                var fileInfo = new System.IO.FileInfo(pluginFile);
                var pluginName = fileInfo.Name.ToLowerInvariant();

                // Skip if the filename has already been processed
                if (!processedFilenames.Add(pluginName))
                {
                    continue;
                }

                var dtStamp = fileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");

                var existingPlugin = AggLoadInfo.Instance.Plugins.FirstOrDefault(p => p.PluginName.Equals(pluginName, StringComparison.OrdinalIgnoreCase));

                if (existingPlugin != null)
                {
                    // Update DTStamp and set the installed flag for the existing plugin
                    existingPlugin.DTStamp = dtStamp;
                    existingPlugin.State |= ModState.GameFolder; // Set the installed flag
                    existingPlugin.WriteMod();

                    // Update FileInfo record
                    var existingFileInfo = existingPlugin.Files.FirstOrDefault(f => f.Filename.Equals(pluginName, StringComparison.OrdinalIgnoreCase));
                    if (existingFileInfo != null)
                    {
                        existingFileInfo.DTStamp = dtStamp;
                        existingFileInfo.HASH = ZO.LoadOrderManager.FileInfo.ComputeHash(fileInfo.FullName);
                        existingFileInfo.Flags = FileFlags.None;
                        ZO.LoadOrderManager.FileInfo.InsertFileInfo(existingFileInfo, existingPlugin.PluginID);
                    }
                }
                else
                {
                    // Determine the group ID for the new plugin
                    long groupID = -997; // Unassigned group
                    long groupSetID = 1; // Assign GroupSetID = 1 for Uncategorized group

                    // Fetch or initialize the ordinal for the group
                    if (!groupOrdinalTracker.ContainsKey(groupID))
                    {
                        groupOrdinalTracker[groupID] = DbManager.GetNextOrdinal(EntityType.Plugin, groupID, -1);
                    }

                    // Create a new Plugin object
                    var newPlugin = new Plugin
                    {
                        PluginName = pluginName,
                        DTStamp = dtStamp,
                        GroupID = groupID,
                        GroupSetID = groupSetID,
                        GroupOrdinal = groupOrdinalTracker[groupID], // Assign the next ordinal
                        State = ModState.GameFolder // Set the installed flag
                    };
                    newPlugin.WriteMod();
                    AggLoadInfo.Instance.Plugins.Add(newPlugin);

                    // Increment the ordinal for the group
                    groupOrdinalTracker[groupID]++;

                    // Insert new FileInfo record
                    var newFileInfo = new ZO.LoadOrderManager.FileInfo
                    {
                        Filename = pluginName,
                        DTStamp = dtStamp,
                        HASH = ZO.LoadOrderManager.FileInfo.ComputeHash(fileInfo.FullName),
                        Flags = FileFlags.None
                    };
                    ZO.LoadOrderManager.FileInfo.InsertFileInfo(newFileInfo, newPlugin.PluginID);
                }
            }
        }
    }
}
