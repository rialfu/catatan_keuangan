import 'package:intl/intl.dart';

extension IntExtend on double {
  String moneyFormat() {
    return NumberFormat("#,##0.00", "en_US").format(this);
  }
}
