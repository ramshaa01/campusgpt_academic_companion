import 'package:flutter/material.dart';
import '../theme.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'ai',
      'content': "Hi Alex! I noticed you have your Advanced Thermodynamics final in 3 days. Would you like me to generate a practice quiz based on past years' papers?"
    }
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.insert(0, {'role': 'user', 'content': text});
      _controller.clear();
      
      // Simulate AI response
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.insert(0, {
              'role': 'ai',
              'content': 'I am generating a comprehensive quiz covering entropy, enthalpy, and the Carnot cycle. This should take just a moment...'
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
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
                    Text(
                      'Always Online',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: CampusGptTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        
        // Chat Area
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['role'] == 'user';
              return _buildMessageBubble(msg['content'], isUser);
            },
          ),
        ),
        
        // Quick Prompts
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
        
        // Input Area
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
                  onTap: () => _sendMessage(_controller.text),
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
