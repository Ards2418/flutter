/*import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  final Query _database = FirebaseDatabase.instance.ref('health_data').limitToLast(1); // Reference to health data in Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Sensor Data")),
      body: StreamBuilder(
        stream: _database.onValue,  // Listen for real-time data changes
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Center(child: CircularProgressIndicator()); // Show loading while data is being fetched
          }

          Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          // Get the latest entry from the database (could be timestamp-based sorting)
          var latestEntry = data.values.last;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Heart Rate: ${latestEntry['heart_rate']} BPM", style: TextStyle(fontSize: 20)),
                Text("SpO₂: ${latestEntry['spo2']} %", style: TextStyle(fontSize: 20)),
                Text("Timestamp: ${latestEntry['timestamp']}", style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}*/