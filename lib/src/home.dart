import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:previewPDF/src/pdfScreen.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  HttpClient client = new HttpClient();

  Future<File> preparePDF() async {
    final url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview PDF')),
      body: Center(
        child: RaisedButton(
          child: Text("Open PDF"),
          onPressed: () {
            preparePDF().then((p) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(p.path)),
              );
            });
          }
        ),
      ),
    );
  }
}