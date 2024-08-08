import 'package:flutter/material.dart';

import '../mythems/theme.dart';

class BirdCard extends StatelessWidget {
  BirdCard({super.key});

  final List<Map<String, String>> cardData = [
    {
      'imageUrl': 'assets/images/characters/1.png',
      'birdname': 'Shulle',
      'speed': '30',
      'energy': '40',
    },
    {
      'imageUrl': 'assets/images/characters/2.png',
      'birdname': 'Kehlanw',
      'speed': '40',
      'energy': '40',
    },
    {
      'imageUrl': 'assets/images/characters/3.png',
      'birdname': 'Her-chaiios',
      'speed': '50',
      'energy': '45',
    },
    {
      'imageUrl': 'assets/images/characters/4.png',
      'birdname': 'Mimi',
      'speed': '60',
      'energy': '50',
    },
    {
      'imageUrl': 'assets/images/characters/5.png',
      'birdname': 'Phorlaj',
      'speed': '70',
      'energy': '60',
    },
    {
      'imageUrl': 'assets/images/characters/6.png',
      'birdname': 'Naza',
      'speed': '80',
      'energy': '70',
    },
    {
      'imageUrl': 'assets/images/characters/7.png',
      'birdname': 'Mark',
      'speed': '100',
      'energy': '100',
    },
    // {
    //   'imageUrl': 'assets/images/angrybird/Blues_Movie.png',
    //   'birdname': 'Blues',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Silver_Movie.png',
    //   'birdname': 'Silver',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/MightyEagle_Movie.png',
    //   'birdname': 'MightyEagle',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Terence_Movie.png',
    //   'birdname': 'Terence',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Matilda_Movie.png',
    //   'birdname': 'Matilda',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Chuck_Movie.png',
    //   'birdname': 'Chuck',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Stella_Movie.png',
    //   'birdname': 'Stella',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Bomb_Movie.png',
    //   'birdname': 'Bomb',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Red_Classic.png',
    //   'birdname': 'Red_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/MinionPig_Classic.png',
    //   'birdname': 'MinionPig_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Bubbles_Classic.png',
    //   'birdname': 'Bubbles_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Blues_Classic.png',
    //   'birdname': 'Blues_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Silver_Classic.png',
    //   'birdname': 'Silver_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/MightyEagle_Classic.png',
    //   'birdname': 'MightyEagle_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Terence_Classic.png',
    //   'birdname': 'Terence_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Matilda_Classic.png',
    //   'birdname': 'Matilda_Classic',
    // },
    // {
    //   'imageUrl': 'assets/images/angrybird/Chuck_Classic.png',
    //   'birdname': 'Chuck_Classic',
    // },
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: cardData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var currentItem = cardData[index];
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  height: 160,
                  width: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${currentItem['birdname']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Speed: ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color.fromARGB(255, 155, 244, 54)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${currentItem['speed']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Energy: ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromARGB(255, 118, 8, 79)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${currentItem['energy']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -40,
                child: Image.asset(
                  '${currentItem['imageUrl']}',
                  height: 160,
                ),
              ),
              const SizedBox(
                height: 250,
              ),
            ],
          );
        },
      ),
    );
  }
}
