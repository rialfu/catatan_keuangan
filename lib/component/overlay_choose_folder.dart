import 'package:acccountmonthly/custom_class/overlayportalcontrollerex.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class OverlayChooseFolder extends StatefulWidget {
  final OverlayPortalControllerEx controller;
  final Widget child;
  final String path;
  final Function(String)? event;
  const OverlayChooseFolder({
    required this.controller,
    required this.child,
    required this.path,
    this.event,
    super.key,
  });

  @override
  State<OverlayChooseFolder> createState() => _OverlayChooseFolderState();
}

class _OverlayChooseFolderState extends State<OverlayChooseFolder> {
  final String pathRootAndroid = '/storage/emulated/0/';
  String path = '';
  bool isAndroid = true;
  List<String> listDir = [];
  List<String> listFile = [];

  @override
  void initState() {
    super.initState();
    widget.controller.status.addListener(listener);
    // checkVersion();
    // getapp
  }

  void listener() {
    // if(widget.)
    print('run listner ${widget.path}');
    if (widget.controller.status.value) {
      loadFolder(widget.path);
    }
  }

  @override
  void dispose() {
    widget.controller.status.removeListener(listener);
    super.dispose();
  }
  // void lis

  void loadFolder(String newPath) {
    final dir = Directory('$pathRootAndroid$newPath');
    print('path andro:$pathRootAndroid$newPath');
    if (!dir.existsSync()) {
      loadFolder('');
      return;
    }
    // print()
    final list = dir.listSync();
    List<String> listDir = [];
    List<String> listFile = [];
    for (int i = 0; i < list.length; i++) {
      print(list[i].path);
      if (list[i] is Directory) {
        listDir.add(list[i].path.replaceAll(pathRootAndroid, ''));
      } else if (list[i] is File) {
        listFile.add(list[i].path.replaceAll(pathRootAndroid, ''));
      }
      // list[i].
    }
    listDir.sort((a, b) => a.compareTo(b));
    print('path new:$newPath');
    setState(() {
      this.listDir = listDir;
      this.listFile = listFile;
      path = newPath;
    });
  }

  Widget setHeader() {
    List<String> list = ['Home'];
    // if (path != '') {
    list.addAll(path.split('/'));
    // }

    print('setHeader list:$list path:$path');
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      separatorBuilder: (context, index) {
        // return SizedBox();
        return index == list.length - 1
            ? const SizedBox()
            : const Icon(Icons.chevron_right);
      },
      itemBuilder: (context, index) {
        if (index == list.length - 1) {
          return Center(
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
                  child: Text(list[index])));
        }
        return Center(
            child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
            // iconColor: Colors.black,
          ),
          onPressed: () {
            // if(index =)
            final listNew = List.of(list);
            listNew.removeAt(0);
            final newPath = listNew.take(index).join('/');
            loadFolder(newPath);
          },
          child: Text(
            list[index],
            style: const TextStyle(color: Colors.black54),
          ),
        ));
      },
    );
    // ListView()
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    final heightScreen = MediaQuery.sizeOf(context).height;
    return OverlayPortal(
      controller: widget.controller,
      overlayChildBuilder: (context) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              width: widthScreen * 0.7,
              height: heightScreen * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              disabledColor: Colors.black,
                              onPressed: isAndroid &&
                                      (pathRootAndroid + path) ==
                                          pathRootAndroid
                                  ? null
                                  : () {
                                      print(pathRootAndroid + path);
                                      List<String> listpath = path.split('/');
                                      if (listpath.length > 1) {
                                        listpath.length -= 1;
                                        loadFolder(listpath.join('/'));
                                        // loadFolder(listpath)
                                      } else {
                                        loadFolder('');
                                      }
                                    },
                              icon: Icon(
                                isAndroid
                                    ? ('$pathRootAndroid$path' ==
                                            pathRootAndroid
                                        ? Icons.home
                                        : Icons.arrow_back)
                                    : Icons.home,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: setHeader(),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                widget.controller.toggleCustom();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                      itemCount: listDir.length + listFile.length,
                      itemBuilder: (context, index) {
                        String name = index >= listDir.length
                            ? listFile[index - listDir.length]
                            : listDir[index];
                        return GestureDetector(
                          onTap: () {
                            if (index >= listDir.length) {
                              print('file');
                            } else {
                              print('folder');
                              loadFolder(name);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Text('${name.split('/').last}'),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (widget.event != null) {
                            widget.event!(path);
                          }
                          widget.controller.toggleCustom();
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
