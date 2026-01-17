// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// class OrdersListScreenAppbar extends StatelessWidget {
//   const OrdersListScreenAppbar({super.key});
//
//   @override
//   AppBar OrdersListScreenAppbar({
//     required BuildContext context,
//     required VoidCallback onTap,
//     required int orderLength,
//     required List<Widget?> actions,
//     required PreferredSizeWidget bottom,
//
//   }) {
//     return AppBar(
//       automaticallyImplyLeading: true,
//       leading: InkWell(
//         onTap: () => BlocProvider.of<AppBloc>(context).add(
//           NavigateToHomeScreen(appState.store),
//         ),
//         child: Icon(Icons.adaptive.arrow_back),
//       ),
//       title: Text('Order List ($orderLength/$orderLength)'),
//       centerTitle: false,
//       actions: ordersScreenActions(
//         context: context,
//         qrCode: searchWithQrCode,
//         filter: filterByDateRange,
//         report: reportToExcel,
//         search: searchWithCustomerName,
//       ),
//       bottom: orderListScreenBottom(
//         context: context,
//         size: size,
//         isSearchTap: _isSearchTap,
//         searchController: _searchController,
//         onChanged: _searchWithCustomerName,
//         totalAmount: formatAmount.format(orderTotalAmount),
//         unpaidAmount: formatAmount.format(0),
//       ),
//
//     );
//   }
// }
