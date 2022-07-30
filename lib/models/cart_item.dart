import 'package:mplus_provider/models/product.dart';

class CartItem {
  int id;
  int quantity;
  double total;
  Product product;

  CartItem(this.id, this.product, this.quantity, this.total);
}
