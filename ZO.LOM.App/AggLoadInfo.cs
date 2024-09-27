﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data.SQLite;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;

namespace ZO.LoadOrderManager
{
    public class AggLoadInfo : INotifyPropertyChanged
    {
        // Singleton Instance with Lazy Initialization
        private static readonly Lazy<AggLoadInfo> _instance = new Lazy<AggLoadInfo>(() => new AggLoadInfo());
        public static AggLoadInfo Instance => _instance.Value;

        // Observable Collections for core entities
        public ObservableCollection<Plugin> Plugins { get; set; } = new ObservableCollection<Plugin>();
        public ObservableCollection<ModGroup> Groups { get; set; } = new ObservableCollection<ModGroup>();
        public ObservableCollection<LoadOut> LoadOuts { get; set; } = new ObservableCollection<LoadOut>();
        public ObservableCollection<GroupSet> GroupSets { get; set; } = new ObservableCollection<GroupSet>();

        // Collections for GroupSet Mappings and Relationships
        public GroupSetGroupCollection GroupSetGroups { get; set; } = new GroupSetGroupCollection();
        public GroupSetPluginCollection GroupSetPlugins { get; set; } = new GroupSetPluginCollection();
        public ProfilePluginCollection ProfilePlugins { get; set; } = new ProfilePluginCollection();


        // Current active LoadOut and GroupSet
        public LoadOut ActiveLoadOut
        {
            get => _activeLoadOut;
            set
            {
                if (_activeLoadOut != value)
                {
                    _activeLoadOut = value;

                    // Check if the LoadOut is in the collection, and add it if not
                    if (!LoadOuts.Contains(_activeLoadOut))
                    {
                        LoadOuts.Add(_activeLoadOut);
                    }

                    OnPropertyChanged();
                }
            }
        }

        private LoadOut _activeLoadOut;
        public GroupSet ActiveGroupSet
        {
            get => _activeGroupSet;
            set
            {
                if (_activeGroupSet != value)
                {
                    _activeGroupSet = value ?? throw new ArgumentNullException(nameof(value));
                    OnPropertyChanged();
                }
            }
        }


        private GroupSet _activeGroupSet;

        // Boolean flag to indicate initialization state
        private static bool _initialized = false;
        private static readonly object _lock = new object();

        private ObservableCollection<GroupSet>? _cachedGroupSets;
        public ObservableCollection<GroupSet> GetGroupSets()
        {
            if (_cachedGroupSets == null)
            {
                _cachedGroupSets = LoadGroupSetsFromDatabase();
            }
            return _cachedGroupSets;
        }

        // Cached GroupSet 1
        private GroupSet? _cachedGroupSet1;

        // Method to get the cached GroupSet 1
        public GroupSet? GetCachedGroupSet1()
        {
            return _cachedGroupSet1;
        }

        // Private constructor for Singleton pattern
        private AggLoadInfo()
        {
            //_activeLoadOut = new LoadOut();
            //ActiveGroupSet = new GroupSet(0, string.Empty, default);
            PropertyChanged = null;
        }


        // New constructor
        public AggLoadInfo(long groupSetID)
        {
            if (groupSetID == 0)
            {
                // Initialize with core defaults
                ActiveGroupSet = new GroupSet();
                //_cachedGroupSet1 = new GroupSet { GroupSetID = 0 };
                //GroupSetGroups = new GroupSetGroupCollection();
                //GroupSetPlugins = new GroupSetPluginCollection();
                // Add any other core defaults initialization here
                PropertyChanged = null;
            }
            else
            {
                // Load the GroupSet from the database
                ActiveGroupSet = GroupSet.LoadGroupSet(groupSetID) ?? throw new InvalidOperationException("GroupSet not found.");
                InitFromDatabase();
            }
        }


        // Method to initialize from the database
        public void InitFromDatabase()
        {
            if (_initialized) return;
            if (ActiveGroupSet.GroupSetID == 0) return;

            lock (_lock)
            {
                if (_initialized) return;

                Plugins.Clear();
                Groups.Clear();
                LoadOuts.Clear();

                // Re-add the ActiveLoadOut if it exists
                if (_activeLoadOut != null && !LoadOuts.Contains(_activeLoadOut))
                {
                    LoadOuts.Add(_activeLoadOut);
                }

                if (_activeGroupSet != null && !GroupSets.Contains(_activeGroupSet))
                {
                    GroupSets.Add(_activeGroupSet);
                }

                GroupSetGroups.Items.Clear();
                GroupSetPlugins.Items.Clear();
                ProfilePlugins.Items.Clear();

                // Load GroupSets from the database with caching
                GroupSets = GetGroupSets();

                // Avoid reloading if cached GroupSet 1 is already available
                if (_cachedGroupSet1 == null)
                {
                    _cachedGroupSet1 = GroupSet.LoadGroupSet(1);
                    if (_cachedGroupSet1 == null)
                    {
                        App.LogDebug("Failed to load GroupSet 1.");
                        return;
                    }
                    App.LogDebug("GroupSet 1 loaded into cache.");
                }
                using var connection = DbManager.Instance.GetConnection();
                LoadGroupSetState(connection);

                _initialized = true;
            }
        }


