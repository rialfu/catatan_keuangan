import 'package:acccountmonthly/extension/double_extension.dart';
import 'package:flutter/material.dart';

class HeaderTotal extends StatelessWidget {
  final double heightScreen;
  final double totalIn;
  final double totalOut;
  const HeaderTotal({
    required this.heightScreen,
    required this.totalIn,
    required this.totalOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "Income",
                    style: TextStyle(
                      fontSize: heightScreen * 0.02,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      totalIn.moneyFormat(),
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: heightScreen * 0.02,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                      fontSize: heightScreen * 0.02,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      totalOut.moneyFormat(),
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: heightScreen * 0.02,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Total",
                      style: TextStyle(fontSize: heightScreen * 0.02),
                    ),
                  ),
                  Text(
                    (totalIn - totalOut).moneyFormat(),
                    style: TextStyle(
                      fontSize: heightScreen * 0.02,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
