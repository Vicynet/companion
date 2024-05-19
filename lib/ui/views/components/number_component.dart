import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NumberComponent extends StackedView<HomeViewModel> {
  final int? item;
  final Color? componentBackgroundColor;
  final Color? componentTextColor;

  const NumberComponent(
      {super.key,
      this.item,
      this.componentBackgroundColor,
      this.componentTextColor});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
          color: componentBackgroundColor!),
      child: Center(
        child: Text(
          item.toString(),
          style: TextStyle(
            fontFamily: 'Poppins',
              fontSize: 14.0, color: componentTextColor), // Adjust text size
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
