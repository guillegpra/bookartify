import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../scan_feature.dart';

class SearchScanBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onScan;

  const SearchScanBar({
    Key? key,
    required this.onChanged,
    this.onScan,
  }) : super(key: key);

  @override
  _SearchScanBarState createState() => _SearchScanBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchScanBarState extends State<SearchScanBar> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(() {
      setState(() {}); // rebuilds the widget on every text change to update the cross icon visibility
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3D4B5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _controller,
          style: GoogleFonts.poppins(
            color: const Color(0xFF372213),
          ),
          decoration: InputDecoration(
            hintText: "Search by Title, Author or ISBN",
            prefixIcon: const Icon(Icons.search),
            // If there's text in the TextField, it shows a clear button, otherwise, shows a scan button
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged("");
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    color: const Color(0xFF372213),
                    onPressed: () async {
                      // This line changes
                      final barcode = await scanBarcode();
                      if (barcode == '-1') {
                        // The user did not return a thing
                        return;
                      } else if (widget.onScan != null) {
                        widget.onScan!(barcode);
                      }
                    },
                  ),
            border: InputBorder.none,
          ),
          onChanged: widget.onChanged,
          focusNode: _focusNode,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}


