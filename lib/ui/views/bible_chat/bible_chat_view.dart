import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:companion/ui/views/components/chat_app_bar.dart';
import 'package:companion/ui/views/components/chat_box_component.dart';
import 'package:companion/ui/views/components/chat_component.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:companion/ui/common/app_colors.dart';

class BibleChatView extends StackedView<BibleChatViewModel> {
  const BibleChatView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcChatBackground,
      appBar: ChatAppBar(
        title: viewModel.sessionConversation?.session?.title.toString() ??
            'No title',
        onHistoryPressed: viewModel.showHistoryDialog,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ChatComponent(
              conversations: viewModel.sessionConversation!.conversations!,
            )),
            const ChatBoxComponent()
          ],
        ),
      ),
    );
  }

  @override
  BibleChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleChatViewModel();
}
