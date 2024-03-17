import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/component/header_main_component.dart';
import 'package:acccountmonthly/component/overlay_date.dart';
import 'package:acccountmonthly/custom_class/overlayportalcontrollerex.dart';
import 'package:acccountmonthly/pages/daily_page.dart';
import 'package:acccountmonthly/pages/monthly_page.dart';
import 'package:acccountmonthly/pages/weekly_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime dt = DateTime.now();
  late final TabController _tabController;
  DateTime now = DateTime.now();

  final _overlayController = OverlayPortalControllerEx();

  @override
  void initState() {
    super.initState();
    setState(() {
      _tabController = TabController(length: 4, vsync: this);
    });
    // _tabController.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    final heightScreen = MediaQuery.sizeOf(context).height;
    print('home width:$widthScreen');
    final _ = widthScreen / heightScreen;
    return BlocBuilder<DBBloc, DBState>(builder: (context, state) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          context.read<SettingCubit>().closeOverlay();
        },
        onPanDown: (details) {
          context.read<SettingCubit>().closeOverlay();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: HeaderMainComponent(
              controller: _tabController,
              overlayController: _overlayController,
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white30,
              // unselectedLabelStyle: TextStyle(backgroundColor: Theme.of(context).colorScheme.),
              // on
              onTap: (value) {
                if ((_tabController.indexIsChanging) &&
                    state is DBStateGetDataLoading) {
                  _tabController.index = _tabController.previousIndex;
                }
              },
              controller: _tabController,
              tabs: const <Widget>[
                Tab(
                  icon: Text(
                    "Daily",
                  ),
                ),
                Tab(
                  icon: Text(
                    "Weekly",
                  ),
                ),
                Tab(
                  icon: Text(
                    "Monthly",
                  ),
                ),
                Tab(
                  icon: Text(
                    "Year",
                  ),
                ),
              ],
            ),
          ),
          body: OverlayDateChoose(
            controller: _overlayController,
            builder: BlocBuilder<DBBloc, DBState>(
              builder: (context, state) {
                if (state is DBStateConnectFailed) {
                  return Column(
                    children: [
                      const Text("Failed Connect to Database"),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DBBloc>().add(ConnectToDatabase());
                        },
                        child: const Text("Try To Connect"),
                      )
                    ],
                  );
                }

                return GestureDetector(
                  onTap: () {
                    if (_overlayController.isShowing) {
                      // _overlayController.toggle();
                      _overlayController.toggleCustom();
                    }
                  },
                  child: TabBarView(
                    physics: state is DBStateGetDataLoading
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    controller: _tabController,
                    children: const <Widget>[
                      DailyPage(),
                      WeeklyPage(),
                      MonthlyPage(),
                      Center(
                        child: Text("Coming Soon"),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
