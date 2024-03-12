import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/data/setting_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ETCPreview extends StatefulWidget {
  const ETCPreview({super.key});

  @override
  State<ETCPreview> createState() => _ETCPreviewState();
}

class _ETCPreviewState extends State<ETCPreview> {
  OverlayEntry? overlayEntry;
  final focusNode = FocusNode();
  LayerLink layerLink = LayerLink();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    overlayEntry?.dispose();

    super.dispose();
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    context.read<SettingCubit>().openOverlay();
    // final renderBox= context.findRenderObject() as RenderBox;
    final widthScreen = MediaQuery.sizeOf(context).width;
    //MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widthScreen * 0.23,
        child: CompositedTransformFollower(
          showWhenUnlinked: false,
          link: layerLink,
          offset: Offset(-(widthScreen * 0.18), 18),
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(overlayEntry!);
  }

  Widget itemList(double heightScreen, double widthScreen, Function() event,
      String text, IconData? icon) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: event,
      child: Container(
        width: widthScreen * 0.25,
        padding: const EdgeInsets.all(8),
        height: heightScreen * 0.05,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(fontSize: heightScreen * 0.015),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOverlay() {
    final widthScreen = MediaQuery.sizeOf(context).width;
    final heightScreen = MediaQuery.sizeOf(context).height;
    return BlocListener<SettingCubit, SettingData>(
      listener: (context, state) {
        if (state.closeOverlay) {
          hideOverlay();
        }
      },
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemList(
              heightScreen,
              widthScreen,
              () {
                hideOverlay();
                Navigator.pushNamed(context, '/category');
              },
              "Category",
              Icons.category,
            ),
            itemList(
              heightScreen,
              widthScreen,
              () => hideOverlay(),
              "Setting",
              Icons.settings,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOverlay();
      },
      child: CompositedTransformTarget(
        link: layerLink,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
