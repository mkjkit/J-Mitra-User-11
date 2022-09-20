import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/base/api_response.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/category.dart';
import 'package:com.jewelmitra.jewel_mitra/data/repository/category_repo.dart';
import 'package:com.jewelmitra.jewel_mitra/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});


  List<Category> _categoryList = [];
  int _categorySelectedIndex;

  List<Category> get categoryList => _categoryList;
  int get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload, BuildContext context) async {
    if (_categoryList.length == 0 || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response.data.forEach((category) => _categoryList.add(Category.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
