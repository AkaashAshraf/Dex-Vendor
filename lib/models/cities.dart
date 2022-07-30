class City {
  dynamic id;
  var name;
  var nameAr;
  var createdAt;
  var updatedAt;
  dynamic longitude;
  dynamic latitude;

  City(
      {this.id,
      this.name,
      this.nameAr,
      this.createdAt,
      this.updatedAt,
      this.longitude,
      this.latitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return new City(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
