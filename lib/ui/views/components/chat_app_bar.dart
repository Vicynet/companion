import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatAppBar extends StackedView<BibleChatViewModel>
    implements PreferredSizeWidget {
  final String? title;
  final Function()? onHistoryPressed;
  final Function()? onOptionsPressed;

  const ChatAppBar({
    super.key,
    required this.title,
    this.onHistoryPressed,
    this.onOptionsPressed,
  });

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    return AppBar(
      backgroundColor: kcPrimaryColorDark,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.history, color: kcPrimaryColorLight),
        onPressed: onHistoryPressed,
      ),
      title: Text(
        title!,
        style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16.0,
            color: kcPrimaryColorLight,
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: kcPrimaryColorLight,
          ),
          onPressed: onOptionsPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  BibleChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleChatViewModel();
}
