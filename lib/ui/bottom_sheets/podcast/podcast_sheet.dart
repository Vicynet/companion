import 'package:flutter/material.dart';
import 'package:companion/ui/common/app_colors.dart';
import 'package:companion/ui/common/ui_helpers.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'podcast_sheet_model.dart';

class PodcastSheet extends StackedView<PodcastSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const PodcastSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    PodcastSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/podcast.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/icons/companion-icon.png'),
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpaceSmall,
              if (viewModel.isBusy) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    width: 100,
                    height: 5,
                    child: LinearProgressIndicator(
                        color: kcAlternateColor,
                        backgroundColor: kcMediumGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(kcLightGrey)),
                  ),
                ),
                verticalSpaceTiny,
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    width: 150,
                    height: 8,
                    child: LinearProgressIndicator(
                        color: kcAlternateColor,
                        backgroundColor: kcMediumGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(kcLightGrey)),
                  ),
                ),
              ] else ...[
                Text(
                  viewModel.podcastTheme ?? '',
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500),
                ),
                verticalSpaceTiny,
                Text(
                  viewModel.podcastTitle ?? '',
                  style: const TextStyle(
                      fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold),
                ),
                verticalSpaceMedium,
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 6,
                    child: LinearProgressIndicator(
                        value: viewModel.progress,
                        color: kcAlternateColor,
                        backgroundColor: kcLightGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kcUserChat)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      viewModel.formatDuration(viewModel.currentDuration),
                      style: const TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                    Text(
                      viewModel.formatDuration(
                          viewModel.totalDuration - viewModel.currentDuration),
                      style: const TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ],
          ),
          verticalSpaceLarge,
          if (viewModel.isBusy) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 50,
                  height: 5,
                  child: LinearProgressIndicator(
                      color: kcAlternateColor,
                      backgroundColor: kcMediumGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(kcLightGrey)),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 50,
                  height: 5,
                  child: LinearProgressIndicator(
                      color: kcAlternateColor,
                      backgroundColor: kcMediumGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(kcLightGrey)),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 50,
                  height: 5,
                  child: LinearProgressIndicator(
                      color: kcAlternateColor,
                      backgroundColor: kcMediumGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(kcLightGrey)),
                ),
              ),
            ])
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    if (viewModel.isPlaying == true) {
                      viewModel.pausePlayback();
                    } else {
                      if (viewModel.isPaused == true) {
                        viewModel.resumePlayback();
                      } else {
                        viewModel.startPlayback();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      viewModel.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_arrow_rounded,
                      color: kcMediumGrey,
                      size: 46,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.share_rounded,
                      color: kcMediumGrey,
                      size: 32,
                    ),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  @override
  PodcastSheetModel viewModelBuilder(BuildContext context) =>
      PodcastSheetModel();

  
  @override
  void onViewModelReady(PodcastSheetModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.generatePodcast());
}
