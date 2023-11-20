import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PriceEventTag {
  PriceEventTag({required this.fuelType, required this.price, required this.date});

  final String fuelType;
  final int price;
  final String date;
}