import 'package:flutter/material.dart';

class TabItemModel {
  const TabItemModel({
    required this.label,
    required this.icon,
    required this.page,
  });
  final String label;
  final IconData icon;
  final Widget page;
}
