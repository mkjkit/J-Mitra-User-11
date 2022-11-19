import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/auth_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/product_details_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/profile_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/review_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/button/custom_button.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  AddReview();

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController _reviewcontroller = TextEditingController();
  List<File> _files = [File(''), File(''), File('')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report theft'),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Consumer<ReviewProvider>(builder: (context, reviewProvider, child) {
        if (reviewProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Row(children: [
                          Expanded(
                              child: Text(getTranslated('your_observation', context),
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL))),
                          // Container(
                          //   height: 30,
                          //   padding:
                          //       EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //   alignment: Alignment.center,
                          //   decoration: BoxDecoration(
                          //     color: ColorResources.getLowGreen(context),
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: ListView.builder(
                          //     itemCount: 5,
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.horizontal,
                          //     itemBuilder: (context, index) {
                          //       return InkWell(
                          //         child: Icon(
                          //           Icons.star,
                          //           size: 20,
                          //           color:
                          //               Provider.of<ProductDetailsProvider>(context)
                          //                           .rating <
                          //                       (index + 1)
                          //                   ? Theme.of(context).highlightColor
                          //                   : ColorResources.getYellow(context),
                          //         ),
                          //         onTap: () => Provider.of<ProductDetailsProvider>(
                          //                 context,
                          //                 listen: false)
                          //             .setRating(index + 1),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CustomTextField(
                          maxLine: 4,
                          hintText: getTranslated(
                              'write_your_experience_here', context),
                          controller: _reviewcontroller,
                          textInputAction: TextInputAction.done,
                          fillColor: ColorResources.getLowGreen(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              getTranslated('upload_images', context),
                              style: robotoBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              itemCount: 3,
                              shrinkWrap: true,
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  child: InkWell(
                                    onTap: () async {
                                      var response = await showDialog(
                                        context: context,
                                        builder: (context) => Center(
                                          child: Container(
                                            height: 100,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.camera),
                                                        Text('Camera')
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                        XFile pickedFile =
                                            await imagePicker.pickImage(
                                                source: ImageSource.gallery,
                                                maxWidth: 500,
                                                maxHeight: 500,
                                                imageQuality: 50);
                                        if (pickedFile != null) {
                                          _files[index] = File(pickedFile.path);
                                          setState(() {});
                                        }
                                      } else if (response == true) {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile pickedFile =
                                            await imagePicker.pickImage(
                                                source: ImageSource.camera,
                                                maxWidth: 500,
                                                maxHeight: 500,
                                                imageQuality: 50);
                                        if (pickedFile != null) {
                                          _files[index] = File(pickedFile.path);
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: _files[index].path.isEmpty
                                        ? Container(
                                            height: 40,
                                            width: 50,
                                            alignment: Alignment.center,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                CustomPaint(
                                                  size: Size(100, 40),
                                                  foregroundPainter: new MyPainter(
                                                      completeColor:
                                                          ColorResources
                                                              .getColombiaBlue(
                                                                  context),
                                                      width: 2),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(_files[index],
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                      Provider.of<ProductDetailsProvider>(context).errorText !=
                              null
                          ? Text(
                              Provider.of<ProductDetailsProvider>(context)
                                  .errorText,
                              style: titilliumRegular.copyWith(
                                  color: ColorResources.RED))
                          : SizedBox.shrink(),
                      Builder(
                        builder: (context) => !Provider.of<
                                    ProductDetailsProvider>(context)
                                .isLoading
                            ? Padding(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_LARGE),
                                child: CustomButton(
                                  buttonText: getTranslated('submit', context),
                                  onTap: () async {
                                    String userID =
                                        await Provider.of<ProfileProvider>(
                                                context,
                                                listen: false)
                                            .getUserInfo(context);

                                    if (_files.every(
                                        (element) => element.path.isEmpty)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Please provide Image!'),
                                        ),
                                      );
                                    } else if (_reviewcontroller.text == '') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please provide your review!'),
                                        ),
                                      );
                                    } else {
                                      ReviewProvider reviewProvider =
                                          Provider.of<ReviewProvider>(context,
                                              listen: false);

                                      reviewProvider.submitReview(
                                        userID,
                                        _reviewcontroller.text,
                                        _files,
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .getUserToken(),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor))),
                      ),
                    ]),
              ),
            ],
          );
      }),
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
