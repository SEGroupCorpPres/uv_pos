import 'package:future_pos/core/core.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    // stacktrace uzunligi
    errorMethodCount: 8,
    // error stacktrace uzunligi
    lineLength: 100,
    // chiziq uzunligi
    colors: true,
    // rangli log
    printEmojis: true,
    // emoji qo‘shiladi
    dateTimeFormat: DateTimeFormat.dateAndTime, // vaqt chiqadi
  ),
);
