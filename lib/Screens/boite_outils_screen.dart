import 'dart:async';

import 'package:benkan_app/Services/PdfApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BoiteOutilsScreen extends StatefulWidget {
  const BoiteOutilsScreen({Key? key}) : super(key: key);

  @override
  State<BoiteOutilsScreen> createState() => _BoiteOutilsScreenState();
}

class _BoiteOutilsScreenState extends State<BoiteOutilsScreen> {
  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";
  String corrupted2PathPDF = "";
  @override
  void initState() {
    super.initState();
    fromAsset(
            'assets/icons/Bio_SeydouMCoulibaly.pdf', 'Bio_SeydouMCoulibaly.pdf')
        .then((f) {
      setState(() {
        corruptedPathPDF = f.path;
      });
    });
    fromAsset('assets/icons/Benkan_StatutsReglement.pdf',
            'Benkan_StatutsReglement.pdf')
        .then((f) {
      setState(() {
        corrupted2PathPDF = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/logoo.png",
          scale: 16,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Boite à outils",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildCard(
              name: "Bio Seydou M. Coulibaly", pathFile: corrupted2PathPDF),
          _buildCard2(
              name: "Benkan Statuts & Reglement",
              pathFile: "assets/icons/Benkan_StatutsReglement.pdf"),
        ],
      ),
    );
  }

  GestureDetector _buildCard({name, pathFile}) {
    return GestureDetector(
      onTap: () async {
        // PDFView(filePath: "");

        Get.to(PDFScreen(
          path: corruptedPathPDF,
        ));
        /*  String path = "${pathFile}";
        final file = await PdfApi.loadAsset(path);
 */

        //  Get.to(HomePage());
      },
      child: Container(
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: new LinearGradient(
                stops: [0.01, 0.01], colors: [Color(0xFFe95022), Colors.white]),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildCard2({name, pathFile}) {
    return GestureDetector(
      onTap: () async {
        // PDFView(filePath: "");

        Get.to(PDFScreen(
          path: corrupted2PathPDF,
        ));
        /*  String path = "${pathFile}";
        final file = await PdfApi.loadAsset(path);
 */

        //  Get.to(HomePage());
      },
      child: Container(
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: new LinearGradient(
                stops: [0.01, 0.01], colors: [Color(0xFFe95022), Colors.white]),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Represents Homepage for Navigation
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
    );
  }
}
