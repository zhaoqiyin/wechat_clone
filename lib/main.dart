import 'package:flutter/material.dart';

import './constants.dart' show AppColors;
import './home/home_screen.dart';

void main() => runApp(MaterialApp(
  title: 'Wechat',
  theme: ThemeData.light().copyWith(
    primaryColor: Color(AppColors.AppBarColor),
  ),
  home: HomeScreen(),
));
