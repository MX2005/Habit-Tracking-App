import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allHabits;
  const ReportScreen({super.key, this.allHabits = const []});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final habits = widget.allHabits;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        centerTitle: true,
        title: const Text(
          'Weekly Report',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          scrollDirection: Axis.horizontal, // ✅ whole page scrolls sideways
          children:[ Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "Habit",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 100),

                  // Days row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Sun", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Mon", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Tue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Wed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Thu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Fri", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 50),
                      Text("Sat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10,),
              Container(width: 800, height: 1, color: Colors.grey,),
              SizedBox(height: 10,),

              for (final habit in habits) 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          habit['name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 110),

                        // Icons for each day
                        for (int i = 0; i < 7; i++) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                habit['status'] == 'done'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: habit['status'] == 'done'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 60),
                            ],
                          ),
                          
                        ],
                      ],
                    ),

                    // ✅ Divider after each habit row
                    const SizedBox(height: 10),
                    Container(width: 800, height: 1, color: Colors.grey),
                    const SizedBox(height: 10),
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
