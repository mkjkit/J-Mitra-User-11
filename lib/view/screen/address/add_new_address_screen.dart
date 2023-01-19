import 'dart:developer';

import 'package:com.jewelmitra.jewel_mitra/provider/view_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/address_model.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/location_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/order_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/profile_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/button/custom_button.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_app_bar.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/my_dialog.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/textfield/custom_textfield.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/address/select_location_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../basewidget/custom_textfield.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  final bool isBilling;

  AddNewAddressScreen(
      {this.isEnableUpdate = false,
      this.address,
      this.fromCheckout = false,
      this.isBilling});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  bool isDistrict = false;
  GlobalKey _hometownKey = GlobalKey();
  final layerLink = LayerLink();
  final districtLayerLink = LayerLink();
  FocusNode districtfn = FocusNode();
  FocusNode statefn = FocusNode();
  OverlayState stateOverlay;
  OverlayState districtOverlay;
  OverlayState overlay;
  Map<String, dynamic> overLayentry = {
    "district_pin": null,
    'state_pin': null,
  };

  showOverlayDistrict(LayerLink _layerLink, String entryKey, FocusNode focus,
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
              ? Offset(-(MediaQuery.of(context).size.width) + 428, 65)
              : Offset(0, 65),
          child: Consumer<LocationProvider>(
              builder: (context, viewProvider, child) {
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        children: List.generate(
                          viewProvider.filteredDistrict.length,
                          (index) => GestureDetector(
                            onTap: () {
                              if (controller != null) {
                                controller.text = viewProvider
                                    .filteredDistrict[index].district
                                    .toString();
                              } else {
                                viewProvider.updateRelative(
                                    viewProvider
                                        .selectedRelativeIndexForDistrict,
                                    'pin',
                                    viewProvider.filteredDistrict[index].pincode
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
                                    viewProvider
                                        .filteredDistrict[index].district,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ));
          }),
        ),
      ),
    );
    overlay.insert(overLayentry[entryKey]);
  }

  showOverlayState(LayerLink _layerLink, String entryKey, FocusNode focus,
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
              ? Offset(-(MediaQuery.of(context).size.width) + 428, 65)
              : Offset(0, 65),
          child: Consumer<LocationProvider>(
              builder: (context, viewProvider, child) {
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        children: List.generate(
                          viewProvider.filteredState.length,
                          (index) => GestureDetector(
                            onTap: () {
                              if (controller != null) {
                                controller.text = viewProvider
                                    .filteredState[index].stateId
                                    .toString();
                              } else {
                                viewProvider.updateRelative(
                                    viewProvider.selectedRelativeIndexForState,
                                    'pin',
                                    viewProvider.filteredState[index].pincode
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
                                    viewProvider.filteredState[index].stateId
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ));
          }),
        ),
      ),
    );
    overlay.insert(overLayentry[entryKey]);
  }

  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonNumberController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _districtNode = FocusNode();
  GoogleMapController _controller;
  CameraPosition _cameraPosition;
  bool _updateAddress = true;
  Address _address;

  @override
  void initState() {
    //super.initState();
    //if(widget.isBilling){
    //_address = Address.billing;
    //}else{
    LocationProvider provider =
        Provider.of<LocationProvider>(context, listen: false);

    districtfn.addListener(() {
      if (!statefn.hasFocus) {
        if (provider.pincodes.data.any((element) =>
            element.district.toString() == provider.districtController.text)) {
          print('text---->' + provider.districtController.text);
        } else {
          // provider.districtController.text = '';
        }
        if (overLayentry['district_pin'] != null) {
          overLayentry['district_pin'].remove();
        }
      } else {
        if (overLayentry['district_pin'] != null) {
          overlay.insert(overLayentry['district_pin']);
        }
      }
    });

    statefn.addListener(() {
      if (!statefn.hasFocus) {
        if (provider.pincodes.data.any((element) =>
            element.stateId.toString() == provider.stateController.text)) {
          print('text---->' + provider.stateController.text);
        } else {}
        if (overLayentry['state_pin'] != null) {
          overLayentry['state_pin'].remove();
        }
      } else {
        if (overLayentry['state_pin'] != null) {
          overlay.insert(overLayentry['state_pin']);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getPinCode();
    });
    _address = Address.billing;
    //}

    Provider.of<LocationProvider>(context, listen: false)
        .initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false)
        .updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false)
        .updateErrorMessage(message: '');
    /*_checkPermission(
        () => Provider.of<LocationProvider>(context, listen: false)
            .getCurrentLocation(context, true, mapController: _controller),
        context);*/
    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
          CameraPosition(
              target: LatLng(double.parse(widget.address.latitude),
                  double.parse(widget.address.longitude))),
          true,
          widget.address.address,
          context);
      _contactPersonNameController.text = '${widget.address.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address.phone}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(0, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(1, false);
      }
    } else {
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
          null) {
        _contactPersonNameController.text =
            '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}'
            ' ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName ?? ''}';
        _contactPersonNumberController.text =
            Provider.of<ProfileProvider>(context, listen: false)
                    .userInfoModel
                    .phone ??
                '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('====selected shipping or billing==>${_address.toString()}');
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
                title: widget.isEnableUpdate
                    ? getTranslated('update_address', context)
                    : getTranslated('add_new_address', context)),
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Google Map Code
                                /*Container(
                                        height: 126,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          child: Stack(
                                            clipBehavior: Clip.none, children: [
                                            GoogleMap(
                                              mapType: MapType.normal,
                                              initialCameraPosition: CameraPosition(
                                                target: widget.isEnableUpdate
                                                    ? LatLng(double.parse(widget.address.latitude) ?? 0.0, double.parse(widget.address.longitude) ?? 0.0)
                                                    : LatLng(locationProvider.position.latitude ?? 0.0, locationProvider.position.longitude ?? 0.0),
                                                zoom: 17,
                                              ),
                                              onTap: (latLng) {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SelectLocationScreen(googleMapController: _controller)));
                                              },
                                              zoomControlsEnabled: false,
                                              compassEnabled: false,
                                              indoorViewEnabled: true,
                                              mapToolbarEnabled: false,
                                              onCameraIdle: () {
                                                if(_updateAddress) {
                                                  locationProvider.updatePosition(_cameraPosition, true, null, context);
                                                }else {
                                                  _updateAddress = true;
                                                }
                                              },
                                              onCameraMove: ((_position) => _cameraPosition = _position),
                                              onMapCreated: (GoogleMapController controller) {
                                                _controller = controller;
                                                if (!widget.isEnableUpdate && _controller != null) {
                                                  Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, true, mapController: _controller);
                                                }
                                              },
                                            ),
                                            locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                                                .of(context).primaryColor))) : SizedBox(),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context).size.height,
                                                child: Icon(
                                                  Icons.location_on,
                                                  size: 40,
                                                  color: Theme.of(context).primaryColor,
                                                )),
                                            Positioned(
                                              bottom: 10,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  _checkPermission(() => locationProvider.getCurrentLocation(context, true, mapController: _controller),context);
                                                },
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                    color: ColorResources.getChatIcon(context),
                                                  ),
                                                  child: Icon(
                                                    Icons.my_location,
                                                    color: Theme.of(context).primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {

                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (BuildContext context) => SelectLocationScreen(googleMapController: _controller)));
                                                },
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.fullscreen,
                                                    color: Theme.of(context).primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                            child: Text(
                                              getTranslated('add_the_location_correctly', context),
                                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getTextTitle(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                            )),
                                      ),*/
                                SizedBox(height: Dimensions.ICON_SIZE_LARGE),
                                Container(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: locationProvider
                                        .getAllAddressType.length,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        locationProvider.updateAddressIndex(
                                            index, true);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                            horizontal:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        margin: EdgeInsets.only(right: 17),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            border: Border.all(
                                                color: locationProvider
                                                            .selectAddressIndex ==
                                                        index
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : ColorResources.getHint(
                                                        context)),
                                            color: locationProvider
                                                        .selectAddressIndex ==
                                                    index
                                                ? Theme.of(context).primaryColor
                                                : ColorResources.getChatIcon(
                                                    context)),
                                        child: Text(
                                          getTranslated(
                                              locationProvider
                                                  .getAllAddressType[index]
                                                  .toLowerCase(),
                                              context),
                                          style: robotoRegular.copyWith(
                                              color: locationProvider
                                                          .selectAddressIndex ==
                                                      index
                                                  ? Theme.of(context).cardColor
                                                  : ColorResources.getHint(
                                                      context)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                    getTranslated('address', context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        .copyWith(
                                            color:
                                                ColorResources.getHint(context),
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),

                                // for Address Field
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText:
                                      getTranslated('address_line_02', context),
                                  textInputType: TextInputType.streetAddress,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _addressNode,
                                  nextNode: _nameNode,
                                  controller:
                                      locationProvider.locationController,
                                ),
                                SizedBox(
                                    height: Dimensions
                                        .PADDING_SIZE_DEFAULT_ADDRESS),
                                Text(
                                  getTranslated('city', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('city', context),
                                  textInputType: TextInputType.streetAddress,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _cityNode,
                                  nextNode: _zipNode,
                                  controller: _cityController,
                                ),
                                SizedBox(
                                    height: Dimensions
                                        .PADDING_SIZE_DEFAULT_ADDRESS),
                                Text(
                                  getTranslated('zip', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('zip', context),
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _zipNode,
                                  nextNode: _nameNode,
                                  controller: _zipCodeController,
                                ),
                                SizedBox(
                                    height: Dimensions
                                        .PADDING_SIZE_DEFAULT_ADDRESS),
                                Text(
                                  getTranslated('state', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('state', context),
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _stateNode,
                                  nextNode: _districtNode,
                                  controller: _stateController,
                                ),
                                SizedBox(
                                    height: Dimensions
                                        .PADDING_SIZE_DEFAULT_ADDRESS),
                                Text(
                                  getTranslated('district', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('district', context),
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _districtNode,
                                  nextNode: _districtNode,
                                  controller: _districtController,
                                ),
                                /*Text(
                                  getTranslated('state', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(0, 1))
                                      // changes position of shadow
                                    ],
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text('State'),
                                    ),
                                  ),
                                ),*/
                                /*Text(
                                  getTranslated('district', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CompositedTransformTarget(
                                  link: districtLayerLink,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    child: customTextField(
                                      focusNode: districtfn,
                                      context: context,
                                      onChange: (e) {
                                        if (overLayentry['district_pin'] ==
                                            null) {
                                          showOverlayDistrict(
                                            districtLayerLink,
                                            'district_pin',
                                            districtfn,
                                            locationProvider
                                                .districtController,
                                          );
                                        }
                                        locationProvider.filterDistrict(
                                            controller: locationProvider
                                                .districtController);
                                      },
                                      onSubmit: (e) {
                                        if (overLayentry['district_pin'] !=
                                            null) {
                                          overLayentry['district_pin']
                                              .remove();
                                          overLayentry['district_pin'] = null;
                                        }
                                        setState(() {});
                                      },
                                      controller:
                                          locationProvider.districtController,
                                      textInputType: TextInputType.text,
                                      title:
                                          getTranslated('district', context),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: Dimensions
                                        .PADDING_SIZE_DEFAULT_ADDRESS),
                                Text(
                                  getTranslated('state', context),
                                  style: robotoRegular.copyWith(
                                      color: ColorResources.getHint(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CompositedTransformTarget(
                                  link: layerLink,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    child: customTextField(
                                      focusNode: statefn,
                                      context: context,
                                      onChange: (e) {
                                        if (overLayentry['state_pin'] ==
                                            null) {
                                          showOverlayState(
                                            layerLink,
                                            'state_pin',
                                            statefn,
                                            locationProvider.stateController,
                                          );
                                        }
                                        locationProvider.filterState(
                                            controller: locationProvider
                                                .stateController);
                                      },
                                      onSubmit: (e) {
                                        if (overLayentry['state_pin'] !=
                                            null) {
                                          overLayentry['state_pin'].remove();
                                          overLayentry['state_pin'] = null;
                                        }
                                        setState(() {});
                                      },
                                      controller:
                                          locationProvider.stateController,
                                      textInputType: TextInputType.number,
                                      title: getTranslated('state', context),
                                    ),
                                  ),
                                ),*/
                                /*TextFormField(
                                        controller: _districtController,
                                        decoration: InputDecoration(
                                          label: Text(profileProvider.)
                                        ),
                                      ),*/
                                /*// for Contact Person Name
                                      Text(
                                        getTranslated('contact_person_name', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('enter_contact_person_name', context),
                                        textInputType: TextInputType.name,
                                        controller: _contactPersonNameController,
                                        focusNode: _nameNode,
                                        nextNode: _numberNode,
                                        textInputAction: TextInputAction.next,
                                        capitalization: TextCapitalization.words,
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT_ADDRESS),

                                      // for Contact Person Number
                                      Text(
                                        getTranslated('contact_person_number', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('enter_contact_person_number', context),
                                        textInputType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        focusNode: _numberNode,
                                        controller: _contactPersonNumberController,
                                      ),*/
                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT),
                                Container(
                                  height: 50.0,
                                  margin: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: !locationProvider.isLoading
                                      ? CustomButton(
                                          buttonText: widget.isEnableUpdate
                                              ? getTranslated(
                                                  'update_address', context)
                                              : getTranslated(
                                                  'save_location', context),
                                          onTap: locationProvider.loading
                                              ? null
                                              : () {
                                                  AddressModel addressModel = AddressModel(
                                                    addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                                                    contactPersonName: _contactPersonNameController.text ?? '',
                                                    phone: _contactPersonNumberController.text ?? '',
                                                    city: _cityController.text ?? '',
                                                    state: _districtController.text ?? '',
                                                    country: _stateController.text ?? '',
                                                    zip: _zipCodeController.text ?? '',
                                                    isBilling: _address == Address.billing
                                                        ? 1
                                                        : 0,
                                                    address: locationProvider.locationController.text ?? '',
                                                    latitude: widget.isEnableUpdate
                                                        ? locationProvider.position.latitude.toString() ?? widget.address.latitude
                                                        : locationProvider.position.latitude.toString() ?? '',
                                                    longitude: widget.isEnableUpdate
                                                        ? locationProvider.position.longitude.toString() ?? widget.address.longitude
                                                        : locationProvider.position.longitude.toString() ?? '',
                                                  );
                                                  if (widget.isEnableUpdate) {
                                                    addressModel.id =
                                                        widget.address.id;
                                                    addressModel.id =
                                                        widget.address.id;
                                                    // addressModel.method = 'put';
                                                    locationProvider
                                                        .updateAddress(context,
                                                            addressModel:
                                                                addressModel,
                                                            addressId:
                                                                addressModel.id)
                                                        .then((value) {});
                                                  } else {
                                                    log('addressModel--->' + addressModel.state.toString());
                                                    locationProvider
                                                        .addAddress(
                                                            addressModel,
                                                            context)
                                                        .then((value) {
                                                      if (value.isSuccess) {
                                                        Provider.of<ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                            .initAddressList(
                                                                context);
                                                        Navigator.pop(context);
                                                        if (widget
                                                            .fromCheckout) {
                                                          Provider.of<ProfileProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .initAddressList(
                                                                  context);
                                                          Provider.of<OrderProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .setAddressIndex(
                                                                  -1);
                                                        } else {
                                                          ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      value
                                                                          .message),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          600),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    value
                                                                        .message),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        600),
                                                                backgroundColor:
                                                                    Colors
                                                                        .red));
                                                      }
                                                    });
                                                  }
                                                },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.whileInUse) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined,
                  title: '',
                  description: getTranslated('you_denied', context))));
    } else if (permission == LocationPermission.deniedForever) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined,
                  title: '',
                  description: getTranslated('you_denied', context))));
    } else {
      callback();
    }
  }
}

enum Address { shipping, billing }
