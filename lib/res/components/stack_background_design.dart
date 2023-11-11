import 'package:e_store/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StackBackground extends StatelessWidget {
  const StackBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 1;
    final double height = MediaQuery.of(context).size.height * 1;
    return Positioned(
      bottom: height * .7,
      right: width * .4,
      child: CircleAvatar(
        radius: 180,
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(left: 120, top: 100),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return FittedBox(
                child: Image.asset(
                  height: height * .3,
                  width: width * .9,
                  themeProvider.isDarkTheme ?
                  'assets/images/darkLogo.png' : 'assets/images/lightLogo.png',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
