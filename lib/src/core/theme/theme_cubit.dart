import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({this.themeMode = ThemeMode.light});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      emit(state.copyWith(themeMode: _themeMode));
    } else {
      _themeMode = ThemeMode.light;
      emit(state.copyWith(themeMode: _themeMode));
    }
  }
}
