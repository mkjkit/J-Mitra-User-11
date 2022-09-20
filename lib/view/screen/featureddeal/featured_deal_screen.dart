import 'package:flutter/material.dart';

import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/featured_deal_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_app_bar.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/home/widget/featured_deal_view.dart';
import 'package:provider/provider.dart';

class FeaturedDealScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: getTranslated('featured_deals', context)),

        Expanded(child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<FeaturedDealProvider>(context, listen: false).getFeaturedDealList(true, context);
          },
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: FeaturedDealsView(isHomePage: false),
          ),
        )),

      ]),
    );
  }
}
