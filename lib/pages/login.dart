import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/fuel_price.dart';
import '../main.dart';

class MyLoginPage extends StatelessWidget {
  final String title;

  const MyLoginPage({Key? key, required this.title}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Consumer<FuelPriceModel>(
      builder: (context, appState, child) =>
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("$title - Portal"),
              ),
            ),

            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left) of the column
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: Center(child: Icon(Icons.monetization_on_outlined, size: 75,)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      !appState.loggedIn ? context.push('/sign-in') : null;
                    },
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blue)),
                    icon: const Icon(Icons.person),
                    label: const Text("Login"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(
                    thickness: 1,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Fuel for you",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Empowering you to plan your life.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
    );
  }

}