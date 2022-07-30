// To parse this JSON data, do
//
//     final shopReport = shopReportFromJson(jsonString);

import 'dart:convert';

ShopReport shopReportFromJson(String str) =>
    ShopReport.fromJson(json.decode(str));

String shopReportToJson(ShopReport data) => json.encode(data.toJson());

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
    this.orders,
  });

  dynamic totalCount;
  dynamic totalIncume;
  List<Order> orders;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["TotalCount"],
        totalIncume: json["TotalIncume"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TotalCount": totalCount,
        "TotalIncume": totalIncume,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.id,
    this.totalValue,
    this.createdAt,
    this.updatedAt,
    this.state,
    this.note,
    this.city,
    this.time,
    this.cancellationReason,
    this.paymentMethod,
    this.myShopcartProdcuts,
    this.myShoptotalValue,
    this.customerInfo,
    this.shopInfo,
    this.cityInfo,
    this.cartProdcuts,
  });

  int id;
  double totalValue;
  DateTime createdAt;
  DateTime updatedAt;
  String state;
  dynamic note;
  int city;
  String time;
  dynamic cancellationReason;
  int paymentMethod;
  List<CartProdcut> myShopcartProdcuts = [];
  double myShoptotalValue;
  CustomerInfo customerInfo;
  ShopInfo shopInfo;
  dynamic cityInfo;
  List<CartProdcut> cartProdcuts = [];

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalValue:
            json["total_value"] != null ? json["total_value"].toDouble() : 0.0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        state: json["state"],
        note: json["note"],
        city: json["city"],
        time: json["time"],
        cancellationReason: json["cancellation_reason"],
        paymentMethod: json["paymentMethod"],
        myShopcartProdcuts: List<CartProdcut>.from(
            json["MyShopcartProdcuts"].map((x) => CartProdcut.fromJson(x))),
        myShoptotalValue: json["MyShoptotal_value"]?.toDouble() ?? 0.0,
        customerInfo: CustomerInfo.fromJson(json["CustomerInfo"]),
        shopInfo: ShopInfo.fromJson(json["ShopInfo"]),
        cityInfo: json["CityInfo"],
        cartProdcuts: List<CartProdcut>.from(
            json["cartProdcuts"].map((x) => CartProdcut.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_value": totalValue,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "state": state,
        "note": note,
        "city": city,
        "time": time,
        "cancellation_reason": cancellationReason,
        "paymentMethod": paymentMethod,
        "MyShopcartProdcuts":
            List<dynamic>.from(myShopcartProdcuts.map((x) => x.toJson())),
        "MyShoptotal_value": myShoptotalValue,
        "CustomerInfo": customerInfo?.toJson(),
        "ShopInfo": shopInfo?.toJson(),
        "CityInfo": cityInfo,
        "cartProdcuts": List<dynamic>.from(cartProdcuts.map((x) => x.toJson())),
      };
}

class CartProdcut {
  CartProdcut({
    this.id,
    this.ordersId,
    this.productsId,
    this.productName,
    this.price,
    this.quantity,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.shopname,
    this.productNote,
    this.prodcutsUnit,
  });

  int id;
  int ordersId;
  int productsId;
  String productName;
  double price;
  int quantity;
  double total;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String shopname;
  dynamic productNote;
  String prodcutsUnit;

