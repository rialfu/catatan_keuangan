import 'package:acccountmonthly/bloc/date/date_cubit.dart';
import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
// import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/component/etc_preview.dart';
// import 'package:acccountmonthly/bloc/page/page_cubit.dart';
import 'package:acccountmonthly/custom_class/overlayportalcontrollerex.dart';
import 'package:acccountmonthly/data/setting_data.dart';
import 'package:acccountmonthly/extension/datetime_extension.dart';
// import 'package:acccountmonthly/page_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderMainComponent extends StatefulWidget {
  final TabController controller;
  final OverlayPortalControllerEx overlayController;
  const HeaderMainComponent(
      {required this.controller, required this.overlayController, super.key});

  @override
  State<HeaderMainComponent> createState() => _HeaderMainComponentState();
}

class _HeaderMainComponentState extends State<HeaderMainComponent>
    with TickerProviderStateMixin {
  // late final TabController _tabController;
  int indexTab = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(changeTab);
  }

  void changeTab() {
    setState(() {
      indexTab = widget.controller.index;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(changeTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateTime>(
      builder: (context, state) {
        // context.read
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: indexTab == 3
                      ? [
                          const Text(
                            'Total',
                            style: TextStyle(color: Colors.white70),
                          )
                        ]
                      : [
                          GestureDetector(
                            onTap: () {
                              DateTime? dt;
                              if (indexTab == 0 || indexTab == 1) {
                                dt = DateTime(
                                  state.year,
                                  state.month - 1,
                                  state.day,
                                );
                              } else if (indexTab == 2) {
                                dt = DateTime(
                                  state.year - 1,
                                  state.month,
                                  state.day,
                                );
                              }
                              if (dt != null) {
                                context.read<DateCubit>().update(dt);
                              }
                            },
                            child: const Icon(
                              Icons.arrow_left,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (indexTab != 2) {
                                widget.overlayController.toggleCustom();
                                // context.read<DateCubit>().update(state);
                              }
                            },
                            //center header
                            child: Text(
                              '${indexTab == 1 || indexTab == 0 ? '${state.nameMonth()} ' : ''}${state.year}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DateTime? dt;
                              if (indexTab == 0 || indexTab == 1) {
                                dt = DateTime(
                                  state.year,
                                  state.month + 1,
                                  state.day,
                                );
                              } else if (indexTab == 2) {
                                dt = DateTime(
                                  state.year + 1,
                                  state.month,
                                  state.day,
                                );
                              }
                              if (dt != null) {
                                context.read<DateCubit>().update(dt);
                              }
                            },
                            child: const Icon(
                              Icons.arrow_right,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<SettingCubit, SettingData>(
                        builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          context.read<SettingCubit>().changeSort();
                          // Navigator.pushNamed(context, '/chart');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform.flip(
                            flipY: state.isAsc,
                            child: const Icon(
                              Icons.sort,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/add');
                        if (!context.mounted) return;
                        final bloc = context.read<DBBloc>();
                        final state = bloc.state;
                        if (state.db != null) {
                          if (indexTab == 0) {
                            bloc.add(FetchData(
                                state.db!, state.data, state.categoryData));
                          } else if (indexTab == 1) {
                            bloc.add(FetchDataCategory(
                              state.db!,
                              state.data,
                              state.categoryData,
                              weeklyData: state.weeklyData,
                            ));
                          } else if (indexTab == 2) {
                            bloc.add(FetchDataCategoryMonth(
                              state.db!,
                              state.data,
                              state.categoryData,
                              weeklyData: state.weeklyData,
                            ));
                          }
                          // bloc.add(Fet)
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const ETCPreview()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
