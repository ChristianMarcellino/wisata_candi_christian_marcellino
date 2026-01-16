import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/Helpers/database_helper.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/screen/profile_screen.dart';
import 'package:wisata_candi/screen/sign_in_screen.dart';

class DetailScreen extends StatefulWidget {
  final Candi placeholder;

  const DetailScreen({super.key, required this.placeholder});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isSignedIn = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Candi currentCandi;

  @override
  void initState() {
    super.initState();
    currentCandi = widget.placeholder;
    _checkSignInStatus();
    _loadCandiData();
  }

  void _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;
    setState(() {
      isSignedIn = signedIn;
    });
  }

  Future<void> _loadCandiData() async {
    if (widget.placeholder.id != null) {
      final candi = await _dbHelper.getCandiById(widget.placeholder.id!);
      if (candi != null) {
        setState(() {
          currentCandi = candi;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentCandi.name)),
      body: SingleChildScrollView(
        child: (Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: currentCandi.imageAsset,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        currentCandi.imageAsset,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentCandi.name),
                      currentCandi.isFavorite
                          ? IconButton(
                              onPressed: () async {
                                if (currentCandi.id != null) {
                                  await _dbHelper.toggleFavorite(
                                    currentCandi.id!,
                                    currentCandi.isFavorite,
                                  );
                                  setState(() {
                                    currentCandi.isFavorite =
                                        !currentCandi.isFavorite;
                                  });
                                }
                              },
                              icon: Icon(Icons.favorite, color: Colors.red),
                            )
                          : IconButton(
                              onPressed: () async {
                                if (currentCandi.id != null) {
                                  await _dbHelper.toggleFavorite(
                                    currentCandi.id!,
                                    currentCandi.isFavorite,
                                  );
                                  setState(() {
                                    currentCandi.isFavorite =
                                        !currentCandi.isFavorite;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.red),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 78,
                        child: Text(
                          'Lokasi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(": ${currentCandi.location}"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.red),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 78,
                        child: Text(
                          'Dibangun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(": ${currentCandi.built}"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.house, color: Colors.red),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 78,
                        child: Text(
                          'Tipe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(": ${currentCandi.type}"),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.deepPurple.shade100),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    children: [
                      Text(currentCandi.description, style: TextStyle()),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.deepPurple.shade100),
                  Text(
                    "Galeri",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: currentCandi.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.deepPurple.shade100,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: currentCandi.imageUrls[index],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.deepPurple[50],
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tap untuk memperbesar",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.person),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
