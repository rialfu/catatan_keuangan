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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MonthlyPage extends StatefulWidget {
  const MonthlyPage({super.key});

  @override
  State<MonthlyPage> createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {
  List<int> dateRange = List.generate(12, (index) => index + 1);
  @override
  void initState() {
    super.initState();

    loadData(context.read<DateCubit>().state);
  }

  void loadData(DateTime? date) {
    final bloc = context.read<DBBloc>();
    final state = bloc.state;
    if (state.db != null) {
      bloc.add(FetchDataCategoryMonth(
        state.db!,
        state.data,
        state.categoryData,
        weeklyData: state.weeklyData,
        date: date,
      ));
    }
  }

  final moneyFormat = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    final heightScreen = MediaQuery.sizeOf(context).height;
    return BlocListener<DateCubit, DateTime>(
      listener: (contextDateCubit, valueDateCubit) {
        loadData(valueDateCubit);
      },
      child: BlocBuilder<DBBloc, DBState>(
        builder: (context, state) {
          if (state is DBStateGetDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DBStateGetFailed) {}
          final double totalIn = state.weeklyData.fold(
              0, (previousValue, element) => previousValue + element.totalIn);
          final double totalOut = state.weeklyData.fold(
              0, (previousValue, element) => previousValue + element.totalOut);
          return Container(
            height: heightScreen,
            color: Colors.grey[300],
            child: Column(
              children: [
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
                  child: BlocBuilder<SettingCubit, SettingData>(
                      builder: (ctx, valueSetting) {
                    return Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          if (!valueSetting.isAsc) {
                            index = 11 - index;
                          }
                          GroupingCategoryData? data;
                          final found = state.weeklyData.indexWhere((element) {
                            return (DateTime.parse(element.category).month ==
                                index + 1);
                            // if (DateTime.parse(element.category).month ==
                            //     index + 1) {
                            //   return true;
                            // }
                            // return false;
                          });
                          if (found != -1) {
                            data = state.weeklyData[found];
                          }
                          return Container(
                            padding: const EdgeInsets.fromLTRB(12, 7, 12, 12),
                            width: widthScreen,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(children: [
                                    Container(
                                      width: widthScreen * 0.1,
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.grey[300],
                                      child: Center(child: Text(month[index])),
                                    )
                                  ]),
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
                                      // tex
                                      fontSize: heightScreen / 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
