using System.Collections.ObjectModel;
using System.Data.SQLite;

namespace ZO.LoadOrderManager
{
    public class LoadOut
    {
        public int ProfileID { get; set; }
        public required string Name { get; set; }
        public ObservableCollection<PluginViewModel> Plugins { get; set; }
        private HashSet<int> enabledPlugins;

        // Add GroupSet property
        public GroupSet GroupSet { get; set; }

        // Default constructor
        public LoadOut()
        {
            Plugins = new ObservableCollection<PluginViewModel>();
            enabledPlugins = new HashSet<int>();

            // Load GroupSet with ID 2 or initialize with a new GroupSet if not found
            GroupSet = GroupSet.LoadGroupSet(2) ?? GroupSet.CreateEmptyGroupSet();
            if (GroupSet.GroupSetID != 2)
            {
                GroupSet.GroupSetName = $"{Name}_Groupset_{GroupSet.GroupSetID}";
            }
        }

        // Parameterized constructor
        public LoadOut(GroupSet groupSet)
        {
            Plugins = new ObservableCollection<PluginViewModel>();
            enabledPlugins = new HashSet<int>();

            // Use the provided GroupSet
            GroupSet = groupSet;
        }

        

        public void LoadPlugins(IEnumerable<Plugin> plugins)
        {
            foreach (var plugin in plugins)
            {
                var pluginViewModel = new PluginViewModel(plugin, this);
                Plugins.Add(pluginViewModel);
            }
        }

        public static LoadOut Load(int loadOutID)
        {
            App.LogDebug("Loading profile from database");
            using var connection = DbManager.Instance.GetConnection();

            App.LogDebug("LoadOut Begin Transaction");
            using var transaction = connection.BeginTransaction();
            try
            {
                LoadOut loadOut = null;

                // Load LoadOutProfiles
                using (var command = new SQLiteCommand("SELECT * FROM LoadOutProfiles WHERE ProfileID = @ProfileID", connection))
                {
                    command.Parameters.AddWithValue("@ProfileID", loadOutID);
                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            var groupSetID = reader.GetInt32(reader.GetOrdinal("GroupSetID"));
                            var groupSet = GroupSet.LoadGroupSet(groupSetID) ?? GroupSet.LoadGroupSet(1) ?? GroupSet.CreateEmptyGroupSet();

                            loadOut = new LoadOut
                            {
                                ProfileID = reader.GetInt32(reader.GetOrdinal("ProfileID")),
                                Name = reader.GetString(reader.GetOrdinal("ProfileName")),
                                GroupSet = groupSet
                            };

                            // If a new GroupSet was created, set its name
                            if (groupSet.GroupSetID == 0)
                            {
                                groupSet.GroupSetName = $"{loadOut.Name}_GroupSet_{groupSet.GroupSetID}";
                            }
                        }
                        else
                        {
                            throw new InvalidOperationException($"LoadOut with ID {loadOutID} not found.");
                        }
                    }
                }

                // Load ProfilePlugins
                using (var command = new SQLiteCommand("SELECT PluginID FROM ProfilePlugins WHERE ProfileID = @ProfileID", connection))
                {
                    command.Parameters.AddWithValue("@ProfileID", loadOutID);
                    using (var reader = command.ExecuteReader())
                    {
                        var plugins = new List<PluginViewModel>();
                        while (reader.Read())
                        {
                            var pluginID = reader.GetInt32(reader.GetOrdinal("PluginID"));
                            var plugin = Plugin.LoadPlugin(pluginID);
                            if (plugin != null)
                            {
                                plugins.Add(new PluginViewModel(plugin, loadOut) { IsEnabled = true });
                            }
                        }
                        loadOut.Plugins = new ObservableCollection<PluginViewModel>(plugins);
                    }
                }

