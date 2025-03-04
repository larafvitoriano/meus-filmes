import 'package:flutter/material.dart';
import 'movie_form.dart';
import 'catalog_page.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Filmes',
      home: MyHomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[850]),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelStyle: TextStyle(color: Colors.white),
          floatingLabelStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
          focusColor: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    return Scaffold(
      appBar: AppBar(title: Text('Meus Filmes')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Cadastrar Filme'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieForm(dbHelper: dbHelper),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Lista de Filmes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogPage(dbHelper: dbHelper),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Image.asset('assets/icon.png', height: 50),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => MovieForm(dbHelper: dbHelper),
                  ),
                );
              },

              child: Text('Cadastrar Filme'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => CatalogPage(dbHelper: dbHelper),
                  ),
                );
              },

              child: Text('Lista de Filmes'),
            ),
          ],
        ),
      ),
    );
  }
}
