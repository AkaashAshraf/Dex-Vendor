class Notifications {
  int id;
  int userId;
  String title;
  String body;
  String image;
  String createdAt;
  String updatedAt;

  Notifications(
      {this.id,
      this.userId,
      this.title,
      this.body,
      this.image,
      this.createdAt,
      this.updatedAt});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return new Notifications(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
