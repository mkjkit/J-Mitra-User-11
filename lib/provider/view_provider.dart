import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/dio/dio_client.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/bio_data_model.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/pincode_model.dart';
import 'package:com.jewelmitra.jewel_mitra/notification/my_notification.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewProvider extends ChangeNotifier {
  final DioClient dioClient;

  ViewProvider(this.dioClient);

  TextEditingController firstnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ftController = TextEditingController();
  TextEditingController inchController = TextEditingController();
  TextEditingController presentPinController = TextEditingController();
  TextEditingController hometowmPinController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController filterpinController = TextEditingController();

  bool _isLoading = false;
  bool _isFilter = false;
  bool isMaleFilter = false;
  bool isFemaleFilter = false;
  RangeValues _ageFilter = RangeValues(18.0, 30.0);
  RangeValues _heightFilter = RangeValues(5.0, 6.0);
  String _genderFilter = '';
  bool _isApplyingFilter = false;
  final List<String> _genders = ['Male', 'Female'];
  String _selectedGender = 'Male';
  int _selectedRelativeIndex = 0;
  List<Map<String, dynamic>> _relatives = [
    {
      "name": "",
      "relation": "",
      "address": "",
      "pin": TextEditingController(),
      "focus_node": FocusNode(),
      "layer_link": LayerLink()
    }
  ];
  BioDataModel _bioDatas;
  Pincodes _pincodes = null;
  List _filteredPincode = [];
  File _pdfbiodata = File('');
  File _profilePicture = File('');
  File _profilePicture2 = File('');

  String _message = '';
  //
  // Listeners
  //
  bool get isLoading => _isLoading;
  bool get isFilter => _isFilter;
  RangeValues get ageFilter => _ageFilter;
  RangeValues get heightFilter => _heightFilter;
  String get genderFilter => _genderFilter;
  bool get isApplyingFilter => _isApplyingFilter;
  List<String> get genders => _genders;
  String get selectedGender => _selectedGender;
  List<Map<String, dynamic>> get relatives => _relatives;
  File get pdfBioData => _pdfbiodata;
  File get profilePicture => _profilePicture;
  File get profilePicture2 => _profilePicture2;
  BioDataModel get biodatas => _bioDatas;
  Pincodes get pincodes => _pincodes;
  List get filteredPincode => _filteredPincode;
  int get selectedRelativeIndex => _selectedRelativeIndex;
  String get resMessage => _message;

  void updateState() {
    notifyListeners();
  }

  void clearImages() {
    _profilePicture = File('');
    _profilePicture2 = File('');
    notifyListeners();
  }

  void clearBiodata() {
    _pdfbiodata = File('');
    notifyListeners();
  }

  void updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateIsFilter(bool value) {
    _isFilter = value;
    notifyListeners();
  }

  void updateProfilePicture(File file) {
    _profilePicture = file;
    notifyListeners();
  }

  void updateProfilePicture2(File file) {
    _profilePicture2 = file;
    notifyListeners();
  }

  void updatePickedBiodata(File file) {
    _pdfbiodata = file;
    notifyListeners();
  }

  void updateAgeFilter(RangeValues value) {
    _ageFilter = RangeValues(value.start.ceilToDouble(), value.end.ceilToDouble());
    notifyListeners();
  }

  void updateHeightFilter(RangeValues value) {
    _heightFilter = RangeValues(double.parse(value.start.toStringAsFixed(1)),
        double.parse(value.end.toStringAsFixed(1)));
    notifyListeners();
  }

  void updateGenderFilter(String val) {
    _genderFilter = val;
    print('_genderFilter--->'+_genderFilter.toString());
    notifyListeners();
  }

  void clearFilter() {
    _isFilter = false;
    _isApplyingFilter = false;
    _genderFilter = '';
    getBiodata({});
    notifyListeners();
  }

  void applyFilter(Map<String, String> filters) {
    _isApplyingFilter = true;
    getBiodata(filters);
    notifyListeners();
  }

  void updateSelectedGender(String value) {
    _selectedGender = selectedGender;
    genderController.text = value;
    notifyListeners();
  }

  void updateRelative(int index, String key, String value) {
    if (key == 'pin') {
      _relatives[index][key].text = value;
    } else {
      _relatives[index][key] = value.toString();
    }
    notifyListeners();
  }

  void addRelative() {
    _relatives.add({
      "name": "",
      "relation": "",
      "address": "",
      "pin": TextEditingController(),
      "focus_node": FocusNode(),
      "layer_link": LayerLink()
    });
    notifyListeners();
  }

  void removeLastRelative() {
    _relatives.removeLast();
    notifyListeners();
  }

  void updateSelectedRelativeIndex(int index) {
    _selectedRelativeIndex = index;
    notifyListeners();
  }

  void getBiodata(Map<String, String> filters) async {
    _isLoading = true;
    try {
      Dio dio = new Dio();

      final Response response = await dioClient
          .get('${AppConstants.GET_BIODATA}', queryParameters: filters)
          .catchError((e) => print(e.response.toString()));

      if (response.data != null && response.statusCode == 200) {
        _bioDatas = BioDataModel.fromJson(response.data);
      }
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _isLoading = false;
    }
  }

  void getPinCode() async {
    try {
      _isLoading = true;
      notifyListeners();
      final Response response = await dioClient
          .get('${AppConstants.PIN_CODE}')
          .catchError((e) => print(e.response.toString()));
      if (response.data != null && response.statusCode == 200) {
        _pincodes = Pincodes.fromJson(response.data);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPincodes({TextEditingController controller, String text}) {
    if (controller != null) {
      _filteredPincode.clear();
      var res = pincodes.data.where(
          (element) => element.pincode.toString().startsWith(controller.text));
      _filteredPincode.addAll(res);
    } else {
      _filteredPincode.clear();
      var res = pincodes.data
          .where((element) => element.pincode.toString().startsWith(text));
      _filteredPincode.addAll(res);
    }
    notifyListeners();
  }

  Future submitProfile(BuildContext context) async {
    List _relativesObj = [];
    relatives.forEach((element) {
      Map<String, dynamic> _k = {};
      element.forEach((key, value) {
        if (key != 'focus_node' && key != 'layer_link' && key != 'pin') {
          _k.addAll({key: value});
        }
        if (key == 'pin') {
          _k.addAll({
            key: pincodes.data
                .where((element) => element.pincode.toString() == value.text)
                .first
                .pincodeId
          });
          _k.addAll({
            "address_pincode": pincodes.data
                .where((element) => element.pincode.toString() == value.text)
                .first
                .pincodeId
          });
        }
      });
      _relativesObj.add(json.encode(_k));
    });

    List _tmpImg = [];

    if (profilePicture.path.isNotEmpty) {
      _tmpImg.add(profilePicture.path);
    }
    if (profilePicture2.path.isNotEmpty) {
      _tmpImg.add(profilePicture2.path);
    }

    try {
      updateLoading(true);
      FormData formData;
      if (profilePicture.path.isNotEmpty && profilePicture2.path.isNotEmpty) {
        formData = new FormData.fromMap({
          "user_id": "1",
          "name": firstnameController.text,
          "gender": genderController.text,
          "age": ageController.text,
          "address": addressController.text,
          "height": "${ftController.text}.${inchController.text}",
          "present_address_pincode": pincodes.data
              .where((element) =>
                  element.pincode.toString() == presentPinController.text)
              .first
              .pincodeId,
          "hometown_address_pincode": pincodes.data
              .where((element) =>
                  element.pincode.toString() == hometowmPinController.text)
              .first
              .pincodeId,
          'biodata': await MultipartFile.fromFile(
            pdfBioData.path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.pdf',
          ),
          'profile_pic[0]': await MultipartFile.fromFile(
            profilePicture.path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          'profile_pic[1]': await MultipartFile.fromFile(
            profilePicture2.path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          "relations": _relativesObj.toString(),
        });
      }

      if (_tmpImg.length < 2) {
        formData = new FormData.fromMap({
          "user_id": "1",
          "name": firstnameController.text,
          "gender": genderController.text,
          "age": ageController.text,
          "address": addressController.text,
          "height": "${ftController.text}.${inchController.text}",
          "present_address_pincode": pincodes.data
              .where((element) =>
                  element.pincode.toString() == presentPinController.text)
              .first
              .pincodeId,
          "hometown_address_pincode": pincodes.data
              .where((element) =>
                  element.pincode.toString() == hometowmPinController.text)
              .first
              .pincodeId,
          'biodata': await MultipartFile.fromFile(
            pdfBioData.path,
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.pdf',
          ),
          'profile_pic[]': await MultipartFile.fromFile(
            _tmpImg[0],
            filename: DateTime.now().microsecondsSinceEpoch.toString() + '.jpg',
          ),
          "relations": _relativesObj.toString(),
        });
      }
      Dio dio = new Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";

      final Response response = await dio.post(
          '${AppConstants.BASE_URL}${AppConstants.ADD_BIODATA}',
          data: formData);

      _message = 'Profile Successfully added';
      updateLoading(false);
      getBiodata({});
      return true;
    } catch (e) {
      print(e);
      updateLoading(false);
      return false;
    }
  }

  void downloadBiodata(String url, BuildContext context) async {
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
