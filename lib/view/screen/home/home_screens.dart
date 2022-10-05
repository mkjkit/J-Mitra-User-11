import 'package:flutter/material.dart';

import 'package:com.jewelmitra.jewel_mitra/helper/product_type.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/auth_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/banner_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/brand_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/cart_provider.dart';
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
import 'package:com.jewelmitra.jewel_mitra/view/screen/brand/all_brand_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/cart/cart_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/category/all_category_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/featureddeal/featured_deal_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/announcement.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/banners_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/brand_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/category_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/featured_deal_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/featured_product_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/flash_deals_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/home_category_product_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/latest_product_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/marque_text.dart';
import 'package:com.jewelmitra.jewel_mitra/view/s'
    'creen/home/widget/products_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/flashdeal/flash_deal_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/top_seller_view.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/product/view_all_product_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/review/review.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/search/search_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/topSeller/all_top_seller_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/view/view.dart';
import 'package:marquee/marquee.dart';
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
    //await Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(reload, context,_languageCode,true);
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
    /*Provider.of<FlashDealProvider>(context, listen: false)
        .getMegaDealList(true, context, true);*/

    _loadData(context, false);

    /*if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<CartProvider>(context, listen: false).uploadToServer(context);
      Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    } else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }*/
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
                      /*IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => CartScreen()));
                        },
                        icon: Stack(clipBehavior: Clip.none, children: [
                          Image.asset(
                            Images.cart_arrow_down_image,
                            height: Dimensions.ICON_SIZE_DEFAULT,
                            width: Dimensions.ICON_SIZE_DEFAULT,
                            color: ColorResources.getPrimary(context),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Consumer<CartProvider>(
                                builder: (context, cart, child) {
                                  return CircleAvatar(
                                    radius: 7,
                                    backgroundColor: ColorResources.RED,
                                    child: Text(cart.cartList.length.toString(),
                                        style: titilliumSemiBold.copyWith(
                                          color: ColorResources.WHITE,
                                          fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        )),
                                  );
                                }),
                          ),
                        ]),
                      ),*/
                    ],
                  ),

                  // Search Button
                  // comment start
                  // SliverPersistentHeader(
                  //     pinned: true,
                  //     delegate: SliverDelegate(
                  //         child: InkWell(
                  //       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
                  //           child: Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 2),
                  //             color: Theme.of(context).highlightColor,
                  //             alignment: Alignment.center,
                  //             child: Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), height: 50, alignment: Alignment.centerLeft,
                  //               decoration: BoxDecoration(color: ColorResources.getGrey(context), borderRadius: BorderRadius.circular(
                  //                 Dimensions.PADDING_SIZE_SMALL),),
                  //               child: Row(children: [Icon(Icons.search, color: ColorResources.getPrimary(context), size: Dimensions.ICON_SIZE_LARGE),
                  //                 SizedBox(width: 5),
                  //                 Text(getTranslated('SEARCH_HINT', context), style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                  //           ]),
                  //         ),
                  //       ),
                  //     ))),
                  // comment end
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: BannersView(),
                        ),
                        // comment start
                        // Category title
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title: getTranslated('CATEGORY', context),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (_) => AllCategoryScreen()));
                        //       }),
                        // ),

                        // //category
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                        //   child: CategoryView(isHomePage: true),
                        // ),
                        // comment end
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 250,
                              width: 250,
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
                                                .PADDING_SIZE_DEFAULT),
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
                                                .PADDING_SIZE_DEFAULT),
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
                        // Mega Deal
                        /*Consumer<FlashDealProvider>(
                          builder: (context, flashDeal, child) {
                            return flashDeal.flashDeal == null
                                ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: TitleRow(
                                  title: getTranslated(
                                      'flash_deal', context),
                                  eventDuration:
                                  flashDeal.flashDeal != null
                                      ? flashDeal.duration
                                      : null,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                FlashDealScreen()));
                                  }),
                            )
                                : (flashDeal.flashDeal.id != null &&
                                flashDeal.flashDealList != null &&
                                flashDeal.flashDealList.length > 0)
                                ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                  Dimensions
                                      .PADDING_SIZE_EXTRA_SMALL),
                              child: TitleRow(
                                  title: getTranslated(
                                      'flash_deal', context),
                                  eventDuration:
                                  flashDeal.flashDeal != null
                                      ? flashDeal.duration
                                      : null,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                FlashDealScreen()));
                                  }),
                            )
                                : SizedBox.shrink();
                          },
                        ),

                        Consumer<FlashDealProvider>(
                          builder: (context, megaDeal, child) {
                            return megaDeal.flashDeal == null
                                ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: Container(
                                  height: 150, child: FlashDealsView()),
                            )
                                : (megaDeal.flashDeal.id != null &&
                                megaDeal.flashDealList != null &&
                                megaDeal.flashDealList.length > 0)
                                ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: Container(
                                  height: 150,
                                  child: FlashDealsView()),
                            )
                                : SizedBox.shrink();
                          },
                        ),*/

                        // Brand
                        // comment start
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title: getTranslated('brand', context),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (_) => AllBrandScreen()));
                        //       }),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                        //   child: BrandView(isHomePage: true),
                        // ),

                        // Featured Products
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title:
                        //           getTranslated('featured_products', context),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (_) => AllProductScreen(
                        //                     productType:
                        //                         ProductType.FEATURED_PRODUCT)));
                        //       }),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                        //   child: FeaturedProductView(
                        //     scrollController: _scrollController,
                        //     isHome: true,
                        //   ),
                        // ),
                        // Featured Deal
                        // Consumer<FeaturedDealProvider>(
                        //   builder: (context, featuredDealProvider, child) {
                        //     return featuredDealProvider.featuredDealList == null
                        //         ? Padding(
                        //             padding: EdgeInsets.fromLTRB(
                        //                 Dimensions.PADDING_SIZE_DEFAULT,
                        //                 Dimensions.PADDING_SIZE_DEFAULT,
                        //                 Dimensions.PADDING_SIZE_DEFAULT,
                        //                 Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //             child: TitleRow(
                        //                 title: getTranslated(
                        //                     'featured_deals', context),
                        //                 onTap: () {
                        //                   Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                           builder: (_) =>
                        //                               FeaturedDealScreen()));
                        //                 }),
                        //           )
                        //         : (featuredDealProvider.featuredDealList !=
                        //                     null &&
                        //                 featuredDealProvider
                        //                         .featuredDealList.length >
                        //                     0)
                        //             ? Padding(
                        //                 padding: EdgeInsets.fromLTRB(
                        //                     Dimensions.PADDING_SIZE_DEFAULT,
                        //                     Dimensions.PADDING_SIZE_DEFAULT,
                        //                     Dimensions.PADDING_SIZE_DEFAULT,
                        //                     Dimensions
                        //                         .PADDING_SIZE_EXTRA_SMALL),
                        //                 child: TitleRow(
                        //                     title: getTranslated(
                        //                         'featured_deals', context),
                        //                     onTap: () {
                        //                       Navigator.push(
                        //                           context,
                        //                           MaterialPageRoute(
                        //                               builder: (_) =>
                        //                                   FeaturedDealScreen()));
                        //                     }),
                        //               )
                        //             : SizedBox.shrink();
                        //   },
                        // ),
                        // Consumer<FeaturedDealProvider>(
                        //   builder: (context, featuredDeal, child) {
                        //     return featuredDeal.featuredDealList == null
                        //         ? Padding(
                        //             padding: EdgeInsets.symmetric(
                        //                 horizontal:
                        //                     Dimensions.PADDING_SIZE_SMALL),
                        //             child: Container(
                        //                 height: 150,
                        //                 child: FeaturedDealsView()),
                        //           )
                        //         : (featuredDeal.featuredDealList != null &&
                        //                 featuredDeal.featuredDealList.length >
                        //                     0)
                        //             ? Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                     horizontal:
                        //                         Dimensions.PADDING_SIZE_SMALL),
                        //                 child: Container(
                        //                     height: 150,
                        //                     child: FeaturedDealsView()),
                        //               )
                        //             : SizedBox.shrink();
                        //   },
                        // ),
                        // comment end
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

                        // Latest Products
                        // comment start
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title: getTranslated('latest_products', context),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (_) => AllProductScreen(
                        //                     productType:
                        //                         ProductType.LATEST_PRODUCT)));
                        //       }),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                        //   child: LatestProductView(
                        //       scrollController: _scrollController),
                        // ),

                        //Home category

                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: HomeCategoryProductView(isHomePage: true),
                        // ),

                        //Category filter

                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_DEFAULT,
                        //       Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: Consumer<ProductProvider>(
                        //       builder: (ctx, prodProvider, child) {
                        //     return Row(children: [
                        //       Expanded(
                        //           child: Padding(
                        //         padding: const EdgeInsets.only(
                        //             right: Dimensions.PADDING_SIZE_DEFAULT),
                        //         child: Text(
                        //             prodProvider.title == 'xyz'
                        //                 ? getTranslated('new_arrival', context)
                        //                 : prodProvider.title,
                        //             style: titleRegular),
                        //       )),
                        //       prodProvider.latestProductList != null
                        //           ? PopupMenuButton(
                        //               itemBuilder: (context) {
                        //                 return [
                        //                   PopupMenuItem(
                        //                       value: ProductType.NEW_ARRIVAL,
                        //                       child: Text(getTranslated(
                        //                           'new_arrival', context)),
                        //                       textStyle: robotoRegular.copyWith(
                        //                         color:
                        //                             Theme.of(context).hintColor,
                        //                       )),
                        //                   PopupMenuItem(
                        //                       value: ProductType.TOP_PRODUCT,
                        //                       child: Text(getTranslated(
                        //                           'top_product', context)),
                        //                       textStyle: robotoRegular.copyWith(
                        //                         color:
                        //                             Theme.of(context).hintColor,
                        //                       )),
                        //                   PopupMenuItem(
                        //                       value: ProductType.BEST_SELLING,
                        //                       child: Text(getTranslated(
                        //                           'best_selling', context)),
                        //                       textStyle: robotoRegular.copyWith(
                        //                         color:
                        //                             Theme.of(context).hintColor,
                        //                       )),
                        //                   PopupMenuItem(
                        //                       value: ProductType
                        //                           .DISCOUNTED_PRODUCT,
                        //                       child: Text(getTranslated(
                        //                           'discounted_product',
                        //                           context)),
                        //                       textStyle: robotoRegular.copyWith(
                        //                         color:
                        //                             Theme.of(context).hintColor,
                        //                       )),
                        //                 ];
                        //               },
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(
                        //                       Dimensions.PADDING_SIZE_SMALL)),
                        //               child: Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                     horizontal:
                        //                         Dimensions.PADDING_SIZE_SMALL),
                        //                 child: Icon(Icons.filter_list),
                        //               ),
                        //               onSelected: (value) {
                        //                 if (value == ProductType.NEW_ARRIVAL) {
                        //                   Provider.of<ProductProvider>(context,
                        //                           listen: false)
                        //                       .changeTypeOfProduct(
                        //                           value, types[0]);
                        //                 } else if (value ==
                        //                     ProductType.TOP_PRODUCT) {
                        //                   Provider.of<ProductProvider>(context,
                        //                           listen: false)
                        //                       .changeTypeOfProduct(
                        //                           value, types[1]);
                        //                 } else if (value ==
                        //                     ProductType.BEST_SELLING) {
                        //                   Provider.of<ProductProvider>(context,
                        //                           listen: false)
                        //                       .changeTypeOfProduct(
                        //                           value, types[2]);
                        //                 } else if (value ==
                        //                     ProductType.DISCOUNTED_PRODUCT) {
                        //                   Provider.of<ProductProvider>(context,
                        //                           listen: false)
                        //                       .changeTypeOfProduct(
                        //                           value, types[3]);
                        //                 }

                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: Dimensions
                        //                           .PADDING_SIZE_SMALL),
                        //                   child: ProductView(
                        //                       isHomePage: false,
                        //                       productType: value,
                        //                       scrollController:
                        //                           _scrollController),
                        //                 );
                        //                 Provider.of<ProductProvider>(context,
                        //                         listen: false)
                        //                     .getLatestProductList(1, context,
                        //                         reload: true);
                        //               })
                        //           : SizedBox(),
                        //     ]);
                        //   }),
                        // ),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                        //   child: ProductView(
                        //       isHomePage: false,
                        //       productType: ProductType.NEW_ARRIVAL,
                        //       scrollController: _scrollController),
                        // ),

                        // comment end
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