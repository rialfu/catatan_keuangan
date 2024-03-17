import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class _ChartScreenState extends State<ChartScreen> {
  late TooltipBehavior tooltipBehavior;
  List<ChartData> data = [];
  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    setState(() {
      data = [
        ChartData('senin', 20000),
        ChartData('selasa', 15000),
        ChartData('rabu', 15000)
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart"),
      ),
      body: BlocBuilder<DBBloc, DBState>(
        builder: (context, state) {
          return Container(
            height: heightScreen,
            color: Colors.grey[300],
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text("kiri"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Kanan"),
                      )
                    ]),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.white,
                    child: SfCircularChart(
                      tooltipBehavior: tooltipBehavior,
                      series: <CircularSeries<ChartData, String>>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: data,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          name: 'Gold',
                          // explode: true,
                          // explodeAll: true,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelIntersectAction: LabelIntersectAction.hide,
                            labelAlignment: ChartDataLabelAlignment.top,
                            connectorLineSettings: ConnectorLineSettings(
                              length: '10',
                              type: ConnectorType.curve,
                              width: 2,
                            ),
                            labelPosition: ChartDataLabelPosition.inside,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                )
              ],
            ),
          );
        },
        // child: ,
      ),
    );
  }
}
