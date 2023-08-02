import 'package:flutter/material.dart';
import 'package:bookartify/screens/cover_upload.dart';
import 'package:bookartify/screens/fanart_upload.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String selectedOption = 'art';

  final ButtonStyle customButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 48, 80, 72)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(42),
      ),
    ),
    minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xfffbf8f2),
        centerTitle: true,
        title: Text(
          "Upload options",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: Color(0xff2f2f2f),
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Choose your option",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
              child: Text(
                "Select to 'Upload Art' or to 'Upload Cover' to proceed",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xbe8a8989),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = 'art';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      width: 140,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: selectedOption == 'art'
                                ? const Color(0xFFBFA054)
                                : const Color.fromARGB(255, 47, 47, 1),
                            width: 4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.image,
                            color: selectedOption == 'art'
                                ? const Color(0xFFBFA054)
                                : const Color.fromARGB(255, 47, 47, 1),
                            size: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Text(
                              "Upload Art",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = 'book_cover';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      padding: const EdgeInsets.all(0),
                      width: 140,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8f2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: selectedOption == 'book_cover'
                                ? const Color(0xFFBFA054)
                                : const Color.fromARGB(255, 47, 47, 1),
                            width: 4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.book,
                            color: selectedOption == 'book_cover'
                                ? const Color(0xFFBFA054)
                                : const Color.fromARGB(255, 47, 47, 1),
                            size: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              "Upload Cover",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ElevatedButton(
                  onPressed: () {
                    if (selectedOption == 'art') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArtUploadPage()),
                      );
                    } else if (selectedOption == 'book_cover') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoverUploadPage()),
                      );
                    }
                  },
                  style: customButtonStyle,
                  child: Text(
                    "Select Option",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