        // Load GroupSet data including plugins, groups, and profiles
        private void LoadGroupSetState(SQLiteConnection connection)
        {



            // Load core entities from vwPluginGrpUnion
            using var command = new SQLiteCommand(@"
    SELECT DISTINCT * FROM (
        SELECT *
        FROM vwPluginGrpUnion
        WHERE GroupSetID = @GroupSetID);", connection);
            command.Parameters.AddWithValue("@GroupSetID", ActiveGroupSet.GroupSetID);

            Console.WriteLine($"GroupSetID: {ActiveGroupSet.GroupSetID}");
            Console.WriteLine($"Executing query: {command.CommandText} with GroupSetID = {ActiveGroupSet.GroupSetID}");

            using var reader = command.ExecuteReader();
            var pluginDict = new Dictionary<long, Plugin>();
            var groupDict = new Dictionary<long, ModGroup>();

            while (reader.Read())
            {
                // Load Plugins
                LoadPluginFromReader(reader, pluginDict);

                // Load Groups
                LoadGroupFromReader(reader, groupDict);
            }

            // Check if the loaded groups contain a group with GroupID 1
            if (!groupDict.ContainsKey(1))
            {
                // If not, add a copy of the group with GroupID 1 from the cached GroupSet 1
                var cachedGroup1 = _cachedGroupSet1?.ModGroups.FirstOrDefault(g => g.GroupID == 1);
                if (cachedGroup1 != null)
                {
                    var clonedGroup = cachedGroup1.Clone();
                    Groups.Add(clonedGroup);
                    groupDict[1] = clonedGroup;
                }
            }

            // Associate Plugins with Groups
            foreach (var plugin in pluginDict.Values)
            {
                if (plugin.GroupID.HasValue && groupDict.ContainsKey(plugin.GroupID.Value))
                {
                    var modGroup = groupDict[plugin.GroupID.Value];
                    if (!modGroup.Plugins.Contains(plugin))
                    {
                        modGroup.Plugins.Add(plugin);
                    }
                }
            }

            // Load GroupSetGroups, GroupSetPlugins, and ProfilePlugins for Active GroupSet
            GroupSetGroups.LoadGroupSetGroups(ActiveGroupSet.GroupSetID, connection);
            GroupSetPlugins.LoadGroupSetPlugins(ActiveGroupSet.GroupSetID, connection);
            ProfilePlugins.LoadProfilePlugins(ActiveGroupSet.GroupSetID, connection);

        }

        // Load a plugin from the data reader
        private void LoadPluginFromReader(SQLiteDataReader reader, Dictionary<long, Plugin> pluginDict)
        {
            // Check if PluginID is NULL before proceeding to create a Plugin object
            if (reader.IsDBNull(reader.GetOrdinal("PluginID")))
            {
                // Skip this row since it doesn't contain plugin data
                return;
            }

            // Retrieve PluginID
            var pluginID = reader.GetInt64(reader.GetOrdinal("PluginID"));

            // Check if the plugin already exists in the dictionary
            if (!pluginDict.ContainsKey(pluginID))
            {
                // Create a new Plugin object and populate its properties from the reader
                var plugin = new Plugin
                {
                    PluginID = pluginID,
                    PluginName = reader.GetString(reader.GetOrdinal("PluginName")),
                    Description = reader.IsDBNull(reader.GetOrdinal("PluginDescription")) ? string.Empty : reader.GetString(reader.GetOrdinal("PluginDescription")),
                    Achievements = reader.IsDBNull(reader.GetOrdinal("Achievements")) ? false : reader.GetInt64(reader.GetOrdinal("Achievements")) == 1,
                    DTStamp = reader.IsDBNull(reader.GetOrdinal("DTStamp")) ? string.Empty : reader.GetString(reader.GetOrdinal("DTStamp")),
                    Version = reader.IsDBNull(reader.GetOrdinal("Version")) ? string.Empty : reader.GetString(reader.GetOrdinal("Version")),
                    State = reader.IsDBNull(reader.GetOrdinal("State")) ? ModState.None : (ModState)reader.GetInt64(reader.GetOrdinal("State")),
                    BethesdaID = reader.IsDBNull(reader.GetOrdinal("BethesdaID")) ? string.Empty : reader.GetString(reader.GetOrdinal("BethesdaID")),
                    NexusID = reader.IsDBNull(reader.GetOrdinal("NexusID")) ? string.Empty : reader.GetString(reader.GetOrdinal("NexusID")),
                    GroupID = reader.IsDBNull(reader.GetOrdinal("GroupID")) ? (long?)null : reader.GetInt64(reader.GetOrdinal("GroupID")),
                    GroupOrdinal = reader.IsDBNull(reader.GetOrdinal("GroupOrdinal")) ? (long?)null : reader.GetInt64(reader.GetOrdinal("GroupOrdinal")),
                    GroupSetID = reader.IsDBNull(reader.GetOrdinal("GroupSetID")) ? (long?)null : reader.GetInt64(reader.GetOrdinal("GroupSetID"))
                };

                // Add the plugin to the Plugins collection and dictionary
                Plugins.Add(plugin);
                pluginDict[pluginID] = plugin;
            }
        }



        // Load a group from the data reader
        private void LoadGroupFromReader(SQLiteDataReader reader, Dictionary<long, ModGroup> groupDict)
        {
            var groupID = reader.GetInt64(reader.GetOrdinal("GroupID"));

            // If groupID is less than 1, assign it to GroupSetID 1
            //if (groupID < 1)
            //{
            //    groupID = 1;
            //}

            if (!groupDict.ContainsKey(groupID))
            {
                var modGroup = new ModGroup
                {
                    GroupID = groupID,
                    GroupName = reader.GetString(reader.GetOrdinal("GroupName")),
                    Description = reader.IsDBNull(reader.GetOrdinal("GroupDescription")) ? string.Empty : reader.GetString(reader.GetOrdinal("GroupDescription")),
                    ParentID = reader.IsDBNull(reader.GetOrdinal("ParentID")) ? (long?)null : reader.GetInt64(reader.GetOrdinal("ParentID")),
                    GroupSetID = ActiveGroupSet.GroupSetID,
                    Plugins = new ObservableCollection<Plugin>()
                };

                Groups.Add(modGroup);
                groupDict[groupID] = modGroup;
            }
        }

        // Associate plugins with groups based on the data reader
        private void AssociatePluginsWithGroups(SQLiteDataReader reader, Dictionary<long, Plugin> pluginDict, Dictionary<long, ModGroup> groupDict)
        {
            // Check if PluginID or GroupID is null before proceeding
            if (reader.IsDBNull(reader.GetOrdinal("PluginID")) || reader.IsDBNull(reader.GetOrdinal("GroupID")))
            {
                // If either PluginID or GroupID is null, there's nothing to associate
                return;
            }

            // Retrieve PluginID and GroupID
            var pluginID = reader.GetInt64(reader.GetOrdinal("PluginID"));
            var groupID = reader.GetInt64(reader.GetOrdinal("GroupID"));

            // Check if both plugin and group exist in their respective dictionaries
            if (pluginDict.ContainsKey(pluginID) && groupDict.ContainsKey(groupID))
            {
                var plugin = pluginDict[pluginID];
                var modGroup = groupDict[groupID];

                // Check if the plugin is not already part of the group, then add it
                if (!modGroup.Plugins.Contains(plugin))
                {
                    modGroup.Plugins.Add(plugin);
                }
            }
        }
        public static ObservableCollection<GroupSet> LoadGroupSetsFromDatabase()
        {
            var groupSets = new ObservableCollection<GroupSet>();

            using var connection = DbManager.Instance.GetConnection();
            using var command = new SQLiteCommand("SELECT GroupSetID, GroupSetName, GroupSetFlags FROM GroupSets", connection);
            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                var groupSet = new GroupSet(
                    reader.GetInt64(reader.GetOrdinal("GroupSetID")),
                    reader.GetString(reader.GetOrdinal("GroupSetName")),
                    (GroupFlags)reader.GetInt32(reader.GetOrdinal("GroupSetFlags"))
                );

                groupSets.Add(groupSet);
            }

            return groupSets;
        }


