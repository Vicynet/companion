import 'package:companion/services/bible_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bibleDataService = locator<BibleDataService>();

  List<String> _books = [];

  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 5));
    await _bibleDataService.readJson().then((value) {
      _books = _bibleDataService.getBooks();
    });
    _navigationService.replaceWithHomeView(books: _books);
  }
}
