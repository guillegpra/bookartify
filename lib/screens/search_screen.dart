// import 'dart:async';
// import 'package:rxdart/rxdart.dart';
// import 'package:bookartify/models/book_search.dart';
// import 'package:bookartify/services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/search_bar.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   Future<List<Book>>? _searchResult;
//   final _apiService = ApiService();
//   final PublishSubject<String> _searchSubject = PublishSubject<String>();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     _searchSubject.stream.listen((value) {
//       if (_debounce?.isActive ?? false) _debounce?.cancel();
//       _debounce = Timer(const Duration(milliseconds: 500), () {
//         setState(() {
//           if (value.isNotEmpty) {
//             _searchResult = _apiService.fetchBooks(value);
//           } else {
//             _searchResult =
//                 null; // resets the search result when the text field is empty
//           }
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchSubject.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SearchScanBar(
//         onChanged: (value) {
//           _searchSubject.add(value);
//         },
//       ),
//       body: _searchResult == null
//           ? Center(
//               child: Text('No search yet',
//                   style: GoogleFonts.poppins(fontSize: 18)))
//           : FutureBuilder<List<Book>>(
//               future: _searchResult,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text('An error occurred',
//                           style: GoogleFonts.poppins(fontSize: 18)));
//                 } else {
//                   final books = snapshot.data ?? [];
//                   if (books.isEmpty) {
//                     return Center(
//                         child: Text('No results found',
//                             style: GoogleFonts.poppins(fontSize: 18)));
//                   } else {
//                     return ListView.builder(
//                       itemCount: books.length,
//                       itemBuilder: (context, index) {
//                         final book = books[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 10),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(2.0),
//                                       child: book.thumbnailUrl.isNotEmpty
//                                           ? FadeInImage.assetNetwork(
//                                               placeholder:
//                                                   'images/search_placeholder_image.jpg',
//                                               image: book.thumbnailUrl,
//                                               width:
//                                                   90, // you can change width and height as you need
//                                               height: 120,
//                                               fit: BoxFit.cover,
//                                               imageErrorBuilder:
//                                                   (BuildContext context,
//                                                       Object exception,
//                                                       StackTrace? stackTrace) {
//                                                 return Image.asset(
//                                                     'images/search_placeholder_image.jpg',
//                                                     width: 90,
//                                                     height: 120,
//                                                     fit: BoxFit.cover);
//                                               },
//                                             )
//                                           : Image.asset(
//                                               'images/search_placeholder_image.jpg',
//                                               width: 90,
//                                               height: 120,
//                                               fit: BoxFit.cover),
//                                     ),
//                                     const SizedBox(width: 16.0),
//                                     Expanded(
//                                       child: Container(
//                                         margin: const EdgeInsets.only(left: 10),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               book.title,
//                                               style: GoogleFonts.poppins(
//                                                   fontSize: 17.0,
//                                                   color: const Color.fromARGB(
//                                                       255, 78, 54, 46)),
//                                             ),
//                                             Text(
//                                               book.author,
//                                               style: const TextStyle(
//                                                   fontSize: 14.0),
//                                             ),

//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(color: Colors.grey, thickness: 0.5),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 }
//               },
//             ),
//     );
//   }
// }

// Code with button
import 'dart:async';
import 'package:bookartify/widgets/search/btn_search_result.dart';
import 'package:bookartify/widgets/search/search_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Book>>? _searchResult;
  final _apiService = ApiService();
  final PublishSubject<String> _searchSubject = PublishSubject<String>();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchSubject.stream.listen((value) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          if (value.isNotEmpty) {
            _searchResult = _apiService.fetchBooks(value);
          } else {
            _searchResult =
                null; // resets the search result when the text field is empty
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _searchSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchScanBar(
        onChanged: (value) {
          _searchSubject.add(value);
        },
        onScan: (barcode) {
          // Handle the barcode here
          _searchSubject.add(barcode);
        },
      ),
      body: _searchResult == null
          ? Center(
              child: Text('No search yet',
                  style: GoogleFonts.poppins(fontSize: 18)))
          : FutureBuilder<List<Book>>(
              future: _searchResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('An error occurred',
                          style: GoogleFonts.poppins(fontSize: 18)));
                } else {
                  final books = snapshot.data ?? [];
                  if (books.isEmpty) {
                    return Center(
                        child: Text('No results found',
                            style: GoogleFonts.poppins(fontSize: 18)));
                  } else {
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: book.thumbnailUrl.isNotEmpty
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  'images/search_placeholder_image.jpg',
                                              image: book.thumbnailUrl,
                                              width:
                                                  90, // you can change width and height as you need
                                              height: 120,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                    'images/search_placeholder_image.jpg',
                                                    width: 90,
                                                    height: 120,
                                                    fit: BoxFit.cover);
                                              },
                                            )
                                          : Image.asset(
                                              'images/search_placeholder_image.jpg',
                                              width: 90,
                                              height: 120,
                                              fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book.title,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17.0,
                                                  color: const Color.fromARGB(
                                                      255, 78, 54, 46)),
                                            ),
                                            Text(
                                              book.author,
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: SearchResultBtn(
                                                    book: book)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey, thickness: 0.5),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
    );
  }
}
