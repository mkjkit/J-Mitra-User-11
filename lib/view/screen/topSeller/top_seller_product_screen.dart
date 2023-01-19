import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/top_seller_model.dart';

//import 'package:com.jewelmitra.jewel_mitra/helper/product_type.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/auth_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/product_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/seller_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/splash_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/images.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/animated_custom_dialog.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_app_bar.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/guest_dialog.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/rating_bar.dart';

//import 'package:com.jewelmitra.jewel_mitra/view/basewidget/search_widget.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/chat/top_seller_chat_screen.dart';

//import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/products_view.dart';
//import 'package:com.jewelmitra.jewel_mitra/provider/seller_cat_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/catalogue_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/pdf_api.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/button/button_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopSellerProductScreen extends StatefulWidget {
  final TopSellerModel topSeller;
  final int topSellerId;

  TopSellerProductScreen({@required this.topSeller, this.topSellerId});

  @override
  State<TopSellerProductScreen> createState() => _TopSellerProductScreenState();
}

class _TopSellerProductScreenState extends State<TopSellerProductScreen> {
  ScrollController _scrollController = ScrollController();

  void _load() {
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(
        widget.topSeller.sellerId.toString(), 1, context);
    Provider.of<SellerProvider>(context, listen: false)
        .initSeller(widget.topSeller.sellerId.toString(), context);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(title: widget.topSeller.name),
          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              children: [
                // Banner
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      height: 120,
                      fit: BoxFit.cover,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/banner/${widget.topSeller.banner != null ? widget.topSeller.banner : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholder,
                          height: 120,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).highlightColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${widget.topSeller.image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                  Images.placeholder,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                          child: Consumer<SellerProvider>(
                              builder: (context, sellerProvider, _) {
                            String ratting = sellerProvider.sellerModel !=
                                        null &&
                                    sellerProvider.sellerModel.avgRating !=
                                        null
                                ? sellerProvider.sellerModel.avgRating
                                    .toString()
                                : "0";

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.topSeller.name,
                                        style: titilliumSemiBold.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (!Provider.of<AuthProvider>(
                                                context,
                                                listen: false)
                                            .isLoggedIn()) {
                                          showAnimatedDialog(
                                              context, GuestDialog(),
                                              isFlip: true);
                                        } else if (widget.topSeller != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TopSellerChatScreen(
                                                          topSeller: widget
                                                              .topSeller)));
                                        }
                                      },
                                      child: Image.asset(Images.chat_image,
                                          height:
                                              Dimensions.ICON_SIZE_DEFAULT),
                                    ),
                                  ],
                                ),
                                sellerProvider.sellerModel != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              RatingBar(
                                                  rating:
                                                      double.parse(ratting)),
                                              Text(
                                                '(${sellerProvider.sellerModel.totalReview.toString()})',
                                                style: titilliumRegular
                                                    .copyWith(),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Row(
                                            children: [
                                              Text(
                                                sellerProvider.sellerModel
                                                        .totalReview
                                                        .toString() +
                                                    ' ' +
                                                    '${getTranslated('reviews', context)}',
                                                style: titleRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE,
                                                    color: ColorResources
                                                        .getReviewRattingColor(
                                                            context)),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_DEFAULT),
                                              Text('|'),
                                              SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_DEFAULT),
                                              Text(
                                                sellerProvider.sellerModel
                                                        .totalProduct
                                                        .toString() +
                                                    ' ' +
                                                    '${getTranslated('products', context)}',
                                                style: titleRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE,
                                                    color: ColorResources
                                                        .getReviewRattingColor(
                                                            context)),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            );
                          }),
                        ),
                      ]),
                ),
                InkWell(
                  onTap: () async {
                    CatalogueProvider.openFile(url: widget.topSeller.catalogue);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue,
                        border: Border.all(color: Colors.grey.shade400)),
                    child: Text(
                      getTranslated('view_catalogue', context),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Contact:- ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.topSeller.contact,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Address:- ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.topSeller.address,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
