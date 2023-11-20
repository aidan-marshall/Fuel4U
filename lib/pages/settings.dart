import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuel_app/model/fuel_price.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _petrolTextController = TextEditingController();
  final TextEditingController _dieselTextController = TextEditingController();

  bool _notifyChanges = false;

  @override
  void initState() {
    super.initState();
    FuelPriceModel fuelPriceModel = Provider.of<FuelPriceModel>(context, listen: false);
    _petrolTextController.text = fuelPriceModel.currentPetrolPrice.toString();
    _dieselTextController.text = fuelPriceModel.currentDieselPrice.toString();

    _petrolTextController.addListener(() {
      FuelPriceModel model = Provider.of<FuelPriceModel>(context, listen: false);
      int newValue =
          int.tryParse(_petrolTextController.text) ?? model.currentPetrolPrice;
      model.updatePetrolPrice(newValue);
    });
    _dieselTextController.addListener(() {
      FuelPriceModel model = Provider.of<FuelPriceModel>(context, listen: false);
      int newValue =
          int.tryParse(_dieselTextController.text) ?? model.currentDieselPrice;
      model.updateDieselPrice(newValue);
    });
  }


  @override
  void dispose() {
    _petrolTextController.dispose();
    _dieselTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Settings'),
        ),
        body: Consumer<FuelPriceModel>(
          builder: (context, fuelPriceModel, child) {
            // _petrolTextController.text = fuelPriceModel.currentPetrolPrice.toString();
            // _dieselTextController.text = fuelPriceModel.currentDieselPrice.toString();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 16.0,
                ),
                _buildToggleRow(
                    context,
                    'Show Diesel Price',
                    fuelPriceModel.showDieselPrice,
                    fuelPriceModel.updateShowDieselPrice),
                _buildToggleRow(
                    context,
                    'Show Petrol Price',
                    fuelPriceModel.showPetrolPrice,
                    fuelPriceModel.updateShowPetrolPrice),
                _buildToggleRow(context, 'Notify Price Changes', _notifyChanges,
                    _updateNotifyChanges),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextField(
                    controller: _petrolTextController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Petrol', suffixText: "R/litre"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextField(
                    controller: _dieselTextController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Diesel', suffixText: "R/litre"),
                  ),
                )
              ],
            );
          },
        ));
  }

  _updateNotifyChanges(bool value) {
    setState(() {
      _notifyChanges = value;
    });
  }

  Widget _buildToggleRow(BuildContext context, String label, bool initialValue,
      void Function(bool value) updateFunction) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Switch(value: initialValue, onChanged: updateFunction)
          ],
        ));
  }
}
