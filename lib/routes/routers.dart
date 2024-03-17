import 'package:acccountmonthly/page_name.dart';

class AppRoute {
  final PageName? pageName;
  final bool _isUnknown;

  AppRoute.home()
      : pageName = PageName.home,
        _isUnknown = false;

  AppRoute.add()
      : pageName = PageName.add,
        _isUnknown = false;
  AppRoute.edit()
      : pageName = PageName.edit,
        _isUnknown = false;
  AppRoute.setting()
      : pageName = PageName.edit,
        _isUnknown = false;

  AppRoute.unknown()
      : pageName = null,
        _isUnknown = true;

//Used to get the current path
  bool get isHome => pageName == PageName.home;
  bool get isSetting => pageName == PageName.setting;
  bool get isAdd => pageName == PageName.add;
  bool get isEdit => pageName == PageName.edit;
  bool get isUnknown => _isUnknown;
}
