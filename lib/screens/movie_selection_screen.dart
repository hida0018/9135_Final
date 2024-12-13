import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import '../utils/constants.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final List<Map<String, dynamic>> _movieCollection = [];
  int _activeMovieIndex = 0;
  int _pageNumber = 1;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData && _movieCollection.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_movieCollection.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Selection'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: Text('No movies available!'),
        ),
      );
    }

    final currentMovie = _movieCollection[_activeMovieIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Movies'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Dismissible(
          key: Key(currentMovie['id'].toString()),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            final isLiked = direction == DismissDirection.startToEnd;
            _submitVote(isLiked);
          },
          background: _buildSwipeIndicator(
              color: Colors.green,
              icon: Icons.thumb_up,
              alignment: Alignment.centerLeft),
          secondaryBackground: _buildSwipeIndicator(
              color: Colors.red,
              icon: Icons.thumb_down,
              alignment: Alignment.centerRight),
          child: _generateMovieCard(currentMovie),
        ),
      ),
    );
  }

  Future<void> _fetchMovieData() async {
    try {
      final movies = await HttpHelper.fetchMovies(_pageNumber);
      setState(() {
        _movieCollection.addAll(movies);
        _isLoadingData = false;
        _pageNumber++;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load movies.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _submitVote(bool isLiked) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sessionId = appState.sessionId!;
    final movie = _movieCollection[_activeMovieIndex];
    final movieId = movie['id'];

    try {
      final response = await HttpHelper.voteMovie(sessionId, movieId, isLiked);

      if (response.containsKey('data') && response['data']['match'] == true) {
        _displayMatchDialog(movie);
      }

      setState(() {
        _activeMovieIndex++;
      });

      if (_activeMovieIndex >= _movieCollection.length - 1) {
        await _fetchMovieData();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting your vote.'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
    }
  }

  void _displayMatchDialog(Map<String, dynamic> movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('It\'s a Match!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(movie['title'] ?? 'No Title Available'),
            const SizedBox(height: 10),
            Image.network(
              '${HttpHelper.tmdbImageBaseUrl}${movie['poster_path']}',
              height: 150,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeIndicator(
      {required Color color,
      required IconData icon,
      required Alignment alignment}) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }

  Widget _generateMovieCard(Map<String, dynamic> movie) {
    return Card(
      margin: const EdgeInsets.all(Spacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (movie['poster_path'] != null)
            Image.network(
              '${HttpHelper.tmdbImageBaseUrl}${movie['poster_path']}',
              height: 400,
            )
          else
            const SizedBox(
              height: 400,
              child: Center(child: Text('Image Not Available')),
            ),
          Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Release Date: ${movie['release_date'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Rating: ${movie['vote_average'] ?? 'N/A'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
