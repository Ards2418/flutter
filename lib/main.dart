import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wristband/live_tracking_screen.dart';
import 'firebase_options.dart'; //firebase realtime database connection
import 'package:flutter_map/flutter_map.dart'; //for maps screen
import 'package:shared_preferences/shared_preferences.dart'; // Added for Shared Preferences
import 'package:audioplayers/audioplayers.dart';
import 'sensor_data_screen.dart';
//import 'package:latlong2/'; inaayos pa to wait lang
//import 'package:audioplayers/audioplayers.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'live_tracking_screen.dart'; wag pansinin

// Firebase connection details
const String firebaseHost = "riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app";
const String firebaseAuth = "fJ0y6TGCa730ewDi3ols8we5DWWGZjHMeeodcOQF";



/*buburahin
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // ✅ Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Response Wristband',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SensorDataScreen(),  // ✅ Set the SensorDataScreen as the home screen
    );
  }
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Request permission (Required for iOS notifications)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications');
  } else {
    print('User denied permission');
  }


  // Check if user data exists
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userType = prefs.getString('userType');
  String? relativeName = prefs.getString('relativeName');
  String? patientName = prefs.getString('patientName');
  String? contact = prefs.getString('contact');

  runApp(MyApp(userType: userType, relativeName: relativeName, patientName: patientName, contact: contact));
}

// Function to retrieve data from Firebase
/*Future<Map<String, dynamic>> retrieveData() async {
  DatabaseReference refHealth = FirebaseDatabase.instance.ref("health_data").limitToLast(1); // Reference to health data

  try {
    // Fetch health data
    DatabaseEvent eventHealth = await refHealth.once();
    DataSnapshot snapshotHealth = eventHealth.snapshot;

    Map<String, dynamic> healthData = {
      'heartRate': 0,
      'spo2': 0,
      'battery': 0,
      'location': "Location not available",
    };

    if (snapshotHealth.exists) {
      Map<dynamic, dynamic> data = snapshotHealth.value as Map<dynamic, dynamic>;
      var latestEntry = data.values.last; // Get the latest entry
      healthData['heartRate'] = latestEntry['heart_rate'] ?? healthData['heartRate']; // Update heart rate
      healthData['spo2'] = latestEntry['spo2'] ?? healthData['spo2']; // Update SpO2
      healthData['battery'] = latestEntry['battery'] ?? healthData['battery']; // Update battery
      healthData['location'] = latestEntry['location'] ?? healthData['location']; // Update location
    } else {
      print("No data found at the specified reference for health data.");
    }

    return healthData;

  } catch (error) {
    print("Error retrieving data: $error");
    return {
      'heartRate': 0,
      'spo2': 0,
      'battery': 0,
      'location': "Location not available",
    };
  }
}*/

// Function to set up a real-time listener for health data
void setupHealthDataListener(Function(Map<String, dynamic>) onDataReceived) {
  // pede add if need // Query refHealth = FirebaseDatabase.instance.ref("health_data").limitToLast(1); // Limit to last entry
  DatabaseReference refHealth = FirebaseDatabase.instance.ref("health_data");

  refHealth.onValue.listen((DatabaseEvent event) {
    final dataSnapshot = event.snapshot;
    if (dataSnapshot.exists) {
      Map<dynamic, dynamic> healthData = dataSnapshot.value as Map<dynamic, dynamic>;
      var latestEntry = healthData.values.last; // Get the latest entry
      onDataReceived({
        'heartRate': latestEntry['heart_rate'] ?? 0,
        'spo2': latestEntry['spo2'] ?? 0,
        'battery': latestEntry['battery'] ?? 0,
        'location': latestEntry['location'] ?? "Location not available",
        'timestamp': latestEntry['timestamp'] ?? "Timestamp not available", // Add timestamp
      });
    } else {
      print("No data found at the specified reference for health data.");
      onDataReceived({
        'heartRate': 0,
        'spo2': 0,
        'battery': 0,
        'location': "Location not available",
        'timestamp': "Timestamp not available", // Default value for timestamp
      });
    }
  });
}


