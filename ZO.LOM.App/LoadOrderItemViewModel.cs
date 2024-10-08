﻿using System.Collections.ObjectModel;
using ZO.LoadOrderManager;

public class LoadOrderItemViewModel : ViewModelBase
{
    private long groupID;
    private long? parentID;
    private string displayName = string.Empty;
    private EntityType entityType;
    private Plugin pluginData = new Plugin();
    private bool isActive;
    private ObservableCollection<LoadOrderItemViewModel> children = new ObservableCollection<LoadOrderItemViewModel>();

    private bool isSelected;

    public bool IsSelected
    {
        get => isSelected;
        set => SetProperty(ref isSelected, value);
    }

    public long GroupID
    {
        get => groupID;
        set => SetProperty(ref groupID, value);
    }

    public long? ParentID
    {
        get => parentID;
        set => SetProperty(ref parentID, value);
    }

    public string DisplayName
    {
        get => displayName;
        set => SetProperty(ref displayName, value);
    }

    public EntityType EntityType
    {
        get => entityType;
        set => SetProperty(ref entityType, value);
    }

    public Plugin PluginData
    {
        get => pluginData;
        set => SetProperty(ref pluginData, value);
    }



    public bool IsActive
    {
        get => isActive;
        set => SetProperty(ref isActive, value);

    }

    // ObservableCollection to hold child items
    public ObservableCollection<LoadOrderItemViewModel> Children
    {
        get => children;
        set => SetProperty(ref children, value);
    }

    // Constructor for group items
    public LoadOrderItemViewModel(ModGroup group)
    {
        GroupID = group.GroupID ?? throw new ArgumentNullException(nameof(group.GroupID), "GroupID cannot be null");
        ParentID = group.ParentID;
        DisplayName = group.DisplayName;
        EntityType = EntityType.Group;
    }

    // Constructor for plugin items
    public LoadOrderItemViewModel(Plugin plugin)
    {
        GroupID = plugin.GroupID ?? throw new ArgumentNullException(nameof(plugin.GroupID), "GroupID cannot be null");
        DisplayName = plugin.PluginName;
        ParentID = plugin.GroupID;
        PluginData = plugin;
        EntityType = EntityType.Plugin;
    }

    public LoadOrderItemViewModel()
    {
        // Default constructor
    }

    // Retrieve the ModGroup associated with this item using the GroupID
    public ModGroup? GetModGroup()
    {
        ModGroup? group = AggLoadInfo.Instance.Groups.FirstOrDefault(g => g.GroupID == GroupID);
        group.Ordinal = group.Ordinal;
        return group;
    }

    // Retrieve the parent ModGroup associated with this item using the ParentID
    public ModGroup? GetParentGroup()
    {
        if (!ParentID.HasValue) return null;

        return AggLoadInfo.Instance.Groups.FirstOrDefault(g => g.GroupID == ParentID.Value);
    }

    private bool _isHighlighted;

    public bool IsHighlighted
    {
        get => _isHighlighted;
        set
        {
            if (_isHighlighted != value)
            {
                _isHighlighted = value;
                OnPropertyChanged(nameof(IsHighlighted));
            }
        }
    }

    public override string ToString()
    {
        if (PluginData != null)
        {
            return PluginData.ToString();
        }
        else
        {
            var group = GetModGroup();
            return group != null ? group.ToString() : base.ToString();
        }
    }


    public void HighlightSearchResults(string searchTerm)
    {
        if (string.IsNullOrWhiteSpace(searchTerm))
        {
            IsHighlighted = false;
            foreach (var child in Children)
            {
                child.HighlightSearchResults(searchTerm);
            }
            return;
        }

        IsHighlighted = DisplayName.Contains(searchTerm, StringComparison.OrdinalIgnoreCase);
        foreach (var child in Children)
        {
            child.HighlightSearchResults(searchTerm);
        }
    }


    public override bool Equals(object? obj)
    {
        if (obj is LoadOrderItemViewModel other)
        {
            // First, compare GroupID and EntityType for an early break
            if (this.GroupID != other.GroupID || this.EntityType != other.EntityType)
            {
                return false; // Early exit if GroupID or EntityType don't match
            }

            // If GroupID and EntityType match, compare PluginData (if applicable)
            if (this.PluginData != null && other.PluginData != null)
            {
                return this.PluginData.PluginID == other.PluginData.PluginID;
            }

            // If PluginData is null, fallback to GroupID and EntityType comparison (already matched)
            return true;
        }
        else if (obj is Plugin plugin)
        {
            // Compare against a Plugin object directly based on PluginID
            return this.PluginData != null && this.PluginData.PluginID == plugin.PluginID;
        }
        else if (obj is ModGroup modGroup)
        {
            // Compare against a ModGroup object based on GroupID
            return this.GroupID == modGroup.GroupID;
        }

        return false;
    }

    public override int GetHashCode()
    {
        unchecked
        {
            int hash = 17;
            hash = hash * 23 + GroupID.GetHashCode();
            hash = hash * 23 + EntityType.GetHashCode();
            if (PluginData != null)
            {
                hash = hash * 23 + PluginData.PluginID.GetHashCode();
            }
            return hash;
        }
    }

}
