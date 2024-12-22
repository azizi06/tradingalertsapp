import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_event.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_state.dart';

class ThemeBlocProvider extends Bloc<ThemeEvent, ThemeState> {
  ThemeBlocProvider() : super(ThemeState(currentTheme: ThemeType.light)) {
    on<ThemeChangeEvent>((event, emit) {
      emit(ThemeState(currentTheme: event.theme));
    });
  }
}
