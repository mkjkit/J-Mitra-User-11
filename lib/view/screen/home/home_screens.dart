import 'package:flutter/material.dart';

import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/banner_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/brand_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/category_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/featured_deal_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/flash_deal_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/home_category_product_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/product_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/splash_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/top_seller_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/images.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/title_row.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/announcement.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/banners_view.dart';

import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/top_seller_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/review/review.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/topSeller/all_top_seller_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/view/view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(reload, context);
    Provider.of<BannerProvider>(context, listen: false)
        .getFooterBannerList(context);
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(reload, context);
    await Provider.of<HomeCategoryProductProvider>(context, listen: false)
        .getHomeCategoryProductList(reload, context);
    await Provider.of<TopSellerProvider>(context, listen: false)
        .getTopSellerList(reload, context);
    await Provider.of<BrandProvider>(context, listen: false)
        .getBrandList(reload, context);
    await Provider.of<ProductProvider>(context, listen: false)
        .getLatestProductList(1, context, reload: reload);
    await Provider.of<ProductProvider>(context, listen: false)
        .getFeaturedProductList('1', context, reload: reload);
    await Provider.of<FeaturedDealProvider>(context, listen: false)
        .getFeaturedDealList(reload, context);
    await Provider.of<ProductProvider>(context, listen: false)
        .getLProductList('1', context, reload: reload);
  }

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();

    singleVendor = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .businessMode ==
        "single";


    _loadData(context, false);


  }

  @override
  Widget build(BuildContext context) {
    print('======>Single vendor active=======>$singleVendor');
    List<String> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await _loadData(context, true);
            await Provider.of<FlashDealProvider>(context, listen: false)
                .getMegaDealList(true, context, false);

            return true;
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).highlightColor,
                    title: Image.asset(Images.logo_with_name_image, height: 35),
                    actions: [

                    ],
                  ),


                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: BannersView(),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ViewScrenn()));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    color: Theme.of(context).highlightColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: EdgeInsets.all(Dimensions
                                                .PADDING_SIZE_SMALL),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(10)),
                                              child: Image(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      Images.placeholder);
                                                },
                                                image: NetworkImage(
                                                    '${AppConstants.BASE_URL}/storage/app/public/self/matrimonial.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorResources.getTextBg(
                                                    context),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  child: Text(
                                                    getTranslated(
                                                        'matrimonial', context),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ReviewList()));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    color: Theme.of(context).highlightColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: EdgeInsets.all(Dimensions
                                                .PADDING_SIZE_SMALL),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(10)),
                                              child: Image(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      Images.placeholder);
                                                },
                                                image: NetworkImage(
                                                    '${AppConstants.BASE_URL}/storage/app/public/self/survey.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorResources.getTextBg(
                                                    context),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  child: Text(
                                                    getTranslated(
                                                        'theft_reporting',
                                                        context),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //top seller
                        singleVendor
                            ? SizedBox()
                            : Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.PADDING_SIZE_DEFAULT,
                              Dimensions.PADDING_SIZE_DEFAULT,
                              Dimensions.PADDING_SIZE_DEFAULT,
                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: TitleRow(
                            title: getTranslated('top_seller', context),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AllTopSellerScreen(
                                        topSeller: null,
                                      )));
                            },
                          ),
                        ),
                        singleVendor
                            ? SizedBox()
                            : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: TopSellerView(isHomePage: false),
                        ),


                      ],
                    ),
                  )
                ],
              ),
              Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .announcement
                  .status ==
                  '1'
                  ? Positioned(
                top: MediaQuery.of(context).size.height - 128,
                left: 0,
                right: 0,
                child: Consumer<SplashProvider>(
                  builder: (context, announcement, _) {
                    return announcement.onOff
                        ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                          Dimensions.PADDING_SIZE_SMALL),
                      child: AnnouncementScreen(
                          announcement: announcement
                              .configModel.announcement),
                    )
                        : SizedBox();
                  },
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}