        // Clone method to create a copy of the current AggLoadInfo
        public AggLoadInfo Clone()
        {
            return new AggLoadInfo
            {
                Plugins = new ObservableCollection<Plugin>(this.Plugins),
                Groups = new ObservableCollection<ModGroup>(this.Groups),
                LoadOuts = new ObservableCollection<LoadOut>(this.LoadOuts),
                GroupSetGroups = new GroupSetGroupCollection { Items = new ObservableCollection<(long, long, long?, long)>(this.GroupSetGroups.Items) },
                GroupSetPlugins = new GroupSetPluginCollection { Items = new ObservableCollection<(long, long, long, long)>(this.GroupSetPlugins.Items) },
                ProfilePlugins = new ProfilePluginCollection { Items = new ObservableHashSet<(long ProfileID, long PluginID)>()  },
                ActiveLoadOut = this.ActiveLoadOut,
                ActiveGroupSet = this.ActiveGroupSet
            };
        }

        public void RefreshMetadataFromDB()
        {
            using var connection = DbManager.Instance.GetConnection();
            GroupSetGroups.LoadGroupSetGroups(ActiveGroupSet.GroupSetID, connection);
            GroupSetPlugins.LoadGroupSetPlugins(ActiveGroupSet.GroupSetID, connection);
            ProfilePlugins.LoadProfilePlugins(ActiveGroupSet.GroupSetID, connection);
        }

        // INotifyPropertyChanged implementation
        public event PropertyChangedEventHandler? PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string? propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
