import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/bio_data_model.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/view_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_textfield.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/paragraph_textfield.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/view/view_large_image.dart';
import 'package:provider/provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/pdf_api.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/topSeller/pdf_viewer_page.dart';

class BiodataOverView extends StatefulWidget {
  final Datum biodata;
  const BiodataOverView({Key key, this.biodata}) : super(key: key);

  @override
  State<BiodataOverView> createState() => _BiodataOverViewState();
}

class _BiodataOverViewState extends State<BiodataOverView> {
  popAddProfile() {
    Future.delayed(Duration(seconds: 1))
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    ViewProvider _viewProvider =
        Provider.of<ViewProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _viewProvider.getPinCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ViewProvider _viewProvider = Provider.of<ViewProvider>(context);
    print('----------1111');
    print(widget.biodata.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('view', context)),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: _viewProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Consumer<ViewProvider>(
                  builder: (context, viewProvider, child) {
                bool isHomeTownPinCodeExist = viewProvider.pincodes.data.any(
                    (element) =>
                        element.pincodeId.toString() ==
                        widget.biodata.hometownAddressPincode);

                bool isPresentPinCodeExist = viewProvider.pincodes.data.any(
                    (element) =>
                        element.pincodeId.toString() ==
                        widget.biodata.presentAddressPincode);
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
                        children: List.generate(
                          widget.biodata.profilePics.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              print(widget.biodata.profilePics[index].image);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewLargeImage(
                                        imageUrl: widget
                                            .biodata.profilePics[index].image),
                                  ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border:
                                      widget.biodata.profilePics[index].image !=
                                              ''
                                          ? null
                                          : Border.all(color: Colors.blue),
                                  borderRadius: viewProvider
                                          .profilePicture.path.isNotEmpty
                                      ? null
                                      : BorderRadius.circular(30),
                                ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.biodata.profilePics[index].image,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                        readOnly: true,
                        labelText: getTranslated('name', context),
                        initialValue: widget.biodata.name,
                        title: getTranslated('name', context),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        context: context,
                        readOnly: true,
                        labelText: getTranslated('gender', context),
                        initialValue: widget.biodata.gender.name.toUpperCase(),
                        title: getTranslated('gender', context),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      customTextField(
                        context: context,
                        textInputType: TextInputType.number,
                        initialValue: widget.biodata.age.toString(),
                        readOnly: true,
                        labelText: getTranslated('age', context),
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
                                textInputType: TextInputType.number,
                                readOnly: true,
                                initialValue:
                                    widget.biodata.height.split('.')[0],
                                title: getTranslated('ft', context),
                                labelText: getTranslated('ft', context),
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
                                textInputType: TextInputType.number,
                                readOnly: true,
                                title: getTranslated('inch', context),
                                labelText: getTranslated('inch', context),
                                initialValue:
                                    widget.biodata.height.split('.')[1],
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
                          if (!isPresentPinCodeExist)
                            SizedBox(
                              height: 60,
                              width: 175,
                              child: customTextField(
                                context: context,
                                readOnly: true,
                                labelText: getTranslated('', context),
                                initialValue:
                                    widget.biodata.presentAddressPincode,
                                title: getTranslated('pin', context),
                              ),
                            ),
                          if (isPresentPinCodeExist)
                            SizedBox(
                              height: 60,
                              width: 175,
                              child: customTextField(
                                context: context,
                                textInputType: TextInputType.number,
                                readOnly: true,
                                initialValue: viewProvider.pincodes.data
                                        .where((element) =>
                                            element.pincodeId.toString() ==
                                            widget
                                                .biodata.presentAddressPincode)
                                        .first
                                        .district ??
                                    widget.biodata.presentAddressPincode,
                                title: getTranslated('pin', context),
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
                          if (!isHomeTownPinCodeExist)
                            SizedBox(
                              height: 60,
                              width: 175,
                              child: customTextField(
                                context: context,
                                readOnly: true,
                                labelText: getTranslated('', context),
                                initialValue:
                                    widget.biodata.hometownAddressPincode,
                                title: getTranslated('pin', context),
                              ),
                            ),
                          if (isHomeTownPinCodeExist)
                            SizedBox(
                              height: 60,
                              width: 175,
                              child: customTextField(
                                context: context,
                                readOnly: true,
                                initialValue: viewProvider.pincodes.data
                                        .where((element) =>
                                            element.pincodeId.toString() ==
                                            widget
                                                .biodata.hometownAddressPincode)
                                        .first
                                        .district ??
                                    widget.biodata.hometownAddressPincode,
                                textInputType: TextInputType.number,
                                title: getTranslated('pin', context),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      peragraphTextField(
                        context: context,
                        readOnly: true,
                        labelText: getTranslated('address', context),
                        initialValue: widget.biodata.address,
                        title: getTranslated('address', context),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // Text(
                      //   getTranslated('relatives', context),
                      //   style: TextStyle(
                      //       fontSize: 17, fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(
                        height: 12,
                      ),
                      relativeWidget(size, viewProvider),
                      SizedBox(
                        height: 22,
                      ),
                      Center(
                          child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // popAddProfile();
                              viewProvider.downloadBiodata(
                                  widget.biodata.biodata, context);
                              final file = await PDFApi.loadNetwork(widget.biodata.biodata);
                              openPDF(context, file);
                            },
                            child: Text(
                              getTranslated('download_biodata', context),
                            )),
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

  Widget relativeWidget(Size size, ViewProvider viewProvider) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('relatives', context),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            itemCount: widget.biodata.relations.length ?? 0,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              bool isPinCodeExist = viewProvider.pincodes.data.any((element) =>
                  element.pincodeId.toString() ==
                  widget.biodata.relations[index].addressPincode);

              var _k = false;
              if (widget.biodata.relations.isNotEmpty) {
                for (var rel in widget.biodata.relations) {
                  if (rel.name.trim() == '' ||
                      rel.relation.trim() == '' ||
                      rel.address.trim() == '' ||
                      rel.addressPincode.trim() == '') {
                    _k = true;
                  }
                }
              }
              if (_k == true) {
                return Container();
              } else {
                return Column(
                  children: [
                    Container(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: customTextField(
                                          context: context,
                                          title: getTranslated('name', context),
                                          labelText:
                                              getTranslated('name', context),
                                          readOnly: true,
                                          initialValue: widget
                                              .biodata.relations[index].name,
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
                                          labelText: getTranslated(
                                              'relation', context),
                                          readOnly: true,
                                          initialValue: widget.biodata
                                              .relations[index].relation,
                                          onChange: (e) {
                                            viewProvider.updateRelative(
                                                index, 'relation', e);
                                          }),
                                    ),
                                    if (widget.biodata.relations[index]
                                                .addressPincode
                                                .trim() !=
                                            '' &&
                                        isPinCodeExist == true)
                                      SizedBox(
                                        child: customTextField(
                                            context: context,
                                            textInputType: TextInputType.number,
                                            readOnly: true,
                                            labelText:
                                                getTranslated('pin', context),
                                            initialValue: viewProvider
                                                    .pincodes.data
                                                    .where((element) =>
                                                        element.pincodeId
                                                            .toString() ==
                                                        widget
                                                            .biodata
                                                            .relations[index]
                                                            .addressPincode)
                                                    .first
                                                    .district ??
                                                widget.biodata.relations[index]
                                                    .addressPincode,
                                            title:
                                                getTranslated('pin', context),
                                            onChange: (e) {
                                              viewProvider.updateRelative(
                                                  index, 'address_pincode', e);
                                            }),
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
                                      title: getTranslated('address', context),
                                      labelText:
                                          getTranslated('address', context),
                                      readOnly: true,
                                      initialValue: widget
                                          .biodata.relations[index].address,
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
                    ),
                  ],
                );
              }
            },
          ),
        ],
      );
    } catch (e) {
      return Container();
    }
  }
  static void openPDF(BuildContext context, file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
}
