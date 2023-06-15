import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonSwitcherState {
  final double index;

  ButtonSwitcherState({this.index = 0});

  ButtonSwitcherState copyWith({double? index}) {
    return ButtonSwitcherState(
      index: index ?? this.index,
    );
  }
}

class ButtonSwitcherCubit extends Cubit<ButtonSwitcherState> {
  ButtonSwitcherCubit() : super(ButtonSwitcherState());

  void toggleButton(double index) {
    emit(state.copyWith(index: index));
  }
}
