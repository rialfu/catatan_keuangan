// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class FormType extends StatelessWidget {
  final String? initial;
  final String? positiveValue;
  final String? positiveName;
  final String? negativeName;
  final String? negativeValue;
  final String message;
  final Function(String?) saved;
  final Function(Object?)? event;
  const FormType(
    this.initial,
    this.saved, {
    this.message = '',
    this.positiveValue,
    this.negativeValue,
    this.positiveName,
    this.negativeName,
    this.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.sizeOf(context).height;
    return FormField<String>(
      onSaved: saved,
      initialValue: initial,
      validator: (value) {
        if (value == null) {
          return message == '' ? 'Please choose income / expense' : message;
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        field.didChange(positiveValue ?? 'in');
                        if (event != null) {
                          event!(positiveValue ?? 'in');
                        }
                      },
                      child: Container(
                        // height: heightScreen * 0.045,
                        decoration: BoxDecoration(
                          color: (positiveValue != null
                                  ? (field.value == positiveValue)
                                  : (field.value == "in"))
                              ? Colors.green[600]
                              : Colors.green[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              positiveName ?? 'Income',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: heightScreen * 0.015,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        field.didChange(negativeValue ?? 'out');
                        if (event != null) {
                          event!(negativeValue ?? 'out');
                        }
                      },
                      child: Container(
                        // height: heightScreen * 0.045,
                        decoration: BoxDecoration(
                          color: (negativeValue != null
                                  ? (field.value == negativeValue)
                                  : (field.value == "out"))
                              ? Colors.red[600]
                              : Colors.red[200],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              negativeName ?? "Expense",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: heightScreen * 0.015,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: heightScreen * 0.015,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
