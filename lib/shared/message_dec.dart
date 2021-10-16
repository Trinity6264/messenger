import 'package:flutter/material.dart';
import 'package:messenger/const/const_color.dart';

const textDecoration = InputDecoration(
  border: InputBorder.none,
  fillColor: textInput,
  filled: true,
  enabled: true,
  enabledBorder: OutlineInputBorder(),
  focusColor: textInput,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
    ),
  ),
  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
);
