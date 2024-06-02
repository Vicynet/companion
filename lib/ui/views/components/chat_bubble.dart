import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/common/ui_helpers.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatBubble extends StackedView<BibleChatViewModel> {
  final String role;
  final String message;
  final bool showAvatarAndName;

  const ChatBubble(
      {super.key,
      required this.role,
      required this.message,
      required this.showAvatarAndName});

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            role == 'user' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: role == 'user'
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (showAvatarAndName) ...[
                role == 'user'
                    ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_2_outlined,
                            color: kcDarkGreyColor,
                            size: 16,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/icons/companion-icon.png'),
                        ),
                      ),
                horizontalSpaceTiny,
                Text(
                  role == 'user' ? 'You' : 'Companion',
                  style: const TextStyle(
                      fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          Visibility(visible: showAvatarAndName, child: verticalSpaceTiny),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: role == 'user' ? kcUserChat : kcPrimaryColorLight,
              borderRadius: BorderRadius.only(
                topLeft: role == 'user'
                    ? const Radius.circular(15.0)
                    : const Radius.circular(0.0),
                topRight: role == 'user'
                    ? const Radius.circular(0.0)
                    : const Radius.circular(15.0),
                bottomLeft: const Radius.circular(15.0),
                bottomRight: const Radius.circular(15.0),
              ),
            ),
            child: SelectableText(
              message,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: kcPrimaryColorDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0),
            ),
          ),
          Row(children: [
            if (role != 'user') ...[
              GestureDetector(
                onTap: () => viewModel.copyText(message),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.copy_all_rounded,
                    color: kcMediumGrey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => viewModel.shareText(message,
                    viewModel.sessionConversation!.session!.title ?? ''),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.share_rounded,
                    color: kcMediumGrey,
                    size: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => viewModel.isPlaying
                    ? viewModel.pausePlayback()
                    : viewModel.startPlayback(message),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    viewModel.isPlaying
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_arrow_rounded,
                    color: kcMediumGrey,
                  ),
                ),
              ),
            ]
          ])
        ],
      ),
    );
  }

  @override
  BibleChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleChatViewModel();
}
