part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}
