import 'package:companion/ui/common/app_strings.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:companion/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SummaryDialog extends StackedView<BibleChatViewModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SummaryDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    BibleChatViewModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            height: 55,
            decoration: const BoxDecoration(
              color: kcHeader,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ksSummaryTitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcDarkGreyColor),
                ),
                GestureDetector(
                  onTap: () => completer(DialogResponse(confirmed: true)),
                  child: const Icon(
                    Icons.close,
                    color: kcDarkGreyColor,
                  ),
                )
              ],
            ),
          ),
          if (viewModel.isBusy == true) ...[
            const LinearProgressIndicator(
                color: kcAlternateColor,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(kcHeader))
          ],
          if (request.data != null) ...[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  text:
                      'Get set! Stay focuses! And prepare to explore the book of ',
                  children: <InlineSpan>[
                    TextSpan(
                      text:
                          '${request.data.book} ${request.data.chapter} vs ${request.data.verse} ',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: kcMediumGrey,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'in the ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: kcMediumGrey,
                      ),
                    ),
                    TextSpan(
                      text: '${request.data.translation} translation ',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: kcMediumGrey,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'in your chosen native ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: kcMediumGrey,
                      ),
                    ),
                    TextSpan(
                      text: '${request.data.language} ',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: kcMediumGrey,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'language.',
                      style: TextStyle(
                        fontSize: 16,
                        color: kcMediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
          GestureDetector(
            onTap: viewModel.isBusy == true
                ? null
                : () {
                    viewModel
                        .bibleChat(request.data)
                        .then((value) => viewModel.navigateToChat());
                  },
            child: Container(
              margin: const EdgeInsets.all(24),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    viewModel.isBusy == true ? kcLightGrey : kcAlternateColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'Got it',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  BibleChatViewModel viewModelBuilder(BuildContext context) =>
      BibleChatViewModel();
}
