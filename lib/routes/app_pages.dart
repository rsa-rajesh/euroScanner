import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:euro_scanner/screens/home_page/home_page_binding.dart';
import 'package:euro_scanner/screens/home_page/home_page_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomePagePage(),
      binding: HomePageBinding(),
    ),
  ];
}