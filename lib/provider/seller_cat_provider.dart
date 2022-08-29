import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/notification/my_notification.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CatalogueProvider extends ChangeNotifier {
  final DioClient dioClient;

  CatalogueProvider(this.dioClient);


  bool _isLoading = false;


  SellerModel _catLogues;
  File _pdfcatalogue = File('');


  String _message = '';
  //
  // Listeners
  //
  bool get isLoading => _isLoading;


  File get pdfCatLogue => _pdfcatalogue;

  SellerModel get catalogues => _catLogues;

  void clearCatalogue() {
    _pdfcatalogue = File('');
    notifyListeners();
  }

  void updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void getCatalogue(Map<String, String> filters) async {
    _isLoading = true;
    try {
      Dio dio = new Dio();

      final Response response = await dioClient
          .get('${AppConstants.TOP_SELLER}', queryParameters: filters)
          .catchError((e) => print(e.response.toString()));

      if (response.data != null && response.statusCode == 200) {
        _catLogues = SellerModel.fromJson(response.data);
      }
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _isLoading = false;
    }
  }

  void downloadCatalogue(String url, BuildContext context) async {
    Dio dio = Dio();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      String dirloc;
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      String filePath =
          dirloc + DateTime.now().millisecondsSinceEpoch.toString();

      try {
        await dio.download(url, filePath + ".pdf",
            onReceiveProgress: (receivedBytes, totalBytes) {});
      } catch (e) {
        print('catch catch catch');
        print(e);
      }
      MyNotification.showBigTextNotification(
          'Bio-Data Downloaded', '', '', FlutterLocalNotificationsPlugin());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Bio-Data Downloaded')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to Downloaded')));
    }
  }
}
