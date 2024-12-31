import 'package:flutter/material.dart';
<<<<<<< Updated upstream
// ignore: unused_import
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';
=======
import 'package:http/http.dart' as http;
import 'dart:convert';
>>>>>>> Stashed changes

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> activeAlerts = [];
  List<Map<String, dynamic>> alertHistory = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Récupérer le prix actuel via l'API
  Future<double?> getCoinPrice(String coin) async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=$coin&vs_currencies=usd'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey(coin)) {
        return data[coin]['usd'];
      }
    }
    return null; // Si le coin n'existe pas
  }

  // Ajouter une alerte
  void _addAlert(String coin, double targetPrice) {
    setState(() {
      activeAlerts.add({
        "coin": coin,
        "targetPrice": targetPrice,
        "createdAt": DateTime.now(),
      });
    });
  }

  // Supprimer une alerte active
  void _removeAlert(int index) {
    setState(() {
      alertHistory.add(activeAlerts[index]);
      activeAlerts.removeAt(index);
    });
  }

  // Afficher le dialogue pour ajouter une alerte
  void _showAddAlertDialog(BuildContext context) {
    final TextEditingController coinController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    String? coinValidationMessage;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Créer une Alarme",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: coinController,
                      decoration: InputDecoration(
                        labelText: "Nom du Coin (ex: bitcoin)",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            final coin = coinController.text.trim().toLowerCase();
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
                            color: coinValidationMessage!.contains("Prix actuel")
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Prix Cible (USD)",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final coin = coinController.text.trim().toLowerCase();
                        final price = double.tryParse(priceController.text);

                        // Validation sécurisée pour éviter les erreurs
                        if (coinValidationMessage == null ||
                            !(coinValidationMessage?.contains("Prix actuel") ??
                                false)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
                            SnackBar(
                              content: Text(
                                  "Veuillez vérifier les informations saisies."),
                            ),
                          );
                        }
                      },
                      child: Text("Créer une Alarme"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarmes"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Actives"),
            Tab(text: "Historique"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet des alertes actives
          activeAlerts.isEmpty
              ? Center(child: Text("Aucune alarme active."))
              : ListView.builder(
                  itemCount: activeAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = activeAlerts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(alert["coin"][0].toUpperCase()),
                      ),
                      title: Text(
                          "${alert['coin'].toUpperCase()} - ${alert['targetPrice']} USD"),
                      subtitle: Text(
                          "Ajoutée le ${alert['createdAt'].toString().split(' ')[0]}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeAlert(index),
                      ),
                    );
                  },
                ),
          // Onglet historique des alertes
          alertHistory.isEmpty
              ? Center(child: Text("Aucune alarme dans l'historique."))
              : ListView.builder(
                  itemCount: alertHistory.length,
                  itemBuilder: (context, index) {
                    final alert = alertHistory[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(alert["coin"][0].toUpperCase()),
                      ),
                      title: Text(
                          "${alert['coin'].toUpperCase()} - ${alert['targetPrice']} USD"),
                      subtitle: Text(
                          "Ajoutée le ${alert['createdAt'].toString().split(' ')[0]}"),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAlertDialog(context),
        child: Icon(Icons.add),
        tooltip: "Créer une Alarme",
      ),
    );
  }
}
