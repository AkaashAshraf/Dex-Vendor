class Shop {
  dynamic id;
  dynamic name;
  dynamic nameAr;
  dynamic image;
  dynamic description;
  dynamic Phone;
  dynamic email;
  dynamic shopSerialNumber;
  dynamic licenseImage;
  dynamic licenseEndDate;
  dynamic website;
  dynamic address;
  dynamic is_On;
  dynamic rate;
  dynamic raters_count;
  dynamic sold_count;
  dynamic longitude;
  dynamic user_distances;
  dynamic Latitude;
  ShopCity shopCity;
  ShopReport shopReport;
  dynamic Dealer;
  dynamic ProductCount;
  dynamic orderCount;
  dynamic isRestaurant;
  dynamic isStore;
  dynamic credit;
  List<ShopsComments> shopsComments = [];
  double taxOne;
  String taxOneName;
  String taxOneNameAr;
  double taxTwo;
  String taxTwoName;
  String taxTwoNameAr;
  Shop(
      {this.name,
      this.nameAr,
      this.image,
      this.user_distances,
      this.description,
      this.Phone,
      this.email,
      this.website,
      this.isRestaurant,
      this.isStore,
      this.shopSerialNumber,
      this.address,
      this.is_On,
      this.rate,
      this.raters_count,
      this.sold_count,
      this.longitude,
      this.Latitude,
      this.shopCity,
      this.shopReport,
      this.Dealer,
      this.id,
      this.ProductCount,
      this.shopsComments,
      this.credit,
      this.orderCount,
      this.licenseImage,
      this.licenseEndDate,
      this.taxOne,
      this.taxOneName,
      this.taxOneNameAr,
      this.taxTwo,
      this.taxTwoName,
      this.taxTwoNameAr});
  factory Shop.fromJson(Map<String, dynamic> json) {
    dynamic city;
    dynamic myDist;
    List<ShopsComments> comments;

    if (json['ShopsComments'] != null) {
      comments = <ShopsComments>[];
      json['ShopsComments'].forEach((v) {
        comments.add(new ShopsComments.fromJson(v));
      });
    }
    if (json['ShopCity'] != null) {
      city = ShopCity.fromJson(json['ShopCity']);
    }

    return new Shop(
        user_distances: myDist,
        ProductCount: json['ProductCount'],
        name: json['name'],
        nameAr: json['name_ar'],
        isRestaurant: json['isRestaurant'],
        isStore: json['isStore'],
        image: json['image'],
        description: json['description'],
        Phone: json['Phone'],
        email: json['email'],
        website: json['website'],
        shopSerialNumber: json['shopSerialNumber'],
        address: json['address'],
        is_On: json['is_On'],
        rate: json['rate'],
        id: json['id'],
        raters_count: json['raters_count'],
        sold_count: json['sold_count'],
        longitude: json['longitude'],
        Latitude: json['Latitude'],
        shopCity: city,
        Dealer: json['Dealer'],
        credit: json['Credit'],
        orderCount: json['OrdersCount'],
        licenseImage: json['licenseImage'],
        licenseEndDate: json['licenseEndDate'],
        taxOne: json['TaxOne_value'] != null
            ? double.parse(json['TaxOne_value']) * 1.0
            : 0.0,
        taxOneName: json['TaxOne_name'].toString(),
        taxOneNameAr: json['TaxOne_name_ar'].toString(),
        taxTwo: json['TaxTwo_value'] != null
            ? double.parse(json['TaxTwo_value']) * 1.0
            : 0.0,
        taxTwoName: json['TaxTwo_name'].toString(),
        taxTwoNameAr: json['TaxTwo_name_ar'].toString(),
        shopsComments: comments);
  }
}

class ShopsComments {
  int id;
  int productId;
  int customerId;
  String comment;
  String createdAt;
  String updatedAt;
  int shopId;
  String username;
  String userimage;

  ShopsComments({
    this.id,
    this.productId,
    this.customerId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.shopId,
    this.username,
    this.userimage,
  });

  factory ShopsComments.fromJson(Map<String, dynamic> json) {
    return new ShopsComments(
      id: json['id'],
      productId: json['product_Id'] != null ? json['product_Id'] : 0,
      customerId: json['Customer_id'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      shopId: json['shop_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_Id'] = this.productId;
    data['Customer_id'] = this.customerId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['shop_id'] = this.shopId;
    data['UserInfo'] = this.username;
    data['UserInfo'] = this.username;
    return data;
  }
}

class ShopCity {
  int id;
  String name;

  ShopCity({this.id, this.name});

  factory ShopCity.fromJson(Map<String, dynamic> parsedJson) {
    return new ShopCity(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}

class ShopReport {
  ShopReport({
    this.state,
    this.data,
  });

  int state;
  Data data;

  factory ShopReport.fromJson(Map<String, dynamic> json) => ShopReport(
        state: json["State"],
        data: Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "State": state,
        "Data": data.toJson(),
      };
}

class Data {
  Data({
    this.totalCount,
    this.totalIncume,
  });

  int totalCount;
  int totalIncume;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["TotalCount"],
        totalIncume: json["TotalIncume"],
      );

  Map<String, dynamic> toJson() => {
        "TotalCount": totalCount,
        "TotalIncume": totalIncume,
      };
}
