import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/dio/dio_client.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/general_review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final DioClient dioClient;

  ReviewProvider(this.dioClient);

  String url = "${AppConstants.BASE_URL}${AppConstants.GET_REVIEW}";
  List<GeneralsurveyModel> _reviews = [];
  bool _isLoading = true;

  List<GeneralsurveyModel> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> getAllGeneralReview() async {
    _reviews.clear();
    _isLoading = true;
    notifyListeners();
    try {
      var response = await dioClient.get(url);
      Map jsonResponse = Map.from(response.data);
      if (jsonResponse['success'] == "1") {
        List<dynamic> _reviewList = jsonResponse['data'];
        _reviewList.forEach((element) {
          _reviews.add(GeneralsurveyModel.fromJson(element));
        });
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview(
      String userid, String reviewBody, List<File> files, String token) async {
    _isLoading = true;
    notifyListeners();

    List<File> _tempFile = [];

    files.forEach((element) {
      if (element.path.isNotEmpty) {
        _tempFile.add(element);
      }
    });
    notifyListeners();

    try {
      Dio dio = new Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";
      FormData formData;
      if (_tempFile.length <= 1) {
        formData = new FormData.fromMap({
          'image[0]': await MultipartFile.fromFile(
            _tempFile[0].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'review': reviewBody,
          'user_id': userid
        });
      } else if (_tempFile.length <= 2) {
        formData = new FormData.fromMap({
          'image[0]': await MultipartFile.fromFile(
            _tempFile[0].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'image[1]': await MultipartFile.fromFile(
            _tempFile[1].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'review': reviewBody,
          'user_id': userid
        });
      } else if (_tempFile.length <= 3) {
        formData = new FormData.fromMap({
          'image[0]': await MultipartFile.fromFile(
            _tempFile[0].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'image[1]': await MultipartFile.fromFile(
            _tempFile[1].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'image[2]': await MultipartFile.fromFile(
            _tempFile[2].path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'review': reviewBody,
          'user_id': userid
        });
      }

      Response response = await dio
          .post('${AppConstants.BASE_URL}${AppConstants.SUBMIT_REVIEW}',
              data: formData)
          .catchError((e) => print(e.response.toString()));
      print('-----finished------');
      _isLoading = false;
      notifyListeners();
      getAllGeneralReview();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
