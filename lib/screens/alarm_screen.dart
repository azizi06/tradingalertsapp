import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocksalertapp/models/alert_model.dart';
import 'package:stocksalertapp/services/firestore_service.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with SingleTickerProviderStateMixin {
  List<AlertModel> activeAlerts = [];
  List<AlertModel> alertHistory = [];
  AlertService alertService = AlertService();

  late TabController _tabController;
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getAlerts();
  }

  void _getAlerts() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      print('Retrieved uid Token: $uid');
      print("getting Alerts .. ");
      List<AlertModel> AllAlerts;
      AllAlerts = await alertService.fetchAlertsByToken(uid ?? "");
      for (AlertModel alert in AllAlerts) {
        if (alert.isNotified == true) {
          alertHistory.add(alert);
        } else {
          activeAlerts.add(alert);
        }
      }
      print(activeAlerts);
      setState(() {});
    }
  }

  // Récupérer le prix actuel via l'API
  Future<double?> getCoinPrice(String coin) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=$coin&vs_currencies=usd'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey(coin)) {
          return data[coin]['usd'];
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération du prix : $e");
    }
    return null;
  }

  // Ajouter une alerte
  void _addAlert(String coin, double targetPrice) {
    /* setState(() {
      activeAlerts.add({
        "coin": coin,
        "targetPrice": targetPrice,
        "createdAt": DateTime.now(),
      });
    }); */
  }

  // Supprimer une alerte active
  void _removeAlert(int index,String? alertID) {
    setState(() {
      //alertHistory.add(activeAlerts[index]);
      activeAlerts.removeAt(index);
      if(alertID != null){
      alertService.deleteAlert(alertID);

      }
    });
  }

  // Afficher le dialogue pour ajouter une alerte
  void _showAddAlertDialog(BuildContext context) {
    final TextEditingController coinController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    String? coinValidationMessage;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Créer une Alarme",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: coinController,
                      decoration: InputDecoration(
                        labelText: "Nom du Coin (ex: bitcoin)",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final coin =
                                coinController.text.trim().toLowerCase();
                            final price = await getCoinPrice(coin);
                            setState(() {
                              if (price != null) {
                                coinValidationMessage =
                                    "Prix actuel : $price USD";
                              } else {
                                coinValidationMessage =
                                    "Coin introuvable ou invalide.";
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    if (coinValidationMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          coinValidationMessage!,
                          style: TextStyle(
                            color:
                                coinValidationMessage!.contains("Prix actuel")
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: "Prix Cible (USD)",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final coin = coinController.text.trim().toLowerCase();
                        final price = double.tryParse(priceController.text);

                        // Validation sécurisée pour éviter les erreurs
                        if (coinValidationMessage == null ||
                            !(coinValidationMessage?.contains("Prix actuel") ??
                                false)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Veuillez vérifier le nom du coin et rechercher son prix."),
                            ),
                          );
                          return;
                        }

                        if (coin.isNotEmpty && price != null) {
                          _addAlert(coin, price);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Veuillez vérifier les informations saisies."),
                            ),
                          );
                        }
                      },
                      child: const Text("Créer une Alarme"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Alerts"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Actives"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Onglet des alertes actives
            activeAlerts.isEmpty
                ? const Center(child: Text("No active alarms."))
                : ListView.builder(
                    itemCount: activeAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = activeAlerts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                              Icons.alarm), //Text(alert.coinID.toUpperCase()),
                        ),
                        title: Text(
                            "${alert.coinID.toUpperCase()} - ${alert.value} USD"),
                        subtitle: Row(
                          children: [
                            Text(
                                "Added ${alert.createdAt.toString().split(' ')[0]} \n when : ${alert.type} "),
                               
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeAlert(index,alert.documentId),
                        ),
                      );
                    },
                  ),
            // Onglet historique des alertes
            alertHistory.isEmpty
                ? const Center(child: Text("No alarms in the history"))
                : ListView.builder(
                    itemCount: alertHistory.length,
                    itemBuilder: (context, index) {
                      final alert = alertHistory[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.alarm_off),
                        ),
                        title: Text(
                            "${alert.coinID.toUpperCase()} - ${alert.value} USD"),
                        subtitle: Text(
                            "Added ${alert.createdAt.toString().split(' ')[0]}"),
                      );
                    },
                  ),
          ],
        ),
        /* floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddAlertDialog(context),
          child: const Icon(Icons.add),
          tooltip: "Créer une Alarme",
        ), */
      ),
    );
  }
}
