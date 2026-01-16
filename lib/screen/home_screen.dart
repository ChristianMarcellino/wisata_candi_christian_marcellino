import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/helpers/database_helper.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/widget/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Candi> _candiList = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCandiData();
  }

  Future<void> _loadCandiData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (kIsWeb) {
        setState(() {
          _candiList = candiList;
          _isLoading = false;
        });
        return;
      }

      final candiListFromDb = await _dbHelper.getAllCandi();

      setState(() {
        _candiList = candiListFromDb.isNotEmpty ? candiListFromDb : candiList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data from database: $e');
      setState(() {
        _candiList = candiList;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO : 1 Buat appbar dengan judul Wisata Candi
      appBar: AppBar(title: Text("Wisata Candi")),
      // TODO : 2 Buat body dengan GridView.builder
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: EdgeInsets.all(8),
              itemCount: _candiList.length,
              itemBuilder: (context, index) {
                return ItemCard(candi: _candiList[index]);
                // TODO : 3 Buat ItemCard sebagai return value dari GridView.builder
              },
            ),
    );
  }
}
