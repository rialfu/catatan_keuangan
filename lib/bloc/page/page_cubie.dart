import 'package:acccountmonthly/data/page_data.dart';
import 'package:acccountmonthly/page_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageCubit extends Cubit<PageData> {
  PageCubit() : super(const PageData(PageName.home, false));
  void changePage({required PageName? page, required bool unknown}) {
    emit(PageData(page, unknown));
  }
}
