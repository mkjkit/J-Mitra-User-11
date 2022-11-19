// To parse this JSON data, do
//
//     final generalsurveyModel = generalsurveyModelFromJson(jsonString);

import 'dart:convert';

List<GeneralsurveyModel> generalsurveyModelFromJson(String str) =>
    List<GeneralsurveyModel>.from(
        json.decode(str).map((x) => GeneralsurveyModel.fromJson(x)));

String generalsurveyModelToJson(List<GeneralsurveyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeneralsurveyModel {
  GeneralsurveyModel(
      {this.id,
      this.survey,
      this.star,
      this.images,
      this.city,
      this.district,
      this.state,
      this.userId,
      this.userName,
      this.address});

  final int id;
  final String survey;
  final dynamic star;
  final List<Image> images;
  final int userId;
  final String userName;
  final String district;
  final String state;
  final String city;
  final String address;


  factory GeneralsurveyModel.fromJson(Map<String, dynamic> json) =>
      GeneralsurveyModel(
        id: json["id"],
        survey: json["survey"],
        star: json["star"],
        userId: json["user_id"],
        userName: json["user_name"],
        address: json["address"],
        district: json["district"],
        state: json["state"],
        city: json["city"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "survey": survey,
        "star": star,
        "user_id": userId,
        "user_name": userName,
        "address": address,
        "district": district,
        "state": state,
        "city": city,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Image {
  Image({
    this.id,
    this.surveyId,
    this.image,
  });

  final int id;
  final int surveyId;
  final String image;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        surveyId: json["survey_id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "survey_id": surveyId,
        "image": image,
      };
}
