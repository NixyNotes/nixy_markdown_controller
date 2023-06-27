// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

const CODE_STYLE = TextStyle(
  backgroundColor: Colors.grey,
  wordSpacing: 3,
);

const BOLD_TEXT_STYLE = TextStyle(fontWeight: FontWeight.bold);

final CHECKBOX_LIST_STYLE =
    const TextStyle(decoration: TextDecoration.lineThrough)
        .merge(BOLD_TEXT_STYLE);

final HEADERS_STYLE = const TextStyle(fontSize: 25).merge(BOLD_TEXT_STYLE);

const URL_STYLE = TextStyle(color: Colors.purple);
