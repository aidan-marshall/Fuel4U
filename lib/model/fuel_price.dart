import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


///Contains the relevant data for our views regarding fuel prices
class FuelPriceModel extends  ChangeNotifier {

  FuelPriceModel() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

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
      } else {
        _loggedIn = false;
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