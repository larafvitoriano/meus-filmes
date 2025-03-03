import 'movie.dart';
import 'package:flutter/material.dart';
import 'movie_form.dart';
import 'database_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CatalogPage extends StatefulWidget {
  final DatabaseHelper dbHelper;

  CatalogPage({required this.dbHelper});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  void _refreshMovies() {
    setState(() {
      movies = widget.dbHelper.getMovies();
    });
  }

  void _deleteMovie(int id) async {
    int result = await widget.dbHelper.deleteMovie(id);
    if (result != -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Filme removido com sucesso!')));
      _refreshMovies();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover filme.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Filmes')),
      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MovieForm(
                              movie: movie,
                              dbHelper: widget.dbHelper,
                            ),
                      ),
                    );
                    _refreshMovies();
                  },
                  onLongPress: () {
                    _deleteMovie(movie.id!);
                  },

                  child: Card(
                    color: Colors.grey[850],
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          height: 150.0,
                          child:
                              movie.posterUrl != null &&
                                      movie.posterUrl!.isNotEmpty
                                  ? Image.network(
                                    movie.posterUrl!,
                                    width: 100.0,
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(color: Colors.grey[700]),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                movie.title,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diretor: ${movie.director}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    'Ano: ${movie.year}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    'Sinopse: ${movie.synopsis}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  RatingBarIndicator(
                                    rating: movie.rating,
                                    itemBuilder:
                                        (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar filmes'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieForm(dbHelper: widget.dbHelper),
            ),
          );
          _refreshMovies();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
