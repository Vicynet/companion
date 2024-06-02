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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta != null &&
                        details.primaryDelta!.abs() > 10) {
                      // Dragging right
                      if (details.primaryDelta! > 0 &&
                          viewModel.showPreviousVerse == false) {
                        viewModel.previousVerse();
                      }
                      // Dragging left
                      else {
                        if (viewModel.showNextVerse == false) {
                          viewModel.nextVerse();
                        }
                      }
                    }
                  },
                  child: ChatComponent(
                    conversations:
                        viewModel.sessionConversation?.conversations ?? [],
                  ),
                )),
                const ChatBoxComponent()
              ],
            ),
            if (viewModel.isBusy && viewModel.showPreviousVerse == true)
              Positioned(
                left: 2.0,
                top: MediaQuery.of(context).size.height / 3.5 - 24.0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(
                      width: 200,
                      height: 8,
                      child: LinearProgressIndicator(
                          color: kcAlternateColor,
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kcUserChat)),
                    ),
                  ),
                ),
              ),
            if (viewModel.isBusy && viewModel.showNextVerse == true)
              Positioned(
                right: 2.0,
                top: MediaQuery.of(context).size.height / 3.5 - 24.0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(
                      width: 200,
                      height: 8,
                      child: LinearProgressIndicator(
                          color: kcAlternateColor,
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kcUserChat)),
                    ),
                  ),
                ),
              ),
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
