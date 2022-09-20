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
                  margin: EdgeInsets.all(7),
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              reviewProvider.reviews[index].images.isNotEmpty
                                  ? reviewProvider
                                      .reviews[index].images.first.image
                                  : 'https://www.uhonline.hawaii.edu/uhoic/wp-content/plugins/elementor/assets/images/placeholder.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(reviewProvider.reviews[index].survey ?? '')
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
