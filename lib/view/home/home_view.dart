import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
        return Scaffold(
          body: homeViewModel.tabs[homeViewModel.currentIndex],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: GNav(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              gap: 10,
              backgroundColor: Theme.of(context).cardColor,
              tabBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              tabMargin: const EdgeInsets.all(10),
              selectedIndex: homeViewModel.currentIndex,
              onTabChange: (index) {
                homeViewModel.setCurrentIndex(index);
              },
              tabs: const [
                GButton(icon: Icons.home, text: "Home"),
                GButton(icon: Icons.message, text: "Chat"),
                GButton(icon: Icons.add, text: ""),
                GButton(icon: Icons.stacked_bar_chart_rounded, text: "Posts"),
                GButton(icon: Icons.settings, text: "Settings"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
