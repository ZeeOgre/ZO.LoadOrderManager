using Microsoft.Win32;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Timers;
using System.Windows;
using System.Windows.Input;
using ZO.LoadOrderManager;
using Timer = System.Timers.Timer;

namespace ZO.LoadOrderManager
{
    public partial class LoadOrderWindowViewModel : INotifyPropertyChanged
    {
        public ICommand RefreshDataCommand { get; }


        public LoadOrderWindowViewModel()
        {
            _selectedGroupSet = AggLoadInfo.Instance.ActiveGroupSet;
            _selectedLoadOut = AggLoadInfo.Instance.ActiveLoadOut;


            // Initialize collections and commands
            Items = new ObservableCollection<LoadOrderItemViewModel>();
            GroupSets = new ObservableCollection<GroupSet>();
            LoadOuts = new ObservableCollection<LoadOut>();
            LoadOrders = SortingHelper.CreateLoadOrdersViewModel(AggLoadInfo.Instance.ActiveGroupSet, AggLoadInfo.Instance.ActiveLoadOut, false);
            CachedGroupSetLoadOrders = SortingHelper.CreateLoadOrdersViewModel(AggLoadInfo.Instance.GetCachedGroupSet1(), LoadOut.Load(1), true); ;

            // Initialize commands
            SearchCommand = new RelayCommand<string?>(Search);
            MoveUpCommand = new RelayCommand<object?>(param => MoveUp(), param => CanMoveUp());
            MoveDownCommand = new RelayCommand<object?>(param => MoveDown(), param => CanMoveDown());
            SaveAsNewLoadoutCommand = new RelayCommand<object?>(param => SaveAsNewLoadout());
            OpenGameFolderCommand = new RelayCommand<object?>(param => OpenGameFolder(), _ => true);
            OpenGameSaveFolderCommand = new RelayCommand<object?>(param => OpenGameSaveFolder(), _ => true);
            EditPluginsCommand = new RelayCommand<object?>(param => EditPlugins(), _ => true);
            EditContentCatalogCommand = new RelayCommand<object?>(param => EditContentCatalog(), _ => true);
            ImportContextCatalogCommand = new RelayCommand<object?>(param => ImportContextCatalog());
            SavePluginsCommand = new RelayCommand(param => SavePlugins(), param => CanSavePlugins());
            EditHighlightedItemCommand = new RelayCommand<object?>(param => EditHighlightedItem());
            OpenAppDataFolderCommand = new RelayCommand<object?>(param => OpenAppDataFolder(), _ => true);
            OpenGameLocalAppDataCommand = new RelayCommand<object?>(param => OpenGameLocalAppData(), _ => true);
            SettingsWindowCommand = new RelayCommand<object?>(param => SettingsWindow(), _ => true);
            ImportFromYamlCommand = new RelayCommand<object?>(param => ImportFromYaml());
            OpenGameSettingsCommand = new RelayCommand<object?>(param => OpenGameSettings(), _ => true);
            OpenPluginEditorCommand = new RelayCommand<object?>(param => OpenPluginEditor());
            OpenGroupEditorCommand = new RelayCommand<object?>(param => OpenGroupEditor());
            RefreshDataCommand = new RelayCommand<object?>(param => RefreshData(), _ => true);
            CopyTextCommand = new RelayCommand<object?>(param => CopyText(), param => CanExecuteCopyText(null));
            DeleteCommand = new RelayCommand<object?>(param => Delete(), param => CanExecuteDelete(null));
            EditCommand = new RelayCommand<object?>(param => EditHighlightedItem(), param => CanExecuteEdit(null));
            ToggleEnableCommand = new RelayCommand<object>(ToggleEnable, CanExecuteToggleEnable);
            ChangeGroupCommand = new RelayCommandWithParameter(ChangeGroup, CanExecuteChangeGroup);

            // Load initial data
            LoadInitialData();
        }

        private void LoadInitialData()
        {
            if (_isInitialDataLoaded)
            {
                return;
            }

            InitializationManager.StartInitialization(nameof(LoadOrderWindowViewModel));
            try
            {
                if (AggLoadInfo.Instance != null)
                {
                    // Clear existing items and select active GroupSet and LoadOut
                    Items.Clear();
                    GroupSets.Clear();
                    LoadOuts.Clear();

                    foreach (var groupSet in AggLoadInfo.Instance.GroupSets)
                    {
                        GroupSets.Add(groupSet);
                    }

                    foreach (var loadOut in AggLoadInfo.Instance.LoadOuts)
                    {
                        LoadOuts.Add(loadOut);
                    }
                    //_selectedGroupSet = AggLoadInfo.Instance.ActiveGroupSet;
                    //_selectedLoadOut = AggLoadInfo.Instance.ActiveLoadOut;




                    InitializationManager.ReportProgress(95, "Initial data loaded into view");

                    StatusMessage = $"Loaded plugins for profile: {SelectedLoadOut.Name}";
                    UpdateStatus(StatusMessage);

                    _isInitialDataLoaded = true;
                }
            }
            finally
            {
                InitializationManager.EndInitialization(nameof(LoadOrderWindowViewModel));
                // Refresh data in the view
                //RefreshData();
            }
        }

        private LoadOrderItemViewModel CreateGroupViewModel(ModGroup group)
        {
            return new LoadOrderItemViewModel(group);
        }

        private async void RefreshData()
        {
            if (InitializationManager.IsAnyInitializing()) return;

            UpdateStatus("Refreshing data...");

            if (SelectedLoadOut != null && ! _isSynchronizing)
            {


                
                _isSynchronizing = true;
                // Using async to improve performance and avoid blocking the UI
                await Task.Run(() =>
                {
                    LoadOrders = SortingHelper.CreateLoadOrdersViewModel(SelectedGroupSet, SelectedLoadOut, false);
                });


                    //    // Directly using the enabledPlugins hashset from SelectedLoadOut
                    //    var enabledPluginIds = SelectedLoadOut.enabledPlugins;

                    //    Items.Clear();
                    //    foreach (var group in AggLoadInfo.Instance.Groups)
                    //    {
                    //        var groupViewModel = CreateGroupViewModel(group);

                    //        foreach (var plugin in group.Plugins ?? Enumerable.Empty<Plugin>())
                    //        {
                    //            var isEnabled = enabledPluginIds.Contains(plugin.PluginID); // Simplified check
                    //            groupViewModel.Children.Add(new LoadOrderItemViewModel
                    //            {
                    //                PluginData = plugin,
                    //                IsActive = isEnabled,
                    //                EntityType = EntityType.Plugin
                    //            });
                    //        }
                    //        Items.Add(groupViewModel);
                    //    }
                    //});

                    StatusMessage = $"Loaded plugins for profile: {SelectedLoadOut.Name}";
            }
            else
            {
                StatusMessage = "No LoadOut selected.";
            }
            _isSynchronizing = false;

            UpdateStatus(StatusMessage);
        }
    }
}