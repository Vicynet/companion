 import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

Widget languageComponent(HomeViewModel viewModel) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 200.0,
        decoration: const BoxDecoration(
          color: kcBlock,
        ),
        child: ListView.builder(
          itemCount: viewModel.languages.length,
          itemBuilder: (context, index) {
            return InkWell(
              splashColor: kcAlternateColor,
              onTap: () {
                viewModel.selectLanguage(index, viewModel.languages[index]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.languages[index],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (viewModel.languageIndex == index) //
                          const Icon(Icons.check_circle_rounded,
                              color: kcPrimaryColor),
                      ],
                    ),
                  ),
                  if (index < viewModel.languages.length - 1) const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
