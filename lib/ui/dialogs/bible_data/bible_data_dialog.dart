import 'package:companion/ui/views/components/bible_component.dart';
import 'package:companion/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BibleDataDialog extends StackedView<HomeViewModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const BibleDataDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: bibleComponent(viewModel));
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchBibleBooks();
    });
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
