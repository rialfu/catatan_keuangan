import 'dart:io';

import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/component/component_custom.dart';
import 'package:acccountmonthly/component/overlay_choose_folder.dart';
import 'package:acccountmonthly/custom_class/overlayportalcontrollerex.dart';
import 'package:acccountmonthly/data/setting_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen>
    with SingleTickerProviderStateMixin {
  final String pathRootAndroid = '/storage/emulated/0/';
  final _overlayController = OverlayPortalControllerEx();
  late AnimationController _controller;
  double heightChild = 0;
  String path = '';
  // bool firstTime = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void checkPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    bool permissionStatus = false;
    final bloc = context.read<SettingCubit>();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      // if()
      // permission

      int ver = info.version.sdkInt;
      try {
        if (ver < 29) {
          const storage = Permission.storage;
          if (await storage.isGranted) {
            permissionStatus = true;
          } else {
            final res = storage.request();
            if (await res.isGranted) {
              permissionStatus = true;
            }
          }
        } else if (ver < 33) {
          const storage = Permission.storage;
          if (await storage.isGranted) {
            permissionStatus = true;
          } else {
            final res = storage.request();
            if (await res.isGranted) {
              permissionStatus = true;
            }
          }
        } else {
          print("ini 33");
          const storage = Permission.manageExternalStorage;
          if (await storage.isGranted) {
            permissionStatus = true;
          } else {
            final res = await storage.request();
            if (res.isGranted) {
              permissionStatus = true;
            }
          }
        }
      } catch (err) {
        print(err);
        ComponentCustom.messageDialog('Fail', err.toString(), () {
          Navigator.of(context).pop();
        }, context);
      }
    }
    print('permission:$permissionStatus');
    // if (!permissionStatus) {
    //   openAppSettings();
    // }
    if (permissionStatus) {
      _overlayController.toggleCustom();
    }
    bloc.setStorage(permissionStatus);
  }

  Future<bool> backupData(int i) async {
    final state = context.read<DBBloc>().state;
    if (state.db == null) {
      throw 'not available db';
      // return false;
    }
    String query = 'select a.id, description, datenote, money, a.type, ';
    query += 'case when b.category is null then \'other\' else b.category ';
    query += 'end as category from notes a left join category b ';
    query += 'on b.id=a.id_category and a.type=b.type order by datenote asc';
    final datas = await state.db!.rawQuery(query);
    Map<String, Object?> data = {};
    String total = '';
    for (int i = 0; i < datas.length; i++) {
      data = datas[i];
      // String id = (data['id'] as int).toString();
      String desc = '${data['description']}';
      String date = '${data['datenote']}';
      String money = '${data['money']}';
      String type = '${data['type']}';
      String category = '${data['category']}';
      total += '$desc,$date,$money,$type,$category|';
    }
    if (total.isNotEmpty && total.substring(total.length - 1) == '|') {
      total = total.substring(0, total.length - 1);
    }

    File file = File('$pathRootAndroid$path/newfile.txt');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(total);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: OverlayChooseFolder(
        controller: _overlayController,
        path: path,
        event: (path) {
          setState(() {
            this.path = path;
          });
          // path
        },
        child: Container(
          width: widthScreen,
          height: heightScreen,
          color: Colors.grey.shade200,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: Colors.white,
                  height: heightScreen * 0.1,
                  child: Row(
                    children: [
                      const Text("Backup"),
                      IconButton(
                        onPressed: () {
                          if (_controller.isCompleted) {
                            _controller.reverse();
                            setState(() {
                              heightChild = 0;
                            });
                          } else {
                            _controller.forward();
                            setState(() {
                              heightChild = 0.15;
                            });
                          }
                        },
                        icon: RotationTransition(
                          turns: Tween(begin: 0.25, end: 0.75)
                              .animate(_controller),
                          child: const Icon(
                            Icons.chevron_left,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  // constraints: BoxConstraints(minHeight: 150),
                  duration: const Duration(milliseconds: 500),
                  height: heightScreen * (heightChild),
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: widthScreen,
                  child: BlocBuilder<SettingCubit, SettingData>(
                      builder: (context, valueSetting) {
                    return SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widthScreen,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(path == '' ? 'Home' : path),
                                  IconButton(
                                    onPressed: () {
                                      if (valueSetting.permissionStorage) {
                                        _overlayController.toggleCustom();
                                      } else {
                                        checkPermission();
                                      }
                                    },
                                    icon: const Icon(Icons.folder),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   child: Text("Path"),
                            // ),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!valueSetting.permissionStorage) {
                                    checkPermission();
                                    return;
                                  }
                                  final bloc = context.read<DBBloc>();
                                  final state = bloc.state;
                                  if (state.db != null) {
                                    bloc.add(BackupData(
                                      state.db!,
                                      state.data,
                                      state.weeklyData,
                                      state.categoryData,
                                      path: path,
                                    ));
                                    // return false;
                                  }
                                  // compute(backupData, 1)
                                  //     .then((value) =>
                                  //         print('hasil backup:$value'))
                                  //     .catchError((err) => print('err:$err'));
                                },
                                child: Text("Backup"),
                              ),
                            )
                          ]),
                    );
                  }),
                ),
                // GestureDetector(
                //   onTap: () {
                //     _overlayController.show();
                //   },
                //   child: Container(
                //     color: Colors.white,
                //     height: heightScreen * 0.1,
                //     width: double.infinity,
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                //     child: Text("Backup"),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.white,
                    height: heightScreen * 0.1,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text("Restore"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
