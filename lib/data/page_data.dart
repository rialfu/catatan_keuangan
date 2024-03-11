import 'package:acccountmonthly/page_name.dart';
import 'package:equatable/equatable.dart';

class PageData extends Equatable {
  final PageName? pageName;
  final bool unknownPath;
  const PageData(this.pageName, this.unknownPath);
  @override
  List<Object?> get props => [pageName, unknownPath];
}
