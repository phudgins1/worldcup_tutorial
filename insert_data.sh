#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games,teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #find team_id of winner
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'");
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #create winning name
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_RESULT = "INSERT 0 1" ]]
      then
        echo Added winning name, $WINNER
      fi
    fi
    #find team_id of opponent
    TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'");
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #create opponent name
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT = "INSERT 0 1" ]]
      then
        echo Added opponent name, $OPPONENT
      fi
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #find winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'");
    #find opponent_id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'");
    #find game combo row
    GAME_ROW=$($PSQL "select year, round, winner_id, opponent_id from games where year=$YEAR AND round='$ROUND' and winner_id=$WINNER_ID and opponent_id=$OPPONENT_ID");
    #if not found
    if [[ -z $GAME_ROW ]]
    then
      #create game row
      INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
      then
        echo Added game, $YEAR : $ROUND : $WINNER : $OPPONENT
      fi
    fi
  fi
done
