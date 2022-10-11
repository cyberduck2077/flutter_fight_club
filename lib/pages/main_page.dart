import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Center(//
              child: Text(
                "The\nFight\nClub".toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then(
                (sharedPreferences) =>
                    sharedPreferences.getString("last_fight_result"),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                } else {
                  FightResult fightResult ;
                  if(snapshot.data.toString() == FightResult.won.result){
                    fightResult = FightResult.won;
                  }else if(snapshot.data.toString() == FightResult.lost.result){
                    fightResult = FightResult.lost;
                  }else {
                    fightResult = FightResult.draw;
                  }
                  return Column(
                    children: [
                       const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text("Last fight result"),
                      ),
                      FightResultWidget(fightResult: fightResult,),
                    ],
                  );
                }
              },
            ),
            const Expanded(child: SizedBox()),
            Padding(//при выполнении дз 4.2 пришлось переделать в Padding
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SecondaryActionButton(
                text: "Statistics",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StatisticsPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8,),
            ActionButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FightPage(),
                  ),
                );
              },
              text: "Start".toUpperCase(),
              color: FightClubColors.blackButton,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
