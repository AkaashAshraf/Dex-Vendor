import 'package:mplus_provider/models/shops.dart';

import 'cart_products.dart';
import 'customer_info.dart';

class OrderInfo {
  int id;
  dynamic totalValue;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic state;
  dynamic note;
  CustomerInfo customerInfo;
  Shop shopInfo;
  double taxOne;
  double taxTwo;
  double delivery;
  String time;
  List<CartProdcuts> cartProdcuts = [];

  OrderInfo(
      {this.id,
      this.totalValue,
      this.createdAt,
      this.updatedAt,
      this.state,
      this.note,
      this.customerInfo,
      this.shopInfo,
      this.cartProdcuts,
      this.taxOne,
      this.taxTwo,
      this.delivery,
      this.time});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['orderId'];
    taxOne = json['ShopInfo']['TaxOne_value'] != null
        ? double.parse(json['ShopInfo']['TaxOne_value']) * 1.0
        : 0.0;
    taxTwo = json['ShopInfo']['TaxTwo_value'] != null
        ? double.parse(json['ShopInfo']['TaxTwo_value']) * 1.0
        : 0.0;
    totalValue = json['OrdersInfo']['total_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state = json['OrdersInfo']['state'];
    note = json['OrdersInfo']['note'];
    shopInfo =
        json['ShopInfo'] != null ? Shop.fromJson(json['ShopInfo']) : null;
    customerInfo = json['OrdersInfo']['CustomerInfo'] != null
        ? new CustomerInfo.fromJson(json['OrdersInfo']['CustomerInfo'])
        : null;
    delivery = json['OrdersInfo']['deliveryPrice'] * 1.0;
    if (json['OrdersInfo']['cartProdcuts'] != null) {
      cartProdcuts = [];
      json['OrdersInfo']['cartProdcuts'].forEach((v) {
        cartProdcuts.add(new CartProdcuts.fromJson(v));
      });
    }
    time = json['time'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_value'] = this.totalValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['state'] = this.state;
    data['note'] = this.note;
    if (this.customerInfo != null) {
      data['CustomerInfo'] = this.customerInfo?.toJson();
    }
    data['deliveryPrice'] = this.delivery;
    if (this.cartProdcuts != null) {
      data['cartProdcuts'] = this.cartProdcuts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
