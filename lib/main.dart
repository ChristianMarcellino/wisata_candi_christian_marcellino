import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/helpers/database_helper.dart';
import 'package:wisata_candi/screen/favorite_screen.dart';
import 'package:wisata_candi/screen/home_screen.dart';
import 'package:wisata_candi/screen/profile_screen.dart';
import 'package:wisata_candi/screen/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<void> _initializeDatabase() async {
    try {
      final dbHelper = DatabaseHelper();

      print('Checking database status...');

      // Check apakah database sudah memiliki data
      final isEmpty = await dbHelper.isDatabaseEmpty();

      if (isEmpty) {
        print('Database empty, migrating data...');

        // Migrasi data dari static list ke database
        await dbHelper.insertCandiList(candiList);

        print('Data candi berhasil dimigrasikan ke database');
      } else {
        print('Database sudah memiliki data');
      }
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  try {
    await _initializeDatabase();
  } catch (e) {
    print("Error Initializing Database $e");
  }

  runApp(
    MaterialApp(
      title: "Wisata Candi di Indonesia",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.deepPurple, opacity: 21),
          titleTextStyle: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ).copyWith(primary: Colors.deepPurple, surface: Colors.deepPurple[50]),
        useMaterial3: true,
      ),

      home: MainScreen(),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // TODO: 1. Deklarasi variabel
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2. Buat properti body berupa widget yang ditampilkan
      body: _children[_currentIndex],
      // TODO: 3. Buat properti BottomNavigationBar dengan nilai Theme
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple[50]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.deepPurple),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.deepPurple),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.deepPurple),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple[100],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
