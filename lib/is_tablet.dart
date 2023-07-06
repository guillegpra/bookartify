import 'dart:math';

import 'package:flutter/material.dart';

bool isTablet(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final diagonalSize = sqrt(
    (screenSize.width * screenSize.width) +
      (screenSize.height * screenSize.height));
  return diagonalSize >= 1100; // Adjust the threshold according to your needs
}