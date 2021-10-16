import 'package:flutter/material.dart';
import 'package:messenger/const/const_color.dart';

const inputDecoration = InputDecoration(
  border: InputBorder.none,
  fillColor: textInput,
  filled: true,
  enabled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    ),
  ),
  focusColor: textInput,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  ),
  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
);
