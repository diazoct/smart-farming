import 'package:flutter/material.dart';

class TitleScreen extends StatelessWidget implements PreferredSizeWidget {
  const TitleScreen({super.key, this.titleContainer});
  final String? titleContainer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(
          titleContainer!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF5F84B1),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
