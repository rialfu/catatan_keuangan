import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingData extends Equatable {
  final bool isAsc;
  final bool isModeEdit;
  final Color foreground;
  final bool closeOverlay;
  // final
  const SettingData(this.isAsc, this.isModeEdit, this.foreground,
      {this.closeOverlay = true});

  SettingData copyWith({
    bool? isAsc,
    bool? isModeEdit,
    Color? foreground,
    bool? closeOverlay,
  }) {
    // Colors.red
    return SettingData(
      isAsc ?? this.isAsc,
      isModeEdit ?? this.isModeEdit,
      foreground ?? this.foreground,
      closeOverlay: closeOverlay ?? this.closeOverlay,
    );
  }

  @override
  List<Object> get props => [isAsc, isModeEdit, closeOverlay];
}
