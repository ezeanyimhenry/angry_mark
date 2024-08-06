
import 'package:flutter/material.dart';

import '../mythems/theme.dart';

class BirdCard extends StatelessWidget {
  BirdCard({Key? key}) : super(key: key);

  final List<Map<String, String>> cardData = [
    {
      'imageUrl': 'assets/images/angrybird/Red_Movie.png',
      'birdname': 'Red',
    },
    {
      'imageUrl': 'assets/images/angrybird/Hatclings_Movie.png',
      'birdname': 'Hatclings',
    },
    {
      'imageUrl': 'assets/images/angrybird/Courtney_Movie.png',
      'birdname': 'Courtney',
    },
    {
      'imageUrl': 'assets/images/angrybird/MinionPig_Movie.png',
      'birdname': 'MinionPig',
    },
    {
      'imageUrl': 'assets/images/angrybird/Garry_Movie.png',
      'birdname': 'Garry',
    },
    {
      'imageUrl': 'assets/images/angrybird/Bubbles_Movie.png',
      'birdname': 'Bubbles',
    },
    {
      'imageUrl': 'assets/images/angrybird/Zeta_Movie.png',
      'birdname': 'Zeta',
    },
    {
      'imageUrl': 'assets/images/angrybird/Blues_Movie.png',
      'birdname': 'Blues',
    },
    {
      'imageUrl': 'assets/images/angrybird/Silver_Movie.png',
      'birdname': 'Silver',
    },
    {
      'imageUrl': 'assets/images/angrybird/MightyEagle_Movie.png',
      'birdname': 'MightyEagle',
    },
    {
      'imageUrl': 'assets/images/angrybird/Terence_Movie.png',
      'birdname': 'Terence',
    },
    {
      'imageUrl': 'assets/images/angrybird/Matilda_Movie.png',
      'birdname': 'Matilda',
    },
    {
      'imageUrl': 'assets/images/angrybird/Chuck_Movie.png',
      'birdname': 'Chuck',
    },
    {
      'imageUrl': 'assets/images/angrybird/Stella_Movie.png',
      'birdname': 'Stella',
    },
    {
      'imageUrl': 'assets/images/angrybird/Bomb_Movie.png',
      'birdname': 'Bomb',
    },
    {
      'imageUrl': 'assets/images/angrybird/Red_Classic.png',
      'birdname': 'Red_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/MinionPig_Classic.png',
      'birdname': 'MinionPig_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Bubbles_Classic.png',
      'birdname': 'Bubbles_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Blues_Classic.png',
      'birdname': 'Blues_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Silver_Classic.png',
      'birdname': 'Silver_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/MightyEagle_Classic.png',
      'birdname': 'MightyEagle_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Terence_Classic.png',
      'birdname': 'Terence_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Matilda_Classic.png',
      'birdname': 'Matilda_Classic',
    },
    {
      'imageUrl': 'assets/images/angrybird/Chuck_Classic.png',
      'birdname': 'Chuck_Classic',
    },
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
                      Padding(
                        padding: const EdgeInsets.all(
                          15.0,
                        ),
                        child: Text(
                          "${currentItem['birdname']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
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
