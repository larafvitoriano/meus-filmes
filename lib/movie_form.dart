import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'movie.dart';

class MovieForm extends StatefulWidget {
  final Movie? movie;
  final DatabaseHelper dbHelper;

  MovieForm({this.movie, required this.dbHelper});

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _directorController;
  late TextEditingController _yearController;
  late TextEditingController _synopsisController;
  late TextEditingController _posterUrlController;
  double _rating = 0;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _useImageUrl = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _directorController = TextEditingController(
      text: widget.movie?.director ?? '',
    );
    _yearController = TextEditingController(
      text: widget.movie?.year?.toString() ?? '',
    );
    _synopsisController = TextEditingController(
      text: widget.movie?.synopsis ?? '',
    );
    _posterUrlController = TextEditingController(
      text: widget.movie?.posterUrl ?? '',
    );
    _rating = widget.movie?.rating ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    _synopsisController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _useImageUrl = false;
      });
    }
  }

  String? _validateField(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira $label';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Cadastrar Filme' : 'Editar Filme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextFormField(_titleController, 'Título'),
              _buildTextFormField(_synopsisController, 'Sinopse'),
              _buildTextFormField(_directorController, 'Direção'),
              _buildTextFormField(
                _yearController,
                'Ano',
                keyboardType: TextInputType.number,
              ),
              _buildImageSelection(),
              SizedBox(height: 30),
              _buildRatingBar(),
              SizedBox(height: 10),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) => _validateField(value, label),
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildImageSelection() {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: _useImageUrl,
              onChanged:
                  (value) => setState(() {
                    _useImageUrl = value;
                    _image = null;
                  }),
            ),
            SizedBox(width: 8.0),
            Text(_useImageUrl ? 'URL da Imagem' : 'Imagem da Galeria'),
          ],
        ),
        if (_useImageUrl)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: _posterUrlController,
              decoration: InputDecoration(labelText: 'URL do Cartaz'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          )
        else
          Column(
            children: [
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Selecionar Imagem'),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_image!, height: 100),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) => setState(() => _rating = rating),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final movie = Movie(
              id: widget.movie?.id,
              title: _titleController.text,
              director: _directorController.text,
              year: int.tryParse(_yearController.text) ?? 0,
              synopsis: _synopsisController.text,
              rating: _rating,
              posterUrl: _posterUrlController.text,
            );

            final result =
                widget.movie == null
                    ? await widget.dbHelper.insertMovie(movie)
                    : await widget.dbHelper.updateMovie(movie);

            if (result != -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${widget.movie == null ? 'Filme cadastrado' : 'Filme atualizado'} com sucesso!',
                  ),
                ),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erro ao ${widget.movie == null ? 'cadastrar' : 'atualizar'} filme.',
                  ),
                ),
              );
            }
          }
        },
        child: Text(widget.movie == null ? 'Cadastrar' : 'Salvar'),
      ),
    );
  }
}
