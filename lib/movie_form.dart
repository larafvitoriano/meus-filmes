import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'database_helper.dart';
import 'movie.dart';

class MovieForm extends StatefulWidget {
  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _yearController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _posterUrlController = TextEditingController();
  double _rating = 0;
  String? _posterUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Filme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Adicionado
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _synopsisController,
                decoration: InputDecoration(labelText: 'Sinopse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sinopse';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Adicionado
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _directorController,
                decoration: InputDecoration(labelText: 'Direção'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a direção';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Adicionado
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Adicionado
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _posterUrlController,
                decoration: InputDecoration(labelText: 'URL do Cartaz'),
                autovalidateMode: AutovalidateMode.onUserInteraction, // Adicionado
              ),
              SizedBox(height: 30),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final movie = Movie(
                        title: _titleController.text,
                        director: _directorController.text,
                        year: int.parse(_yearController.text),
                        synopsis: _synopsisController.text,
                        rating: _rating,
                        posterUrl: _posterUrlController.text,
                      );
                      int result = await dbHelper.insertMovie(movie);
                      if (result != -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              'Filme cadastrado com sucesso!')),
                        );
                        Navigator.pop(context); // Volta para o CatalogPage
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao cadastrar filme.')),
                        );
                      }
                    }
                  },
                  child: Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}