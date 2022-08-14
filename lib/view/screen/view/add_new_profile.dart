import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/view_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/paragraph_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddNewProfile extends StatefulWidget {
  const AddNewProfile({Key key}) : super(key: key);

  @override
  State<AddNewProfile> createState() => _AddNewProfileState();
}

class _AddNewProfileState extends State<AddNewProfile> {
  GlobalKey _hometownKey = GlobalKey();
  FocusNode _hometownfn = FocusNode();
  FocusNode _presentfn = FocusNode();
  OverlayState overlay;
  final layerLink = LayerLink();
  final presentlayerLink = LayerLink();
  Map<String, dynamic> overLayentry = {
    "home_pin": null,
    'present_pin': null,
    'relative0': null
  };
  popAddProfile() {
    Future.delayed(Duration(seconds: 1))
        .then((value) => Navigator.pop(context, true));
  }

  showOverlay(LayerLink _layerLink, String entryKey, FocusNode focus,
      [TextEditingController controller, int index]) {
    overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    overLayentry[entryKey] = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: controller != null
              ? Offset(-(MediaQuery.of(context).size.width) + 200, 65)
              : Offset(0, 65),
          child:
              Consumer<ViewProvider>(builder: (context, viewProvider, child) {
            return SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 5),
                    ],
                  ),
                  margin: EdgeInsets.only(right: 30),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    children: List.generate(
                      viewProvider.filteredPincode.length,
                      (index) => GestureDetector(
                        onTap: () {
                          if (controller != null) {
                            controller.text = viewProvider
                                .filteredPincode[index].pincode
                                .toString();
                          } else {
                            viewProvider.updateRelative(
                                viewProvider.selectedRelativeIndex,
                                'pin',
                                viewProvider.filteredPincode[index].pincode
                                    .toString());
                          }
                          focus.unfocus();
                        },
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Text((index + 1).toString() + '.  '),
                              Text(
                                viewProvider.filteredPincode[index].district,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
    overlay.insert(overLayentry[entryKey]);
  }

  @override
  void initState() {
    super.initState();
    ViewProvider _viewProvider =
        Provider.of<ViewProvider>(context, listen: false);
    _viewProvider.firstnameController.text = '';
    _viewProvider.ageController.text = '';
    _viewProvider.ftController.text = '';
    _viewProvider.inchController.text = '';
    _viewProvider.presentPinController.text = '';
    _viewProvider.hometowmPinController.text = '';
    _viewProvider.addressController.text = '';
    _viewProvider.relatives[0]['pin'] = TextEditingController();
    _viewProvider.genderController.text = '';
    _viewProvider.clearImages();
    _viewProvider.clearBiodata();

    _presentfn.addListener(() {
      if (!_hometownfn.hasFocus) {
        if (_viewProvider.pincodes.data.any((element) =>
            element.pincode.toString() ==
            _viewProvider.presentPinController.text)) {
        } else {
          _viewProvider.presentPinController.text = '';
        }
        if (overLayentry['present_pin'] != null) {
          overLayentry['present_pin'].remove();
        }
      } else {
        if (overLayentry['present_pin'] != null) {
          overlay.insert(overLayentry['present_pin']);
        }
      }
    });
    _hometownfn.addListener(() {
      if (!_hometownfn.hasFocus) {
        if (_viewProvider.pincodes.data.any((element) =>
            element.pincode.toString() ==
            _viewProvider.hometowmPinController.text)) {
        } else {
          _viewProvider.hometowmPinController.text = '';
        }
        if (overLayentry['home_pin'] != null) {
          overLayentry['home_pin'].remove();
        }
      } else {
        if (overLayentry['home_pin'] != null) {
          overlay.insert(overLayentry['home_pin']);
        }
      }
    });

    (_viewProvider.relatives[0]['focus_node'] as FocusNode).addListener(() {
      if (!(_viewProvider.relatives[0]['focus_node'] as FocusNode).hasFocus) {
        if (overLayentry['relative0'] != null) {
          overLayentry['relative0'].remove();
        }
      } else {
        if (overLayentry['relative0'] != null) {
          overlay.insert(overLayentry['relative0']);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _viewProvider.getPinCode();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ViewProvider _viewProvider = Provider.of<ViewProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(getTranslated('add_profile', context)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: _viewProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Consumer<ViewProvider>(
                  builder: (context, viewProvider, child) {
                viewProvider.relatives.forEach(((element) {
                  int _index = viewProvider.relatives.indexOf(element);
                  if (!(_viewProvider.relatives[_index]['focus_node']
                          as FocusNode)
                      .hasListeners) {
                    (_viewProvider.relatives[_index]['focus_node'] as FocusNode)
                        .addListener(() {
                      if (!(_viewProvider.relatives[_index]['focus_node']
                              as FocusNode)
                          .hasFocus) {
                        if (overLayentry['relative$_index'] != null) {
                          overLayentry['relative$_index'].remove();
                        }
                      } else {
                        viewProvider.updateSelectedRelativeIndex(_index);
                        if (overLayentry['relative$_index'] != null) {
                          overlay.insert(overLayentry['relative$_index']);
                        }
                      }
                    });
                  }
                }));

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var response = await showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Container(
                                    height: 100,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera),
                                                Text('Camera')
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.file_upload),
                                                Text('Files')
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              if (response == false) {
                                ImagePicker imagePicker = ImagePicker();
                                XFile pickedFile = await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 50);
                                if (pickedFile != null) {
                                  viewProvider.updateProfilePicture(
                                      File(pickedFile.path));
                                }
                              } else if (response == true) {
                                ImagePicker imagePicker = ImagePicker();
                                XFile pickedFile = await imagePicker.pickImage(
                                    source: ImageSource.camera,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 50);
                                if (pickedFile != null) {
                                  viewProvider.updateProfilePicture(
                                      File(pickedFile.path));
                                }
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                child: viewProvider
                                        .profilePicture.path.isNotEmpty
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.file(
                                          viewProvider.profilePicture,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          CustomPaint(
                                            size: Size(100, 100),
                                            foregroundPainter: new MyPainter(
                                                completeColor: ColorResources
                                                    .getColombiaBlue(context),
                                                width: 2),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var response = await showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Container(
                                    height: 100,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera),
                                                Text('Camera')
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.file_upload),
                                                Text('Files')
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              if (response == false) {
                                ImagePicker imagePicker = ImagePicker();
                                XFile pickedFile = await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 50);
                                if (pickedFile != null) {
                                  viewProvider.updateProfilePicture2(
                                      File(pickedFile.path));
                                }
                              } else if (response == true) {
                                ImagePicker imagePicker = ImagePicker();
                                XFile pickedFile = await imagePicker.pickImage(
                                    source: ImageSource.camera,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 50);
                                if (pickedFile != null) {
                                  viewProvider.updateProfilePicture2(
                                      File(pickedFile.path));
                                }
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                child: viewProvider
                                        .profilePicture2.path.isNotEmpty
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.file(
                                          viewProvider.profilePicture2,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          CustomPaint(
                                            size: Size(100, 100),
                                            foregroundPainter: new MyPainter(
                                                completeColor: ColorResources
                                                    .getColombiaBlue(context),
                                                width: 2),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        getTranslated('personal_details', context),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        context: context,
                        controller: viewProvider.firstnameController,
                        title: getTranslated('name', context),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text(
                              'Gender',
                              style: TextStyle(color: Colors.blue),
                            ),
                            value: viewProvider.genderController.text == ''
                                ? null
                                : viewProvider.genderController.text,
                            onChanged: (value) {
                              viewProvider.updateSelectedGender(value);
                            },
                            items: viewProvider.genders.map((religion) {
                              return DropdownMenuItem(
                                child: Text(religion),
                                value: religion,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // Container(
                      //   height: 60,
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(
                      //       color: Colors.blue,
                      //     ),
                      //   ),
                      //   child: Center(
                      //     child: DropdownButton<String>(
                      //       value: viewProvider.genderController.text,
                      //       underline: Container(),
                      //       isExpanded: true,
                      //       selectedItemBuilder: (BuildContext ctxt) {
                      //         return viewProvider.genders.map<Widget>((item) {
                      //           return DropdownMenuItem(
                      //               child: Text(
                      //                 item,
                      //                 style:
                      //                     const TextStyle(color: Colors.black),
                      //               ),
                      //               value: item);
                      //         }).toList();
                      //       },
                      //       items: viewProvider.genders.map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(
                      //             value,
                      //             style: const TextStyle(color: Colors.black),
                      //           ),
                      //         );
                      //       }).toList(),
                      //       onChanged: (value) {
                      //         viewProvider.updateSelectedGender(value);
                      //       },
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        context: context,
                        controller: viewProvider.ageController,
                        textInputType: TextInputType.number,
                        title: getTranslated('age', context),
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated('height', context),
                            style: TextStyle(fontSize: 17),
                          ),
                          Spacer(),
                          SizedBox(
                            height: 60,
                            width: 80,
                            child: customTextField(
                                context: context,
                                controller: viewProvider.ftController,
                                textInputType: TextInputType.number,
                                title: getTranslated('ft', context),
                                onChange: (e) {
                                  ViewProvider viewProvider =
                                      Provider.of<ViewProvider>(context,
                                          listen: false);
                                  viewProvider.updateState();
                                }),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          SizedBox(
                            height: 60,
                            width: 80,
                            child: customTextField(
                                context: context,
                                controller: viewProvider.inchController,
                                textInputType: TextInputType.number,
                                title: getTranslated('inch', context),
                                onChange: (e) {
                                  ViewProvider viewProvider =
                                      Provider.of<ViewProvider>(context,
                                          listen: false);
                                  viewProvider.updateState();
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        getTranslated('address_details', context),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated('present_pin', context),
                            style: TextStyle(fontSize: 17),
                          ),
                          Spacer(),
                          CompositedTransformTarget(
                            link: presentlayerLink,
                            child: SizedBox(
                              height: 60,
                              width: 100,
                              child: customTextField(
                                context: context,
                                focusNode: _presentfn,
                                onChange: (e) {
                                  print(overLayentry['present_pin']);
                                  if (overLayentry['present_pin'] == null) {
                                    showOverlay(
                                      presentlayerLink,
                                      'present_pin',
                                      _presentfn,
                                      viewProvider.presentPinController,
                                    );
                                  }
                                  viewProvider.filterPincodes(
                                      controller:
                                          viewProvider.presentPinController);
                                },
                                onSubmit: (e) {
                                  if (overLayentry['present_pin'] != null) {
                                    print('---------submnit');
                                    overLayentry['present_pin'].remove();
                                    overLayentry['present_pin'] = null;
                                  }
                                  setState(() {});
                                },
                                controller: viewProvider.presentPinController,
                                textInputType: TextInputType.number,
                                title: getTranslated('pin', context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated('hometown_pin', context),
                            style: TextStyle(fontSize: 17),
                          ),
                          Spacer(),
                          CompositedTransformTarget(
                            link: layerLink,
                            child: SizedBox(
                              key: _hometownKey,
                              height: 60,
                              width: 100,
                              child: customTextField(
                                focusNode: _hometownfn,
                                context: context,
                                onChange: (e) {
                                  if (overLayentry['home_pin'] == null) {
                                    showOverlay(
                                      layerLink,
                                      'home_pin',
                                      _hometownfn,
                                      viewProvider.hometowmPinController,
                                    );
                                  }
                                  viewProvider.filterPincodes(
                                      controller:
                                          viewProvider.hometowmPinController);
                                },
                                onSubmit: (e) {
                                  if (overLayentry['home_pin'] != null) {
                                    overLayentry['home_pin'].remove();
                                    overLayentry['home_pin'] = null;
                                  }
                                  setState(() {});
                                },
                                controller: viewProvider.hometowmPinController,
                                textInputType: TextInputType.number,
                                title: getTranslated('pin', context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      peragraphTextField(
                        context: context,
                        controller: viewProvider.addressController,
                        title: getTranslated('address', context),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path);
                            viewProvider.updatePickedBiodata(file);
                          } else {
                            viewProvider.updatePickedBiodata(File(''));
                          }
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: viewProvider.pdfBioData.path.isEmpty
                                ? [
                                    Icon(Icons.file_upload_sharp),
                                    Text(getTranslated(
                                        'upload_bio_data', context)),
                                  ]
                                : [
                                    Text(viewProvider.pdfBioData.path
                                        .split('/')
                                        .last)
                                  ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        getTranslated('relatives', context),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      ListView.builder(
                        itemCount: viewProvider.relatives.length,
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          if (!(_viewProvider.relatives[index]['focus_node']
                                  as FocusNode)
                              .hasFocus) {
                            if (_viewProvider.pincodes.data.any((element) =>
                                element.pincode.toString() ==
                                _viewProvider.relatives[index]['pin'].text)) {
                            } else {
                              _viewProvider.relatives[index]['pin'].text = '';
                            }
                          }
                          return Container(
                            width: size.width,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: customTextField(
                                                context: context,
                                                title: getTranslated(
                                                    'name', context),
                                                onChange: (e) {
                                                  viewProvider.updateRelative(
                                                      index, 'name', e);
                                                }),
                                          ),
                                          SizedBox(
                                            child: customTextField(
                                                context: context,
                                                title: getTranslated(
                                                    'relation', context),
                                                onChange: (e) {
                                                  viewProvider.updateRelative(
                                                      index, 'relation', e);
                                                }),
                                          ),
                                          CompositedTransformTarget(
                                            link: viewProvider.relatives[index]
                                                ['layer_link'],
                                            child: SizedBox(
                                              child: customTextField(
                                                  context: context,
                                                  controller: viewProvider
                                                      .relatives[index]['pin'],
                                                  focusNode: viewProvider
                                                          .relatives[index]
                                                      ['focus_node'],
                                                  textInputType:
                                                      TextInputType.number,
                                                  title: 'Pin',
                                                  onChange: (e) {
                                                    if (overLayentry['relative' +
                                                            index.toString()] ==
                                                        null) {
                                                      showOverlay(
                                                          viewProvider.relatives[
                                                                  index]
                                                              ['layer_link'],
                                                          'relative' +
                                                              index.toString(),
                                                          viewProvider.relatives[
                                                                  index]
                                                              ['focus_node'],
                                                          null,
                                                          index);
                                                    }
                                                    viewProvider.filterPincodes(
                                                        text: viewProvider
                                                            .relatives[index]
                                                                ['pin']
                                                            .text);
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        margin: EdgeInsets.only(left: 12),
                                        child: peragraphTextField(
                                            context: context,
                                            title: getTranslated(
                                                'address', context),
                                            onChange: (e) {
                                              viewProvider.updateRelative(
                                                  index, 'address', e);
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (viewProvider.relatives.length < 5)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (viewProvider.relatives.length > 1)
                              ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  viewProvider.removeLastRelative();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.red)),
                                child: Text(
                                  getTranslated('REMOVE', context),
                                ),
                              ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                viewProvider.addRelative();
                              },
                              child: Text(
                                getTranslated('add_another', context),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 22,
                      ),
                      Center(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              var _k = false;

                              if (viewProvider.relatives.isNotEmpty) {
                                for (var rel in viewProvider.relatives) {
                                  if (rel['name'] == '' &&
                                      rel['relation'] == '' &&
                                      rel['address'] == '' &&
                                      rel['pin'].text == '') {
                                  } else {
                                    rel.forEach((key, value) {
                                      if (value.runtimeType == String) {
                                        if (value.trim() == '') {
                                          _k = true;
                                        }
                                      }
                                      if (value.runtimeType ==
                                          TextEditingController) {
                                        if (value.text.trim() == '') {
                                          _k = true;
                                        }
                                      }
                                    });
                                  }
                                }
                                if (_k == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'relative_error', context)),
                                  ));
                                }
                              }
                              print(_k);
                              if (_k == false) {
                                if (viewProvider.pdfBioData.path.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'biodata_error', context)),
                                  ));
                                } else {
                                  var res =
                                      await viewProvider.submitProfile(context);

                                  if (res == false) {
                                    await ScaffoldMessenger.of(
                                            _scaffoldKey.currentContext)
                                        .showSnackBar(SnackBar(
                                            content:
                                                Text('Something went wrong!')));
                                  } else {
                                    popAddProfile();
                                  }
                                }
                              }
                            },
                            child: Text(getTranslated('submit', context))),
                      )),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor = Colors.transparent;
  Color completeColor;
  double width;
  MyPainter({this.completeColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    var percent = (size.width * 0.001) / 2;
    double arcAngle = 2 * pi * percent;

    for (var i = 0; i < 8; i++) {
      var init = (-pi / 2) * (i / 2);
      canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), init,
          arcAngle, false, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
