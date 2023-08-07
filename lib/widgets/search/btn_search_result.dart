import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/book_screen.dart';
import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResultBtn extends StatelessWidget {
  const SearchResultBtn({Key? key, required this.book}) : super(key: key);

  // Define a `Book` instance variable
  final Book book;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleButtonPress(context), // Pass `context` to `_handleButtonPress`
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 48, 80, 72)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text('View Art & Covers', style:GoogleFonts.poppins(fontSize: 14,), textAlign:TextAlign.center,),
    );
  }

  void _handleButtonPress(BuildContext context) {
    // Navigate to `BookScreen` on button press
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookScreen(book: book)), // Pass the `title` of the `Book` object to `BookScreen`
    );
  }
}
