import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color colorGoButton = FightClubColors.greyButton;
String textInfo = " ";

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  State<FightPage> createState() => _FightPage();
}

class _FightPage extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemyLives = maxLives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              ememysLivesCount: enemyLives,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ColoredBox(
                  color: FightClubColors.backGroundBlue,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          textInfo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: FightClubColors.darkGreyText),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(
              height: 14,
            ),
            ActionButton(
              text: yourLives == 0 || enemyLives == 0 ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color: colorGoButton,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }

    setState(() {
      defendingBodyPart = value;
      if (attackingBodyPart != null) {
        colorGoButton = FightClubColors.blackButton;
      }
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }

    setState(() {
      attackingBodyPart = value;
      if (defendingBodyPart != null) {
        colorGoButton = FightClubColors.blackButton;
      }
    });
  }

  void _getGoButtonColor() {
    if (yourLives == 0 || enemyLives == 0) {
      colorGoButton = FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      colorGoButton = FightClubColors.greyButton;
    } else {
      colorGoButton = FightClubColors.greyButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemyLives == 0) {
      Navigator.of(context).pop();
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        if (defendingBodyPart != null && attackingBodyPart != null) {
          final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
          final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
          if (enemyLoseLife) {
            enemyLives -= 1;
          }
          if (youLoseLife) {
            yourLives -= 1;
          }

          final FightResult? fightResult =
              FightResult.calculateResult(yourLives, enemyLives);

          if (fightResult != null) {
            SharedPreferences.getInstance().then((sharedPreferences) {
              sharedPreferences.setString(
                  "last_fight_result", fightResult.result);
            });
          }

          if (fightResult != null) {

            if (fightResult == FightResult.lost) {

              FightResult.incrementResult(fightResult);

              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences.setInt(
                    "stats_lost", FightResult.lostCount);
              });
            }
            if (fightResult == FightResult.won) {

              FightResult.incrementResult(fightResult);

              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences.setInt(
                    "stats_won", FightResult.wonCount);
              });
            }
            if (fightResult == FightResult.draw) {

              FightResult.incrementResult(fightResult);

              SharedPreferences.getInstance().then((sharedPreferences) {
                sharedPreferences.setInt(
                    "stats_draw", FightResult.drawCount);
              });
            }
          }

          textInfo = _calculateTextInfo(youLoseLife, enemyLoseLife);

          whatEnemyDefends = BodyPart.random();
          whatEnemyAttacks = BodyPart.random();

          defendingBodyPart = null;
          attackingBodyPart = null;
        }
      });
    }
    setState(() {
      _getGoButtonColor();
    });
  }

  String _calculateTextInfo(final bool youLoseLife, final bool enemyLoseLife) {
    if (yourLives == 0 && enemyLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemyLives == 0) {
      return "You won";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy’s ${whatEnemyDefends.name}."
          : "Your attack was blocked.";
      final String second = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name}."
          : "Enemy’s attack was blocked.";

      return "$first\n$second";
    }
  }
}

class FightersInfo extends StatelessWidget {
  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.ememysLivesCount,
  }) : super(key: key);

  final int maxLivesCount;
  final int yourLivesCount;
  final int ememysLivesCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
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
                    gradient: LinearGradient(
                        colors: [Colors.white, FightClubColors.backGroundBlue]),
                  ),
                ),
              ),
              Expanded(
                  child: ColoredBox(
                      color: FightClubColors.backGroundBlue,
                      child: SizedBox())),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                const SizedBox(
                  height: 35,
                ),
                LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: yourLivesCount,
                ),
              ]),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "You".toUpperCase(),
                    style: const TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.youAvatar,
                    height: 92,
                    width: 92,
                  ),
                ],
              ),
              const SizedBox(
                  height: 44,
                  width: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FightClubColors.blueButton),
                    child: Center(
                        child: Text(
                      "vs",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  )),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Enemy".toUpperCase(),
                    style: const TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    height: 92,
                    width: 92,
                  ),
                ],
              ),
              Column(children: [
                const SizedBox(
                  height: 35,
                ),
                LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: ememysLivesCount,
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.attackingBodyPart,
      required this.selectDefendingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  final BodyPart? defendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Defend".toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Attack".toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        //вводит ограничения на вводимые параметры (При debug!)
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return Padding(
            padding: index < overallLivesCount - 1
                ? const EdgeInsets.only(bottom: 4)
                : const EdgeInsets.only(bottom: 0),
            child: Image.asset(
              FightClubIcons.heartFull,
              width: 18,
              height: 18,
            ),
          );
        } else {
          return Padding(
            padding: index < overallLivesCount - 1
                ? const EdgeInsets.only(bottom: 4)
                : const EdgeInsets.only(bottom: 0),
            child: Image.asset(
              FightClubIcons.heartEmpty,
              width: 18,
              height: 18,
            ),
          );
        }
      }),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [
    head,
    torso,
    legs
  ]; //рандомная генерация действий противника

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: FightClubColors.darkGreyText),
            ),
          ),
        ),
      ),
    );
  }
}
