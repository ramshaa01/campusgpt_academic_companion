import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/help_dialog.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    await context.read<AppState>().sendChatMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final messages = appState.chatMessages;
    final isOnline = appState.isOnline;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 50, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: CampusGptTheme.surface.withOpacity(0.8),
            border: Border(
              bottom: BorderSide(color: CampusGptTheme.onSurface.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [CampusGptTheme.primary, CampusGptTheme.secondary],
                  ),
                ),
                child: const Icon(Icons.psychology, size: 20, color: CampusGptTheme.surface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Study Assistant',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: CampusGptTheme.onSurface,
                          ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isOnline ? Colors.greenAccent : CampusGptTheme.error,
                          ),
                        ),
                        Text(
                          isOnline ? 'Online' : 'Offline (local AI)',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isOnline ? CampusGptTheme.secondary : CampusGptTheme.error,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'clear') {
                    await appState.clearChat();
                  } else if (value == 'help') {
                    if (context.mounted) {
                      await showHelpDialog(
                        context,
                        title: 'AI Study Assistant',
                        body:
                            'Ask for quizzes, summaries, GPA advice, or exam prep. Responses are saved in this session. Set OPENAI_API_KEY at build time for cloud AI.',
                      );
                    }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'help', child: Text('Help')),
                  PopupMenuItem(value: 'clear', child: Text('Clear chat')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: messages.length + (appState.isAiThinking ? 1 : 0),
            itemBuilder: (context, index) {
              if (appState.isAiThinking && index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Thinking...'),
                    ],
                  ),
                );
              }
              final msgIndex = appState.isAiThinking ? index - 1 : index;
              final msg = messages[msgIndex];
              return _buildMessageBubble(msg.content, msg.role == 'user');
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildPromptChip('Quiz me on Thermodynamics'),
              const SizedBox(width: 8),
              _buildPromptChip('Summarize Lecture 4'),
              const SizedBox(width: 8),
              _buildPromptChip('Explain Carnot cycle'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          color: CampusGptTheme.surfaceContainerLowest.withOpacity(0.5),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: CampusGptTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: CampusGptTheme.onSurface.withOpacity(0.1)),
                    ),
                    child: TextField(
                      controller: _controller,
                      enabled: !appState.isAiThinking,
                      style: const TextStyle(color: CampusGptTheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Ask your AI tutor...',
                        hintStyle: TextStyle(color: CampusGptTheme.onSurfaceVariant.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: appState.isAiThinking ? null : () => _sendMessage(_controller.text),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CampusGptTheme.primaryContainer.withOpacity(0.2),
                      border: Border.all(color: CampusGptTheme.primary.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.send, color: CampusGptTheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(String content, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [CampusGptTheme.primary, CampusGptTheme.secondary],
                ),
              ),
              child: const Icon(Icons.psychology, size: 14, color: CampusGptTheme.surface),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser
                    ? CampusGptTheme.primaryContainer.withOpacity(0.2)
                    : CampusGptTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                  bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                border: Border.all(
                  color: isUser
                      ? CampusGptTheme.primary.withOpacity(0.3)
                      : CampusGptTheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CampusGptTheme.onSurface,
                    ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 32),
          if (!isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: CampusGptTheme.surfaceContainer,
      side: BorderSide(color: CampusGptTheme.onSurface.withOpacity(0.1)),
      onPressed: () => _sendMessage(text),
    );
  }
}
