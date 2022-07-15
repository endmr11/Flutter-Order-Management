import 'package:flutter/material.dart';

import 'order_management_view.dart';

class OrderManagement extends StatefulWidget {
  static const String routeName = '/order-management';
  const OrderManagement({Key? key}) : super(key: key);

  @override
  OrderManagementView createState() => OrderManagementView();
}
