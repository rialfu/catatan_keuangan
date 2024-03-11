import 'package:acccountmonthly/bloc/date/date_cubit.dart';
import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/component/header_total.dart';
import 'package:acccountmonthly/data/grouping_category_data.dart';
import 'package:acccountmonthly/data/setting_data.dart';
import 'package:acccountmonthly/extension/datetime_extension.dart';
import 'package:acccountmonthly/extension/int_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeeklyPage extends StatefulWidget {
  const WeeklyPage({super.key});

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class WeekRange extends Equatable {
  final DateTime start;
  final DateTime end;
  final String ordinalName;
  const WeekRange(this.start, this.end, this.ordinalName);

  WeekRange copyWith({DateTime? start, DateTime? end, String? ordinalName}) {
    return WeekRange(
        start ?? this.start, end ?? this.end, ordinalName ?? this.ordinalName);
  }

  @override
  List<Object> get props => [start, end];
}

class _WeeklyPageState extends State<WeeklyPage> {
  List<WeekRange> rangeWeek = [];
  @override
  void initState() {
    super.initState();
    final date = context.read<DateCubit>().state;
    final bloc = context.read<DBBloc>();
    final state = bloc.state;
    if (state is DBStateConnected) {
      bloc.add(FetchDataCategory(
        state.db,
        state.data,
        state.categoryData,
        weeklyData: state.weeklyData,
        date: date,
      ));
    }
    createRange(date);
    // context.read<DateCubit>().state;
  }

