import 'package:acccountmonthly/data/setting_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingData> {
  SettingCubit() : super(const SettingData(false, false, Colors.red));
  void changeSort() {
    emit(state.copyWith(isAsc: !state.isAsc));
  }

  void changeModeEdit() {
    emit(state.copyWith(isModeEdit: !state.isModeEdit));
  }

  void closeOverlay() {
    emit(state.copyWith(closeOverlay: true));
  }

  void openOverlay() {
    emit(state.copyWith(closeOverlay: false));
  }
  // void initial()
}
