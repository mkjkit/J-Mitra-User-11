// To parse this JSON data, do
//
//     final bioDataModel = bioDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BioDataModel bioDataModelFromJson(String str) =>
    BioDataModel.fromJson(json.decode(str));

String bioDataModelToJson(BioDataModel data) => json.encode(data.toJson());

class BioDataModel {
  BioDataModel({
    @required this.success,
    @required this.message,
    @required this.data,
  });

  final String success;
  final String message;
  final List<Datum> data;

  factory BioDataModel.fromJson(Map<String, dynamic> json) => BioDataModel(
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
    @required this.id,
    @required this.userId,
    @required this.name,
    @required this.gender,
    @required this.age,
    @required this.height,
    @required this.districtName,
    @required this.heightIn,
    @required this.address,
    @required this.presentAddressPincode,
    @required this.hometownAddressPincode,
    @required this.biodata,
    @required this.relations,
    @required this.profilePics,
  });

  final int id;
  final int userId;
  final String name;
  final Gender gender;
  final int age;
  final String height;
  final String districtName;
  final HeightIn heightIn;
  final String address;
  final String presentAddressPincode;
  final String hometownAddressPincode;
  final String biodata;
  final List<Relation> relations;
  final List<ProfilePic> profilePics;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        gender: genderValues.map[json["gender"]],
        age: json["age"],
        height: json["height"],
        districtName: json['present_address_district'] ?? '',
        heightIn: heightInValues.map[json["height_in"]],
        address: json["address"],
        presentAddressPincode: json["present_address_pincode"],
        hometownAddressPincode: json["hometown_address_pincode"],
        biodata: json["biodata"],
        relations: List<Relation>.from(
            json["relations"].map((x) => Relation.fromJson(x))),
        profilePics: List<ProfilePic>.from(
            json["profile_pics"].map((x) => ProfilePic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "gender": genderValues.reverse[gender],
        "age": age,
        "height": height,
        "present_address_district": districtName,
        "height_in": heightInValues.reverse[heightIn],
        "address": address,
        "present_address_pincode": presentAddressPincode,
        "hometown_address_pincode": hometownAddressPincode,
        "biodata": biodata,
        "relations": List<dynamic>.from(relations.map((x) => x.toJson())),
        "profile_pics": List<dynamic>.from(profilePics.map((x) => x.toJson())),
      };
}

enum Gender { MALE, FEMALE }

final genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

enum HeightIn { FEET }

final heightInValues = EnumValues({"feet": HeightIn.FEET});

class ProfilePic {
  ProfilePic({
    @required this.id,
    @required this.biodataId,
    @required this.image,
  });

  final int id;
  final int biodataId;
  final String image;

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
        id: json["id"],
        biodataId: json["biodata_id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "biodata_id": biodataId,
        "image": image,
      };
}

class Relation {
  Relation({
    @required this.id,
    @required this.biodataId,
    @required this.name,
    @required this.relation,
    @required this.address,
    @required this.addressPincode,
  });

  final int id;
  final int biodataId;
  final String name;
  final String relation;
  final String address;
  final String addressPincode;

  factory Relation.fromJson(Map<String, dynamic> json) => Relation(
        id: json["id"],
        biodataId: json["biodata_id"],
        name: json["name"],
        relation: json["relation"],
        address: json["address"],
        addressPincode: json["address_pincode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "biodata_id": biodataId,
        "name": name,
        "relation": relation,
        "address": address,
        "address_pincode": addressPincode,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
