﻿using System;
using System.Collections.ObjectModel;
using System.Data.SQLite;

namespace ZO.LoadOrderManager
{
    public class GroupSetGroupCollection
    {
        public ObservableCollection<(int GroupID, int GroupSetID, int? ParentID, int Ordinal)> Items { get; set; }

        public GroupSetGroupCollection()
        {
            Items = new ObservableCollection<(int, int, int?, int)>();
        }

        // Load data from the database for a specific GroupSetID
        public void LoadGroupSetGroups(int groupSetID, SQLiteConnection connection)
        {
            try
            {
                Items.Clear();

                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                SELECT GroupID, GroupSetID, ParentID, Ordinal
                FROM GroupSetGroups
                WHERE GroupSetID = @GroupSetID";
                command.Parameters.AddWithValue("@GroupSetID", groupSetID);

                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var groupID = reader.GetInt32(0);
                    var grpSetID = reader.GetInt32(1);
                    var parentID = reader.IsDBNull(2) ? (int?)null : reader.GetInt32(2);
                    var ordinal = reader.GetInt32(3);

                    Items.Add((groupID, grpSetID, parentID, ordinal));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading GroupSetGroups: {ex.Message}");
            }
        }

        // Write or update an entry in the database
        public void WriteGroupSetGroup(int groupID, int groupSetID, int? parentID, int ordinal, SQLiteConnection connection)
        {
            try
            {
                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                INSERT INTO GroupSetGroups (GroupID, GroupSetID, ParentID, Ordinal)
                VALUES (@GroupID, @GroupSetID, @ParentID, @Ordinal)
                ON CONFLICT(GroupID, GroupSetID) DO UPDATE 
                SET ParentID = COALESCE(@ParentID, ParentID),
                    Ordinal = COALESCE(@Ordinal, Ordinal);";

                command.Parameters.AddWithValue("@GroupID", groupID);
                command.Parameters.AddWithValue("@GroupSetID", groupSetID);
                command.Parameters.AddWithValue("@ParentID", (object?)parentID ?? DBNull.Value);
                command.Parameters.AddWithValue("@Ordinal", ordinal);

                command.ExecuteNonQuery();
                Console.WriteLine($"GroupSetGroup written to database: GroupID = {groupID}, GroupSetID = {groupSetID}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing GroupSetGroup: {ex.Message}");
            }
        }
    }

    public class GroupSetPluginCollection
    {
        public ObservableCollection<(int GroupSetID, int GroupID, int PluginID, int Ordinal)> Items { get; set; }

        public GroupSetPluginCollection()
        {
            Items = new ObservableCollection<(int, int, int, int)>();
        }

        // Load data from the database for a specific GroupSetID
        public void LoadGroupSetPlugins(int groupSetID, SQLiteConnection connection)
        {
            try
            {
                Items.Clear();

                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                SELECT GroupSetID, GroupID, PluginID, Ordinal
                FROM GroupSetPlugins
                WHERE GroupSetID = @GroupSetID";
                command.Parameters.AddWithValue("@GroupSetID", groupSetID);

                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var grpSetID = reader.GetInt32(0);
                    var groupID = reader.GetInt32(1);
                    var pluginID = reader.GetInt32(2);
                    var ordinal = reader.GetInt32(3);

                    Items.Add((grpSetID, groupID, pluginID, ordinal));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading GroupSetPlugins: {ex.Message}");
            }
        }

        // Write or update an entry in the database
        public void WriteGroupSetPlugin(int groupSetID, int groupID, int pluginID, int ordinal, SQLiteConnection connection)
        {
            try
            {
                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                INSERT INTO GroupSetPlugins (GroupSetID, GroupID, PluginID, Ordinal)
                VALUES (@GroupSetID, @GroupID, @PluginID, @Ordinal)
                ON CONFLICT(GroupSetID, GroupID, PluginID) DO UPDATE 
                SET Ordinal = COALESCE(@Ordinal, Ordinal);";

                command.Parameters.AddWithValue("@GroupSetID", groupSetID);
                command.Parameters.AddWithValue("@GroupID", groupID);
                command.Parameters.AddWithValue("@PluginID", pluginID);
                command.Parameters.AddWithValue("@Ordinal", ordinal);

                command.ExecuteNonQuery();
                Console.WriteLine($"GroupSetPlugin written to database: GroupSetID = {groupSetID}, GroupID = {groupID}, PluginID = {pluginID}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing GroupSetPlugin: {ex.Message}");
            }
        }
    }

    public class ProfilePluginCollection
    {
        public ObservableCollection<(int ProfileID, int PluginID)> Items { get; set; }

        public ProfilePluginCollection()
        {
            Items = new ObservableCollection<(int, int)>();
        }

        // Load data from the database for all profiles associated with a specific GroupSetID
        public void LoadProfilePlugins(int groupSetID, SQLiteConnection connection)
        {
            try
            {
                Items.Clear();

                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                SELECT pp.ProfileID, pp.PluginID
                FROM ProfilePlugins pp
                INNER JOIN LoadOutProfiles lp ON pp.ProfileID = lp.ProfileID
                WHERE lp.GroupSetID = @GroupSetID";
                command.Parameters.AddWithValue("@GroupSetID", groupSetID);

                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var profileID = reader.GetInt32(0);
                    var pluginID = reader.GetInt32(1);

                    Items.Add((profileID, pluginID));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading ProfilePlugins: {ex.Message}");
            }
        }

        // Write or update an entry in the database
        public void WriteProfilePlugin(int profileID, int pluginID, SQLiteConnection connection)
        {
            try
            {
                using var command = new SQLiteCommand(connection);
                command.CommandText = @"
                INSERT INTO ProfilePlugins (ProfileID, PluginID)
                VALUES (@ProfileID, @PluginID)
                ON CONFLICT(ProfileID, PluginID) DO NOTHING;"; // No updates on conflict

                command.Parameters.AddWithValue("@ProfileID", profileID);
                command.Parameters.AddWithValue("@PluginID", pluginID);

                command.ExecuteNonQuery();
                Console.WriteLine($"ProfilePlugin written to database: ProfileID = {profileID}, PluginID = {pluginID}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing ProfilePlugin: {ex.Message}");
            }
        }
    }
}