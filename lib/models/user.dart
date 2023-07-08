User user = User();

class User {
  int id;
  String image;
  String loginPhone;
  String firstName;
  String lastName;
  String password;
  double longtude;
  double latitude;
  dynamic credit;
  dynamic subscriptionDate;
  dynamic subscriptionPackage;
  String email;
  String customerType;
  String isOn;
  String isActive;
  String createdAt;
  String updatedAt;
  String city;
  String address;
  String rate;
  String count;
  String firebaseToken;
  String licenceImage;
  String carImage;
  dynamic smscode;
  dynamic smsExpireDate;
  dynamic isVerified;
//   String userCity;

  User(
      {this.id,
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
      this.isVerified});
  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      image: json['image'],
      loginPhone: json['login_phone'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      password: json['password'],
      longtude: json['longtude'],
      latitude: json['latitude'],
      credit: json['credit'],
      subscriptionDate: json['subscription_date'],
      subscriptionPackage: json['subscription_package'],
      email: json['email'],
      customerType: json['customer_type'],
      isOn: json['is_On'],
      isActive: json['is_Active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      city: json['city'],
      address: json['address'],
      rate: json['rate'],
      count: json['count'],
      firebaseToken: json['FirebaseToken'],
      licenceImage: json['licenceImage'],
      carImage: json['CarImage'],
      smscode: json['smscode'],
      smsExpireDate: json['smsExpireDate'],
      isVerified: json['isVerified'],
//      userCity    : json['UserCity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['login_phone'] = this.loginPhone;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['password'] = this.password;
    data['longtude'] = this.longtude;
    data['latitude'] = this.latitude;
    data['credit'] = this.credit;
    data['subscription_date'] = this.subscriptionDate;
    data['subscription_package'] = this.subscriptionPackage;
    data['email'] = this.email;
    data['customer_type'] = this.customerType;
    data['is_On'] = this.isOn;
    data['is_Active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city'] = this.city;
    data['address'] = this.address;
    data['rate'] = this.rate;
    data['count'] = this.count;
    data['FirebaseToken'] = this.firebaseToken;
    data['licenceImage'] = this.licenceImage;
    data['CarImage'] = this.carImage;
    data['smscode'] = this.smscode;
    data['smsExpireDate'] = this.smsExpireDate;
    data['isVerified'] = this.isVerified;
//    data['UserCity'] = this.userCity;
    return data;
  }
}
