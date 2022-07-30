import 'package:easy_localization/easy_localization.dart';

class Product {
  int id;
  String name;
  String nameAr;
  String categories;
  String image;
  dynamic price;
  String shop;
  String createdAt;
  String updatedAt;
  String description;
  String descriptionAr;
  dynamic stock;
  dynamic unit;
  dynamic unitAr;
  String weight;
  dynamic soldCount;
  dynamic rate;
  dynamic ratersCount;
  int parent;
  String tags;
  String section;
  String sectionAr;
  String isReq;

  Product(
      {this.id,
      this.name,
      this.nameAr,
      this.categories,
      this.image,
      this.price,
      this.shop,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.descriptionAr,
      this.stock,
      this.unit,
      this.unitAr,
      this.weight,
      this.soldCount,
      this.rate,
      this.ratersCount,
      this.parent,
      this.tags,
      this.section,
      this.sectionAr,
      this.isReq});

  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'].toString(),
      categories: json['categories'],
      image: json['image'] ?? '',
      price: json['price'],
      shop: json['shop'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['description'],
      descriptionAr: json['description_ar'].toString(),
      stock: json['stock'],
      weight: json['weight'],
      parent: json['parent'],
      unit: json['shop'] == null
          ? json['unit'] != null
              ? json['unit']
              : 'unkown'
          : json['ProdcutsUnit'].isNotEmpty
              ? json['ProdcutsUnit'][0]["name"]
              : 'unkown',
      unitAr: json['shop'] == null
          ? json['unit'] != null
              ? json['unit']
              : 'unkown'.tr()
          : json['ProdcutsUnit'].isNotEmpty
              ? json['ProdcutsUnit'][0]["name_ar"]
              : 'unkown'.tr(),
      soldCount: json['sold_count'],
      rate: json['rate'],
      ratersCount: json['raters_count'],
      tags: json['tags'],
      section: json['section'],
      sectionAr: json['section_ar'],
      isReq: json['isRequired'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['categories'] = this.categories;
    data['image'] = this.image;
    data['price'] = this.price;
    data['shop'] = this.shop;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['description_ar'] = this.descriptionAr;
    data['stock'] = this.stock;
    data['unit'] = this.unit;
    data['sold_count'] = this.soldCount;
    data['rate'] = this.rate;
    data['weight'] = this.weight;
    data['raters_count'] = this.ratersCount;
    data['parent'] = this.parent;
    data['tags'] = this.tags;
    return data;
  }
}
