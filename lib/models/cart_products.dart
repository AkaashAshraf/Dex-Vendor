class CartProdcuts {
  dynamic id;
  dynamic ordersId;
  dynamic productsId;
  dynamic productName;
  dynamic productNameAr;
  dynamic price;
  dynamic quantity;
  dynamic total;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic parent;
  dynamic section;
  dynamic sectionAr;
  dynamic description;
  dynamic descriptionAr;

  CartProdcuts(
      {this.id,
      this.ordersId,
      this.productsId,
      this.productName,
      this.productNameAr,
      this.price,
      this.quantity,
      this.total,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.parent,
      this.section,
      this.sectionAr,
      this.description,
      this.descriptionAr});

  CartProdcuts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordersId = json['Orders_id'];
    productsId = json['Products_id'];
    productName =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['name'] : '';
    productNameAr =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['name_ar'] : '';
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    parent = json['ProdcutInfo'] != null ? json['ProdcutInfo']['parent'] : 0;
    section = json['ProdcutInfo'] != null ? json['ProdcutInfo']['section'] : '';
    sectionAr =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['section_ar'] : '';
    description =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['description'] : '';
    descriptionAr = json['ProdcutInfo'] != null
        ? json['ProdcutInfo']['description_ar']
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Orders_id'] = this.ordersId;
    data['Products_id'] = this.productsId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['parent'] = this.parent;
    data['section'] = this.section;
    data['section_ar'] = this.sectionAr;
    return data;
  }
}
