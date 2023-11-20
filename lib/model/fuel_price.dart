import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../price_event_tag.dart';


///Contains the relevant data for our views regarding fuel prices
class FuelPriceModel extends  ChangeNotifier {

  FuelPriceModel() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _priceEventSubscription;
  List<PriceEventTag> _priceEventTags = [];
  List<PriceEventTag> get priceEventTags => _priceEventTags;

  int _petrolPricePerLitre = 21;
  int _dieselPricePerLitre = 22;

  bool _showPetrolPrice = true;
  bool _showDieselPrice = true;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _priceEventSubscription = FirebaseFirestore.instance
            .collection('PriceEvent')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _priceEventTags = [];
          for (final document in snapshot.docs) {
            final timestamp = document.data()['timestamp'] as Timestamp;
            final dateTime = timestamp.toDate();
            final formattedDate = DateFormat('dd MMM HH:mm').format(dateTime);

            _priceEventTags.add(
              PriceEventTag(
                fuelType: document.data()['fuelType'] as String,
                price: document.data()['price'] as int,
                date: formattedDate,
            ));
          }

          notifyListeners();
        });
      } else {
        _loggedIn = false;
        // _priceEventTags = [PriceEventTag(fuelType: "lol", price: 1)];
        _priceEventTags = [];
        _priceEventSubscription?.cancel();

      }
      notifyListeners();
    });
  }


  Future<DocumentReference> addPriceEvent(String fuelType, bool isPetrol) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('PriceEvent')
        .add(<String, dynamic>{
      'fuelType': fuelType,
      'timestamp': DateTime.now(),
      'price': !isPetrol ? _dieselPricePerLitre : _petrolPricePerLitre,
    });
  }

  void incrementPetrolPrice() {
    _petrolPricePerLitre++;
    notifyListeners();
  }

  void incrementDieselPrice() {
    _dieselPricePerLitre++;
    notifyListeners();
  }

  void updatePetrolPrice(int newPrice){
    _petrolPricePerLitre = newPrice;
    notifyListeners();
  }

  void updateDieselPrice(int newPrice){
    _dieselPricePerLitre = newPrice;
    notifyListeners();
  }

  int get currentPetrolPrice => _petrolPricePerLitre;

  int get currentDieselPrice => _dieselPricePerLitre;

  void updateShowPetrolPrice(bool show) {
    _showPetrolPrice = show;
    notifyListeners();
  }

  bool get showPetrolPrice => _showPetrolPrice;

  void updateShowDieselPrice(bool show) {
    _showDieselPrice = show;
    notifyListeners();
  }

  bool get showDieselPrice => _showDieselPrice;

}