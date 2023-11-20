import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuel_app/model/fuel_price.dart';
import 'package:fuel_app/pages/settings.dart';
import 'package:fuel_app/pages/login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<FuelPriceModel>(
      builder: (context, fuelPriceModel, child) {
        return !fuelPriceModel.loggedIn ?  MyLoginPage(title: widget.title): Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _openSettingsView(context, fuelPriceModel);
              },
            ),
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  fuelPriceModel.incrementDieselPrice();
                  fuelPriceModel.addPriceEvent("diesel", false);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 16.0,
                ),
                fuelPriceModel.showPetrolPrice
                ? Card(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Current Petrol Price:',
                            ),
                            Text(
                              'R${fuelPriceModel.currentPetrolPrice} per litre.',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ))) : Container(),
                const SizedBox(
                  height: 16.0,
                ),
                fuelPriceModel.showDieselPrice
                ? Card(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.orangeAccent,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Current Diesel Price:',
                            ),
                            Text(
                              'R${fuelPriceModel.currentDieselPrice} per litre.',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ))) : Container(),
                const SizedBox(
                  height: 32.0,
                ),
                Text(
                  'Fuel Price History',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Expanded(child: _buildPriceHistoryList(context, fuelPriceModel)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              fuelPriceModel.incrementPetrolPrice();
              fuelPriceModel.addPriceEvent("petrol", true);
            },
            tooltip: 'Increment Fuel Price',
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }

  Widget _buildPriceHistoryList(BuildContext context, FuelPriceModel fuelPriceModel) {
    return ListView.builder(
        itemCount: 20,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemBuilder: (listBuildContext, index) {
          if (index.isEven && !fuelPriceModel.showDieselPrice) {
            return Container();
          }
          if (!index.isEven && !fuelPriceModel.showPetrolPrice) {
            return Container();
          }
          String message = index.isEven
              ? 'Diesel price changed to ${fuelPriceModel.currentDieselPrice - (index / 2).ceil()}'
              : 'Petrol price changed to ${fuelPriceModel.currentPetrolPrice - (index / 2).floor()}';
          return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ));
        });
  }

  _openSettingsView(BuildContext context, FuelPriceModel fuelPriceModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
              value: fuelPriceModel,
              child: const SettingsView()),
          fullscreenDialog: true),
    );
  }
}
