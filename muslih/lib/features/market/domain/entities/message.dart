import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String requestId;
  final String senderId;
  final String content;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.requestId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, requestId, senderId, content, createdAt];
}
