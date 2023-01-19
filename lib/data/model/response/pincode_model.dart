// To parse this JSON data, do
//
//     final pincodes = pincodesFromJson(jsonString);

import 'dart:developer';

import 'package:meta/meta.dart';
import 'dart:convert';

Pincodes pincodesFromJson(String str) => Pincodes.fromJson(json.decode(str));

String pincodesToJson(Pincodes data) => json.encode(data.toJson());

class Pincodes {
  Pincodes({
    @required this.success,
    @required this.message,
    @required this.data,
  });

  final String success;
  final String message;
  final List<Datum> data;

  factory Pincodes.fromJson(Map<String, dynamic> json) => Pincodes(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    @required this.pincodeId,
    @required this.stateId,
    @required this.pincode,
    @required this.district,
  });

  final int pincodeId;
  int stateId;
  final int pincode;
  final String district;

  factory Datum.fromJson(Map<String, dynamic> json) {
    // log('state_id--->'+json["state_id"].toString());
    // log('district--->'+json["district"].toString());
    return Datum(
      pincodeId: json["pincode_id"],
      stateId: json["state_id"],
      pincode: json["pincode"],
      district: json["district"],
    );
  }

  Map<String, dynamic> toJson() => {
        "pincode_id": pincodeId,
        "state_id": stateId,
        "pincode": pincode,
        "district": district,
      };
}
