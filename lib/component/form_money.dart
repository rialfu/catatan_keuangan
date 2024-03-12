import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class FormMoney extends StatelessWidget {
  final String initial;
  final Function(String?) saved;
  const FormMoney(this.initial, this.saved, {super.key});

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    return FormField<String>(
      initialValue: initial,
      onSaved: saved,
      validator: (value) {
        double money =
            double.tryParse(value?.replaceAll(RegExp(r'[\,]'), '') ?? '0') ?? 0;
        if (money == 0) {
          return 'Please Fill money';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: field.value,
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                maxLines: 1,
                style: TextStyle(
                  fontSize: heightScreen * 0.015,
                ),
                onChanged: (value) {
                  final f = value.replaceAll(RegExp(r'[\,]'), '');
                  field.didChange(f);
                },
                decoration: InputDecoration(
                  hintText: 'Amount',
                  filled: true,
                  isDense: true,
                  // contentPadding: const EdgeInsets.symmetric(
                  //   horizontal: 12,
                  //   vertical: 5,
                  // ),
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: heightScreen * 0.015,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
