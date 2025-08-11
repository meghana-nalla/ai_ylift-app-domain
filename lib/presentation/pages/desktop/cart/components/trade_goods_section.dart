import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'bundled_goods_tile.dart';


class TradeSkuSection extends StatelessWidget {
  final List<StoreTradeGood> tradeGoods;
  const TradeSkuSection({super.key, required this.tradeGoods});
  @override
  Widget build(BuildContext context) {
    if (tradeGoods.isEmpty) {
      return Container();
    }
    return Column(
      spacing: 8,
      children:
          tradeGoods
              .map(
                (e) => BundledGoodsTile(
                  title: e.goodsTradingName,
                  skuNumber: e.goodsTradingId,
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => DeleteBundleDialog(
                            tradeGoodId: e.goodsTradingId,
                            title: e.goodsTradingName,
                            skuNumber: e.goodsTradingId.substring(
                              e.goodsTradingId.length - 5,
                            )),
                    );
                  },
                ),
              )
              .toList(),
    );
  }
}
