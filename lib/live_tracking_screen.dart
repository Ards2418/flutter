import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LiveTrackingScreen extends StatefulWidget {
  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final DatabaseReference databaseRef =
  FirebaseDatabase.instance.ref("testdata"); // Firebase path

  String status = "Loading...";
  String timestamp = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchLiveData();
  }

  void fetchLiveData() {
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        if (data is Map<Object?, Object?>) { // Ensure correct type
          setState(() {
            status = data["status"]?.toString() ?? "No status available";
            timestamp = data["timestamp"]?.toString() ?? "No timestamp available";
          });
        } else {
          print("Unexpected data format: $data");
        }
      }
    }, onError: (error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(status, style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 20),
            Text("Timestamp:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(timestamp, style: TextStyle(fontSize: 18, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}