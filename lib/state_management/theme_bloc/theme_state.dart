import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/state_management/abstract_bloc/abstract_app_state.dart';

class ThemeState {
  ThemeType currentTheme;
  ThemeState({required this.currentTheme});
//   ThemeType get currentTheme => currentTheme;
}
