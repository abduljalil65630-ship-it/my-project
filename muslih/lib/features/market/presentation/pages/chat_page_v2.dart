import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/core/services/location_service.dart';
import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';
import 'package:muslih/l10n/app_localizations.dart';
import 'package:muslih/core/widgets/location_picker.dart';

// --- Chat Page v2 -------------------------------------------
class ChatPageV2 extends ConsumerStatefulWidget {
  final String requestId;
  final String otherPartyName;

  const ChatPageV2({
    super.key,
    required this.requestId,
    required this.otherPartyName,
  });

  @override
  ConsumerState<ChatPageV2> createState() => _ChatPageV2State();
}

class _ChatPageV2State extends ConsumerState<ChatPageV2> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageCtrl.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;

    ref.read(chatRepositoryProvider).sendMessage(
          requestId: widget.requestId,
          senderId: user.id,
          content: content,
        );

    _messageCtrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.requestId));
    final currentUser = ref.watch(authControllerProvider).valueOrNull;
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherPartyName)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                if (messages.isEmpty) {
                  return Center(child: Text('ابدأ المحادثة الآن...'));
                }

                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUser?.id;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? color : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.content,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${msg.createdAt.hour}:${msg.createdAt.minute}',
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ في تحميل الرسائل: $e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: color,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}