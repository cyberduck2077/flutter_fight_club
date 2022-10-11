import 'package:flutter/material.dart';
import '../resources/fight_club_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, required this.onTap, required this.text, required this.color})
      : super(key: key);

  final VoidCallback onTap; //при тапе по кнопке
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 10 ),
        height: 40,
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: FightClubColors.whiteText,
              fontWeight: FontWeight.w900,
              fontSize: 19),
        ),
      ),
    );


  }
}