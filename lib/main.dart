import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:euro_scanner/routes/app_pages.dart';
import 'package:euro_scanner/screens/home_page/home_page_binding.dart';
import 'package:euro_scanner/screens/home_page/home_page_view.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    WindowManager.instance.setMinimumSize(const Size(600, 600));
    // WindowManager.instance.setMaximumSize(const Size(1200, 600));
  }

  if(Platform.isWindows ||Platform.isLinux){
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;
  // HotKey _hotKey = HotKey(
  //   KeyCode.keyQ,
  //   modifiers: [KeyModifier.control],
  //   scope: HotKeyScope.system,
  // );
  // await hotKeySystem.register(
  //   _hotKey,
  //   keyDownHandler: (hotKey) async {
  //     print('onKeyDown+${hotKey.toJson()}');
  //     if(await windowManager.isMinimized()){
  //       windowManager.show();
  //     }else{
  //       windowManager.minimize();
  //     }
  //   },
  //   // Only works on macOS.
  //   keyUpHandler: (hotKey){
  //     print('onKeyUp+${hotKey.toJson()}');
  //   } ,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      title: 'Euro Paints Scanner',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePagePage(),
      initialBinding: HomePageBinding(),
      getPages: AppPages.pages,
    );
  }
}
