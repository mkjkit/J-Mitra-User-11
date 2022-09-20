import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/general_review_model.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';


class ReviewOverview extends StatelessWidget {
  final GeneralsurveyModel review;
  const ReviewOverview({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: AppBar(
        title: Text(getTranslated('theft_reported_person', context)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                review.images.length,
                (index) {
                  return Center(
                    child: Container(
                      height: size.height * 0.3,
                      width: size.width * 0.9,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white, width: 5),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(review.images[index].image),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: review.survey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Name:- ',
                        ),
                        TextSpan(
                          text: review.userName,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Address:- ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: review.address,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'District:- ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: review.district,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
