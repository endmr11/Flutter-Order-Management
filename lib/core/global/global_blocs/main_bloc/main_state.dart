part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [UniqueKey()];
}

class ThemeChangeState extends MainState {
  final bool isLight;
  final String locale;

  const ThemeChangeState(this.isLight, this.locale);
  @override
  List<Object> get props => [UniqueKey(), isLight, locale];
}