                // Commit the transaction
                App.LogDebug("LoadOut Commit Transaction");
                transaction.Commit();
                return loadOut;
            }
            catch (Exception ex)
            {
                App.LogDebug("Error loading profile from database", ex.ToString());
                transaction.Rollback();
                throw;
            }
        }

    
    public int WriteProfile()
        {
            App.LogDebug("Writing profile to database");
            using var connection = DbManager.Instance.GetConnection();

            App.LogDebug("LoadOut Begin Transaction");
            using var transaction = connection.BeginTransaction();
            try
            {
                using (var command = new SQLiteCommand(connection))
                {
                    App.LogDebug($"Updating LoadOutProfiles table for {this.Name}");
                    // Update the LoadOutProfiles table
                    command.CommandText = @"
                                    INSERT OR REPLACE INTO LoadOutProfiles (ProfileID, ProfileName, GroupSetID)
                                    VALUES (@ProfileID, @ProfileName, @GroupSetID)";
                    command.Parameters.AddWithValue("@ProfileID", this.ProfileID);
                    command.Parameters.AddWithValue("@ProfileName", this.Name);
                    command.Parameters.AddWithValue("@GroupSetID", this.GroupSet.GroupSetID);
                    command.ExecuteNonQuery();

                    // Insert or replace ProfilePlugins entries
                    command.CommandText = @"
                                    INSERT OR REPLACE INTO ProfilePlugins (ProfileID, PluginID)
                                    VALUES (@ProfileID, @PluginID)";
                    foreach (var plugin in this.Plugins.Where(p => p.IsEnabled))
                    {
                        App.LogDebug($"Updating ProfilePlugins table for {plugin.Plugin.PluginID}");
                        command.Parameters.Clear();
                        command.Parameters.AddWithValue("@ProfileID", this.ProfileID);
                        command.Parameters.AddWithValue("@PluginID", plugin.Plugin.PluginID);
                        command.ExecuteNonQuery();
                    }

                    // Remove any ProfilePlugins entries not in ActivePlugins
                    var activePluginIds = this.Plugins.Where(p => p.IsEnabled).Select(p => p.Plugin.PluginID).ToArray();
                    var activePluginsList = string.Join(",", activePluginIds);
                    App.LogDebug($"Removing ProfilePlugins entries not in ActivePlugins: {activePluginsList}");
                    command.CommandText = $@"
                                    DELETE FROM ProfilePlugins
                                    WHERE ProfileID = @ProfileID AND PluginID NOT IN ({activePluginsList})";
                    command.Parameters.Clear();
                    command.Parameters.AddWithValue("@ProfileID", this.ProfileID);
                    command.ExecuteNonQuery();
                }

                // Save the GroupSet


                App.LogDebug("LoadOut Commit Transaction");
                transaction.Commit();
                //GroupSet.SaveGroupSet();
                return this.ProfileID;
            }
            catch (Exception ex)
            {
                App.LogDebug("Error writing profile to database", ex.ToString());
                transaction.Rollback();
                throw;
            }
        }

        public static void SetPluginEnabled(int profileID, int pluginID, bool isEnabled)
        {
            using var connection = DbManager.Instance.GetConnection();

            using var command = new SQLiteCommand(connection);
            if (isEnabled)
            {
                command.CommandText = @"
                                INSERT OR IGNORE INTO ProfilePlugins (ProfileID, PluginID)
                                VALUES (@ProfileID, @PluginID)";
            }
            else
            {
                command.CommandText = @"
                                DELETE FROM ProfilePlugins
                                WHERE ProfileID = @ProfileID AND PluginID = @PluginID";
            }
            command.Parameters.AddWithValue("@ProfileID", profileID);
            command.Parameters.AddWithValue("@PluginID", pluginID);
            command.ExecuteNonQuery();
        }

        public static IEnumerable<PluginViewModel> GetActivePlugins(int profileId)
        {
            var loadOut = AggLoadInfo.Instance.LoadOuts.FirstOrDefault(l => l.ProfileID == profileId);
            if (loadOut != null)
            {
                return loadOut.Plugins;
            }
            return Enumerable.Empty<PluginViewModel>();
        }

        public void UpdateEnabledPlugins()
        {
            enabledPlugins.Clear();
            foreach (var plugin in Plugins.Where(p => p.IsEnabled))
            {
                enabledPlugins.Add(plugin.Plugin.PluginID);
            }
        }

        public bool IsPluginEnabled(int pluginID)
        {
            return enabledPlugins.Contains(pluginID);
        }
    }
}
