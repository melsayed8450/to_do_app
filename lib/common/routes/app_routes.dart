import 'package:get/get.dart';
import '../../features/home/screens/home.dart';
import 'app_pages.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppPages.home,
      page: () => HomePage(),
    ),
  ];
}
