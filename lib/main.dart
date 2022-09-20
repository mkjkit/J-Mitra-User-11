import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/facebook_login_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/featured_deal_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/google_sign_in_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/home_category_product_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/location_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/seller_cat_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/top_seller_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/wallet_transaction_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/order/order_details_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/auth_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/brand_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/cart_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/category_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/chat_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/coupon_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/localization_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/notification_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/onboarding_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/order_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/profile_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/search_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/seller_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/splash_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/support_ticket_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/theme_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/wishlist_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/theme/dark_theme.dart';
import 'package:com.jewelmitra.jewel_mitra/theme/light_theme.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/review_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/view_provider.dart';

import 'di_container.dart' as di;
import 'helper/custom_delegate.dart';
import 'localization/app_localization.dart';
import 'notification/my_notification.dart';
import 'provider/product_details_provider.dart';
import 'provider/banner_provider.dart';
import 'provider/flash_deal_provider.dart';
import 'provider/product_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = (notificationAppLaunchDetails.payload != null && notificationAppLaunchDetails.payload.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.payload) : null;
  }
  final RemoteMessage remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    _orderID = remoteMessage.notification.titleLocKey != null ? int.parse(remoteMessage.notification.titleLocKey) : null;
  }
  print('========-notification-----$_orderID----===========');

  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeCategoryProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TopSellerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FeaturedDealProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BrandProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductDetailsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SellerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SupportTicketProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<GoogleSignInProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FacebookLoginProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WalletTransactionProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReviewProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ViewProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CatalogueProvider>()),
    ],
    child: MyApp(orderId: _orderID),
  ));
}

class MyApp extends StatelessWidget {
  final int orderId;
  MyApp({@required this.orderId});

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      title: AppConstants.APP_NAME,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackLocalizationDelegate()
      ],
      supportedLocales: _locals,
      home: orderId == null ? SplashScreen() : OrderDetailsScreen(orderModel: null,
        orderId: orderId, orderType: 'default_type',isNotification: true),
    );
  }
}
