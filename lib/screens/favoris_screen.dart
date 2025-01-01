import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/models/coin_model.dart';

import 'package:stocksalertapp/screens/market_screen.dart';

import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<String> _coins = [
    "bitcoin",
    "ethereum",
    "ripple",
    "litecoin",
    "cardano",
    "polkadot",
    "binancecoin",
    "dogecoin",
    "solana",
    "pepecoin" // Ajout de PepeCoin
  ];

  List<CoinModel> _coinData = [];
  List<CoinModel> _filteredCoins = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _selectedSortOption = 'price_asc'; // Critère de tri par défaut

  // Fonction pour formater le prix (ex : $2.5K pour 2500)
  String _formatPrice(double price) {
    if (price < 1) {
      return "\$${price.toStringAsFixed(6)}";
    } else {
      return "\$${price.toStringAsFixed(2)}";
    }
  }

  Future<void> _fetchCoinPrices() async {
    setState(() {
      _isLoading = true;
      final coinBloC = context.read<CoinBlockProvider>();
      coinBloC.add(CoinListInitEvent());

      _isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    if (savedFavorites != null) {
      setState(() {
        _coins = savedFavorites;
      });
    }
    await _fetchCoinPrices();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _coins);
  }

  void _filterCoins(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCoins = List.from(_coinData);
      } else {
        _filteredCoins = _coinData
            .where(
                (coin) => coin.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _sortCoins(String criterion, CoinBlockProvider coinBloc) {
    setState(() {
      _selectedSortOption =
          criterion; // Mettre à jour l'option de tri sélectionnée
      if (criterion == 'price_asc') {
        //_filteredCoins.sort((a, b) => a['price'].compareTo(b['price']));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.priceAsc));
      } else if (criterion == 'price_desc') {
        // _filteredCoins.sort((a, b) => b['price'].compareTo(a['price']));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.priceDesc));
      } else if (criterion == 'change_24h_asc') {
        // _filteredCoins.sort((a, b) => a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.change24hAsc));
      } else if (criterion == 'change_24h_desc') {
        //_filteredCoins.sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.change24hDesc));
      } else if (criterion == 'name_asc') {
        //_filteredCoins.sort((a, b) => a['name'].compareTo(b['name']));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.nameAsc));
      } else if (criterion == 'name_desc') {
        //_filteredCoins.sort((a, b) => b['name'].compareTo(a['name']));
        coinBloc.add(CoinSortEvent(method: CoinSortingMethod.nameDesc));
      }
    });
  }

  Future<void> _addCoin(String coin) async {
    if (!_coins.contains(coin)) {
      // Vérifie si le coin existe dans l'API
      final response = await http.get(Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$coin"));
      if (response.statusCode == 200 && json.decode(response.body).isNotEmpty) {
        setState(() {
          _coins.add(coin);
        });
        await _saveFavorites();
        await _fetchCoinPrices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Le coin $coin n'existe pas ou est invalide.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$coin est déjà dans vos favoris.")),
      );
    }
  }

  void _confirmRemoveCoin(String coin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmer la suppression"),
          content:
              Text("Êtes-vous sûr de vouloir supprimer $coin de vos favoris ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _removeCoin(coin);
                Navigator.of(context).pop();
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  void _removeCoin(String coin) async {
    if (_coins.contains(coin)) {
      setState(() {
        _coins.remove(coin);
      });
      await _saveFavorites();
      await _fetchCoinPrices();
    }
  }

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _coins.removeAt(oldIndex);
      _coins.insert(newIndex, item);
    });
    await _saveFavorites();
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _searchController.addListener(() {
      _filterCoins(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinBloc = context.read<CoinBlockProvider>();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: AppBar(
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: const Text("Mes Coins Favoris"),
            //backgroundColor: Colors.blue[600],
            actions: [
              // Dropdown de tri
              DropdownButton<String>(
                value: _selectedSortOption,
                //  dropdownColor: Colors.blue[600],
                //  style: TextStyle(color: Colors.white),
                underline: Container(),
                icon: Icon(Icons.sort),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _sortCoins(newValue, coinBloc);
                  }
                },

                items: [
                  // Option de tri par prix croissant
                  DropdownMenuItem(
                    value: 'price_asc',
                    child: Text("Trier par Prix (Croissant)"),
                  ),
                  // Option de tri par prix décroissant
                  DropdownMenuItem(
                    value: 'price_desc',
                    child: Text("Trier par Prix (Décroissant)"),
                  ),
                  // Option de tri par variation 24h croissante
                  DropdownMenuItem(
                    value: 'change_24h_asc',
                    child: Text("Trier par Variation 24h (Croissant)"),
                  ),
                  // Option de tri par variation 24h décroissante
                  DropdownMenuItem(
                    value: 'change_24h_desc',
                    child: Text("Trier par Variation 24h (Décroissant)"),
                  ),
                  // Option de tri par nom croissant (A-Z)
                  DropdownMenuItem(
                    value: 'name_asc',
                    child: Text("Trier par Nom (A-Z)"),
                  ),
                  // Option de tri par nom décroissant (Z-A)
                  DropdownMenuItem(
                    value: 'name_desc',
                    child: Text("Trier par Nom (Z-A)"),
                  ),
                ],
              ),
              // Bouton de rafraîchissement pour actualiser les prix
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchCoinPrices,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Rechercher un coin...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    TabBar(tabs: [
                      Tab(
                        text: "All Coins",
                      ),
                      Tab(
                        text: "Favoris",
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //Center(child: Text("soon"),),
            MarketScreen(
              coins: _filteredCoins,
            ),

            Container(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : BlocConsumer<CoinBlockProvider, CoinState>(
                      listener: (context, state) {
                      setState(() {
                        _filteredCoins = state.coins;
                        _coinData = state.coins;
                      });
                    }, builder: (context, state) {
                      final _favFilteredCoins = _filteredCoins.where((coin) {
                        return _coins.contains(coin.id.toLowerCase());
                      }).toList();

                      return ReorderableListView(
                        onReorder: _onReorder,
                        children: _favFilteredCoins.map((coin) {
                          return ListTile(
                            key: Key(coin.id),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(coin.image),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(coin.name),
                            subtitle: Text(
                                "Prix: ${_formatPrice(coin.currentPrice)}\nVariation 24h: ${coin.priceChange24h.toStringAsFixed(2)}%"),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmRemoveCoin(coin.name);
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newCoin = await showDialog<String>(
              context: context,
              builder: (context) {
                final TextEditingController _newCoinController =
                    TextEditingController();
                return AlertDialog(
                  title: Text("Ajouter un nouveau coin"),
                  content: TextField(
                    controller: _newCoinController,
                    decoration:
                        InputDecoration(hintText: "Entrez le nom du coin"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(_newCoinController.text.toLowerCase());
                      },
                      child: Text("Ajouter"),
                    ),
                  ],
                );
              },
            );
            if (newCoin != null) {
              await _addCoin(newCoin);
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
