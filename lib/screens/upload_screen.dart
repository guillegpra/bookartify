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
    minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
  );

  double getFontSize(double screenWidth) {
    return screenWidth * 0.025;
  }

  double getIconSize(double screenWidth) {
    return screenWidth * 0.07;
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      // Prevent automatic focus
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 1279.0) {
            // Tablet Landscape Mode
            return _buildTabletLandscapeLayout();
          } else if (constraints.maxWidth > 600.0) {
            // Tablet Portrait Mode
            return _buildTabletPortraitLayout();
          } else {
            // Mobile Portrait Mode
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // Mobile Layout

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload options",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xff2f2f2f),
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Choose your option",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.dmSerifDisplay(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  )),
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Text(
                                "Upload Art",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Text(
                                "Upload Cover",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.dmSerifDisplay(
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
                              builder: (context) => const ArtUploadPage()),
                        );
                      } else if (selectedOption == 'book_cover') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoverUploadPage()),
                        );
                      }
                    },
                    style: customButtonStyle,
                    child: const Text(
                      "Select Option",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Portrait Tablet Layout
  Widget _buildTabletPortraitLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerWidth = screenWidth * 0.35;
    final containerHeight = screenHeight * 0.3;

    final fontSize = getFontSize(screenWidth);
    final iconSize = getIconSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload options",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xff2f2f2f),
            fontSize: fontSize * 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Choose your option",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize * 1.3,
                  color: Color(0xff000000),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
                child: Text(
                  "Select to 'Upload Art' or to 'Upload Cover' to proceed",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: fontSize / 1.2,
                    color: Color(0xbe8a8989),
                  ),
                ),
              ),
              Row(
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
                      width: containerWidth,
                      height: containerHeight,
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
                            size: iconSize * 1.2,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Text(
                              "Upload Art",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: fontSize * 1.2,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = 'book_cover';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      padding: const EdgeInsets.all(0),
                      width: containerWidth,
                      height: containerHeight,
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
                            size: iconSize * 1.2,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              "Upload Cover",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: fontSize * 1.2,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      if (selectedOption == 'art') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ArtUploadPage()),
                        );
                      } else if (selectedOption == 'book_cover') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoverUploadPage()),
                        );
                      }
                    },
                    style: customButtonStyle,
                    child: Text(
                      "Select Option",
                      style: TextStyle(
                        fontSize: fontSize / 1.2,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tablet Landscape Layout
  Widget _buildTabletLandscapeLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerWidth = screenWidth * 0.2;
    final containerHeight = screenHeight * 0.35;

    final fontSize = getFontSize(screenWidth);
    final iconSize = getIconSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload options",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xff2f2f2f),
            fontSize: fontSize / 1.4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Choose your option",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize / 1.2,
                  color: Color(0xff000000),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
                child: Text(
                  "Select to 'Upload Art' or to 'Upload Cover' to proceed",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: fontSize / 1.5,
                    color: Color(0xbe8a8989),
                  ),
                ),
              ),
              Row(
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
                      width: containerWidth,
                      height: containerHeight,
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
                            size: iconSize,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Text(
                              "Upload Art",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: fontSize / 1.3,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = 'book_cover';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      padding: const EdgeInsets.all(0),
                      width: containerWidth,
                      height: containerHeight,
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
                            size: iconSize,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              "Upload Cover",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: fontSize / 1.3,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      if (selectedOption == 'art') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ArtUploadPage()),
                        );
                      } else if (selectedOption == 'book_cover') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoverUploadPage()),
                        );
                      }
                    },
                    style: customButtonStyle,
                    child: Text(
                      "Select Option",
                      style: TextStyle(
                        fontSize: fontSize / 1.8,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
