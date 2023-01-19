import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/localization/language_constrants.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/auth_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/provider/profile_provider.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/color_resources.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/custom_themes.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/dimensions.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/custom_app_bar.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/no_internet_screen.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/not_loggedin_widget.dart';
import 'package:com.jewelmitra.jewel_mitra/view/basewidget/show_custom_modal_dialog.dart';
import 'package:com.jewelmitra.jewel_mitra/view/screen/address/add_new_address_screen.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false)
          .initAddressTypeList(context);
      Provider.of<ProfileProvider>(context, listen: false)
          .initAddressList(context);
    }

    return Scaffold(
      floatingActionButton: isGuestMode
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddNewAddressScreen(isBilling: false))),
              child: Icon(Icons.add, color: Theme.of(context).highlightColor),
              backgroundColor: ColorResources.getPrimary(context),
            ),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('ADDRESS_LIST', context)),
          isGuestMode
              ? Expanded(child: NotLoggedInWidget())
              : Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return profileProvider.shippingAddressList != null
                        ? profileProvider.shippingAddressList.length > 0
                            ? Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    Provider.of<ProfileProvider>(context,
                                            listen: false)
                                        .initAddressTypeList(context);
                                    await Provider.of<ProfileProvider>(context,
                                            listen: false)
                                        .initAddressList(context);
                                  },
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: profileProvider
                                        .shippingAddressList.length,
                                    itemBuilder: (context, index) => Card(
                                      color: Colors.pink.shade50,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      child: Stack(
                                        children: [
                                          ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Address: ',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    profileProvider
                                                            .shippingAddressList[
                                                                index]
                                                            .address ??
                                                        "",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  '${getTranslated('city', context)}: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  profileProvider
                                                          .shippingAddressList[
                                                              index]
                                                          .city ??
                                                      "",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_DEFAULT),
                                                Text(
                                                  '${getTranslated('zip', context)}: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
                                                Text(
                                                  profileProvider
                                                      .shippingAddressList[
                                                  index]
                                                      .zip ??
                                                      "",
                                                  style:
                                                  TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete_forever,
                                                  color: Colors.red),
                                              onPressed: () {
                                                showCustomModalDialog(
                                                  context,
                                                  title: getTranslated(
                                                      'REMOVE_ADDRESS',
                                                      context),
                                                  content: profileProvider
                                                      .shippingAddressList[
                                                          index]
                                                      .address,
                                                  cancelButtonText:
                                                      getTranslated(
                                                          'CANCEL', context),
                                                  submitButtonText:
                                                      getTranslated(
                                                          'REMOVE', context),
                                                  submitOnPressed: () {
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeAddressById(
                                                            profileProvider
                                                                .shippingAddressList[
                                                                    index]
                                                                .id,
                                                            index,
                                                            context);
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .initAddressList(
                                                            context);
                                                    Navigator.of(context).pop();
                                                  },
                                                  cancelOnPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child:
                                    NoInternetOrDataScreen(isNoInternet: false))
                        : Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor))));
                  },
                ),
        ],
      ),
    );
  }
}
