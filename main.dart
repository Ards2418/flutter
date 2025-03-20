import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart'; //firebase realtime database connection
//import 'package:audioplayers/audioplayers.dart';
//import 'package:shared_preferences/shared_preferences.dart';

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
  testDatabase();
  runApp(MyApp());
}
//used for testing. Buburahin to ha
void testDatabase() {
  DatabaseReference ref = FirebaseDatabase.instance.ref("testdata");

  ref.set({
    "status": "awlekfjal",
    "timestamp": DateTime.now().toString()
  }).then((_) {
    // Use a logging framework instead of print
    print("Data successfully written to Firebase!");
  }).catchError((error) {
    print("Error writing to Firebase: $error");
  });
}
// hanggang dito, thanks!
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App Interface',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
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


// relatvie login screen
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
      // Show Snackbar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the text fields"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if there are errors
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text.trim()) || nameController.text.trim().isEmpty) {
      // Show Snackbar if name contains special characters, numbers, or is only spaces
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if name is invalid
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(patientNameController.text.trim()) || patientNameController.text.trim().isEmpty) {
      // Show Snackbar if patient name contains special characters, numbers, or is only spaces
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if patient name is invalid
    }

    if (contactController.text.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(contactController.text)) {
      // Show Snackbar if contact is not 11 digits or contains non-numeric characters
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Contact number must be 11 digits and contain only numbers"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if contact number is invalid
    }

    // Capitalize the first letter of each word in the name and patient name
    String capitalize(String s) => s.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    String relativeName = capitalize(nameController.text.trim());
    String patientName = capitalize(patientNameController.text.trim());

    // Define the variables for heart rate, spo2, and battery
    int heartRate = 0; // Replace with actual value
    int spo2 = 0; // Replace with actual value
    int battery = 0; // Replace with actual value

    // If all fields are filled, proceed
    setState(() {
      isSignedUp = true;
    });

    // Navigate to the monitoring screen and prevent going back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RelativeMonitoringScreen(
          relativeName: relativeName,
          patientName: patientName,
          contact: contactController.text,
          heartRate: heartRate, // Retrieved value
          spo2: spo2, // Retrieved value
          battery: battery, // Retrieved value
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
                    errorText: nameError, // Shows error if field is empty
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
                    errorText: patientNameError, // Shows error if field is empty
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
                    errorText: contactError, // Shows error if field is empty
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

//relative monitoring screen
class RelativeMonitoringScreen extends StatelessWidget {
  final String relativeName;
  final String patientName;
  final String contact;
  final int heartRate;
  final int spo2;
  final int battery;
  final String location = " "; // Define the location variable

  RelativeMonitoringScreen({
    required this.relativeName,
    required this.patientName,
    required this.contact,
    required this.heartRate,
    required this.spo2,
    required this.battery,
  });

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
                    Text("Name: $relativeName"),
                    Text("Name of Patient: $patientName"),
                    Text("Contact: $contact"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class FirstAidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Aid Guide")),
      body: SingleChildScrollView(
        child: Center(
          child: Image.network(
            'https://scontent.fmnl17-1.fna.fbcdn.net/v/t1.15752-9/483121034_1843439886424615_5430622793697211745_n.png?stp=dst-png_p480x480&_nc_cat=100&ccb=1-7&_nc_sid=0024fc&_nc_eui2=AeEpoWYm91YO3hmrEfZ8MMnGPCe44MlGV588J7jgyUZXnxezzxu9IE7yBkTCBHHm4vWYjZL1atvpCw8YuO_xaGxj&_nc_ohc=_jXAMl4eITwQ7kNvgFrIRzq&_nc_oc=AdjRiURymWFirW9bv67EW_pP9P15k1u1_YcMfaHX61rPTNFLsr5iRO9kg7pnu46OS8c&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.fmnl17-1.fna&oh=03_Q7cD1wGVN5Fpp5uAZouTfqs5qSReW69DEpTuFBPq_qKMx_E_yw&oe=67FC6FDC',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

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
      // Show Snackbar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill up all the text fields"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if there are errors
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text.trim()) || nameController.text.trim().isEmpty) {
      // Show Snackbar if name contains special characters, numbers, or is only spaces
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if name is invalid
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(relativeNameController.text.trim()) || relativeNameController.text.trim().isEmpty) {
      // Show Snackbar if relative name contains special characters, numbers, or is only spaces
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please avoid special characters and numbers."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if relative name is invalid
    }

    if (relativeContactController.text.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(relativeContactController.text)) {
      // Show Snackbar if contact is not 11 digits or contains non-numeric characters
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Contact number must be 11 digits and contain only numbers"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return; // Stop execution if contact number is invalid
    }

    // Capitalize the first letter of each word in the name and relative name
    String capitalize(String s) => s.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    String patientName = capitalize(nameController.text.trim());
    String relativeName = capitalize(relativeNameController.text.trim());

    int heartRate = 0; // Replace with actual value
    int spo2 = 0; // Replace with actual value
    int battery = 0; 

    // If all fields are filled, proceed
    setState(() {
      isSignedUp = true;
    });

    // Navigate to the monitoring screen and prevent going back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PatientMonitoringScreen(
          relativeName: relativeName,
          patientName: patientName,
          relativeContact: relativeContactController.text,
          heartRate: 0, // Add appropriate value
          spo2: 0, // Add appropriate value
          battery: 0, // Add appropriate value
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
                Text(
                  "PATIENT",
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
                    errorText: nameError, // Shows error if field is empty
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
                    errorText: relativeNameError, // Shows error if field is empty
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
                    errorText: relativeContactError, // Shows error if field is empty
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

class PatientMonitoringScreen extends StatelessWidget {
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
                          "Current",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          heartRate != null && heartRate > 0 ? "$heartRate ❤️" : "No Heart Rate Data",
                          style: TextStyle(
                          color: Colors.red,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          spo2 != null && spo2 > 0 ? "$spo2% SpO2" : "No SpO2 Data",
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
                          Text("Name: $patientName"),
                          Text("Name of Relative: $relativeName"),
                          Text("Contact of Relative: $relativeContact"),
                        ],
                      ),
                    ],
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
  final List<String> hotlines = [
    "911",
    "112",
    "999",
    "123-456-7890" // Example number
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Hotlines")),
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
                  "SOS",
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Emergency Hotlines:",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Column(
                  children: hotlines.map((number) {
                    return Text(
                      number,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("emergency");

  int heartRate = 0;
  int spo2 = 0;
  String location = "0,0";
  int battery = 0;

  @override
  void initState() {
    super.initState();
    fetchEmergencyData();
  }

  void fetchEmergencyData() {
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          heartRate = data['heartRate'];
          spo2 = data['spo2'];
          location = data['location'];
          battery = data['battery'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Heart Rate: $heartRate bpm", style: TextStyle(fontSize: 20)),
            Text("SpO2: $spo2%", style: TextStyle(fontSize: 20)),
            Text("Location: $location", style: TextStyle(fontSize: 20)),
            Text("Battery: $battery%", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

void _showEmergencyAlert(BuildContext context, int heartRate, int spo2, String location) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
      return AlertDialog(
        title: Text("Emergency Alert!", style: TextStyle(color: Colors.red, fontSize: 24)),
        content: Text("Patient's heart rate has risen to $heartRate BPM and $spo2 oxygen level. Possible heart attack detected! Patient's location: $location", style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {
              Vibration.cancel();
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}