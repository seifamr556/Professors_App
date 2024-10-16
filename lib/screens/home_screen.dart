import 'package:college_application/screens/main_screen.dart';
import 'package:college_application/screens/profile_screen.dart';
import 'package:college_application/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Create an instance of the HomeController
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Obx is used to make the body reactive to currentIndex changes
      body:
          Obx(() => homeController.screens[homeController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: const Color(0xff7F1416),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color(0xffffffff),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color(0xffffffff),
              ),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Color(0xffffffff),
              ),
              label: "Settings",
            ),
          ],
          currentIndex: homeController.currentIndex.value,
          selectedItemColor: Colors.black38,
          onTap: (index) {
            homeController
                .changeIndex(index); // Update currentIndex using controller
          },
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> screens = [
    MainScreen(),
    ProfileScreen(),
    SettingsScreen()
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
