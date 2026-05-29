import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_track_app/Screens/detail_screen.dart';
import 'package:habit_track_app/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_track_app/Screens/notification_screen.dart';
import 'package:habit_track_app/Screens/profile_screen.dart';
import 'package:habit_track_app/Screens/report_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedHabits;
  const HomeScreen({Key? key, this.selectedHabits = const []}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> habits = [];
  List<Map<String, dynamic>> doneHabits = [];

  @override
  void initState() {
    super.initState();
    _loadHabitsFromFirestore();
    // ✅ Add selected habits from signup into habits list
    habits.addAll(widget.selectedHabits);
  }

  Future<void> _loadHabitsFromFirestore() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        habits = List<Map<String, dynamic>>.from(data['habits'] ?? []);
        doneHabits = List<Map<String, dynamic>>.from(data['doneHabits'] ?? []);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Text(data['username'] ?? "User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),);
          }
        ),
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                  'habits': habits,
                  'doneHabits': doneHabits,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Habits saved successfully!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to save habits: $e")),
                );
              }
            },
            icon: Icon(Icons.save, color: Colors.white, size: 27,)
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(habits: habits),),);
          if (result != null) {
            setState(() {
              habits = result; // ✅ update HomeScreen with returned habits
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue[700],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[700],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Reports'),
              onTap: () {
                final combinedHabits = [
                ...habits.map((h) => {...h, 'status': 'todo'}),
                ...doneHabits.map((h) => {...h, 'status': 'done'}),
              ];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(allHabits: combinedHabits),
                ),
              );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                final combinedHabits = [
                  ...habits.map((h) => {...h, 'status': 'todo'}),
                  ...doneHabits.map((h) => {...h, 'status': 'done'}),
                ];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(allHabits: combinedHabits),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(habits: habits),),);
                  if (result != null) {
                    setState(() {
                      habits = result; // ✅ update HomeScreen with returned habits
                    });
                  }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Inside your logout button handler
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          children: [
            Expanded(
              child: habits.isEmpty
              ? Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To Do',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.assignment,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: Center(
                      child: Text(
                        'Use the + button to add your habits!',
                        style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ],
              )
              
              : ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return Dismissible(
                      key: Key(habit['name']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction){
                        setState(() {
                          doneHabits.add(habits[index]);
                          habits.removeAt(index);
                        });
                      },
                      background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Swipe to Complete',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.check, color: Colors.white),
                            ],
                          ),
                        ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(habit['color']), // habit color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          habit['name'], // habit name
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                    );
                  },
                ),
            ),

            Divider(),

            Expanded(
              child: doneHabits.isEmpty
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                      'Done',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.celebration,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  
                  ),

                  SizedBox(height: 20,),

                  Text(
                      'Swipe right on an activity to mark it as done',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),

                  SizedBox(height: 40,),
                ],
              )
                : ListView.builder(
                  itemCount: doneHabits.length,
                  itemBuilder: (context, index) {
                    final habit = doneHabits[index];
                    return Dismissible(
                      key: Key(habit['name']),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          doneHabits.removeAt(index);
                          habits.add(habit); // ✅ move back to to-do list
                        });
                      },
                      background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Swipe to Undo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      child: Container(
                        width: 400,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(doneHabits[index]['color']), // habit color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              doneHabits[index]['name'], // habit name
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 25,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}