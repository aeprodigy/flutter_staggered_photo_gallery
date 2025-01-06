// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picture_app/models/photo.dart';
import 'package:picture_app/screens/photo_details_page.dart';
import 'package:picture_app/services/api_Service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //controllers
  final ScrollController _scrollController = ScrollController();
  //variables
  List<Photo> _photos = [];
  int _currentPage = 1;
  bool _isLoading = false;

  //initial state function
  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePhotos();
      }
    });
  }

  //fetchPhotos method
  Future<void> _fetchPhotos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    //exception handling
    try {
      final newPhotos = await ApiService.fetchPhotos(page: _currentPage);

      setState(() {
        _photos.addAll(newPhotos);
        _currentPage++;
      });
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //fetch more photos
  void _loadMorePhotos() {
    _fetchPhotos();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text('Photo Gallery', style: TextStyle(
            color: Colors.orange[300],
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),),
        ),
      ),
      body: _photos.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: MasonryGridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                      itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoDetailsPage(photo: photo,),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Hero(
                              tag: photo.id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  photo.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                                      
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                          )),
                    );
                  }),
            ),
    );
  }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
