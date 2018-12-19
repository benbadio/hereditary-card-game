import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';

    return MaterialApp(title: title, home: CardGrid());
  }
}

class CardGridState extends State<CardGrid> {
  final List<List<int>> allCardDetails = _buildAllCardDetails();
  List<List<int>> inPlayCardDetails;
  final Set<int> selectedCardIndexes = Set();
  final String scoreText = "Score: ";
  final String gameOverText = "Game Over: ";
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(scoreText + score.toString())),
        body: _buildPlayGrid());
  }

  Widget _buildPlayGrid() {
    inPlayCardDetails = _getInPlayCardDetails();

    var fullyBuiltCards = List.generate(inPlayCardDetails.length, (index) {
      return _buildCard(inPlayCardDetails.elementAt(index), index);
    });

    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16.0),
      children: fullyBuiltCards,
    );
  }

  List<List<int>> _getInPlayCardDetails() {
    if (allCardDetails.length > 12) {
      inPlayCardDetails = allCardDetails.sublist(0, 12);
      if (noValidSetsInPlay(inPlayCardDetails) && allCardDetails.length >= 15) {
        inPlayCardDetails.addAll(allCardDetails.sublist(13, 16));
      }
    } else {
      inPlayCardDetails = allCardDetails.sublist(0, allCardDetails.length);
    }
    return inPlayCardDetails;
  }

  static List<List<int>> _buildAllCardDetails() {
    final List<List<int>> cardDetails = List();
    final indexValues = [0, 1, 2];
    indexValues.forEach((count) {
      indexValues.forEach((color) {
        indexValues.forEach((shape) {
          final cardInfo = List.of([count, color, shape]);
          cardDetails.add(cardInfo);
        });
      });
    });
    cardDetails.shuffle(Random.secure());
    return cardDetails;
  }

  Widget _buildCard(List<int> cardDetails, int index) {
    final count = cardDetails.elementAt(0) + 1;
    final colorKey = cardDetails.elementAt(1);
    final shapeKey = cardDetails.elementAt(2);
    final color = getCardColor(colorKey);
    final shape = getCardShape(shapeKey);

    final cardElements = List.generate(count, (index) {
      return Icon(shape, color: color);
    });
    return GestureDetector(
        onTap: () {
          setState(() {
            if (selectedCardIndexes.contains(index)) {
              selectedCardIndexes.remove(index);
              return;
            } else if (selectedCardIndexes.length < 3) {
              selectedCardIndexes.add(index);
            }
            if (selectedCardIndexes.length == 3) {
              if (isAValidSet(selectedCardIndexes)) {
                selectedCardIndexes.forEach((index) {
                  allCardDetails.removeAt(index);
                });
                score += 1;
              }
              selectedCardIndexes.clear();
            }
          });
        },
        child: Card(
            elevation: 2.0,
            color: selectedCardIndexes.contains(index)
                ? Colors.white30
                : Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: cardElements)));
  }

  MaterialColor getCardColor(int colorIndex) {
    var color;
    switch (colorIndex) {
      case 0:
        color = Colors.orange;
        break;
      case 1:
        color = Colors.purple;
        break;
      case 2:
        color = Colors.green;
        break;
    }
    return color;
  }

  IconData getCardShape(int shapeIndex) {
    var shape;
    switch (shapeIndex) {
      case 0:
        shape = Icons.favorite;
        break;
      case 1:
        shape = Icons.build;
        break;
      case 2:
        shape = Icons.audiotrack;
        break;
    }
    return shape;
  }

  bool isAValidSet(Set<int> selectedCardIndexes) {
    final List<int> card1 =
    allCardDetails.elementAt(selectedCardIndexes.elementAt(0));
    final List<int> card2 =
    allCardDetails.elementAt(selectedCardIndexes.elementAt(1));
    final List<int> card3 =
    allCardDetails.elementAt(selectedCardIndexes.elementAt(2));
    final Set<int> cardIconCounts =
    Set.from([card1.elementAt(0), card2.elementAt(0), card3.elementAt(0)]);
    final Set<int> cardColors =
    Set.from([card1.elementAt(1), card2.elementAt(1), card3.elementAt(1)]);
    final Set<int> cardShapes =
    Set.from([card1.elementAt(2), card2.elementAt(2), card3.elementAt(2)]);

    return validTraits(cardColors) &&
        validTraits(cardShapes) &&
        validTraits(cardIconCounts);
  }

  bool validTraits(Set<int> traits) {
    return traits.length != 2;
  }

  // TODO: Write algorithm to determine if the play grid contains a set
  bool noValidSetsInPlay(List<List<int>> inPlayCardDetails) {
    return false;
  }
}

class CardGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CardGridState();
  }
}