class MyApp extends StatelessWidget {
  final String? userType;
  final String? relativeName;
  final String? patientName;
  final String? contact;

  MyApp({this.userType, this.relativeName, this.patientName, this.contact});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App Interface',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: (userType == 'relative' && relativeName != null && patientName != null && contact != null)
          ? RelativeMonitoringScreen(
        relativeName: relativeName!,
        patientName: patientName!,
        contact: contact!,
        heartRate: 0, // Placeholder, will be updated from Firebase
        spo2: 0, // Placeholder, will be updated from Firebase
        battery: 0, // Placeholder, will be updated from Firebase
      )
          : (userType == 'patient' && patientName != null && relativeName != null && contact != null)
          ? PatientMonitoringScreen(
        patientName: patientName!,
        relativeName: relativeName!,
        relativeContact: contact!,
        heartRate: 0, // Placeholder, will be updated from Firebase
        spo2: 0, // Placeholder, will be updated from Firebase
        battery: 0, // Placeholder, will be updated from Firebase
      )
          : HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCC33), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://scontent.fmnl9-6.fna.fbcdn.net/v/t1.15752-9/482682648_657925713292190_7421764742685231718_n.png?_nc_cat=103&ccb=1-7&_nc_sid=0024fc&_nc_eui2=AeEZjPtJ0ot5RJHDuqilZFOlSkqvNLhfT1BKSq80uF9PUGkFRCoWvrTadlyxPm4C3ozhxWnyTlDp_b14PMUoi8j0&_nc_ohc=QwM7PVUawgoQ7kNvgEQMxLk&_nc_oc=AdhZH5KJOLdKmlWDeZHofC3x98xYT1w2qeQinRoLS49wHE0cEIlpM3L0lqoRwAoJBT4&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.fmnl9-6.fna&oh=03_Q7cD1wG1f9ZyfIPtGvdZJUoBulylvWGFTLdagogWZmajIx05eg&oe=67F9D52A',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RelativeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("RELATIVE"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("PATIENT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Relative login screen
class RelativeScreen extends StatefulWidget {
  @override
  _RelativeScreenState createState() => _RelativeScreenState();
}

