import 'package:flame/components.dart';
import 'package:flutter/material.dart';

extension Vector2Size on Vector2 {
  Size toSize2() => Size(x, y);
}