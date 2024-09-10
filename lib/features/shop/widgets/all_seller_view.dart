import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/all_seller_model.dart'; // Ensure this is the correct Seller model
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/all_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/seller_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:provider/provider.dart';

class AllSellerView extends StatefulWidget {
  final bool isHomePage;
  final ScrollController scrollController;

  const AllSellerView({super.key, required this.isHomePage, required this.scrollController});

  @override
  State<AllSellerView> createState() => _AllSellerViewState();
}

class _AllSellerViewState extends State<AllSellerView> {
  @override
  Widget build(BuildContext context) {
    return widget.isHomePage ? Consumer<ShopController>(
      builder: (context, topSellerProvider, child) {
        final sellers = Provider.of<ShopController>(context, listen: false).allSellerModel?.sellers;
        return (sellers != null && sellers.isNotEmpty) ?
        ListView.builder(
          itemCount: sellers.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: widget.isHomePage ? Axis.horizontal : Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 250,
              child: AllSellerCard(
                sellerModel: sellers[index],
                isHomePage: widget.isHomePage,
                index: index,
                length: sellers.length,
              ),
            );
          },
        ) : const SizedBox();
      },
    ) : Consumer<ShopController>(
      builder: (context, topSellerProvider, child) {
        final sellers = Provider.of<ShopController>(context, listen: false).allSellerModel?.sellers;
        return (sellers != null && sellers.isNotEmpty) ?
        SingleChildScrollView(
          controller: widget.scrollController,
          child: PaginatedListView(
            scrollController: widget.scrollController,
            onPaginate: (int? offset) async => await topSellerProvider.getTopSellerList(false, offset ?? 1, type: topSellerProvider.sellerType),
            totalSize: Provider.of<ShopController>(context, listen: false).allSellerModel!.totalSize,
            offset: topSellerProvider.sellerModel!.offset,
            itemView: ListView.builder(
              itemCount: sellers.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: widget.isHomePage ? Axis.horizontal : Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return AllSellerCard(
                  sellerModel: sellers[index],
                  isHomePage: widget.isHomePage,
                  index: index,
                  length: sellers.length,
                );
              },
            ),
          ),
        ) : const SizedBox();
      },
    );
  }
}
