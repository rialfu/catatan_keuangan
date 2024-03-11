// import 'package:acccountmonthly/bloc/arus/arus_bloc.dart';
import 'package:acccountmonthly/bloc/date/date_cubit.dart';
import 'package:acccountmonthly/bloc/db/db_event.dart';
import 'package:acccountmonthly/bloc/db/db_state.dart';
// import 'package:acccountmonthly/bloc/db/db_state.dart';
import 'package:acccountmonthly/bloc/db/db_bloc.dart';
import 'package:acccountmonthly/bloc/setting/setting_cubit.dart';
import 'package:acccountmonthly/screen/addscreen.dart';
import 'package:acccountmonthly/screen/categoryscreen.dart';
import 'package:acccountmonthly/screen/chartscreen.dart';
import 'package:acccountmonthly/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// import 'package:in'
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // final _routerDelegate = AppRoutersDelegate();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    // final widthScreen = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DBBloc()..add(FirstTime2()),
        ),
        BlocProvider(create: (context) => DateCubit()),
        BlocProvider(create: (context) => SettingCubit()),
      ],

      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          // colorScheme: ColorScheme.fromSwatch(
          //  primarySwatch: MaterialColor(primary, swatch)
          // ),
          primaryColor: Colors.white,

          textTheme: TextTheme(
              displayLarge: TextStyle(
                fontSize: heightScreen * 0.03,
              ),
              displayMedium: TextStyle(
                fontSize: heightScreen * 0.015,
              ),
              displaySmall: TextStyle(
                fontSize: heightScreen * 0.007,
              )),
        ),
        routes: {
          '/': (context) {
            return BlocBuilder<DBBloc, DBState>(
              builder: (context, state) {
                if (state is DBStateInitial) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is DBStateConnecting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is DBStateConnectFailed) {
                  return Scaffold(
                    body: Center(
                      child: TextButton(
                        onPressed: () {
                          context.read<DBBloc>().add(FirstTime2());
                        },
                        child: const Text(
                          "Retry",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const HomeScreen();
                }
              },
            );
          },
          '/add': (context) {
            return const AddScreen();
          },
          '/chart': (context) {
            // context.
            return const ChartScreen();
          },
          '/category': (context) => const CategoryScreen(),
        },
      ),
      // child: BlocBuilder<PageCubit, PageData>(builder: (context, state) {
      //   return MaterialApp.router(
      //     title: "Judul",
      //     routeInformationParser: AppRouteInformationParser(),
      //     routerDelegate: AppRouterDelegate(cubit: context.read<PageCubit>()),
      //   );
      // }),
    );
  }
}
