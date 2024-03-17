import 'package:acccountmonthly/bloc/date/date_cubit.dart';
import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/component/header_total.dart';
import 'package:acccountmonthly/data/arus_data.dart';
import 'package:acccountmonthly/data/data_day.dart';
import 'package:acccountmonthly/data/setting_data.dart';
import 'package:acccountmonthly/extension/datetime_extension.dart';
import 'package:acccountmonthly/extension/int_extension.dart';
import 'package:acccountmonthly/screen/addscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  // List<int> data = [];

  @override
  void initState() {
    super.initState();
    loadData(context.read<DateCubit>().state);
  }

  void loadData(DateTime date) {
    final bloc = context.read<DBBloc>();
    final state = bloc.state;
    if (state.db != null) {
      bloc.add(FetchData(
        state.db!,
        state.data,
        state.categoryData,
        weeklyData: state.weeklyData,
        date: date,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    final heightScreen = MediaQuery.sizeOf(context).height;
    return BlocListener<DateCubit, DateTime>(
      listener: (contextDateCubit, valueDateCubit) {
        // print("first time daily page");

        loadData(valueDateCubit);
      },
      child: BlocBuilder<SettingCubit, SettingData>(
        builder: (ctx, valueSetting) {
          return BlocBuilder<DBBloc, DBState>(
            builder: (context, state) {
              if (state is DBStateInsertDataLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is DBStateGetFailed) {
                // state.
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // final dateCubit = context.read<DateCubit>();
                      loadData(context.read<DateCubit>().state);
                      // final dbBloc = context.read<DBBloc>();
                      // dbBloc.add(
                      //   FetchData(
                      //     state.db,
                      //     state.data,
                      //     state.categoryData,
                      //     weeklyData: state.weeklyData,
                      //     date: dateCubit.state,
                      //   ),
                      // );
                    },
                    child: const Text("Retry"),
                  ),
                );
              }
              List<DataDay> list = [];

              double totalOut = 0;
              double totalIn = 0;
              for (int i = 0; i < state.data.length; i++) {
                ArusData data = state.data[i];
                totalOut += data.type == 'out' ? data.money : 0;
                totalIn += data.type == 'in' ? data.money : 0;
                final found =
                    list.indexWhere((element) => element.day == data.date);
                if (found != -1) {
                  list[found].add(data);

                  if (data.type == "in") {
                    list[found] = list[found].addingIn(data.money);
                  } else {
                    list[found] = list[found].addingOut(data.money);
                  }
                } else {
                  list.add(DataDay(
                    data.date,
                    data: [data],
                    totalIn: data.type == "in" ? data.money : 0,
                    totalOut: data.type == "out" ? data.money : 0,
                  ));
                }
              }
              list.sort(
                (a, b) => valueSetting.isAsc
                    ? a.day.compareTo(b.day)
                    : b.day.compareTo(a.day),
              );

              return RefreshIndicator(
                onRefresh: () async {
                  if (state.db != null) {
                    loadData(context.read<DateCubit>().state);
                  }
                },
                child: Container(
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
                      child: list.isEmpty
                          ? Container(
                              // height: 100,
                              color: Colors.white,
                              child: const Center(child: Text("Empty Data")),
                            )
                          : ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                DataDay data = list[index];
                                final year = data.day.substring(0, 4);
                                final month = data.day.substring(5, 7);
                                final day = data.day.substring(8, 10);
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom:
                                          index == list.length - 1 ? 0 : 10),
                                  width: widthScreen,
                                  constraints: BoxConstraints(
                                      minHeight: heightScreen / 9),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black54,
                                        width: .7,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      //top
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 12, 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      day, //day
                                                      style: TextStyle(
                                                          fontSize:
                                                              heightScreen / 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '$year.$month',
                                                        style: TextStyle(
                                                          fontSize:
                                                              heightScreen / 60,
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            widthScreen / 5.7,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        color: Colors.grey[200],
                                                        child: Text(
                                                          DateTime(
                                                            int.parse(year),
                                                            int.parse(month),
                                                            int.parse(day),
                                                          ).nameOfDay(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                heightScreen /
                                                                    60,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                data.totalIn.moneyFormat(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.green[500],
                                                  fontSize: heightScreen / 45,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                data.totalOut.moneyFormat(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.red[600],
                                                  fontSize: heightScreen / 45,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //botttom
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      dataPage(widthScreen, data),
                                    ],
                                  ),
                                );
                              },
                            ),
                    )
                    // Row(children: [],)
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget dataPage(double widthScreen, DataDay dataDay) {
    return SizedBox(
      width: widthScreen,
      child: Column(
        // direction: Axis.vertical,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              width: widthScreen,
              child: const Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Detail",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "Category",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Amount",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          ...dataDay.data.map(
            (e) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                width: widthScreen,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: () {},
                  onTap: () async {
                    // final d = e;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddScreen(
                          type: 'edit',
                          data: e,
                        ),
                      ),
                    );
                    if (context.mounted) {
                      loadData(context.read<DateCubit>().state);
                    }

                    // context.read<()
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text(e.description)),
                      Expanded(flex: 1, child: Text(e.category)),
                      Expanded(
                        flex: 1,
                        child: Text(
                          e.money.moneyFormat(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: e.type == "in"
                                ? Colors.green[400]
                                : Colors.red[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList()
        ],
      ),
    );
  }
}
