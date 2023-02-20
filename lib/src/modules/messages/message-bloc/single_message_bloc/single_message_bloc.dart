import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../socket-Io/socket_io.dart';
import '../../models/message.dart';
import '../../repository/messages_repository.dart';

part 'single_message_event.dart';

part 'single_message_state.dart';

class SingleMessageBloc extends Bloc<SingleMessageEvent, SingleMessageState> {
  final MessageRepository messageRepository;
  final SocketIO _socketIO;

  SingleMessageBloc(this._socketIO, this.messageRepository) : super(const SingleMessageState()) {
    on<SendMessageFiles>((event, emit) async {
      try {
        File message = File(event.message.content.filePath!);
        event.message.content.isLoading = true;
        event.message.content.downloaded = true;
        event.message.content.uploaded = false;
        emit(const SingleMessageState());

        final response = await messageRepository.uploadMessageFile(message);

        event.message.content.fileUrl = response;
        event.message.content.isLoading = false;
        _socketIO.sendMessage(event.message);
        event.message.content.uploaded = true;
        emit(const SingleMessageState());

      } on DioError catch (e) {
        print("=====================================");
        event.message.content.isLoading = false;
        event.message.content.uploaded = false;
        emit(const SingleMessageState());
      }
    });
  }
}
