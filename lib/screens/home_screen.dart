import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_app_3/common/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}
//staturile cu icoane si ar trebui si imaginea numa ca nu merge
class StatsDisplay extends StatelessWidget {
  final int hp;
  final int xp;
  final int level;
  final String encounterType;
  final String encounterMessage;

  const StatsDisplay({
    Key? key,
    required this.hp,
    required this.xp,
    required this.level,
    required this.encounterType,
    required this.encounterMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      
      child: Padding(
        
        padding: const EdgeInsets.all(8.0),
        
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 4), 
                Text('HP: $hp'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4),
                Text('XP: $xp'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.arrow_upward, color: Colors.green),
                const SizedBox(width: 4),
                Text('Level: $level'),
              ],
            ),
            if (encounterType.isNotEmpty) Image.asset('assets/$encounterType.png'),
            Text(encounterMessage),
          ],
        ),
      ),
    );
  }
}
//butoanele
class ActionButtons extends StatelessWidget {
  final Function(String) onPressed;

  const ActionButtons({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => onPressed('hunt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 33, 33), // Change the background color
            ),
            child: const Text(huntButton),
          ),
          const SizedBox(width: 8), // Add some space between buttons
          ElevatedButton(
            onPressed: () => onPressed('heal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Change the background color
            ),
            child: const Text(healButton),
          ),
        ],
      ),
    );
  }
}


class _HomeScreenState extends State<HomeScreen> {
  var str = 1;
  var hp = 10;
  var xp = 0;
  var xpfull = 10;
  var full = 10;
  var level = 1;
  String encounterType = '';
  String encounterMessage = '';
//imagnea de fundal si tine minte var
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(homeScreenTitle),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://static.wixstatic.com/media/6296ce_663f07a068f840109737ad0fbebccd73~mv2.jpg/v1/fill/w_640,h_400,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/6296ce_663f07a068f840109737ad0fbebccd73~mv2.jpg'), // Replace with your image URL
            fit: BoxFit.cover, 
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatsDisplay(
                hp: hp,
                xp: xp,
                level: level,
                encounterType: encounterType,
                encounterMessage: encounterMessage,
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              ActionButtons(onPressed: _onActionButtonPressed),
            ],
          ),
        ),
      ),
    );
  }
//choses action based on button
  void _onActionButtonPressed(String action) {
    setState(() {
      if (action == 'hunt') {
        _hunt();
      } else if (action == 'heal') {
        _heal();
      }
    });
  }
//hunt method
  void _hunt() {
    Random random = Random();
    int randomNumber = random.nextInt(2);
    if (randomNumber == 1) {
      _encounterWolf();
    } else {
      _encounterBear();
    }
  }
//daca vine un lup
  void _encounterWolf() {
    setState(() {
      hp = hp - 2;
      xp = xp + 5;
      _checkLevelUp();
      _updateEncounterType('wolf');
      _updateEncounterMessage('You have been approached by a wolf');
      if (hp <= 0) {
        _die();
      }
    });
  }
//daca vine un urs
  void _encounterBear() {
    setState(() {
      hp = hp - 3;
      xp = xp + 5;
      _checkLevelUp();
      _updateEncounterType('bear');
      _updateEncounterMessage('You have been approached by a bear');
      if (hp <= 0) {
        _die();
      }
    });
  }
//care aleget ce tipe de encounter ii bear sau wolf
  void _updateEncounterType(String type) {
    setState(() {
      encounterType = type;
    });
  }
//la fel numa ca updatateaza mesaju care va aparea
  void _updateEncounterMessage(String message) {
    setState(() {
      encounterMessage = message;
    });
  }
//a heal method
  void _heal() {
    setState(() {
      hp = full;
      _updateEncounterMessage('You have healed');
    });
  }
//level up chekcer
  void _checkLevelUp() {
    if (xp >= xpfull) {
      _levelUp();
    }
  }
//level up
  void _levelUp() {
    setState(() {
      level = level + 1;
      str = str + 1;
      xp = 0;
      xpfull = xpfull + 10;
      full = full + 1;
      hp = full;
      _updateEncounterMessage('Level up! You are now at Level $level');
    });
  }
//dide lol
  void _die() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('You have died. Restart the game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _restartGame(); // Implement a function to reset the game state
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      hp = 10;
      xp = 0;
      level = 1;
      encounterType = '';
      encounterMessage = '';
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
