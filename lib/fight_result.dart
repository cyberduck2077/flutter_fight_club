class FightResult{
  final String result;

  const FightResult._(this.result);

  static const won = FightResult._("Won");
  static const lost = FightResult._("Lost");
  static const draw = FightResult._("Draw");

  static int drawCount = 0;
  static int wonCount = 0;
  static int lostCount = 0;

  static FightResult? calculateResult(final int yourLives, final int enemyLives){
    if(yourLives==0 && enemyLives==0){
      return draw;
    }else if(yourLives==0){
      return lost;
    }else if(enemyLives == 0){
      return won;
    }
    return null;
  }

  static incrementResult(FightResult fightResult){
    if(fightResult==FightResult.lost){
      lostCount++;
    }
    if(fightResult==FightResult.won){
      wonCount++;
    }
    if(fightResult==FightResult.draw){
      drawCount++;
    }
  }


  @override
  String toString() {
    return 'FightResult{result: $result}';
  }
}