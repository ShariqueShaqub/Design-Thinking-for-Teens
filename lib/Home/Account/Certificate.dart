import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For Preview

class CertificateGenerator extends StatefulWidget {
  const CertificateGenerator({super.key});

  @override
  State<CertificateGenerator> createState() => _CertificateGeneratorState();
}

class _CertificateGeneratorState extends State<CertificateGenerator> {
  String? _certificatePath;
  String? _previewPath;
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        _userName = userDoc['firstName'] ?? 'User';
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> generateCertificate(
    String name,
    String course,
    String date,
  ) async {
    final pdf = pw.Document();

    // Load certificate template image
    final ByteData bytes = await rootBundle.load('assets/template.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Certificate Image
              pw.Positioned.fill(
                child: pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.cover),
              ),

              pw.Positioned(
                left: 0,
                right: 0,
                top: 280, // Adjust this value based on your template
                child: pw.Center(
                  child: pw.Text(
                    name,
                    style: pw.TextStyle(
                      fontSize: 35,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                left: 110,
                top: 500,
                child: pw.Text("$date", style: pw.TextStyle(fontSize: 16)),
              ),
            ],
          );
        },
      ),
    );

    // Save the preview certificate as a temporary file
    final tempDir = await getTemporaryDirectory();
    final previewFile = File("${tempDir.path}/certificate_preview.pdf");
    await previewFile.writeAsBytes(await pdf.save());

    setState(() {
      _previewPath = previewFile.path;
    });

    // Show preview dialog
    _showPreviewDialog();
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(""),
          content:
              _previewPath == null
                  ? CircularProgressIndicator()
                  : Container(
                    height: 400,
                    child: PDFView(
                      filePath: _previewPath!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageSnap: true,
                      fitPolicy: FitPolicy.BOTH,
                      onRender: (pages) {
                        print("PDF rendered with $pages pages");
                      },
                      onError: (error) {
                        print("Error loading PDF: $error");
                        Navigator.pop(
                          context,
                        ); // Close the dialog if error occurs
                        _showErrorDialog();
                      },
                    ),
                  ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveCertificate();
                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveCertificate() async {
    if (_previewPath == null) return;

    final output = await getApplicationDocumentsDirectory();
    final savedFile = File("${output.path}/certificate.pdf");
    await File(_previewPath!).copy(savedFile.path);

    setState(() {
      _certificatePath = savedFile.path;
    });

    print("Certificate saved at: ${savedFile.path}");
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to load preview. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Certificate Generator", style: TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: const Text(
                          "Click the below button \n to generate certificate",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
            SizedBox(
              height: 60,
              width: 265,
              child: ElevatedButton(
                onPressed: () {
                  if (_userName != null) {
                    generateCertificate(
                      _userName!,
                      "Design Thinking",
                      "March 26, 2025",
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff75DBCE),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Generate Certificate',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_certificatePath != null)
              Card(
                color: Colors.green[50],
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Certificate Generated!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Saved at: $_certificatePath",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_certificatePath != null) {
                            OpenFile.open(_certificatePath);
                          }
                        },
                        child: const Text("Open Certificate"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
