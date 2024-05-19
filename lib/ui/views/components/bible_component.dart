import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

Widget bibleComponent(HomeViewModel viewModel) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        height: 55,
        decoration: const BoxDecoration(
          color: kcAlternateColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select book',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            GestureDetector(
              onTap: () => viewModel.navigateBack(),
              child: const Icon(
                Icons.close,
                color: kcPrimaryColorLight,
              ),
            )
          ],
        ),
      ),
      viewModel.isBusy == true
          ? const LinearProgressIndicator(
              color: kcAlternateColor,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor))
          : SizedBox(
              height: 250,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: kcBlock,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: ListView.builder(
                  itemCount: viewModel.books.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: kcAlternateColor,
                      onTap: () {
                        viewModel.selectBook(index, viewModel.books[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    viewModel
                                        .books[index],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                if (viewModel.bookIndex == index) //
                                  const Icon(Icons.check_circle_rounded,
                                      color: kcPrimaryColor),
                              ],
                            ),
                          ),
                          if (index < viewModel.books.length - 1)
                            const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    ],
  );
}
