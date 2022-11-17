import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/address_model.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/location_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/profile_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/button/custom_button.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_app_bar.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/textfield/custom_textfield.dart';


import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  final bool isBilling;
  AddNewAddressScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false, this.isBilling});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();
  bool _updateAddress = true;
  Address _address;


  @override
  void initState() {
    super.initState();
    if(widget.isBilling){
      _address = Address.billing;
    }else{
      _address = Address.shipping;
    }



  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    height: MediaQuery.of(context).size.height,
                    child: Column(

                      children: [
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.only(top: 5,),
                                    child: Text(
                                      getTranslated('address', context),
                                      style: Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getHint(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                  ),

                                  // for Address Field
                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    hintText: getTranslated('address_line_02', context),
                                    textInputType: TextInputType.streetAddress,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _addressNode,
                                    nextNode: _nameNode,
                                    controller: locationProvider.locationController,
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT_ADDRESS),
                                  Text(
                                    getTranslated('city', context),
                                    style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
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
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT_ADDRESS),
                                  Text(
                                    getTranslated('zip', context),
                                    style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
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
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT_ADDRESS),

                                  // for Contact Person Name
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
                                  ),

                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                                  Container(
                                    height: 50.0,
                                    margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: !locationProvider.isLoading ? CustomButton(
                                      buttonText: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
                                      onTap: locationProvider.loading ? null : () { AddressModel addressModel = AddressModel(
                                        addressType: "Home",
                                        //addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                                        contactPersonName: _contactPersonNameController.text ?? '',
                                        phone: _contactPersonNumberController.text ?? '',
                                        city: _cityController.text ?? '',
                                        zip: _zipCodeController.text?? '',
                                        isBilling: _address == Address.billing ? 1:0,
                                        address: locationProvider.locationController.text ?? '',
                                                                              );
                                      if (widget.isEnableUpdate) {
                                        addressModel.id = widget.address.id;
                                        addressModel.id = widget.address.id;
                                        // addressModel.method = 'put';
                                        locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                                      } else {
                                        locationProvider.addAddress(addressModel, context).then((value) {
                                          if (value.isSuccess) {
                                            Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                                            Navigator.pop(context);
                                            if (widget.fromCheckout) {
                                              Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), duration: Duration(milliseconds: 600), backgroundColor: Colors.green));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), duration: Duration(milliseconds: 600), backgroundColor: Colors.red));
                                          }
                                        });
                                      }
                                      },
                                    )
                                        : Center(
                                        child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
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
      ),
    );
  }

}

enum Address {shipping, billing }