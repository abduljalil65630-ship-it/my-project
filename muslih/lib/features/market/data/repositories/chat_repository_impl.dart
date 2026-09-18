import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:muslih/features/market/domain/entities/message.dart';
import 'package:muslih/features/market/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SupabaseClient _client;

  ChatRepositoryImpl(this._client);

  @override
  Future<void> sendMessage({
    required String requestId,
    required String senderId,
    required String content,
  }) async {
    await _client.from('messages').insert({
      'request_id': requestId,
      'sender_id': senderId,
      'content': content,
    });
  }

  @override
  Stream<List<Message>> getMessagesStream(String requestId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('request_id', requestId)
        .order('created_at')
        .map((rows) => rows.map((json) => _mapToMessage(json)).toList());
  }

  @override
  Future<List<Message>> getMessagesHistory(String requestId) async {
    final rows = await _client
        .from('messages')
        .select()
        .eq('request_id', requestId)
        .order('created_at');
    
    return (rows as List).map((json) => _mapToMessage(json)).toList();
  }

  Message _mapToMessage(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      requestId: json['request_id'],
      senderId: json['sender_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
