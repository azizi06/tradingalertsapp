import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/state_management/abstract_bloc/abstract_app_event.dart';

abstract class ThemeEvent  extends AbstractAppEvent {}
class ThemeChangeEvent extends ThemeEvent{
    final ThemeType theme;
   ThemeChangeEvent(this.theme);
}