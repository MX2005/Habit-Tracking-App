
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> habits;

  const DetailScreen({super.key, required this.habits});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };
  Color selectedColor = Colors.amber; // Default color
  String selectedColorName = 'Amber'; // Default color name
  String habitName = '';

  
  late List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    habits = List.from(widget.habits); // ✅ copy from Home
  }
  
  void _addHabit(Color color, String name) {
    setState(() {
      habits.add({'name': name,'color': color.value,});
    });   
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Configure Habits'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          onPressed: () {
            Navigator.pop(context, habits); // ✅ goes back to previous screen
          },
        ),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 10,),
            
            TextField(
              onChanged: (value) {
                habitName = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your habit',
                contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
        
            SizedBox(height: 20,),
        
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Color : ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
            SizedBox(height: 20,),

            Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black38, width: 2),
                    ),
                    child: DropdownButton<String>(
                      menuWidth: 400,
                      menuMaxHeight: 200,
                      borderRadius: BorderRadius.circular(5),
                      hint: Text("Select Color"),
                      value: selectedColorName,
                      icon: Icon(Icons.arrow_drop_down),
                      underline: SizedBox(), // removes default underline
                      items: _habitColors.keys.map((String colorName) {
                        return DropdownMenuItem<String>(
                          value: colorName,
                          child: Container(
                            height: 40,
                            width: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _habitColors[colorName],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              colorName,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedColorName = value!;
                          selectedColor = _habitColors[value]!;
                        });
                      },
                    ),
                  ),

            SizedBox(height: 20,),

            Align(
              alignment: Alignment.centerLeft, // positions it at center left
              child: ElevatedButton(
                onPressed: () {
                  // Build a habit map with name + color
                  Map<String, dynamic> habit = {
                    'name': habitName,
                    'color': selectedColor,
                  };
                  _addHabit(selectedColor, habitName);
                },
                child: Text(
                  'Add Habit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 25),
                  backgroundColor: Colors.blue[600],
                  elevation: 3.0,
                ),
              ),
            ),

            SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return Row(

                    children: [
                      Icon(Icons.circle,
                          color: Color(habit['color']), size: 45),
                      SizedBox(width: 5),
                      Text(
                        habit['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red[600], size: 27),
                        onPressed: () {
                          setState(() {
                            habits.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

          ],
        ),
      )
    );
  }
}