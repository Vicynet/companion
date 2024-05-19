import 'package:companion/ui/views/components/book_component.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/common/ui_helpers.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  final List<String>? books;
  const HomeView({super.key, this.books});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 16.0, bottom: 24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 70,
                          child: Image.asset(
                              'assets/images/companion-home-logo.png'),
                        ),
                        horizontalSpaceTiny,
                        const Text(
                          'Companion',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceTiny,
                    const Text(
                      'Your everyday Bible companion',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                verticalSpaceLarge,
                Expanded(
                  child: BookComponent(
                    items: books,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) async {
    viewModel.fetchBibleBooks();
    await viewModel.fetchLocalSessionsWithConversations();
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
