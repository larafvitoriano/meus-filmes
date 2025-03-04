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
      _showSnackBar('Filme removido com sucesso!');
      _refreshMovies();
    } else {
      _showSnackBar('Erro ao remover filme.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDeleteConfirmation(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Deseja realmente excluir o filme "${movie.title}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _deleteMovie(movie.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToMovieForm({Movie? movie}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MovieForm(movie: movie, dbHelper: widget.dbHelper),
      ),
    );
    _refreshMovies();
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
                return _buildMovieCard(snapshot.data![index]);
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
        onPressed: () => _navigateToMovieForm(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToMovieForm(movie: movie),
      onLongPress: () => _showDeleteConfirmation(context, movie),
      child: Card(
        color: Colors.grey[850],
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            _buildMoviePoster(movie.posterUrl),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: _buildMovieInfo(movie),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster(String? posterUrl) {
    return Container(
      width: 100.0,
      height: 150.0,
      child:
          posterUrl != null && posterUrl.isNotEmpty
              ? Image.network(
                posterUrl,
                width: 100.0,
                height: 150.0,
                fit: BoxFit.cover,
              )
              : Container(color: Colors.grey[700]),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return ListTile(
      title: Text(movie.title, style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoText('Diretor: ${movie.director}'),
          _buildInfoText('Ano: ${movie.year}'),
          _buildInfoText('Sinopse: ${movie.synopsis}'),
          RatingBarIndicator(
            rating: movie.rating,
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(text, style: TextStyle(color: Colors.white70));
  }
}
