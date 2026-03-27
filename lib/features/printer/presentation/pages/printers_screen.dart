// import 'printer.dart';
// import 'package:flutter/material.dart';

// class PrintersScreen extends StatefulWidget {
//   const PrintersScreen({super.key});

//   static Page page() => const MaterialPage(
//           child: PrintersScreen(),
//         );

//   @override
//   State<PrintersScreen> createState() => _PrintersScreenState();
// }

// class _PrintersScreenState extends State<PrintersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (bool didPop, result) {
//         context.read<AppBloc>().add(
//               const NavigateToHomeScreen(),
//             );
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//           leading: InkWell(
//             onTap: () => BlocProvider.of<AppBloc>(context).add(
//               const NavigateToHomeScreen(),
//             ),
//             child: Icon(Icons.adaptive.arrow_back),
//           ),
//           title: const Text('Printers (0)'),
//           centerTitle: false,
//         ),
//         body: const Center(
//           child: Text('No record found'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => BlocProvider.of<AppBloc>(context).add(
//             NavigateToAddPrintersScreen(),
//           ),
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }
