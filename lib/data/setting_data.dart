import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingData extends Equatable {
  final bool isAsc;
  final bool isModeEdit;
  final Color foreground;
  final bool closeOverlay;
  final double fontSizeNormal;
  final bool permissionStorage;
  // final bool
  // final
  const SettingData(
    this.isAsc,
    this.isModeEdit,
    this.foreground, {
    this.closeOverlay = true,
    this.fontSizeNormal = 16,
    this.permissionStorage = false,
  });

  SettingData copyWith({
    bool? isAsc,
    bool? isModeEdit,
    Color? foreground,
    bool? closeOverlay,
    double? fontSizeNormal,
    bool? permissionStorage,
  }) {
    // Colors.red
    return SettingData(
      isAsc ?? this.isAsc,
      isModeEdit ?? this.isModeEdit,
      foreground ?? this.foreground,
      closeOverlay: closeOverlay ?? this.closeOverlay,
      fontSizeNormal: fontSizeNormal ?? this.fontSizeNormal,
      permissionStorage: permissionStorage ?? this.permissionStorage,
    );
  }

  @override
  List<Object> get props => [
        isAsc,
        isModeEdit,
        permissionStorage,
        closeOverlay,
        fontSizeNormal,
      ];
}
