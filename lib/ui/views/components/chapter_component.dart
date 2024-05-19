import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/views/components/number_component.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

Widget chapterComponent(HomeViewModel viewModel, List<int> data) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 200.0,
      decoration: const BoxDecoration(
        color: kcBlock,
      ),
      child: GridView.count(
        crossAxisCount: 5,
        children: List.generate(data.length, (index) {
          return Center(
            child: InkWell(
              onTap: () {
                viewModel.selectChapter(index, viewModel.book);
              },
              child: NumberComponent(
                  item: data[index],
                  componentBackgroundColor: viewModel.chapterIndex == index
                      ? kcAlternateColor
                      : Colors.transparent,
                  componentTextColor: viewModel.chapterIndex == index
                      ? Colors.white
                      : kcDarkGreyColor),
            ),
          );
        }),
      ),
    ),
  );
}
