import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wisata_candi/Helpers/database_helper.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // TODO 1. Deklarasi variabel yang diperlukan
  List<Candi> _filteredCandis = candiList;
  List<Candi> _allCandis = [];
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;

  Future<void> _loadCandiData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (kIsWeb) {
        setState(() {
          _allCandis = candiList;
          _filteredCandis = candiList;
          _isLoading = false;
        });
        return;
      }

      final candiListFromDb = await _dbHelper.getAllCandi();

      setState(() {
        _allCandis = candiListFromDb.isNotEmpty ? candiListFromDb : candiList;
        _filteredCandis = candiListFromDb.isNotEmpty
            ? candiListFromDb
            : candiList;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading data from database in search: $e');
      setState(() {
        _allCandis = candiList;
        _filteredCandis = candiList;
        _isLoading = false;
      });
    }
  }

  // TODO : Tambahkan initState untuk menambahkan listener
  @override
  void initState() {
    super.initState();
    _loadCandiData();
    _searchController.addListener(_filterCandis);
  }

  // TODO : Tambahkan dispose untuk membersihkan controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // TODO: Buat fungsi untuk memfilter list candi
  void _filterCandis() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase().trim();
      if (searchQuery.isEmpty) {
        _filteredCandis = _allCandis;
      } else {
        _filteredCandis = _allCandis.where((candi) {
          return candi.name.toLowerCase().contains(searchQuery) ||
              candi.location.toLowerCase().contains(searchQuery) ||
              candi.type.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO 2. Buat appBar untuk judul Pencarian Candi
      appBar: AppBar(title: Text("Pencarian Candi")),

      // TODO 3. Buat body yang berisikan Column
      body: Column(
        children: [
          // TODO 4. Buat TextField pencarian Candi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.cyan[100],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Cari Candi / Lokasinya / Agama',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // TODO 5. Buat ListView hasil pencarian Candi
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCandis.length,
              itemBuilder: (context, index) {
                final candi = _filteredCandis[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(placeholder: candi),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: candi.imageAsset,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                candi.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                candi.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(candi.location),
                              SizedBox(height: 4),
                              Text(candi.type),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
