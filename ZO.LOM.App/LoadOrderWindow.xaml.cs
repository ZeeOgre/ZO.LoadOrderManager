using Microsoft.Win32;
using System.Collections.ObjectModel;
using System.Data.SQLite;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Navigation;
using ZO.LoadOrderManager;
using MessageBox = System.Windows.MessageBox;


namespace ZO.LoadOrderManager
{
    public partial class LoadOrderWindow
    {
        private bool isSaved;
        private int SelectedLoadOutID; // Add this line
        private System.Timers.Timer cooldownTimer;

        //public ObservableCollection<ModGroup> Groups { get; set; }
        //public ObservableCollection<Plugin> Plugins { get; set; }
        //public ObservableCollection<LoadOut> LoadOuts { get; set; }

        public LoadOrderWindow()
        {
            InitializeComponent();

            // Initialize non-nullable fields and properties
            cooldownTimer = new System.Timers.Timer();
            //Groups = new ObservableCollection<ModGroup>();
            //Plugins = new ObservableCollection<Plugin>();
            //LoadOuts = new ObservableCollection<LoadOut>();

            try
            {
                if (AggLoadInfo.Instance != null)
                {
                    App.Current.Dispatcher.Invoke(() =>
                        ((LoadingWindow)App.Current.MainWindow).UpdateProgress(10, "Initializing LoadOrderWindow..."));
                    this.DataContext = new LoadOrderWindowViewModel();
                    App.LogDebug("LoadOrderWindow: DataContext set to LoadOrderWindowViewModel");

                    App.Current.Dispatcher.Invoke(() =>
                        ((LoadingWindow)App.Current.MainWindow).UpdateProgress(50, "LoadOrderWindow initialized successfully."));
                }
                else
                {
                    MessageBox.Show("Singleton is not initialized. Please initialize the singleton before opening the window.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    Close();
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"LoadOrderWindow: Exception occurred - {ex.Message}");
                MessageBox.Show($"An error occurred while initializing the window: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                Close();
            }
        }

        private void LoadOrderWindow_Loaded(object sender, RoutedEventArgs e)
        {
            App.LogDebug("Loading groups and plugins...");
        }

        private void LoadOrderWindow_Closing(object? sender, System.ComponentModel.CancelEventArgs e)
        {
            App.LogDebug("MainWindow is closing.");
        }


        private void Hyperlink_RequestNavigate(object sender, RequestNavigateEventArgs e)
        {
            Uri uri = e.Uri;
            string newUri = uri.AbsoluteUri;

            if (!uri.IsAbsoluteUri || string.IsNullOrEmpty(uri.OriginalString))
            {
                newUri = "https://google.com";
                if (uri.OriginalString.Contains("Nexus") || string.IsNullOrEmpty(uri.OriginalString))
                {
                    newUri = "https://www.nexusmods.com/starfield";
                }
                else if (uri.OriginalString.Contains("Bethesda") || string.IsNullOrEmpty(uri.OriginalString))
                {
                    newUri = "https://creations.bethesda.net/en/starfield/";
                }
                uri = new Uri(newUri);
            }

            _ = Process.Start(new ProcessStartInfo(uri.AbsoluteUri) { UseShellExecute = true });
            e.Handled = true;
            isSaved = false;
        }

        private void TreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            Debug.WriteLine("TreeView_SelectedItemChanged event triggered.");
            if (DataContext is LoadOrderWindowViewModel viewModel)
            {
                viewModel.SelectedItem = e.NewValue;
                Debug.WriteLine($"SelectedItem set to: {e.NewValue}");
            }
        }

        private void TreeView_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            if (DataContext is LoadOrderWindowViewModel viewModel && viewModel.SelectedItem != null)
            {
                viewModel.EditHighlightedItem();
            }
        }

        private void TreeView_KeyDown(object sender, KeyEventArgs e)
        {
            if (DataContext is LoadOrderWindowViewModel viewModel)
            {
                if (e.Key == Key.C && (Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control)
                {
                    if (viewModel.SelectedItem != null)
                    {
                        viewModel.CopyTextCommand.Execute(viewModel.SelectedItem);
                    }
                }
                else if (e.Key == Key.Up)
                {
                    // Navigate up
                    viewModel.SelectPreviousItem();
                }
                else if (e.Key == Key.Down)
                {
                    // Navigate down
                    viewModel.SelectNextItem();
                }
                else if (e.Key == Key.Delete)
                {
                    // Delete item
                    if (viewModel.SelectedItem != null)
                    {
                        viewModel.DeleteCommand.Execute(viewModel.SelectedItem);
                    }
                }
                else if (e.Key == Key.Insert)
                {
                    // Open editor
                    if (viewModel.SelectedItem != null)
                    {
                        viewModel.EditHighlightedItem();
                    }
                }
                else if (e.Key == Key.Home)
                {
                    // Jump to top
                    viewModel.SelectFirstItem();
                }
                else if (e.Key == Key.End)
                {
                    // Jump to bottom
                    viewModel.SelectLastItem();
                }
                else if (e.Key == Key.Up && (Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control)
                {
                    // Move up
                    if (viewModel.SelectedItem != null)
                    {
                        viewModel.MoveUpCommand.Execute(viewModel.SelectedItem);
                    }
                }
                else if (e.Key == Key.Down && (Keyboard.Modifiers & ModifierKeys.Control) == ModifierKeys.Control)
                {
                    // Move down
                    if (viewModel.SelectedItem != null)
                    {
                        viewModel.MoveDownCommand.Execute(viewModel.SelectedItem);
                    }
                }
            }
        }

        private void TreeView_MouseRightButtonDown(object sender, MouseButtonEventArgs e)
        {
            // Handle the MouseRightButtonDown event here
            // For example, you can select the item under the mouse cursor
            var treeViewItem = VisualUpwardSearch(e.OriginalSource as DependencyObject);
            if (treeViewItem != null)
            {
                treeViewItem.Focus();
                e.Handled = true;
            }
        }

        private static TreeViewItem VisualUpwardSearch(DependencyObject source)
        {
            while (source != null && !(source is TreeViewItem))
                source = VisualTreeHelper.GetParent(source);

            return source as TreeViewItem;
        }

        private void LoadOrderTreeView_Loaded(object sender, RoutedEventArgs e)
        {
            ExpandOrCollapseGroups(LoadOrderTreeView.Items, true);
        }

        private void ExpandOrCollapseGroups(ItemCollection items, bool expand)
        {
            foreach (var item in items)
            {
                if (item is LoadOrderItemViewModel viewModel)
                {
                    var treeViewItem = (TreeViewItem)LoadOrderTreeView.ItemContainerGenerator.ContainerFromItem(item);
                    if (treeViewItem != null)
                    {
                        if (viewModel.GroupID.HasValue)
                        {
                            treeViewItem.IsExpanded = expand && viewModel.GroupID > 0;
                        }
                        else
                        {
                            // Handle the case for the default group or any group without GroupID
                            treeViewItem.IsExpanded = expand;
                        }

                        // Recursively expand or collapse child items
                        ExpandOrCollapseGroups(treeViewItem.Items, expand);
                    }
                }
            }
        }
    }
}