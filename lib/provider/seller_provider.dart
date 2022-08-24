import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/seller_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sixvalley_ecommerce/notification/my_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';



class SellerProvider extends ChangeNotifier {
  final SellerRepo sellerRepo;
  SellerProvider({@required this.sellerRepo});

  List<SellerModel> _orderSellerList = [];
  SellerModel _sellerModel;

  List<SellerModel> get orderSellerList => _orderSellerList;
  SellerModel get sellerModel => _sellerModel;

  void initSeller(String sellerId, BuildContext context) async {
    _orderSellerList =[];
    ApiResponse apiResponse = await sellerRepo.getSeller(sellerId);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderSellerList =[];
      _orderSellerList.add(SellerModel.fromJson(apiResponse.response.data));
      _sellerModel = SellerModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removePrevOrderSeller() {
    _orderSellerList = [];
  }


}
