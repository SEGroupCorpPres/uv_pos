import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'stock.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  static Page page() => const MaterialPage(
        child: StocksScreen(),
      );

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  List<StockModel> stocks = [];
  final TextEditingController _searchController = TextEditingController();
  double orderTotalAmount = 0;
  int orderLength = 0;
  final List<StockModel> _searchList = [];
  List<StockModel> _stockList = [];
  bool _isSearching = false;
  bool _isSearchTap = false;
  double stock = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        context.read<AppBloc>().add(
              const NavigateToHomeScreen(),
            );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  context.read<AppBloc>().add(
                        const NavigateToHomeScreen(),
                      );
                  BlocProvider.of<UserBloc>(context).add(FetchUserByIdEvent(state.userID!));
                },
                child: Icon(Icons.adaptive.arrow_back),
              );
            },
          ),
          title: Text('Stocks (${stocks.length}/${stocks.length})'),
          centerTitle: false,
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _isSearchTap = !_isSearchTap;
                });
              },
              icon: const Icon(Icons.search),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.sizeOf(context).width, _isSearchTap ? 50.h : 0),
            child: _isSearchTap
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        _searchList.clear();
                      },
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  )
                : Container(),
          ),
        ),
        body: BlocBuilder<StockBloc, StockState>(
          builder: (context, stockState) {
            log(stockState.toString());
            List<StockModel> stocks = [];
            if (stockState is StockLoading) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            if (stockState is StocksLoaded) {
              if (stockState.stocks.isNotEmpty) {
                _stockList = stockState.stocks;
                stocks = _isSearching ? _searchList : _stockList;
                return ListView.builder(
                  itemCount: stocks.length,
                  itemBuilder: (context, item) {
                    StockModel stock = stocks[item];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: CupertinoListTile(
                        backgroundColorActivated: Colors.transparent,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${stock.id}',
                              style: TextStyle(
                                  color: Colors.blueAccent.withGreen(200), fontSize: 18.sp),
                            ),
                            Text(
                              'Name: ${stock.id}',
                              style: TextStyle(color: Colors.black, fontSize: 18.sp),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'Qty: ${stock.qty}',
                          style: TextStyle(color: Colors.black, fontSize: 13.sp),
                        ),
                      ),
                    );
                  },
                );

              }
              else {
                return const Center(
                  child: Text('No data'),
                );
              }
            }
            if (stockState is StockError) {
              log(stocks.toString());
              return Center(
                child: Text(stockState.error),
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(NavigateToCreateEditStockScreen());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
