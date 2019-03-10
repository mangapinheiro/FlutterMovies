import 'package:flutter/material.dart';
import 'package:flutter_movies/src/data/movie_data.dart';
import 'package:flutter_movies/src/movie_list.dart';
import 'package:flutter_movies/src/movie_search.dart';
import 'package:flutter_movies/src/movie_search_bloc.dart';
import 'package:flutter_movies/src/provider/movies_provider.dart';
import 'package:flutter_movies/src/provider/search_provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class HomeTabContainer extends StatefulWidget {
  @override
  HomeTabContainerState createState() {
    return HomeTabContainerState();
  }
}

class HomeTabContainerState extends State<HomeTabContainer> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  int _currentIndex = 0;

  MovieList _page1;
  Widget _page2;
  List<Widget> _pages;
  Widget _currentPage;

  @override
  void initState() {
    _page1 = MovieList(
      mainColor: mainColor,
    );

    _page2 = SearchProvider(
      bloc: SearchMoviesBloc(kiwi.Container().resolve<MovieRepository>()),
      child: SearchListBody(),
    );

    _pages = [_page1, _page2];

    _currentPage = _page1;

    super.initState();
  }

  Widget build(BuildContext context) {
    final bloc = MoviesProvider.of(context).bloc;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Movies',
          style: TextStyle(color: mainColor, fontFamily: 'Arvo', fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[Icon(Icons.menu, color: mainColor)],
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('New Releases'),
            icon: Icon(Icons.new_releases),
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search),
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _currentPage = _pages[index];
          });
        },
      ),
    );
  }
}
