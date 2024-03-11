import 'package:flutter/cupertino.dart';

class OverlayPortalControllerEx extends OverlayPortalController {
  ValueNotifier<bool> status = ValueNotifier<bool>(false);
  OverlayPortalControllerEx() {
    status.value = isShowing;
  }
  void toggleCustom() {
    if (isShowing) {
      hide();
      status.value = false;
    } else {
      show();
      status.value = true;
    }
  }
}
