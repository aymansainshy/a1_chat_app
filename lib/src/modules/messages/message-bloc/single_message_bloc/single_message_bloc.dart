import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'single_message_event.dart';
part 'single_message_state.dart';

class SingleMessageBloc extends Bloc<SingleMessageEvent, SingleMessageState> {
  SingleMessageBloc() : super(SingleMessageInitial()) {
    on<SingleMessageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
