import 'package:delivery_flutter_master/splash_screen.dart';
import 'package:delivery_flutter_master/utils/shared_preference_utils.dart';
import 'package:delivery_flutter_master/utils/themes.dart';
import 'package:delivery_flutter_master/view/general_screens/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'models/connectivity_model.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefUtils.initialize();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          theme: MyTheme().lightTheme,
          title: "Dairy Product Delivery",
          onGenerateRoute: generateRoute,
          initialRoute: '/',
        );
        ;
      },
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => GetBuilder<ConnectivityViewModel>(
              builder: (connectivityViewModel) {
                if (connectivityViewModel.isOnline != null) {
                  if (connectivityViewModel.isOnline!) {
                    return SplashScreen();
                  } else {
                    return const NoInterNetConnected();
                  }
                } else {
                  return const Material();
                }
              },
            ));

      default:
        return MaterialPageRoute(
          builder: (_) => GetBuilder<ConnectivityViewModel>(
            builder: (connectivityController) {
              if (connectivityViewModel.isOnline != null) {
                if (connectivityViewModel.isOnline!) {
                  return SplashScreen();
                } else {
                  return const NoInterNetConnected();
                }
              } else {
                return const Material();
              }
            },
          ),
        );
    }
  }
  /// CONTROLLER INITIALIZE
  ConnectivityViewModel connectivityViewModel =
  Get.put(ConnectivityViewModel());
}