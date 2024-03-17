import 'package:acccountmonthly/page_name.dart';
import 'package:acccountmonthly/routes/routers.dart';
import 'package:flutter/material.dart';

String? _unknownPath;

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri; //Uri.parse(routeInformation.uri);

    if (uri.pathSegments.isEmpty) {
      return AppRoute.home();
    }

    //If path includes more than one segement, go to 404
    if (uri.pathSegments.length > 1) {
      _unknownPath = routeInformation.uri.path;
      // _unknownPath = routeInformation.location;
      return AppRoute.unknown();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments.first == PageName.add.name) {
        return AppRoute.add();
      }

      if (uri.pathSegments.first == PageName.edit.name) {
        return AppRoute.edit();
      }

      if (uri.pathSegments.first == PageName.setting.name) {
        return AppRoute.setting();
      }
    }

    _unknownPath = uri.path;
    return AppRoute.unknown();
  }

//This passes route information to the parseRouteInformation method depending on the current AppRoute
  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.isAdd) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse(_unknownPath!));
      // return RouteInformation(location: _unknownPath);
    }

    if (configuration.isEdit) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isSetting) {
      return _getRouteInformation(configuration.pageName!.name);
    }
    return RouteInformation(uri: Uri.parse('/'));
    // return const RouteInformation(location: "/");
  }

//Get Route Information depending on the PageName passed
  RouteInformation _getRouteInformation(String page) {
    return RouteInformation(uri: Uri.parse("/$page"));
    // return RouteInformation(location: "/$page");
  }
}
