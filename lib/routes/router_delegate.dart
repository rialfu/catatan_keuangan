import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/page/page_cubie.dart';
import 'package:acccountmonthly/data/page_data.dart';
import 'package:acccountmonthly/page_name.dart';
import 'package:acccountmonthly/routes/routers.dart';
import 'package:acccountmonthly/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  // final PageNotifier notifier;
  final PageCubit cubit;
  AppRouterDelegate({required this.cubit});
  bool isFinishLoad = false;
  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  List<Page<dynamic>> dataPage(PageData state) {
    List<Page<dynamic>> page = [];

    if (state.unknownPath) {
      page.add(
        const MaterialPage(
          child: Scaffold(
            body: Center(child: Text("Not Found")),
          ),
        ),
      );
    }
    if (!state.unknownPath) {
      page.add(MaterialPage(
        child: BlocBuilder<DBBloc, DBState>(
          builder: (context, state) {
            if (state is DBStateInitial) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is DBStateConnecting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const HomeScreen();
          },
        ),
      ));
    }
    if (state.pageName == PageName.home) {
      page.add(const MaterialPage(child: HomeScreen()));
    }
    if (state.pageName == PageName.add) {
      page.add(const MaterialPage(
        child: Scaffold(
          body: Center(child: Text("Addd")),
        ),
      ));
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageData>(
      builder: (context, pageState) {
        return Navigator(
          key: navigatorKey,
          pages: dataPage(pageState),
          onPopPage: (route, result) {
            print('result pop:${route.didPop(result)}');
            return false;
          },
        );
      },
    );
  }

//currentConfiguration is called whenever there might be a change in route
//It checks for the current page or route and return a new route information
//This is what populates our browser history
  @override
  AppRoute? get currentConfiguration {
    if (cubit.state.unknownPath) {
      return AppRoute.unknown();
    }

    if (cubit.state.pageName == PageName.home) {
      return AppRoute.home();
    }

    if (cubit.state.pageName == PageName.add) {
      return AppRoute.add();
    }

    if (cubit.state.pageName == PageName.edit) {
      return AppRoute.edit();
    }

    if (cubit.state.pageName == PageName.setting) {
      return AppRoute.setting();
    }

    return AppRoute.unknown();
  }

//This is called whenever the system detects a new route is passed
//It checks the current route through the configuration and uses that to update the notifier
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    if (configuration.isUnknown) {
      cubit.changePage(page: null, unknown: true);
      // _updateRoute(page: null, isUnknown: true);
    }
    if (configuration.isHome) {
      cubit.changePage(page: PageName.home, unknown: false);
    }
    if (configuration.isAdd) {
      cubit.changePage(page: PageName.add, unknown: false);
    }

    // if (configuration.isAbout) {
    //   _updateRoute(page: PageName.about);
    // }

    // if (configuration.isContact) {
    //   _updateRoute(page: PageName.contact);
    // }

    // if (configuration.isServices) {
    //   _updateRoute(page: PageName.services);
    // }

    // if (configuration.isHome) {
    //   _updateRoute(page: PageName.home);
    // }
  }

  // _updateRoute({PageName? page, bool isUnknown = false}) {
  //   notifier.changePage(page: page, unknown: isUnknown);
  // }
}
