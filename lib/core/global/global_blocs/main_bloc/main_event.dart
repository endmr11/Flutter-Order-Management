part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class ThemeChangeEvent extends MainEvent {
  const ThemeChangeEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class LanguageChangeEvent extends MainEvent {
  final String? value;
  const LanguageChangeEvent(this.value);

  @override
  List<Object> get props => [UniqueKey()];
}
