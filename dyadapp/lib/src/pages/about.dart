import 'package:flutter/material.dart';

//The about page is where users can go to find out more about the application and its creators
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle _headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
    );
    const TextStyle _bodyStyle = TextStyle(
      fontSize: 18.0,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dyad'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: 12.0,
            runSpacing: 4.0,
            children: <Widget>[
              const Text('What is Dyad?', style: _headerStyle),
              const Text(
                  'Dyad aims to be a social networking app that emphasizes and enforces real social interaction by placing restrictions on location and permanence of posts.',
                  style: _bodyStyle),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: const Text('Creators', style: _headerStyle),
              ),
              Center(
                child: Image.asset(
                  'assets/images/jake.JPG',
                  height: 300.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.topCenter,
                  semanticLabel: "Jake Portrait",
                ),
              ),
              const Text(
                'Jake is a Computer Science undergraduate at the University of Nevada, Reno. In his free time, he likes to play sports and video games.',
                style: _bodyStyle,
              ),
              Center(
                child: Image.asset(
                  'assets/images/vincent.png',
                  height: 300.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                  semanticLabel: "Vincent Portrait",
                ),
              ),
              const Text(
                  'Vincent is a Computer Science undergraduate at the University of Nevada, Reno. He is from California, but now resides in Reno, NV.',
                  style: _bodyStyle),
              Center(
                child: Image.asset(
                  'assets/images/prim.png',
                  height: 300.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                  semanticLabel: "Prim Portrait",
                ),
              ),
              const Text(
                  "Prim is a Computer Science undergraduate at the University of Nevada, Reno. She is from Las Vegas, but decided that UNLV jus't wasn't it!",
                  style: _bodyStyle),
              Center(
                child: Image.asset(
                  'assets/images/sam.png',
                  height: 300.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                  semanticLabel: "Sam Portrait",
                ),
              ),
              const Text(
                  'Sam is a Computer Science undergraduate at the University of Nevada, Reno. He has interests in music production and cybersecurity.',
                  style: _bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
