// import 'dart:async';
// import 'dart:typed_data';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:intl/intl.dart';
//
// class PrinterService {
//
//
//
//   final printer = FlutterThermalPrinter.instance;
//
//   Future<void> printReceipt() async {
//     try {
//       // 1. Ulangan printerlar ro‘yxati
//       final List<BluetoothDevice> devices = await printer.getPrinters();
//
//       if (devices.isEmpty) {
//         print("❌ Hech qanday printer topilmadi.");
//         return;
//       }
//
//       // 2. 1-chi topilgan printerga ulanadi
//       final device = devices.first;
//       final isConnected = await printer.connectBluetooth(device);
//
//       if (!isConnected) {
//         print("❌ Ulanib bo‘lmadi.");
//         return;
//       }
//
//       // 3. Chek yaratish
//       final profile = await CapabilityProfile.load();
//       final generator = Generator(PaperSize.mm58, profile);
//       final now = DateTime.now();
//       final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       List<int> bytes = [];
//
//       bytes += generator.text('GOLD MARKET',
//           styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, bold: true));
//       bytes += generator.text('STIR: 305123456', styles: PosStyles(align: PosAlign.center));
//       bytes += generator.text('Toshkent, Chilonzor-5', styles: PosStyles(align: PosAlign.center));
//       bytes += generator.text('Tel: +998 90 123-45-67', styles: PosStyles(align: PosAlign.center));
//       bytes += generator.feed(1);
//
//       bytes += generator.text('FISKAL CHEK', styles: PosStyles(align: PosAlign.center, bold: true));
//       bytes += generator.text('Sana: $formattedDate');
//       bytes += generator.text('Chek №: 0000456  Operator: Azimov O.');
//       bytes += generator.hr();
//
//       // Mahsulotlar
//       bytes += generator.text('Pepsi 1.5L gazli ichimlik');
//       bytes += generator.row([
//         PosColumn(text: '2 x 6000', width: 6, styles: PosStyles(align: PosAlign.left)),
//         PosColumn(text: '12,000', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//
//       bytes += generator.text('Farmfresh Tuxum 10 dona');
//       bytes += generator.row([
//         PosColumn(text: '2 x 1500', width: 6),
//         PosColumn(text: '3,000', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//       bytes += generator.text('➤ Chegirma: -500', styles: PosStyles(align: PosAlign.right));
//
//       bytes += generator.text('Shakar 1kg');
//       bytes += generator.row([
//         PosColumn(text: '1.5 x 9000', width: 6),
//         PosColumn(text: '13,500', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//
//       bytes += generator.hr();
//       bytes += generator.row([
//         PosColumn(text: 'Ara-jami:', width: 6),
//         PosColumn(text: '28,500', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//       bytes += generator.row([
//         PosColumn(text: 'Chegirma:', width: 6),
//         PosColumn(text: '-500', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//       bytes += generator.row([
//         PosColumn(text: 'QQS (12%):', width: 6),
//         PosColumn(text: '3,360', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//       bytes += generator.row([
//         PosColumn(text: 'To‘lov turi:', width: 6),
//         PosColumn(text: 'Naqd', width: 6, styles: PosStyles(align: PosAlign.right)),
//       ]);
//       bytes += generator.row([
//         PosColumn(text: 'Umumiy to‘lov:', width: 6),
//         PosColumn(text: '28,000', width: 6, styles: PosStyles(align: PosAlign.right, bold: true)),
//       ]);
//
//       bytes += generator.feed(1);
//       bytes += generator.text('Fiskal belgi:');
//       bytes += generator.text('7AB3-C4D1-EF89', styles: PosStyles(align: PosAlign.center));
//       bytes += generator.feed(1);
//       bytes += generator.text('RAHMAT!', styles: PosStyles(align: PosAlign.center, bold: true));
//       bytes += generator.feed(2);
//       bytes += generator.cut();
//
//       // 4. Chop etish
//       await printer.printEscPos(Uint8List.fromList(bytes));
//
//       print("✅ Chek muvaffaqiyatli chop etildi.");
//     } catch (e) {
//       print("❌ Xatolik: $e");
//     }
//   }
// }
