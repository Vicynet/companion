import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/common/ui_helpers.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:companion/ui/views/components/chat_box_component.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(fields: [
  FormTextField(name: 'queryInput'),
])
class ChatBoxComponent extends StackedView<BibleChatViewModel>
    with $ChatBoxComponent {
  const ChatBoxComponent({
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      color: kcChatBackground,
      height: 75,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: MaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                color: kcUserChat,
                onPressed: () {
                  // viewModel.showBibleBookDialog();
                  viewModel.navigateToHome();
                },
                child: Image.asset(
                  'assets/icons/chat-plus-icon.png',
                  color: kcPrimaryColorDark,
                )),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: TextFormField(
                scrollPadding: const EdgeInsets.all(0.0),
                controller: queryInputController,
                maxLines: 10,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                cursorHeight: 15.0,
                cursorColor: kcUserChat,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: 'Bible questions?',
                  hintMaxLines: 1,
                  hintStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        queryInputController.text.split('\n').length > 1
                            ? 20
                            : 100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: kcMediumGrey), // Border color when focused
                  ),
                  suffixIcon: GestureDetector(
                    onTap: queryInputController.text.isNotEmpty
                        ? () async {
                            await viewModel
                                .continousBibleChat()
                                .then((value) => queryInputController.clear());
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send,
                        color: queryInputController.text.isNotEmpty
                            ? kcUserChat
                            : kcMediumGrey,
                      ),
                    ),
                  ),
                ),
                style: const TextStyle(height: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(BibleChatViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  BibleChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleChatViewModel();
}
