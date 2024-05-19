import 'package:companion/ui/views/components/chapter_component.dart';
import 'package:companion/ui/views/components/language_component.dart';
import 'package:companion/ui/views/components/verse_component.dart';
import 'package:companion/ui/views/components/version_component.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:companion/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BibleSheet extends StackedView<HomeViewModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const BibleSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            height: 55,
            decoration: const BoxDecoration(
              color: kcAlternateColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                Visibility(
                  visible: viewModel.chapterIndex > -1,
                  child: GestureDetector(
                      onTap: () {
                        viewModel.back();
                      },
                      child: const Icon(Icons.arrow_back_ios,
                          color: kcPrimaryColorLight)),
                ),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: '${viewModel.book} ',
                    style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: viewModel.chapter != null
                            ? viewModel.chapter.toString()
                            : '',
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: viewModel.verse != null
                            ? ':${viewModel.verse} '
                            : '',
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: viewModel.transalation.isNotEmpty
                            ? '- ${viewModel.transalation} '
                            : '',
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: viewModel.language.isNotEmpty
                            ? '(${viewModel.language})'
                            : '',
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (viewModel.bookIndex > -1 && viewModel.chapterIndex == -1)
            chapterComponent(viewModel, request.data),
          if (viewModel.chapterIndex > -1 && viewModel.verseIndex == -1)
            verseComponent(viewModel),
          if (viewModel.verseIndex > -1 && viewModel.translationIndex == -1)
            versionComponent(viewModel),
          if (viewModel.translationIndex > -1 && viewModel.languageIndex == -1)
            languageComponent(viewModel)
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
