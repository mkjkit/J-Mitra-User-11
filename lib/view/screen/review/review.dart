import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/review_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/review/add_new_review.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/review/review_overview.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  void initState() {
    super.initState();
    ReviewProvider reviewProvider =
        Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.getAllGeneralReview();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('theft_reporting', context)),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddReview()));
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
      body: Consumer<ReviewProvider>(builder: (context, reviewProvider, child) {
        if (reviewProvider.reviews.length > 0) {
          print(reviewProvider.reviews[0].toJson());
          return ListView(
            children: List.generate(
              reviewProvider.reviews.length,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReviewOverview(review: reviewProvider.reviews[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              reviewProvider.reviews[index].images.isNotEmpty
                                  ? reviewProvider
                                      .reviews[index].images.first.image
                                  : 'assets/images/placeholder.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      // Text(reviewProvider.reviews[index].survey ?? '')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Shop Name : ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: size.width / 2.3,
                                child: Text(
                                    reviewProvider.reviews[index].userName ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'District : ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  reviewProvider.reviews[index].district ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'State : ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  reviewProvider.reviews[index].state ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Description : ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: size.width / 2.1,
                                child: Text(
                                    reviewProvider
                                                .reviews[index].survey.length >
                                            50
                                        ? reviewProvider.reviews[index].survey
                                                .substring(0, 50) +
                                            '...'
                                        : reviewProvider.reviews[index].survey,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (reviewProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      }),
    );
  }
}