  void createRange(DateTime date) {
    DateTime start = DateTime(date.year, date.month, 1);
    DateTime end = date;
    List<WeekRange> rangeWeek1 = [];
    int i = 0;
    while (true) {
      end = start.endOfWeek();
      rangeWeek1.add(WeekRange(start, end, (i + 1).ordinalSuffixOf()));
      start = end.add(const Duration(days: 1));
      if (start.month != date.month) {
        break;
      }
      i++;
      if (i == 10) break;
    }
    // final bloc = context.read<SettingCubit>();
    // rangeWeek1.sort(
    //   (a, b) {
    //     return bloc.state.isAsc
    //         ? a.start.compareTo(b.start)
    //         : b.start.compareTo(a.start);
    //   },
    // );
    // for (int i = 0; i < rangeWeek1.length; i++) {
    //   String ordinalName = bloc.state.isAsc
    //       ? (i + 1).ordinalSuffixOf()
    //       : (rangeWeek1.length - i).ordinalSuffixOf();
    //   rangeWeek1[i] = rangeWeek1[i].copyWith(ordinalName: ordinalName);
    // }
    // rangeWeek1.map((e) {
    //   if(bloc.state.isAsc){

    //   }
    // },)
    setState(() {
      rangeWeek = rangeWeek1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    final format = DateFormat('dd.MM');
    return BlocListener<DateCubit, DateTime>(
      listener: (contextDateCubit, valueDateCubit) {
        createRange(valueDateCubit);
        final bloc = context.read<DBBloc>();
        final state = bloc.state;
        if (state is DBStateConnected) {
          bloc.add(FetchDataCategory(
            state.db,
            state.data,
            state.categoryData,
            weeklyData: state.weeklyData,
            date: valueDateCubit,
          ));
        }
      },
      child: BlocBuilder<DBBloc, DBState>(
        builder: (context, state) {
          if (state is DBStateGetDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DBStateGetFailed) {}
          // if(DBState is )
          final double totalIn =
              state.weeklyData.fold(0, (prev, e) => prev + e.totalIn);
          final double totalOut =
              state.weeklyData.fold(0, (prev, e) => prev + e.totalOut);
          return RefreshIndicator(
            onRefresh: () async {
              if (state is DBStateConnected) {
                final dateCubit = context.read<DateCubit>();
                context.read<DBBloc>().add(FetchDataCategory(
                      state.db,
                      state.data,
                      state.categoryData,
                      date: dateCubit.state,
                    ));
              }
            },
            child: BlocBuilder<SettingCubit, SettingData>(
                builder: (ctx, valueSetting) {
              final range = rangeWeek;
              if (!valueSetting.isAsc) {
                range.sort((a, b) => b.start.compareTo(a.start));
              } else {
                range.sort((a, b) => a.start.compareTo(b.start));
              }
              // range.so
              return Container(
                color: Colors.grey[300],
                height: heightScreen,
                child: Column(children: [
                  HeaderTotal(
                    heightScreen: heightScreen,
                    totalIn: totalIn,
                    totalOut: totalOut,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount: range.length,
                      // itemCount: rangeWeek.length,
                      itemBuilder: (context, index) {
                        final week = range[index];
                        final start = week.start;
                        final end = week.end;
                        final found = state.weeklyData.indexWhere(
                          (element) {
                            final dt = DateTime.parse(element.category);
                            if ((start.isBefore(dt) || (start.day == dt.day)) &&
                                (end.isAfter(dt) || end.day == dt.day)) {
                              return true;
                            }
                            return false;
                          },
                        );
                        GroupingCategoryData? data;
                        if (found != -1) {
                          data = state.weeklyData[found];
                        }
                        // final data = state.weeklyData[index];
                        // DateTime date = DateTime.parse(data.category);
                        // String orderingName =
                        //     (rangeWeek.length - index).ordinalSuffixOf();
                        return Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.3,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          // color:Colo
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${week.ordinalName} week'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      color: Colors.grey[200],
                                      child: Text(
                                          '${format.format(week.start)} - ${format.format(week.end)}'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  data?.totalIn.moneyFormat() ?? '0.00',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.green[500],
                                    fontSize: heightScreen / 50,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  data?.totalOut.moneyFormat() ?? '0.00',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: heightScreen / 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]),
                // child: ListView.builder(
                //   itemCount: rangeWeek.length,
                //   // itemCount: state.weeklyData.length,
                //   itemBuilder: (context, index) {
                //     final week = rangeWeek[index];
                //     final start = week.start;
                //     final end = week.end;
                //     final found = state.weeklyData.indexWhere(
                //       (element) {
                //         final dt = DateTime.parse(element.category);
                //         if ((start.isBefore(dt) || (start.day == dt.day)) &&
                //             (end.isAfter(dt) || end.day == dt.day)) {
                //           return true;
                //         }
                //         return false;
                //       },
                //     );
                //     print(rangeWeek.length);
                //     GroupingCategoryData? data;
                //     if (found != -1) {
                //       data = state.weeklyData[found];
                //     }
                //     // final data = state.weeklyData[index];
                //     // DateTime date = DateTime.parse(data.category);
                //     String orderingName =
                //         (rangeWeek.length - index).ordinalSuffixOf();
                //     return Container(
                //       padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                //       decoration: const BoxDecoration(
                //         border: Border(
                //           bottom: BorderSide(
                //             color: Colors.black,
                //             width: 0.3,
                //           ),
                //         ),
                //         color: Colors.white,
                //       ),
                //       // color:Colo
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           Expanded(
                //             flex: 1,
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Text('$orderingName week'),
                //                 ),
                //                 Container(
                //                   padding: const EdgeInsets.all(6),
                //                   color: Colors.grey[200],
                //                   child: Text(
                //                       '${format.format(week.start)} - ${format.format(week.end)}'),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Expanded(
                //             flex: 1,
                //             child: Text(
                //               data?.totalIn.moneyFormat() ?? '0.00',
                //               textAlign: TextAlign.end,
                //               style: TextStyle(
                //                 color: Colors.green[500],
                //                 fontSize: heightScreen / 50,
                //               ),
                //             ),
                //           ),
                //           Expanded(
                //             flex: 1,
                //             child: Text(
                //               data?.totalOut.moneyFormat() ?? '0.00',
                //               textAlign: TextAlign.end,
                //               style: TextStyle(
                //                 color: Colors.red[600],
                //                 fontSize: heightScreen / 50,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              );
            }),
          );
          // if (state is DBStateConnected) {

          // }
        },
      ),
    );
  }
}
