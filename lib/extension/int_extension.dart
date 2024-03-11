import 'package:intl/intl.dart';

extension IntExtend on int {
  String ordinalSuffixOf() {
    int j = this % 10;
    int k = this % 100;
    if (j == 1 && k != 11) {
      return '${this}st';
    }
    if (j == 2 && k != 12) {
      return '${this}nd';
    }
    if (j == 3 && k != 13) {
      return '${this}rd';
    }
    return '${this}th';
    // return '';
  }

  String moneyFormat() {
    return NumberFormat("#,##0.00", "en_US").format(this);
  }
}
