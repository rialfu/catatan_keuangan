import 'package:acccountmonthly/extension/datetime_extension.dart';
import 'package:flutter/material.dart';

class FormDate extends StatelessWidget {
  final DateTime? initial;
  final Function(DateTime?) saved;
  const FormDate(this.initial, this.saved, {super.key});

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    return FormField(
      initialValue: initial,
      onSaved: saved,
      validator: (value) {
        if (value == null) {
          return "Date must fill";
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () async {
                  DateTime val = field.value ?? DateTime.now();
                  final newDate = await showDatePicker(
                    firstDate: DateTime(2000),
                    lastDate: DateTime(val.year + 10),
                    context: context,
                    initialDate: val,
                  );
                  if (newDate != null) {
                    field.didChange(newDate);
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    // vertical: 8,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.value?.formatddMMyyyy() ?? '',
                        style: TextStyle(fontSize: heightScreen * 0.015),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
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
