import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';

class FakeOrdersData {
  const FakeOrdersData._();

  static Future<List<OrderUiModel>> getOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    return [
      OrderUiModel(
        id: '#ZD-2048',
        createdAt: DateTime(2026, 3, 22),
        totalPrice: 285.0,
        status: OrderStatus.pending,
        items: const [
          OrderItemUiModel(id: '1', name: 'Fresh Tomatoes', quantity: 2, price: 30),
          OrderItemUiModel(id: '2', name: 'Milk', quantity: 1, price: 25),
          OrderItemUiModel(id: '3', name: 'Bread', quantity: 3, price: 15),
        ],
      ),
      OrderUiModel(
        id: '#ZD-2041',
        createdAt: DateTime(2026, 3, 21),
        totalPrice: 199.5,
        status: OrderStatus.processing,
        items: const [
          OrderItemUiModel(id: '4', name: 'Chicken Breast', quantity: 2, price: 75),
          OrderItemUiModel(id: '5', name: 'Rice', quantity: 1, price: 49.5),
        ],
      ),
      OrderUiModel(
        id: '#ZD-2032',
        createdAt: DateTime(2026, 3, 20),
        totalPrice: 340.75,
        status: OrderStatus.shipped,
        items: const [
          OrderItemUiModel(id: '6', name: 'Salmon', quantity: 2, price: 130),
          OrderItemUiModel(id: '7', name: 'Orange Juice', quantity: 3, price: 26.9),
        ],
      ),
      OrderUiModel(
        id: '#ZD-2018',
        createdAt: DateTime(2026, 3, 16),
        totalPrice: 420.0,
        status: OrderStatus.delivered,
        items: const [
          OrderItemUiModel(id: '8', name: 'Avocado', quantity: 5, price: 24),
          OrderItemUiModel(id: '9', name: 'Greek Yogurt', quantity: 4, price: 30),
        ],
      ),
      OrderUiModel(
        id: '#ZD-2009',
        createdAt: DateTime(2026, 3, 13),
        totalPrice: 112.0,
        status: OrderStatus.cancelled,
        items: const [
          OrderItemUiModel(id: '10', name: 'Eggs', quantity: 2, price: 18),
          OrderItemUiModel(id: '11', name: 'Cheese', quantity: 2, price: 38),
        ],
      ),
    ];
  }
}
