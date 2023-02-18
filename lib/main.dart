import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Search',
      home: MovieSearch(),
    );
  }
}

class MovieSearch extends StatefulWidget {
  @override
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {
  final _controller = TextEditingController();
  String _searchText = '';
  Map<String, dynamic> _movieData = {};
  List<String> _searchHistory = [];

  Future<Map<String, dynamic>> _fetchMovieData(String title) async {
    final apiKey = 'ffbe8347';
    final url = 'https://www.omdbapi.com/?apikey=$apiKey&t=${Uri.encodeComponent(title)}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = response.body;
      if (body.isEmpty) {
        return <String, dynamic>{};
      }
      final decoded = json.decode(body);
      return decoded;
    } else {
      return <String, dynamic>{};
    }
  }

  void _searchMovie() async {
    final movieData = await _fetchMovieData(_searchText);
    if (movieData.isNotEmpty) {
      setState(() {
        _movieData = movieData;
        if (_searchHistory.length >= 5) {
          _searchHistory.removeAt(0);
        }
        _searchHistory.add(_searchText);
      });
    } else {
      setState(() {
        _movieData = {'Error': 'Movie not found.'};
      });
    }
  }

  void _showSearchHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search history'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final item = _searchHistory[index];
              return ListTile(
                title: Text(item),
                onTap: () {
                  _controller.text = item;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showSearchHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Place the name of the movie here.',
              ),
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchText.isNotEmpty ? _searchMovie : null,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            _movieData.isNotEmpty
                ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _movieData['Poster'] != 'N/A'
                            ? Image.network(_movieData['Poster'])
                            : Container(),
                        SizedBox(height: 16.0),
                        Text(
                          'Title: ${_movieData['Title']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Year: ${_movieData['Year']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rated: ${_movieData['Rated']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Released: ${_movieData['Released']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Runtime: ${_movieData['Runtime']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Genre: ${_movieData['Genre']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Director: ${_movieData['Director']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Writer: ${_movieData['Writer']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Actors: ${_movieData['Actors']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Plot: ${_movieData['Plot']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Language: ${_movieData['Language']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Country: ${_movieData['Country']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Awards: ${_movieData['Awards']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ]
                  )
                  )
                )
                : Container(
                    
                ),
          ],
        ),
      ),
    );
  }
}
