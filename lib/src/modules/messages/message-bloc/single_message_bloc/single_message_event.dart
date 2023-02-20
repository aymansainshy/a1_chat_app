part of 'single_message_bloc.dart';

abstract class SingleMessageEvent extends Equatable {
const SingleMessageEvent();

@override
List<Object> get props => [];}


class SendMessageFiles extends SingleMessageEvent {
  final Message message;

  const SendMessageFiles(this.message);
}