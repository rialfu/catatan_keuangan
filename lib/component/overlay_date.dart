import 'package:acccountmonthly/bloc/date/date_cubit.dart';
import 'package:acccountmonthly/custom_class/overlayportalcontrollerex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acccountmonthly/extension/datetime_extension.dart';

class OverlayDateChoose extends StatefulWidget {
  final OverlayPortalControllerEx controller;
  final Widget builder;
  // final DateTime time;
  const OverlayDateChoose({
    required this.controller,
    required this.builder,
    super.key,
  });
  // const OverlayDateChoose(this._controller, this.builder, {super.key});

  @override
  State<OverlayDateChoose> createState() => _OverlayDateChooseState();
}

class _OverlayDateChooseState extends State<OverlayDateChoose> {
  DateTime dt = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.controller.status.addListener(listenerValue);
  }

  void listenerValue() {
    setState(() {
      dt = context.read<DateCubit>().state;
    });
  }

  @override
  void dispose() {
    widget.controller.status.removeListener(listenerValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    return OverlayPortal(
      controller: widget.controller,
      overlayChildBuilder: (context) {
        return Positioned(
          left: 0,
          top: 0,
          child: Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            width: widthScreen,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dt = DateTime(dt.year - 1, dt.month, dt.day);
                        });
                      },
                      child: const Icon(
                        Icons.arrow_left,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      dt.year.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dt = DateTime(dt.year + 1, dt.month, dt.day);
                        });
                      },
                      child: const Icon(
                        Icons.arrow_right,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    childAspectRatio: 1 / .4,
                    primary: true,
                    shrinkWrap: true,
                    children: List.generate(
                      month.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            DateTime date = DateTime(
                              dt.year,
                              index + 1,
                              context.read<DateCubit>().state.day,
                            );
                            context.read<DateCubit>().update(date);
                            widget.controller.toggleCustom();
                          },
                          child: Center(
                            child: Text(
                              month[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      child: widget.builder,
    );
  }
}
