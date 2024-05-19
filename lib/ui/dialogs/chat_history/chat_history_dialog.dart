import 'package:companion/ui/views/components/history_component.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_history_dialog_model.dart';

class ChatHistoryDialog extends StackedView<ChatHistoryDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ChatHistoryDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    ChatHistoryDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: const HistoryComponent(),
    );
  }

  @override
  ChatHistoryDialogModel viewModelBuilder(BuildContext context) =>
      ChatHistoryDialogModel();
}
