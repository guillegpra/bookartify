import 'package:flutter/material.dart';
import 'package:bookartify/screens/cover_upload.dart';
import 'package:bookartify/screens/fanart_upload.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String selectedOption = 'art'; // initially selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true, // Change this line
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xfffbf8f2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Upload Options",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
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
            Padding(
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
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      width: 140,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: selectedOption == 'art'
                                ? Color(0xFFBFA054)
                                : Color.fromARGB(255, 47, 47, 1),
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
                                ? Color(0xFFBFA054)
                                : Color.fromARGB(255, 47, 47, 1),
                            size: 24,
                          ),
                          Padding(
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
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      padding: EdgeInsets.all(0),
                      width: 140,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xfffbf8f2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: selectedOption == 'book_cover'
                                ? Color(0xFFBFA054)
                                : Color.fromARGB(255, 47, 47, 1),
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
                                ? Color(0xFFBFA054)
                                : Color.fromARGB(255, 47, 47, 1),
                            size: 24,
                          ),
                          Padding(
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
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  if (selectedOption == 'art') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArtUploadPage()),
                    );
                  } else if (selectedOption == 'book_cover') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoverUploadPage()),
                    );
                  }
                },
                color: Color.fromARGB(255, 47, 47, 1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Option",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xFFE3D4B5),
                height: 50,
                minWidth: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
