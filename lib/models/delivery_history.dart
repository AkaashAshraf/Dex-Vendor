import 'driver_info.dart';
import 'order_info.dart';

class DeliveryHistory {
  var id;
  var address;
  var state;
  double deliveryPrice;
  dynamic stageStartedAt;
  dynamic startLatitude;
  dynamic startLongtude;
  dynamic endLatitude;
  dynamic endLongitude;
  var createdAt;
  var updatedAt;
  DriverInfo driverInfo;
  OrderInfo orderInfo;

  DeliveryHistory(
      {this.id,
      this.address,
      this.state,
      this.deliveryPrice,
      this.stageStartedAt,
      this.startLatitude,
      this.startLongtude,
      this.endLatitude,
      this.endLongitude,
      this.createdAt,
      this.updatedAt,
      this.driverInfo,
      this.orderInfo});

  DeliveryHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    state = json['state'];
    deliveryPrice = json['delivery_price'] * 1.0;
    stageStartedAt = json['stage_started_at'];
    startLatitude = json['start_latitude'];
    startLongtude = json['start_longtude'];
    endLatitude = json['end_latitude'];
    endLongitude = json['end_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driverInfo = json['DriverInfo'] != null
        ? new DriverInfo.fromJson(json['DriverInfo'])
        : null;
    orderInfo = json['OrderInfo'] != null
        ? new OrderInfo.fromJson(json['OrderInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['state'] = this.state;
    data['delivery_price'] = this.deliveryPrice;
    data['stage_started_at'] = this.stageStartedAt;
    data['start_latitude'] = this.startLatitude;
    data['start_longtude'] = this.startLongtude;
    data['end_latitude'] = this.endLatitude;
    data['end_longitude'] = this.endLongitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.driverInfo != null) {
      data['DriverInfo'] = this.driverInfo?.toJson();
    }
    if (this.orderInfo != null) {
      data['OrderInfo'] = this.orderInfo?.toJson();
    }
    return data;
  }
}