  factory CartProdcut.fromJson(Map<String, dynamic> json) => CartProdcut(
        id: json["id"],
        ordersId: json["Orders_id"],
        productsId: json["Products_id"],
        productName: json["product_name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        total: json["total"].toDouble(),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        shopname: json["Shopname"],
        productNote: json["productNote"],
        prodcutsUnit: json["ProdcutsUnit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Orders_id": ordersId,
        "Products_id": productsId,
        "product_name": productName,
        "price": price,
        "quantity": quantity,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "Shopname": shopname,
        "productNote": productNote,
        "ProdcutsUnit": prodcutsUnit,
      };
}

class CustomerInfo {
  CustomerInfo({
    this.id,
    this.image,
    this.loginPhone,
    this.firstName,
    this.lastName,
    this.password,
    this.longtude,
    this.latitude,
    this.credit,
    this.subscriptionDate,
    this.subscriptionPackage,
    this.email,
    this.customerType,
    this.isOn,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.address,
    this.rate,
    this.count,
    this.firebaseToken,
    this.licenceImage,
    this.carImage,
    this.smscode,
    this.smsExpireDate,
    this.isVerified,
    this.medicalTestImg,
    this.insuranceImg,
    this.carOwnerAuthImg,
    this.frontPlateImg,
    this.backPlateImg,
    this.birthDay,
    this.idType,
    this.nationalIdImg,
    this.carLicenceImg,
    this.stcpay,
    this.ipan,
    this.deliveryCarType,
    this.userDistrictsId,
    this.userCity,
    this.userDistrict,
  });

  int id;
  String image;
  String loginPhone;
  String firstName;
  dynamic lastName;
  String password;
  double longtude;
  double latitude;
  dynamic credit;
  dynamic subscriptionDate;
  String subscriptionPackage;
  String email;
  String customerType;
  String isOn;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic city;
  dynamic address;
  dynamic rate;
  dynamic count;
  String firebaseToken;
  String licenceImage;
  dynamic carImage;
  String smscode;
  dynamic smsExpireDate;
  int isVerified;
  dynamic medicalTestImg;
  String insuranceImg;
  dynamic carOwnerAuthImg;
  String frontPlateImg;
  String backPlateImg;
  String birthDay;
  String idType;
  String nationalIdImg;
  String carLicenceImg;
  dynamic stcpay;
  String ipan;
  int deliveryCarType;
  String userDistrictsId;
  dynamic userCity;
  UserDistrict userDistrict;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        id: json["id"],
        image: json["image"],
        loginPhone: json["login_phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
        longtude: json["longtude"] != null ? json["longtude"].toDouble() : 0.0,
        latitude: json["longtude"] != null ? json["latitude"].toDouble() : 0.0,
        credit: json["credit"],
        subscriptionDate: json["subscription_date"],
        subscriptionPackage: json["subscription_package"],
        email: json["email"],
        customerType: json["customer_type"],
        isOn: json["is_On"],
        isActive: json["is_Active"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        city: json["city"],
        address: json["address"],
        rate: json["rate"],
        count: json["count"],
        firebaseToken: json["FirebaseToken"],
        licenceImage: json["licenceImage"],
        carImage: json["CarImage"],
        smscode: json["smscode"],
        smsExpireDate: json["smsExpireDate"],
        isVerified: json["isVerified"],
        medicalTestImg: json["medicalTestImg"],
        insuranceImg: json["insuranceImg"],
        carOwnerAuthImg: json["carOwnerAuthImg"],
        frontPlateImg: json["frontPlateImg"],
        backPlateImg: json["backPlateImg"],
        birthDay: json["birthDay"],
        idType: json["idType"],
        nationalIdImg: json["nationalIDImg"],
        carLicenceImg: json["carLicenceImg"],
        stcpay: json["stcpay"],
        ipan: json["ipan"],
        deliveryCarType: json["deliveryCarType"],
        userDistrictsId: json["userDistrictsID"],
        userCity: json["UserCity"],
        userDistrict: UserDistrict.fromJson(json["UserDistrict"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "login_phone": loginPhone,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "longtude": longtude,
        "latitude": latitude,
        "credit": credit,
        "subscription_date": subscriptionDate,
        "subscription_package": subscriptionPackage,
        "email": email,
        "customer_type": customerType,
        "is_On": isOn,
        "is_Active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "city": city,
        "address": address,
        "rate": rate,
        "count": count,
        "FirebaseToken": firebaseToken,
        "licenceImage": licenceImage,
        "CarImage": carImage,
        "smscode": smscode,
        "smsExpireDate": smsExpireDate,
        "isVerified": isVerified,
        "medicalTestImg": medicalTestImg,
        "insuranceImg": insuranceImg,
        "carOwnerAuthImg": carOwnerAuthImg,
        "frontPlateImg": frontPlateImg,
        "backPlateImg": backPlateImg,
        "birthDay": birthDay,
        "idType": idType,
        "nationalIDImg": nationalIdImg,
        "carLicenceImg": carLicenceImg,
        "stcpay": stcpay,
        "ipan": ipan,
        "deliveryCarType": deliveryCarType,
        "userDistrictsID": userDistrictsId,
        "UserCity": userCity,
        "UserDistrict": userDistrict?.toJson(),
      };
}

class UserDistrict {
  UserDistrict({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.longitude,
    this.latitude,
    this.cityId,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String longitude;
  String latitude;
  int cityId;

  factory UserDistrict.fromJson(Map<String, dynamic> json) => UserDistrict(
        id: json["id"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        name: json["name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        cityId: json["cityId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "cityId": cityId,
      };
}

class ShopInfo {
  ShopInfo({
    this.id,
    this.name,
    this.image,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.longitude,
    this.latitude,
    this.createdAt,
    this.updatedAt,
    this.isOn,
    this.rate,
    this.ratersCount,
    this.soldCount,
    this.userDistances,
    this.credit,
    this.shopSerialNumber,
    this.licenseImage,
    this.licenseEndDate,
    this.doorStartAt,
    this.doorCloseAt,
    this.shopCity,
    this.dealer,
    this.productCount,
    this.shopsComments,
    this.salesCount,
    this.taxOne,
    this.taxTwo,
    this.ordersCount,
  });

  int id;
  String name;
  String image;
  String description;
  String phone;
  String email;
  String website;
  String address;
  dynamic longitude;
  dynamic latitude;
  DateTime createdAt;
  DateTime updatedAt;
  int isOn;
  int rate;
  int ratersCount;
  int soldCount;
  dynamic userDistances;
  dynamic credit;
  String shopSerialNumber;
  dynamic licenseImage;
  String licenseEndDate;
  String doorStartAt;
  String doorCloseAt;
  ShopCity shopCity;
  CustomerInfo dealer;
  int productCount;
  List<dynamic> shopsComments = [];
  int salesCount;
  Tax taxOne;
  Tax taxTwo;
  int ordersCount;

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        phone: json["Phone"],
        email: json["email"],
        website: json["website"],
        address: json["address"],
        longitude: json["longitude"],
        latitude: json["Latitude"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        isOn: json["is_On"],
        rate: json["rate"],
        ratersCount: json["raters_count"],
        soldCount: json["sold_count"],
        userDistances: json["user_distances"],
        credit: json["Credit"],
        shopSerialNumber: json["shopSerialNumber"],
        licenseImage: json["licenseImage"],
        licenseEndDate: json["licenseEndDate"],
        doorStartAt: json["doorStartAt"],
        doorCloseAt: json["doorCloseAt"],
        shopCity: ShopCity.fromJson(json["ShopCity"]),
        dealer: CustomerInfo.fromJson(json["Dealer"]),
        productCount: json["ProductCount"],
        shopsComments: List<dynamic>.from(json["ShopsComments"].map((x) => x)),
        salesCount: json["SalesCount"],
        taxOne: Tax.fromJson(json["TaxOne"]),
        taxTwo: Tax.fromJson(json["TaxTwo"]),
        ordersCount: json["OrdersCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "Phone": phone,
        "email": email,
        "website": website,
        "address": address,
        "longitude": longitude,
        "Latitude": latitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_On": isOn,
        "rate": rate,
        "raters_count": ratersCount,
        "sold_count": soldCount,
        "user_distances": userDistances,
        "Credit": credit,
        "shopSerialNumber": shopSerialNumber,
        "licenseImage": licenseImage,
        "licenseEndDate": licenseEndDate,
        "doorStartAt": doorStartAt,
        "doorCloseAt": doorCloseAt,
        "ShopCity": shopCity?.toJson(),
        "Dealer": dealer?.toJson(),
        "ProductCount": productCount,
        "ShopsComments": List<dynamic>.from(shopsComments.map((x) => x)),
        "SalesCount": salesCount,
        "TaxOne": taxOne?.toJson(),
        "TaxTwo": taxTwo?.toJson(),
        "OrdersCount": ordersCount,
      };
}

class ShopCity {
  ShopCity({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.longitude,
    this.latitude,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  double longitude;
  double latitude;

  factory ShopCity.fromJson(Map<String, dynamic> json) => ShopCity(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        longitude: json["longitude"]?.toDouble() ?? 0.0,
        latitude: json["latitude"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "longitude": longitude,
        "latitude": latitude,
      };
}

class Tax {
  Tax({
    this.nameAr,
    this.nameEn,
    this.value,
  });

  String nameAr;
  String nameEn;
  double value;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        nameAr: json["name_ar"],
        nameEn: json["name_en"],
        value: json["value"] != null ? double.parse(json["value"]) * 1.0 : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "name_ar": nameAr,
        "name_en": nameEn,
        "value": value,
      };
}
