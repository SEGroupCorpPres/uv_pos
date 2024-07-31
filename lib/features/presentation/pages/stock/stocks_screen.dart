import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: StocksScreen(),
        )
      : const MaterialPage(
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockBloc, StockState>(
      listener: (context, state) {
        if (state is StockLoaded) {
          if (state.stocks.isNotEmpty) {
            stocks = state.stocks;
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.read<AppBloc>().add(
                const NavigateToHomeScreen(),
              );
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              onTap: () => context.read<AppBloc>().add(
                    const NavigateToHomeScreen(),
                  ),
              child: Icon(Icons.adaptive.arrow_back),
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
                          for (StockModel stock in _stockList) {
                            if (stock.product.name.toLowerCase().contains(value.toLowerCase())) {
                              _searchList.add(stock);
                            }
                            setState(() {
                              _searchList;
                              _isSearching = true;
                            });
                          }
                        },
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    )
                  : Container(),
            ),
          ),
          body: BlocBuilder<StockBloc, StockState>(
            builder: (context, stockState) {
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
              if (stockState is StockLoaded) {
                if (stockState.stocks.isNotEmpty) {
                  _stockList = stockState.stocks;
                  stocks = _isSearching ? _searchList : _stockList;
                }
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
                              style: TextStyle(color: Colors.blueAccent.withGreen(200), fontSize: 18.sp),
                            ),
                            Text(
                              'Name: ${stock.product.name}',
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
              if (stockState is StockError) {
                return Center(
                  child: Text(stockState.error),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
