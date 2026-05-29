import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:habit_track_app/local_notification.dart';

class NotificationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allHabits;
  const NotificationScreen({super.key, this.allHabits = const []});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> selectedHabits = [];
  String selectedTime = "";
  final List<String> times = ["Morning", "Afternoon", "Evening"];
  bool isOn = true;

  String formatTopic(String habitName) {
    // Lowercase, replace spaces with underscores, remove invalid chars
    return habitName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_-]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final habits = widget.allHabits;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Notifications'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          onPressed: () {
            Navigator.pop(context); // goes back to previous screen
          },
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enable Notifications",
                  style: TextStyle(fontSize: 20),
                ),

                Switch(
                  value: isOn,
                  onChanged: (bool newValue) async {
                    setState(() {
                      isOn = newValue;
                    });

                    if (!isOn) {
                      // Cancel all scheduled notifications when turned OFF
                      await LocalNotificationService.cancelAll();
                    }

                  },         // thumb color when ON
                  activeTrackColor: Colors.purple,    // track color when ON
                  inactiveThumbColor: Colors.white,   // thumb color when OFF
                  inactiveTrackColor: Colors.grey, 
                ),
              ],
            ),
          ),

          Divider(),
          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Habits for Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: SizedBox(
              height: 50, // ✅ give ListView a fixed height so it knows how much space to take
              child: ListView(
                scrollDirection: Axis.horizontal, // ✅ horizontal scrolling
                children: habits.map((habit) {
                  final habitName = habit['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12), // spacing between chips
                    child: ChoiceChip(
                      label: Text(habitName),
                      labelStyle: TextStyle(
                        color: selectedHabits.contains(habitName)
                            ? Colors.indigo
                            : Colors.purpleAccent.shade200,
                      ),
                      selected: selectedHabits.contains(habitName),
                      selectedColor: Colors.indigo[100],
                      onSelected: (bool selected) async {
                        setState(() {
                          if (selected) {
                            selectedHabits.add(habitName);
                          } else {
                            selectedHabits.remove(habitName);
                          }
                        });

                        
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: selectedHabits.contains(habitName)
                              ? Colors.indigo
                              : Colors.purpleAccent.shade200,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),


          SizedBox(height: 20,),
          
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Times for Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: [
                Wrap(
                  spacing: 12,
                  children: times.map((time) {
                    return ChoiceChip(
                      label: Text(time),
                      selected: selectedTime == time,
                      selectedColor: Colors.pink.shade100,
                      checkmarkColor: Colors.black,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selectedTime == time) {
                            // ✅ If already selected, unselect it
                            selectedTime = "";
                          } else {
                            // ✅ Otherwise, select it
                            selectedTime = time;
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: selectedTime == time ? Colors.transparent : Colors.grey, // darker border when not selected
                          width: 1.5, // thickness of border
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 100,),
          ElevatedButton(
            onPressed: () async {
              if (!isOn){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Notidication are disbaled")),
                );
                return;
              }
              if (selectedHabits.isEmpty || selectedTime.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select at least one habit and a time")),
                );
                return;
              }

              await LocalNotificationService.showNotification(
                title: "Habit Reminder",
                body: "Reminder: ${selectedHabits.first} at $selectedTime",
              );



            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 5.0,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Send Test Notification',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }
}