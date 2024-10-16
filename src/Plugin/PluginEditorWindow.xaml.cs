using MahApps.Metro.Controls;
using System.Windows;

namespace ZO.LoadOrderManager
{
    public partial class PluginEditorWindow : MetroWindow
    {
        public Task<bool?> ShowDialogAsync()
        {
            TaskCompletionSource<bool?> tcs = new TaskCompletionSource<bool?>();
            this.Closed += (s, e) => tcs.SetResult(this.DialogResult);
            _ = this.ShowDialog(); // Change this line to ShowDialog
            return tcs.Task;
        }

        private PluginViewModel _pluginViewModel;

        public PluginEditorWindow(Plugin plugin, AggLoadInfo? aggLoadInfo = null)
        {
            InitializeComponent();
            _pluginViewModel = new PluginViewModel(plugin, aggLoadInfo);
            DataContext = _pluginViewModel;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            _pluginViewModel.SavePluginChanges();
            this.DialogResult = true;
            this.Close();
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
            this.Close();
        }
    }
}
