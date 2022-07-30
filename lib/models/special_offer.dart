class SpecialOffer {
  int id;
  String image;
  int shopId;
  String description;
  String title;
  String createdAt;
  String updatedAt;

  SpecialOffer(
      {this.id,
      this.image,
      this.shopId,
      this.description,
      this.title,
      this.createdAt,
      this.updatedAt});

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return new SpecialOffer(
      id: json['id'],
      image: json['image'],
      shopId: json['shop_id'],
      description: json['description'],
      title: json['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
