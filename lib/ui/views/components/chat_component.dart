import 'package:companion/model/conversation.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:companion/ui/views/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

late ScrollController controller;

class ChatComponent extends StackedView<BibleChatViewModel> {
  final List<Conversation> conversations;

  const ChatComponent({super.key, required this.conversations});

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
    return ListView.builder(
      controller: controller,
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final currentMessage = conversations[index];
        final previousMessage = index > 0 ? conversations[index - 1] : null;
        final showAvatarAndName = previousMessage == null ||
            previousMessage.role != currentMessage.role;
        return ChatBubble(
          role: currentMessage.role!,
          message: currentMessage.message!,
          showAvatarAndName: showAvatarAndName,
        );
      },
    );
  }

  @override
  void onViewModelReady(BibleChatViewModel viewModel) {
    controller = ScrollController();
  }

  @override
  void onDispose(BibleChatViewModel viewModel) {
    controller.dispose();
    super.onDispose(viewModel);
  }

  @override
  BibleChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleChatViewModel();
}
