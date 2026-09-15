import 'package:flutter/material.dart';

class Breakpoint {
  static const mobile = 600.0;
  static const tablet = 900.0;

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobile;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobile && 
    MediaQuery.of(context).size.width >= tablet;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tablet;
} 