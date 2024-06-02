import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/common/app_strings.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BookComponent extends StackedView<HomeViewModel> {
  final List<String>? items;

  const BookComponent({
    super.key,
    this.items,
  });

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        height: 55,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              ksBookComponentTitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kcDarkGreyColor),
            ),
            if (viewModel.allSessionsWithConversations!.isNotEmpty)
              GestureDetector(
                  onTap: viewModel.showHistoryDialog,
                  child: const Icon(Icons.history, color: kcDarkGreyColor)),
          ],
        ),
      ),
      viewModel.isBusy == true
          ? const LinearProgressIndicator(
              color: kcAlternateColor,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor))
          : Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                decoration: const BoxDecoration(
                  color: kcBlock,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: ListView.builder(
                  itemCount: items!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: kcAlternateColor,
                      onTap: () {
                        viewModel.selectBook(index, items![index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items![index],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (viewModel.bookIndex == index) //
                                  const Icon(Icons.check_circle_rounded,
                                      color: kcPrimaryColor),
                              ],
                            ),
                          ),
                          if (index < items!.length - 1) const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    ]);
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
