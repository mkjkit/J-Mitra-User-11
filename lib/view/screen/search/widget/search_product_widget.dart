import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/product_model.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/images.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/product_widget.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/search/widget/search_filter_bottom_sheet.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchProductWidget extends StatelessWidget {
  final bool isViewScrollable;
  final List<Product> products;
  SearchProductWidget({this.isViewScrollable, this.products});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          Text.rich(TextSpan(
              children: [
                TextSpan(text: '${getTranslated('searched_item', context)}',
                    style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: ColorResources.getReviewRattingColor(context))),

                TextSpan(text: '(${products.length} ' + '${getTranslated('item_found', context)})'),
              ],
            ),
          ),
          Row(children: [
            Expanded(child: Text('${getTranslated('products', context)}',style: robotoBold,)),

            InkWell(onTap: () => showModalBottomSheet(context: context,
                isScrollControlled: true, backgroundColor: Colors.transparent,
                builder: (c) => SearchFilterBottomSheet()),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),
                  child: Image.asset(Images.dropdown, scale: 3),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


          Expanded(child: StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            crossAxisCount: 2,
            itemCount: products.length,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: products[index]);},
            ),
          ),
        ],
      ),
    );
  }
}
