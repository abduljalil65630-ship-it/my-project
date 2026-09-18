import 'package:muslih/features/market/domain/entities/message.dart';

abstract class ChatRepository {
  /// إرسال رسالة جديدة
  Future<void> sendMessage({
    required String requestId,
    required String senderId,
    required String content,
  });

  /// جلب الرسائل الحية لطلب معين
  Stream<List<Message>> getMessagesStream(String requestId);
  
  /// جلب تاريخ الرسائل
  Future<List<Message>> getMessagesHistory(String requestId);
}
