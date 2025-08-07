import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app/Screen/AppScreen/History.dart';
import 'package:uber_app/Screen/AppScreen/Home.dart';
import 'package:uber_app/Screen/AppScreen/Inbox.dart';
import 'package:uber_app/Screen/AppScreen/Settings.dart';

class NavigationBottom extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  const NavigationBottom({super.key, required this.uid, required this.name, required this.email, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NavigationController(
        uid: uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
      ),
      tag: uid,
      permanent: false,
    );
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.history), label: 'History'),
            NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        )
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  NavigationController({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  late final screens = [
    Home(uid: uid, name: name, email: email, photoUrl: photoUrl),
    History(uid: uid, name: name, email: email, photoUrl: photoUrl),
    Inbox(uid: uid, name: name, email: email, photoUrl: photoUrl),
    Settings(uid: uid, name: name, email: email, photoUrl: photoUrl)
  ];
}

