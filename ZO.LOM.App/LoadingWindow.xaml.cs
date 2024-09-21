using System.Windows;
using System.Windows.Controls; // Add this line
using System.Windows.Media.Animation; // Add this line

namespace ZO.LoadOrderManager
{
    public partial class LoadingWindow : Window
    {
        public LoadingWindow()
        {
            InitializeComponent();
        }

        public void UpdateProgress(int progress, string message)
        {
            ProgressBar.Value = progress;
            MessageLabel.Content = message;
        }
    }
}
