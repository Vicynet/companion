import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/views/components/number_component.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

Widget verseComponent(HomeViewModel viewModel) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 200.0,
      decoration: const BoxDecoration(
        color: kcBlock,
      ),
      child: GridView.count(
        crossAxisCount: 5,
        children: List.generate(viewModel.verses.length, (index) {
          return Center(
            child: InkWell(
              onTap: () {
                viewModel.selectVerse(index);
              },
              child: NumberComponent(
                  item: viewModel.verses[index],
                  componentBackgroundColor: viewModel.verseIndex == index
                      ? kcAlternateColor
                      : Colors.transparent,
                  componentTextColor: viewModel.verseIndex == index
                      ? Colors.white
                      : kcDarkGreyColor),
            ),
          );
        }),
      ),
    ),
  );
}