class _RelativeScreenState extends State<RelativeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  bool isSignedUp = false;
  String? nameError;
  String? patientNameError;
  String? contactError;

  void validateAndSave() {
    setState(() {
      nameError = nameController.text.isEmpty ? "Please fill up the text field" : null;
      patientNameError = patientNameController.text.isEmpty ? "Please fill up the text field" : null;
      contactError = contactController.text.isEmpty ? "Please fill up the text field" : null;
    });

    if (nameError != null || patientNameError != null || contactError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the text fields"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(patientNameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (contactController.text.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(contactController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Contact number must be 11 digits and contain only numbers"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    String capitalize(String s) => s.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    String relativeName = capitalize(nameController.text.trim());
    String patientName = capitalize(patientNameController.text.trim());

    setState(() {
      isSignedUp = true;
    });

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userType', 'relative');
      prefs.setString('relativeName', relativeName);
      prefs.setString('patientName', patientName);
      prefs.setString('contact', contactController.text);
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RelativeMonitoringScreen(
          relativeName: relativeName,
          patientName: patientName,
          contact: contactController.text,
          heartRate: 0,
          spo2: 0,
          battery: 0,
        ),
      ),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Relative Sign-Up")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCC33), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "RELATIVE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: nameError,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: patientNameController,
                  decoration: InputDecoration(
                    labelText: "Name of Patient: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: patientNameError,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    labelText: "Contact: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: contactError,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                Container(
                  color: const Color.fromARGB(79, 35, 33, 33),
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Reminder: \n     Please double-check your information before saving.",
                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Relative monitoring screen
class RelativeMonitoringScreen extends StatefulWidget {
  final String relativeName;
  final String patientName;
  final String contact;
  final int heartRate;
  final int spo2;
  final int battery;
  

  RelativeMonitoringScreen({
    required this.relativeName,
    required this.patientName,
    required this.contact,
    required this.heartRate,
    required this.spo2,
    required this.battery,
  });

  @override
  _RelativeMonitoringScreenState createState() => _RelativeMonitoringScreenState();
}

class _RelativeMonitoringScreenState extends State<RelativeMonitoringScreen> {
  late int heartRate;
  late int spo2;
  late int battery;
  late String location;
  late String timestamp; // Added for timestamp


  /*@override // dito muna baka magamit something
  void initState() {
    super.initState();
    _updateData();
  }

  // Function to update data from Firebase
  void _updateData() async {
    Map<String, dynamic> data = await retrieveData();
    setState(() {
      heartRate = data['heartRate'];
      spo2 = data['spo2'];
      battery = data['battery'];
      location = data['location'];
    });
  }*/

   @override
  void initState() {
    super.initState();
    setupHealthDataListener((data) {
      setState(() {
        heartRate = data['heartRate'];
        spo2 = data['spo2'];
        battery = data['battery'];
        location = data['location'];
        timestamp = data['timestamp']; // Update timestamp
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCC33), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Battery: $battery%", style: TextStyle(fontSize: 20)),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          heartRate > 0 ? "$heartRate ❤️" : "No Heart Rate Data",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          spo2 > 0 ? "$spo2% SpO2" : "No SpO2 Data",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                        "Timestamp: $timestamp", // Display timestamp
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotlineScreen()),
                    );
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.phone, color: Colors.white),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstAidScreen()),
                    );
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.medical_services, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showEmergencyAlert(context, heartRate, spo2, location);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Emergency Alert"),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.black, size: 30),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("RELATIVE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Name: ${widget.relativeName}"),
                    Text("Name of Patient: ${widget.patientName}"),
                    Text("Contact: ${widget.contact}"),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// First Aid Screen on relative
class FirstAidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Aid Guide")),
      body: SingleChildScrollView(
        child: Center(
          child: Image.network(
            'https://scontent.fmnl9-3.fna.fbcdn.net/v/t39.30808-6/487863124_122129889854796066_6702681718512492020_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeGTGw4jXci16llfET4ZWVbs6GNk7g2wzuDoY2TuDbDO4BxM9x8wAkcINfs0vzqFK7H_d7CH69GQgls55KV8Lmd6&_nc_ohc=crnKNIn7sZ0Q7kNvwGXoy5c&_nc_oc=AdlXCyV0_OFT0aRpkAnisrK8l0iP52OkG78eHXX8jdLLsGA_QCQ2KLB7D289hSlalUw&_nc_zt=23&_nc_ht=scontent.fmnl9-3.fna&_nc_gid=UqTVU-Iyp_Fzm8AmtUz4hQ&oh=00_AYFrk_Qfivsq1NsjL2bObVKW6d_fj0Bki8PFo2p_vsu_cw&oe=67F51015',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// Patient sign-up screen
class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController relativeNameController = TextEditingController();
  final TextEditingController relativeContactController = TextEditingController();

  bool isSignedUp = false;
  String? nameError;
  String? relativeNameError;
  String? relativeContactError;

  void validateAndSave() {
    setState(() {
      nameError = nameController.text.isEmpty ? "Please fill up the text field" : null;
      relativeNameError = relativeNameController.text.isEmpty ? "Please fill up the text field" : null;
      relativeContactError = relativeContactController.text.isEmpty ? "Please fill up the text field" : null;
    });

    if (nameError != null || relativeNameError != null || relativeContactError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the text fields"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(relativeNameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    if (relativeContactController.text.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(relativeContactController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Contact number must be 11 digits and contain only numbers"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    String capitalize(String s) => s.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    String patientName = capitalize(nameController.text.trim());
    String relativeName = capitalize(relativeNameController.text.trim());

    setState(() {
      isSignedUp = true;
    });

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userType', 'patient');
      prefs.setString('relativeName', relativeName);
      prefs.setString('patientName', patientName);
      prefs.setString('contact', relativeContactController.text);
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PatientMonitoringScreen(
          patientName: patientName,
          relativeName: relativeName,
          relativeContact: relativeContactController.text,
          heartRate: 0,
          spo2: 0,
          battery: 0,
        ),
      ),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Sign-Up")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCC33), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("PATIENT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: nameError,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: relativeNameController,
                  decoration: InputDecoration(
                    labelText: "Name of Relative: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: relativeNameError,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: relativeContactController,
                  decoration: InputDecoration(
                    labelText: "Contact of Relative: ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    errorText: relativeContactError,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                Container(
                  color: const Color.fromARGB(79, 35, 33, 33),
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Reminder: \n     Please double-check your information before saving.",
                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PatientMonitoringScreen extends StatefulWidget {
  final String patientName;
  final String relativeName;
  final String relativeContact;
  final int heartRate;
  final int spo2;
  final int battery;

  PatientMonitoringScreen({
    required this.patientName,
    required this.relativeName,
    required this.relativeContact,
    required this.heartRate,
    required this.spo2,
    required this.battery,
  });

  @override
  _PatientMonitoringScreenState createState() => _PatientMonitoringScreenState();
}

class _PatientMonitoringScreenState extends State<PatientMonitoringScreen> {
  late int heartRate;
  late int spo2;
  late int battery;
  late String location;
  late String timestamp; // Added for timestamp

 /* @override dito muna baka magamit something
  void initState() {
    super.initState();
    _updateData();
  }

  // Function to update data from Firebase
  void _updateData() async {
    Map<String, dynamic> data = await retrieveData();
    setState(() {
      heartRate = data['heartRate'];
      spo2 = data['spo2'];
      battery = data['battery'];
      location = data['location'];
    });
  }*/

   @override
  void initState() {
    super.initState();
    setupHealthDataListener((data) {
      setState(() {
        heartRate = data['heartRate'];
        spo2 = data['spo2'];
        battery = data['battery'];
        location = data['location'];
        timestamp = data['timestamp']; // Update timestamp
      });
    });
  }
/*
@override
void dispose() {
  _listener.cancel(); // Proper cleanup
  super.dispose();
}
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFCC33), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Battery: $battery%", style: TextStyle(fontSize: 20)),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          heartRate > 0 ? "$heartRate ❤️" : "No Heart Rate Data",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          spo2 > 0 ? "$spo2% SpO2" : "No SpO2 Data",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                        "Timestamp: $timestamp", // Display timestamp
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HotlineScreen()),
                      );
                    },
                    backgroundColor: Colors.black,
                    child: Icon(Icons.phone, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.black, size: 30),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PATIENT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Name: ${widget.patientName}"),
                          Text("Name of Relative: ${widget.relativeName}"),
                          Text("Contact of Relative: ${widget.relativeContact}"),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotlineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Hotlines")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          'https://scontent.fmnl9-6.fna.fbcdn.net/v/t39.30808-6/488220518_122129889008796066_1430077143398447372_n.jpg?stp=dst-jpg_p552x414_tt6&_nc_cat=107&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeGHZ9HX9QmDRreXiYvtXuEIjjOzTAigoCKOM7NMCKCgItxPV2ybNnb687i3kDTXTo6m-wLakGyM-84C3xcKc7QG&_nc_ohc=n5hars1quFUQ7kNvwH2x-CD&_nc_oc=AdlNzocgJMGAEukVvd2UNvL3L4okK2Mt9ONEhrpzdBhtDpKNgI95sB72tNOoxvCputo&_nc_zt=23&_nc_ht=scontent.fmnl9-6.fna&_nc_gid=G6IHr_1Rq7djLjOaDWDNAw&oh=00_AYGaok7-jXPLKMFKUlTQ2Z-J9RO2MKPGrssWti4CirpXJg&oe=67F51EB8',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

void playAudioFromUrl(AudioPlayer player) async {
  await player.play(AssetSource('alert_sound.mp3'));
}

void _showEmergencyAlert(BuildContext context, int heartRate, int spo2, String location) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final AudioPlayer player = AudioPlayer();
      // Start vibration pattern and play audio simultaneously
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
      playAudioFromUrl(player);
      
      return AlertDialog(
        content: Text(
          "Patient's heart rate has risen to $heartRate BPM and $spo2 oxygen level. Possible heart attack detected! Patient's location: $location",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Vibration.cancel();
              player.stop();
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}