import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/component/component_custom.dart';
import 'package:acccountmonthly/component/form_date.dart';
import 'package:acccountmonthly/component/form_money.dart';
import 'package:acccountmonthly/component/form_type.dart';
import 'package:acccountmonthly/data/arus_data.dart';
import 'package:acccountmonthly/data/category_data.dart';
import 'package:acccountmonthly/extension/datetime_extension.dart';
import 'package:acccountmonthly/extension/int_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScreen extends StatefulWidget {
  final String type;
  final ArusData? data;
  const AddScreen({this.type = "", this.data, super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime? dateData;
  final formKey = GlobalKey<FormState>();
  // final moneyController = TextEditingController(text: '0');
  final detailController = TextEditingController();
  // DateTime? dateData;
  String? type;
  int money = 0;
  bool? isIncome;
  int? defaultValueIn;
  int? defaultValueOut;

  @override
  void initState() {
    super.initState();

    if (widget.type == "edit" && widget.data != null) {
      detailController.text = widget.data!.description;

      final state = context.read<DBBloc>().state;
      final cat = widget.data!.category;
      final ty = widget.data!.type;
      final found = state.categoryData
          .indexWhere((e) => e.category == cat && e.type == ty);
      int? valueIn;
      int? valueOut;
      if (found != -1 && widget.data!.type == 'in') {
        valueIn = state.categoryData[found].id;
      } else if (found != -1 && widget.data!.type == 'out') {
        valueOut = state.categoryData[found].id;
      }

      bool? isIncome1;
      if (widget.data!.type == 'in') {
        isIncome1 = true;
      } else if (widget.data!.type == 'out') {
        isIncome1 = false;
      }

      setState(() {
        isIncome = isIncome1;
        dateData = DateTime.parse(widget.data!.date);
        defaultValueIn = valueIn;
        defaultValueOut = valueOut;
      });
    }
  }

  @override
  void dispose() {
    detailController.dispose();
    super.dispose();
  }

  String? initialValueType() {
    if (widget.type == "edit") {
      return widget.data!.type;
    }
    return null;
  }

  String initialValueMoney() {
    if (widget.type == 'edit') {
      return widget.data!.money.moneyFormat();
    }
    return '0.00';
  }

  DateTime? initialValueDate() {
    if (widget.type == "edit") {
      try {
        return DateTime.parse(widget.data!.date);
      } catch (err) {
        return null;
      }
    }
    return null;
  }

  void send() {
    FocusScope.of(context).requestFocus(FocusNode());
    print('send');
    if (formKey.currentState!.validate()) {
      if ((isIncome! == true && defaultValueIn == null) ||
          (isIncome! == false && defaultValueOut == null)) {
        ComponentCustom.messageDialog(
          'Alert',
          'Please choose Category',
          () => Navigator.of(context).pop(),
          context,
        );
        return;
      }
      formKey.currentState!.save();

      // return;
      print('send1');
      try {
        final tanggal = dateData!.yyyymmdd();
        final bloc = context.read<DBBloc>();
        final state = bloc.state;
        if (state.db == null) {
          bloc.add(FirstTime2());
          return;
        }
        Map<String, Object> data = {
          "datenote": tanggal,
          "description": detailController.text,
          'type': type ?? 'out',
          'money': money,
          'id_category': (isIncome!) ? defaultValueIn! : defaultValueOut!,
        };
        // print(data);
        // return;
        ComponentCustom.confirmationDialog("Confirmation",
            'Are you sure want ${widget.type == "edit" ? "update" : "add"} this data?',
            () {
          if (widget.type == "edit") {
            bloc.add(UpdateData(state.db!, state.data, widget.data!.id, data,
                categoryData: state.categoryData));
            Navigator.of(context).pop();
            return;
          }
          bloc.add(InsertData(state.db!, state.data, data,
              categoryData: state.categoryData));
          Navigator.of(context).pop();
        }, context);
        // }
      } catch (err) {
        ComponentCustom.messageDialog(
          "Fail",
          'error: $err',
          () => Navigator.of(context).pop(),
          context,
        );
      }
    }
  }

  Widget formDropdown(double heightScreen) {
    if (isIncome == null) {
      return Container();
    }

    return BlocBuilder<DBBloc, DBState>(builder: (context, state) {
      List<DropdownMenuItem<int>> items1 = state.categoryData
          .where((element) => element.type == 'in')
          .map((CategoryData value) {
        return DropdownMenuItem<int>(
          value: value.id,
          child: Text(value.category),
        );
      }).toList();
      List<DropdownMenuItem<int>> items2 = state.categoryData
          .where((element) => element.type == 'out')
          .map((CategoryData value) {
        return DropdownMenuItem<int>(
          value: value.id,
          child: Text(value.category),
        );
      }).toList();
      int? valueIn = defaultValueIn;
      int? valueOut = defaultValueOut;
      // try {
      if (widget.type == 'edit' && widget.data != null) {
        final cat = widget.data!.category;
        final ty = widget.data!.type;
        final found = state.categoryData
            .indexWhere((e) => e.category == cat && e.type == ty);

        if (found != -1 && widget.data!.type == 'in') {
          valueIn = state.categoryData[found].id;
        } else if (found != -1 && widget.data!.type == 'out') {
          valueOut = state.categoryData[found].id;
        }
      }

      final dd1 = DropdownButtonFormField(
        value: valueIn,
        items: items1,
        onChanged: (value) {
          setState(() {
            defaultValueIn = value;
          });
        },
      );
      final dd2 = DropdownButtonFormField(
        value: valueOut,
        items: items2,
        onChanged: (value) {
          setState(() {
            defaultValueOut = value;
          });
        },
      );

      return SizedBox(
        width: double.infinity,
        height: heightScreen * 0.065,
        child: Row(children: [
          const Expanded(
            flex: 1,
            child: Text("Category"),
          ),
          Expanded(
            flex: 2,
            child: isIncome! ? dd1 : dd2,
          )
        ]),
      );
    });
  }

  Widget template(String text, double heightScreen, Widget child) {
    return SizedBox(
      height: heightScreen * 0.065,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(text),
            ),
          ),
          Expanded(
            flex: 2,
            child: child,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return BlocListener<DBBloc, DBState>(
      listener: (context, state) {
        if (state is DBStateInsertFailed) {
          ComponentCustom.messageDialog("Fail", 'Saved failed :${state.reason}',
              () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).pop();
          }, context);
        } else if (state is DBStateInsertSuccess) {
          ComponentCustom.messageDialog("Success", "Saved successfully", () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          }, context);
        } else if (state is DBStateUpdateSuccess) {
          ComponentCustom.messageDialog("Success", "Updated successfully", () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          }, context);
        } else if (state is DBStateUpdateFailed) {
          ComponentCustom.messageDialog(
              "Fail", 'Updated failed :${state.reason}', () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).pop();
          }, context);
        } else if (state is DBStateDeleteSuccess) {
          ComponentCustom.messageDialog("Success", "Delete successfully", () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          }, context);
        } else if (state is DBStateDeleteFailed) {
          ComponentCustom.messageDialog(
              "Fail", 'Delete failed :${state.reason}', () {
            context
                .read<DBBloc>()
                .add(ResetStatus(state.db, state.data, state.categoryData));
            Navigator.of(context).pop();
          }, context);
        }
      },
      child: PopScope(
        onPopInvoked: (didPop) {
          final bloc = context.read<DBBloc>();
          final state = bloc.state;
          if (state.db != null) {
            // if(state is DB)
            bloc.add(ResetStatus(state.db!, state.data, state.categoryData));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              widget.type == 'edit' ? "Update Data" : "Add Data",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  template(
                    'Date',
                    heightScreen,
                    FormDate(
                      initialValueDate(),
                      (newvalue) => dateData = newvalue,
                    ),
                  ),
                  template(
                    'Amount',
                    heightScreen,
                    FormMoney(
                      initialValueMoney(),
                      (newValue) {
                        final value = newValue?.replaceAll(
                                RegExp(r'[\,]+|(\.[0-9]+)'), '') ??
                            '0';
                        money = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  template(
                    '',
                    heightScreen,
                    FormType(
                      initialValueType(),
                      (newValue) => type = newValue,
                      event: (newValue) {
                        if (newValue == 'in') {
                          setState(() {
                            isIncome = true;
                          });
                        } else if (newValue == 'out') {
                          setState(() {
                            isIncome = false;
                          });
                        }
                      },
                    ),
                  ),

                  formDropdown(heightScreen),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Detail"),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          height: heightScreen * 0.1,
                          child: TextFormField(
                            controller: detailController,
                            maxLines: 3,
                            maxLength: 50,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(fontSize: heightScreen * 0.015),
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.only(
                                  top: 8, left: 12, right: 12),
                              // const EdgeInsets.symmetric(
                              //   // vertical: double.infinity,
                              //   horizontal: 12,
                              // ),
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // type
                  widget.type == "edit"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widthScreen * 0.5,
                              child: ElevatedButton(
                                onPressed: send,
                                child: const Text("Update"),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: widthScreen * 0.3,
                              child: ElevatedButton(
                                onPressed: () {
                                  final bloc = context.read<DBBloc>();
                                  final state = bloc.state;
                                  if (state.db != null) {
                                    ComponentCustom.confirmationDialog(
                                        "Confirmation",
                                        "Are you sure want delete this data?",
                                        () {
                                      context.read<DBBloc>().add(DeleteData(
                                            state.db!,
                                            state.data,
                                            widget.data!.id,
                                            weeklyData: state.weeklyData,
                                            categoryData: state.categoryData,
                                          ));
                                      Navigator.of(context).pop();
                                    }, context);
                                  }
                                },
                                child: const Text("Delete"),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: widthScreen * 0.5,
                          child: ElevatedButton(
                            onPressed: send,
                            child: const Text("Save"),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
