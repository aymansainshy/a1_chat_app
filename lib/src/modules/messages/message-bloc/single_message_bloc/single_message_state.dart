part of 'single_message_bloc.dart';

class SingleMessageState extends Equatable {
  final DateTime date;

  const SingleMessageState(this.date);

  SingleMessageState copyWith(DateTime? date) {
    return SingleMessageState(date ?? this.date);
  }

  @override
  List<Object?> get props => [date];
}
