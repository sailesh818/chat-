import 'package:flutter/material.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsTileWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16,),
      onTap: onTap,
    );
  }
}