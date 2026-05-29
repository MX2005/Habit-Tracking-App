import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_track_app/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String userName = '';
  bool isLoading = false;
  // Put this list at the top of your file or inside your State class
  final List<String> countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Congo",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czechia",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Grenada",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Korea",
    "North Macedonia",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Korea",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe",
  ];
  final List<String> habits = [
    "Wake Up Early",
    "Workout",
    "Drink Water",
    "Meditate",
    "Read a Book",
    "Practice Gratitude",
    "Sleep 8 Hours",
    "Eat Healthy",
  ];
  
  final List<Map<String, dynamic>> _selectedHabits = [];
  String? _selectedCountry;
  double _age = 0;

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        decoration: BoxDecoration(
           gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue[900]!],
          ),
        ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Row(
                      children: [
            
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          iconSize: 35,
                          onPressed: () {
                            Navigator.pop(context); // ✅ goes back to previous screen
                          },
                        ),
                        SizedBox(width: 90,),
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
            
                      ],
                    ),
                    SizedBox(height: 60,),

                    TextField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        userName = value;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.supervised_user_circle, color: Colors.blue[700],),
                        hintText: 'Enter your Username',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                    
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        
                      ),
                    ),

                    SizedBox(height: 20,),
                    
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.email, color: Colors.blue[700],),
                        hintText: 'Enter your email',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                    
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        
                      ),
                    ),
            
                    SizedBox(height: 20,),
            
                    TextField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[700],),
                        hintText: 'Enter your password',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                    
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        
                      ),
                    ),
            
                    SizedBox(height: 20,),
            
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text(
                          'Age: ${_age.round()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ),
            
                    Slider(
                      value: _age,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _age.round().toString(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white54,
                      onChanged: (Value) {
                        setState(() {
                          _age = Value;
                        });
                      },
                    ),
                  
                    SizedBox(height: 20,),
            
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: DropdownButton<String>(
                        menuWidth: 400,
                        menuMaxHeight: 200,
                        borderRadius: BorderRadius.circular(25),
                        hint: Text("Select Your Country"),
                        value: _selectedCountry,
                        icon: Icon(Icons.arrow_drop_down),
                        underline: SizedBox(), // removes default underline
                        items: countries.map((String country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                      ),
                    ),
            
            
                    SizedBox(height: 30,),
            
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Your Habits',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ),
            
                    SizedBox(height: 20,),
            
            
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: habits.map((habit) {
                        final isSelected = _selectedHabits.any((h) => h["name"] == habit);
                        return FilterChip(
                          label: Text(habit),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold
                          ),
                          selected: isSelected,
                          selectedColor: Colors.blue[100],
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedHabits.add({
                                  "name": habit,
                                  "done": false,
                                  "color": Colors.blue.value,
                                });
                              } else {
                                _selectedHabits.removeWhere((h) => h["name"] == habit);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
            
                    SizedBox(height: 20,),
            
                    ElevatedButton(
                      onPressed: () async {
                        if (email.isEmpty || password.isEmpty || _age == 0 || _selectedCountry == null || userName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all required fields: username, email, password, age, and country')),
                          );
                          return; // stop here, don’t call Firebase
                        }
                        setState(() {
                          isLoading = true;
                        });
            
                        try {
                          final newUser = await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          await FirebaseFirestore.instance.collection('users').doc(newUser.user!.uid).set({
                            'username': userName,
                            'email': email,
                            'age': _age,          // from your slider
                            'country': _selectedCountry,  // from your dropdown
                            'habits': _selectedHabits,   // ✅ save habits here
                            'doneHabits': [],
                            'notificationsEnabled': true,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
            
                          // Navigate to HomeScreen if registration succeeds
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(selectedHabits: _selectedHabits)),);
                          
                        } on FirebaseAuthException catch (e) {
                          String message;
                          if (e.code == 'email-already-in-use') {
                            message = 'This email is already registered.';
                          } else if (e.code == 'invalid-email') {
                            message = 'Please enter a valid email address.';
                          } else if (e.code == 'weak-password') {
                            message = 'Password is too weak. Try a stronger one.';
                          } else {
                            message = 'Registration failed. Please try again.';
                          }
            
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
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
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                    SizedBox(height: 40,),
            
                    
                    
                  ],
                ),
              ),
            ),
          ),
        ) ,
      );
  }
}