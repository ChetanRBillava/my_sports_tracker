part of 'app_theme_cubit.dart';

class AppThemeState extends Equatable {
  final Brightness brightness;
  final String themeSetting;
  final AppTheme themeClass;

  const AppThemeState({required this.brightness, required this.themeClass, required this.themeSetting});

  factory AppThemeState.initialize(){
    return AppThemeState(
        brightness: Brightness.light,
        themeSetting: 'Auto Switching activated',
        themeClass: LightTheme(),
    );
  }

  AppThemeState copyWith({
    Brightness? brightness, String? themeSetting, AppTheme? themeClass
}){
    return AppThemeState(brightness: brightness ?? this.brightness, themeClass: themeClass ?? this.themeClass,
        themeSetting: themeSetting ?? this.themeSetting);
}

  @override
  List<Object> get props => [brightness, themeClass, themeSetting];
}
