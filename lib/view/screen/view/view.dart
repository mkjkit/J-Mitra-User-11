import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/view_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_textfield.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/view/add_new_profile.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/view/biodata_overview.dart';
import 'package:provider/provider.dart';

class ViewScrenn extends StatefulWidget {
  const ViewScrenn({Key key}) : super(key: key);

  @override
  State<ViewScrenn> createState() => _ViewScrennState();
}

class _ViewScrennState extends State<ViewScrenn> {
  bool didAlreadyShowed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  fetchBioData() {
    ViewProvider _viewProvider =
        Provider.of<ViewProvider>(context, listen: false);
    _viewProvider.getBiodata({});
  }

  @override
  void initState() {
    super.initState();
    fetchBioData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ViewProvider _provider = Provider.of<ViewProvider>(context);
    if (_provider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getTranslated('matrimonial', context)),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewProfile(),
            ),
          );
          if (res == true) {
            ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
              SnackBar(
                content: Text('Profile Successfully added'),
              ),
            );
          }
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Center(child: Icon(Icons.add)),
        ),
      ),
      body: Consumer<ViewProvider>(builder: (context, viewProvider, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTranslated('filter', context)),
                        Checkbox(
                            value: viewProvider.isFilter,
                            onChanged: (e) {
                              viewProvider.updateIsFilter(e);
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTranslated('male', context)),
                        Radio(
                          value: 'male',
                          groupValue: viewProvider.genderFilter,
                          onChanged: (e) {
                            Map<String, String> filters = {};
                            filters.addAll({
                              "gender": "MALE",
                            });
                            viewProvider.updateGenderFilter('male');
                            viewProvider.applyFilter(filters);
                          },
                          toggleable: true,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getTranslated('female', context)),
                        Radio(
                          value: 'female',
                          groupValue: viewProvider.genderFilter,
                          onChanged: (e) {
                            Map<String, String> filters = {};
                            filters.addAll({
                              "gender": "FEMALE",
                            });
                            viewProvider.updateGenderFilter('female');
                            viewProvider.applyFilter(filters);
                          },
                          toggleable: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: viewProvider.isFilter,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    alignment: Alignment.topCenter,
                    reverseDuration: const Duration(seconds: 1),
                    child: Container(
                      height: viewProvider.isFilter ? null : 0,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getTranslated('age_filter', context) +
                              ' ( ${viewProvider.ageFilter.start.toString()}-${viewProvider.ageFilter.end.toString()})'),
                          RangeSlider(
                            min: 18.0,
                            max: 100.0,
                            divisions: 50,
                            labels: RangeLabels(
                              viewProvider.ageFilter.start.toString(),
                              viewProvider.ageFilter.end.toString(),
                            ),
                            values: viewProvider.ageFilter,
                            onChanged: (e) {
                              viewProvider.updateAgeFilter(e ?? '');
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(getTranslated('height_filter', context) +
                              ' (${viewProvider.heightFilter.start.toString()}-${viewProvider.heightFilter.end.toString()})'),
                          RangeSlider(
                            min: 4.0,
                            max: 8.0,
                            divisions: 50,
                            labels: RangeLabels(
                              viewProvider.heightFilter.start.toString(),
                              viewProvider.heightFilter.end.toString(),
                            ),
                            values: viewProvider.heightFilter,
                            onChanged: (e) {
                              viewProvider.updateHeightFilter(e);
                            },
                          ),
                          customTextField(
                            context: context,
                            controller: viewProvider.filterpinController,
                            formatter: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            textInputType: TextInputType.number,
                            title: getTranslated('pin', context),
                          ),
                          /*Row(
                            children: [
                              Radio(
                                value: 'male',
                                groupValue: viewProvider.genderFilter,
                                onChanged: (e) {
                                  viewProvider.updateGenderFilter(e ?? '');
                                },
                                toggleable: true,
                              ),
                              Text(getTranslated('male', context)),
                              SizedBox(
                                width: 20,
                              ),
                              Radio(
                                value: 'female',
                                groupValue: viewProvider.genderFilter,
                                onChanged: (e) {
                                  viewProvider.updateGenderFilter(e ?? '');
                                },
                                toggleable: true,
                              ),
                              Text(getTranslated('female', context))
                            ],
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    viewProvider.clearFilter();
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => EdgeInsets.zero),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.red),
                                  ),
                                  child: Text(getTranslated('clear', context)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Map<String, String> filters = {};
                                    if (viewProvider.isApplyingFilter == true) {
                                      filters.addAll({
                                        "gender": viewProvider.genderFilter,
                                        "age":
                                            "${viewProvider.ageFilter.start},${viewProvider.ageFilter.end}",
                                        "height":
                                            "${viewProvider.heightFilter.start},${viewProvider.heightFilter.end}",
                                        "pincode":
                                            viewProvider.filterpinController.text
                                      });
                                    }
                                    viewProvider.applyFilter(filters);
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => EdgeInsets.zero),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.blue),
                                  ),
                                  child: Text(getTranslated('apply', context)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: viewProvider.biodatas.data.length > 21
                    ? 21
                    : viewProvider.biodatas.data.length,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BiodataOverView(
                              biodata: viewProvider.biodatas.data[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: size.width,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          viewProvider
                                  .biodatas.data[index].profilePics.isNotEmpty
                              ? Container(
                                  height: 70,
                                  width: 70,
                                  decoration: viewProvider.biodatas.data[index]
                                              .profilePics.first.image !=
                                          null
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                              image: NetworkImage(viewProvider
                                                  .biodatas
                                                  .data[index]
                                                  .profilePics
                                                  .first
                                                  .image),
                                              fit: BoxFit.cover),
                                        )
                                      : null,
                                )
                              : Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                        'assets/images/placeholder.jpeg'),
                                  ),
                                ),
                          SizedBox(width: 16),
                          /*if (viewProvider
                              .biodatas.data[index].profilePics.isEmpty)
                            Container(
                              height: 70,
                              width: 70,
                            ),
                          SizedBox(
                            width: 20,
                          ),*/
                          Container(
                            width: size.width - 130,
                            height: 68,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: size.width - 225,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Name : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  width: size.width / 3.5,
                                                  child: Text(
                                                      viewProvider.biodatas
                                                          .data[index].name,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Height : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                    viewProvider.biodatas
                                                        .data[index].height,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            ),
                                            /*Row(
                                              children: [
                                                Text(
                                                  'Age : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
                                                Text(
                                                    viewProvider.biodatas
                                                        .data[index].age.toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w400)),
                                              ],
                                            ),*/
                                            Row(
                                              children: [
                                                Text(
                                                  'District : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  width: size.width / 3.9,
                                                  child: Text(
                                                      viewProvider.biodatas
                                                          .data[index].districtName,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                              ],
                                            ),
                                            /*Text(
                                                "Height: ${viewProvider.biodatas.data[index].height.split('.')[0]}feat, ${viewProvider.biodatas.data[index].height.split('.')[1]}inch"),
                                            Text(
                                                'Age: ${viewProvider.biodatas.data[index].age}'),
                                            Text(
                                              "District: ${viewProvider.biodatas.data[index].districtName} ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),*/
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Gender : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  viewProvider
                                                              .biodatas
                                                              .data[index]
                                                              .gender
                                                              .name ==
                                                          'MALE'
                                                      ? "M"
                                                      : "F",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Age : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  viewProvider
                                                      .biodatas.data[index].age
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
