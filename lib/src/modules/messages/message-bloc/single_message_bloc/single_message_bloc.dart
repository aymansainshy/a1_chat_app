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

  SingleMessageBloc(this._socketIO, this.messageRepository) : super(SingleMessageState(DateTime.now())) {
    on<SendMessageFiles>((event, emit) async {
      try {
        File message = File(event.message.content.filePath!);

        event.message.content.isLoading = true;
        event.message.content.downloaded = true;
        event.message.content.uploaded = false;
        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));


        final response = await messageRepository.uploadMessageFile(message);

        event.message.content.fileUrl = response;
        event.message.content.isLoading = false;
        _socketIO.sendMessage(event.message);
        event.message.content.uploaded = true;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));

      } catch (e) {
        event.message.content.isLoading = false;
        event.message.content.uploaded = false;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));
      }
    });

    on<ReTryUploadMessageFiles>((event, emit) async {
      try {
        File message = File(event.message.content.filePath!);

        event.message.content.isLoading = true;
        event.message.content.downloaded = true;
        event.message.content.uploaded = false;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));

        final response = await messageRepository.uploadMessageFile(message);

        event.message.content.fileUrl = response;
        event.message.content.isLoading = false;
        _socketIO.sendMessage(event.message);
        event.message.content.uploaded = true;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));
      } catch (e) {
        event.message.content.isLoading = false;
        event.message.content.uploaded = false;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));
      }
    });

    on<DownloadMessageFiles>((event, emit) async {
      try {
        event.message.content.isLoading = true;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));

        final pathUrl = await messageRepository.downloadMessageFile(event.message.content.fileUrl!);

        event.message.content.filePath = pathUrl;
        event.message.content.isLoading = false;
        event.message.content.downloaded = true;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));

      } catch (e) {
        event.message.content.isLoading = false;
        event.message.content.downloaded = false;

        messageRepository.saveMessage(event.message);
        emit(state.copyWith(DateTime.now()));
      }
    });
  }
}
