import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/helpers/database_helper.dart';
import 'package:wisata_candi/widget/item_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Candi> _favoriteCandis = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCandis();
  }

  Future<void> _loadFavoriteCandis() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getBool('isSignedIn') ?? false;
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await _dbHelper.getFavoriteCandi();
      setState(() {
        _favoriteCandis = favorites;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading favorites: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Candi')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : isSignedIn
          ? _favoriteCandis.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada candi favorit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap icon ❤️ di detail candi untuk menambahkan favorit',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    padding: EdgeInsets.all(8.0),
                    itemCount: _favoriteCandis.length,
                    itemBuilder: (context, index) {
                      return ItemCard(candi: _favoriteCandis[index]);
                    },
                  )
          : Center(
              child: Text(
                'Silakan masuk untuk melihat candi favorit Anda.',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
