import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  static Page page() =>
      Platform.isIOS
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockBloc, StockState>(
      listener: (context, state) {
        if (state is StockLoading) {
          const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is StockLoaded) {
          if (state.stocks.isNotEmpty) {
            stocks = state.stocks;
          }
        }
        // TODO: implement listener}
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () =>
                context.read<AppBloc>().add(
                  const NavigateToHomeScreen(),
                ),
            child: Icon(Icons.adaptive.arrow_back),
          ),
          title: Text('Stocks (0/${stocks.length})'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: BlocBuilder<StockBloc, StockState>(
          builder: (context, stockState) {
            if (stockState is StockLoaded) {
              return ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, item) {
                  StockModel stock = stocks[item];
                  // context.read<ProductBloc>().add(FetchProductByIdEvent(stock.id));
                  return  CupertinoListTile(
                          title: Text(stock.id),
                          subtitle: Text(
                            stock.qty.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(stock.product.name),
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
    );
  }
}
