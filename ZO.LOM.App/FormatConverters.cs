using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;

namespace ZO.LoadOrderManager
{

    public class GroupIDToIsEnabledConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is long groupID)
            {
                return groupID > 0;
            }
            return false;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class GroupIDToIsExpandedConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is long groupID)
            {
                return groupID > 0;
            }
            return false;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class BooleanToColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool boolValue)
            {
                var type = parameter as string;

                if (type == "Highlight")
                {
                    return boolValue ? Brushes.LightYellow : Brushes.Transparent; // Color for highlighting
                }
                else if (type == "Group")
                {
                    return boolValue ? Brushes.LightSeaGreen : Brushes.LightBlue; // Color for groups
                }
                else // Default for plugins or other items
                {
                    return boolValue ? Brushes.LightSkyBlue : Brushes.Transparent; // Color for plugins
                }
            }
            return Brushes.Transparent; // Default color if value is not a boolean
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    //public class ItemStateToColorConverter : IMultiValueConverter
    //{
    //    public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
    //    {
    //        if (values.Length < 3)
    //            return Brushes.Transparent; // Default color if not enough values

    //        bool isSelected = values[0] is bool selected && selected;
    //        bool isHighlighted = values[1] is bool highlighted && highlighted;
    //        EntityType type = values[2] is EntityType entityType ? entityType : EntityType.Url; // Default to Unknown if not valid

    //        // Debugging
    //        Debug.WriteLine($"Selected: {isSelected}, Highlighted: {isHighlighted}, Type: {type}");

    //        if (isHighlighted)
    //        {
    //            return Brushes.LightGoldenrodYellow; // Highlighted color
    //        }

    //        if (isSelected)
    //        {
    //            return type == EntityType.Group ? Brushes.LightSeaGreen : Brushes.CornflowerBlue; // Selected color for groups and plugins
    //        }

    //        // Default colors based on the type when not selected
    //        return type == EntityType.Group ? Brushes.LightBlue : Brushes.Transparent; // Groups default to LightBlue, plugins to Transparent
    //    }


    //    public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
    //    {
    //        throw new NotImplementedException();
    //    }
    //}

    public class ItemStateToColorConverter : IMultiValueConverter
    {
        //private bool IsSystemInDarkMode()
        //{
        //    const string registryKey = @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";
        //    const string registryValue = "AppsUseLightTheme";

        //    object value = Microsoft.Win32.Registry.GetValue(registryKey, registryValue, null);
        //    if (value != null && value is int intValue)
        //    {
        //        return intValue == 0; // 0 means dark mode, 1 means light mode
        //    }

        //    // Default to light mode if unable to detect
        //    return false;
        //}

        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values.Length < 3)
                return Brushes.Transparent; // Default color if not enough values

            bool isSelected = values[0] is bool selected && selected;
            bool isHighlighted = values[1] is bool highlighted && highlighted;
            EntityType type = values[2] is EntityType entityType ? entityType : EntityType.Url; // Default to Unknown if not valid

            bool isDarkMode = Config.Instance.DarkMode;

            string target = parameter as string ?? "Background"; // Check if we're dealing with background or foreground

            if (target == "Foreground")
            {
                // Foreground Colors
                return isDarkMode ? Brushes.White : Brushes.Black; // White text for Dark Mode, Black text for Light Mode
            }




            // Debugging
            Debug.WriteLine($"Selected: {isSelected}, Highlighted: {isHighlighted}, Type: {type}, DarkMode: {isDarkMode}");

            // Dark Mode Colors
            if (isDarkMode)
            {
                if (isHighlighted)
                {
                    return Brushes.DarkGoldenrod; // Highlighted color for Dark Mode
                }

                if (isSelected)
                {
                    return type == EntityType.Group ? Brushes.Teal : Brushes.SteelBlue; // Selected color for Dark Mode
                }

                // Default colors for Dark Mode
                return type == EntityType.Group ? Brushes.DarkBlue : Brushes.DimGray;
            }
            // Light Mode Colors
            else
            {
                if (isHighlighted)
                {
                    return Brushes.LightGoldenrodYellow; // Highlighted color for Light Mode
                }

                if (isSelected)
                {
                    return type == EntityType.Group ? Brushes.LightSeaGreen : Brushes.CornflowerBlue; // Selected color for Light Mode
                }

                // Default colors for Light Mode
                return type == EntityType.Group ? Brushes.LightBlue : Brushes.Transparent;
            }
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }







    public class GroupItemStyleSelector : StyleSelector
    {
        public Style GroupStyle { get; set; } = null!;
        public Style DefaultStyle { get; set; } = null!;

        public override Style SelectStyle(object item, DependencyObject container)
        {
            if (item is ModGroup)
            {
                return GroupStyle;
            }
            return DefaultStyle;
        }
    }

    public class ArchiveFormatConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is string format)
            {
                format = format.ToLower();
                if (format.Contains("7z"))
                {
                    return "7z";
                }
                else if (format.Contains("zip"))
                {
                    return "zip";
                }
            }
            return "zip"; // Default to zip if no match
        }

        public object? ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is string format)
            {
                return format.ToLower(); // Simply return the selected format
            }
            return null; // or return a default if needed
        }
    }

    public class BethesdaUrlConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is string url && !string.IsNullOrEmpty(url))
            {
                if (url.StartsWith("https://"))
                {
                    var uri = new Uri(url);
                    return uri.Segments.Last().TrimEnd('/');
                }
                else if (Guid.TryParse(url, out _))
                {
                    return $"https://creations.bethesda.net/en/starfield/details/{url}";
                }
            }
            return "Bethesda";
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class NexusUrlConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is string url && !string.IsNullOrEmpty(url))
            {
                if (url.StartsWith("https://"))
                {
                    var uri = new Uri(url);
                    return uri.Segments.Last().TrimEnd('/');
                }
                else if (long.TryParse(url, out _))
                {
                    return $"https://www.nexusmods.com/starfield/mods/{url}";
                }
            }
            return "Nexus";
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class NullToBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value != null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class NullToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value == null ? Visibility.Collapsed : Visibility.Visible;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class PathToFolderConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return System.IO.Path.GetDirectoryName(value?.ToString() ?? string.Empty) ?? string.Empty;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class PathToFileNameConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return System.IO.Path.GetFileName(value?.ToString() ?? string.Empty) ?? string.Empty;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class BackupStatusToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return string.IsNullOrEmpty(value as string) ? Visibility.Collapsed : Visibility.Visible;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class BooleanToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool boolValue)
            {
                return boolValue ? Visibility.Visible : Visibility.Collapsed;
            }
            if (value is string stringValue)
            {
                return string.IsNullOrEmpty(stringValue) ? Visibility.Collapsed : Visibility.Visible;
            }
            return Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is Visibility visibility)
            {
                return visibility == Visibility.Visible;
            }
            return false;
        }
    }


    public class StringNullOrEmptyToBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return !string.IsNullOrEmpty(value as string);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }


    public class LoadOutAndPluginToIsEnabledConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values[0] is LoadOut loadOut && values[1] is long pluginID)
            {
                return loadOut.IsPluginEnabled(pluginID);
            }

            return false;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            return null; // or return Binding.DoNothing; depending on your preference
        }
    }


    public class FilesToStringConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is ObservableCollection<FileInfo> files)
            {
                return string.Join(", ", files.Select(f => f.Filename));
            }
            return string.Empty;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
    public class EnumFlagConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var state = (ModState)value;
            var flag = (ModState)parameter;
            return state.HasFlag(flag);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var state = (ModState)value;
            var flag = (ModState)parameter;
            if ((bool)value)
            {
                return state | flag;
            }
            else
            {
                return state & ~flag;
            }
        }
    }
}
