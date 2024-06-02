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
              left: 24.0, right: 24.0, top: 0.0, bottom: 24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: kcBlock,
                                child: Icon(Icons.person_2_rounded,
                                    color: kcDarkGreyColor),
                              ),
                            ),
                            horizontalSpaceTiny,
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.settings,
                          color: kcDarkGreyColor,
                        )
                      ],
                    ),
                    verticalSpaceLarge,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Podcast',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        verticalSpaceTiny,
                        GestureDetector(
                          onTap: viewModel.showPodcastBottomsheet,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            height: 150,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              image: DecorationImage(
                                image: AssetImage('assets/images/podcast.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.spatial_audio_off_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Listen',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalSpaceTiny,
                  ],
                ),
                verticalSpaceTiny,
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
