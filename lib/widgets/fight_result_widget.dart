import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class FightResultWidget extends StatelessWidget {
  const FightResultWidget({Key? key, required this.fightResult})
      : super(key: key);

  final FightResult fightResult;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        width: double.infinity,
        height: 140,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(
                    child: ColoredBox(
                        color: FightClubColors.backGroundWhite,
                        child: SizedBox())),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        FightClubColors.backGroundBlue
                      ]),
                    ),
                  ),
                ),
                Expanded(
                    child: ColoredBox(
                        color: FightClubColors.backGroundBlue,
                        child: SizedBox())),
              ],
            ),
            Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 30, top: 12, bottom: 12),
                  constraints: const BoxConstraints(
                    maxWidth: 116,
                  ),
                  child: Column(
                    children: const [
                      Expanded(
                        child: Text(
                          "You",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _getButtomColor(fightResult),
                  borderRadius: BorderRadius.circular(22),
                ),
                constraints: const BoxConstraints(
                  maxWidth: 88,
                  maxHeight: 44,
                ),
                child: Text(
                  fightResult.result.toLowerCase(),
                  style:
                      const TextStyle(color: FightClubColors.whiteText, fontSize: 16),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 30, top: 12, bottom: 12),
                  child: Column(
                    children: const [
                      Expanded(
                        child: Text(
                          "Enemy",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ));
  }
}

Color _getButtomColor(FightResult fr) {
  if(fr==FightResult.lost){
    return FightClubColors.redButton;
  } else if(fr==FightResult.won){
    return FightClubColors.greenButton;
  }else{
    return FightClubColors.blueButton;
  }
}
