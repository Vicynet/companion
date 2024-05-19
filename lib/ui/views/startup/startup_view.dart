import 'package:companion/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:companion/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Bible Study Made Simpler With AI',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            verticalSpaceMedium,
            SizedBox(
              width: 250.0,
              child: Image.asset('assets/images/intro-image.png'),
            ),
            verticalSpaceMassive,
            SizedBox(
              width: 78.0,
              height: 78.0,
              child: Image.asset('assets/icons/companion-icon.png'),
            ),
            verticalSpaceMedium,
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 100,
                height: 4,
                child: LinearProgressIndicator(
                    color: kcAlternateColor,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor)),
              ),
            ),
            verticalSpaceSmall,
            const Text(
              'Just a moment...',
              style: TextStyle(fontFamily: 'Poppins'),
            )
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
