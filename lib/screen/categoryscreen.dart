import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/component/component_custom.dart';
import 'package:acccountmonthly/component/form_type.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isModeAdd = false;
  bool isEditMode = false;
  String? type;
  int? id;
  String category = '';
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? initialValueType() {
    if (isEditMode) {
      return type;
    }
    return null;
  }

  void send() {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<DBBloc>();
      formKey.currentState!.save();
      Map<String, Object> data = {'category': category};
      if (bloc.state.db == null) {
        bloc.add(FirstTime2());
        return;
      }

      ComponentCustom.confirmationDialog(
        "Confirmation",
        'Are you sure want ${isEditMode ? "update" : "add"} this data?',
        () {
          if (isModeAdd) {
            data['type'] = type ?? 'in';

            bloc.add(InsertDataCategory(
              bloc.state.db!,
              bloc.state.data,
              data,
              bloc.state.weeklyData,
              bloc.state.categoryData,
            ));
          } else if (isEditMode) {
            if (id != null) {
              bloc.add(UpdateDataCategory(
                bloc.state.db!,
                bloc.state.data,
                data,
                bloc.state.weeklyData,
                bloc.state.categoryData,
                id!,
              ));
            }
          }
          Navigator.of(context).pop();
          category = '';
          setState(() {
            isEditMode = false;
            isModeAdd = false;
            type = null;
            id = null;
            // id = false;
          });
        },
        context,
      );
      print("success");
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white70,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Category",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      body: BlocListener<DBBloc, DBState>(
        listener: (context, state) {
          if (state is DBStateInsertFailed) {
            ComponentCustom.messageDialog(
                "Fail", 'Saved failed :${state.reason}', () {
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
              Navigator.of(context).pop();
            }, context);
          } else if (state is DBStateUpdateSuccess) {
            ComponentCustom.messageDialog("Success", "Updated successfully",
                () {
              context
                  .read<DBBloc>()
                  .add(ResetStatus(state.db, state.data, state.categoryData));
              Navigator.of(context).pop();
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
              Navigator.of(context).pop();
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
        child: Container(
          height: heightScreen,
          color: Colors.grey[300],
          child: Column(
            children: [
              Expanded(
                flex: isModeAdd
                    ? 5
                    : isEditMode
                        ? 2
                        : 1,
                child: GestureDetector(
                  onTap: () {
                    if (!isModeAdd) {
                      setState(() {
                        isModeAdd = true;
                      });
                    }
                  },
                  child: Container(
                    width: widthScreen,
                    color: Colors.white,
                    child: isModeAdd || isEditMode
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.07,
                                    child: FormField<String>(
                                      initialValue: category,
                                      onSaved: (newValue) =>
                                          category = newValue ?? '',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please fill';
                                        }
                                        return null;
                                      },
                                      builder: (field) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: TextFormField(
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                maxLength: 20,
                                                initialValue: field.value,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      heightScreen * 0.015,
                                                ),
                                                onChanged: (value) {
                                                  field.didChange(value);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  hintText:
                                                      'Please input name category',
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        field.errorText ?? '',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize:
                                                              heightScreen *
                                                                  0.015,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${field.value?.length} / 20',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize:
                                                              heightScreen *
                                                                  0.015,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  isEditMode
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: heightScreen * 0.07,
                                          child: FormType(
                                            initialValueType(),
                                            (newValue) => type = newValue,
                                          ),
                                        ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: widthScreen * 0.4,
                                        child: ElevatedButton(
                                          onPressed: send,
                                          child: Text(
                                            isModeAdd ? "Save" : "Update",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          category = '';
                                          setState(() {
                                            isModeAdd = false;
                                            isEditMode = false;
                                          });
                                        },
                                        child: const Icon(Icons.close),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                fontSize: heightScreen * 0.02,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: isModeAdd
                    ? 14
                    : isEditMode
                        ? 9
                        : 9,
                child: BlocBuilder<DBBloc, DBState>(
                  builder: (context, state) {
                    final c = state.categoryData;
                    c.sort(
                      (a, b) => a.category.compareTo(b.category),
                    );
                    return ListView.separated(
                      itemCount: c.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        c[index].category,
                                        style: TextStyle(
                                          fontSize: heightScreen * 0.02,
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        c[index].type == 'in'
                                            ? 'Income'
                                            : c[index].type == 'out'
                                                ? 'Expense'
                                                : 'unknown',
                                        style: TextStyle(
                                          fontSize: heightScreen * 0.02,
                                          color: c[index].type == 'in'
                                              ? Colors.green[600]
                                              : (c[index].type == 'out'
                                                  ? Colors.red[600]
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                    const Expanded(flex: 1, child: SizedBox()),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextButton(
                                        onPressed: () {
                                          final val = c[index];
                                          setState(() {
                                            isEditMode = true;
                                            category = val.category;
                                            type = val.type;
                                            id = val.id;
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: heightScreen * 0.025,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextButton(
                                        onPressed: () {
                                          ComponentCustom.confirmationDialog(
                                            'Confirmation',
                                            'are you sure want delete this data?',
                                            () {
                                              final bloc =
                                                  context.read<DBBloc>();
                                              if (state.db == null) {
                                                bloc.add(FirstTime2());
                                                return;
                                              }
                                              bloc.add(DeleteDataCategory(
                                                state.db!,
                                                state.data,
                                                state.weeklyData,
                                                state.categoryData,
                                                c[index].id,
                                              ));
                                              Navigator.of(context).pop();
                                            },
                                            context,
                                          );

                                          // final bloc = state
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: heightScreen * 0.025,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
