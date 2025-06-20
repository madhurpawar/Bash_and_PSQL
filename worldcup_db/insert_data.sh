#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE_VALUES=$($PSQL "TRUNCATE teams, games")
echo $TRUNCATE_VALUES
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  #INSERT TEAMS in teams table, no need for if condition to check duplicates since team names only holds unique values
  INSERT_NAME1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  INSERT_NAME2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  echo $INSERT_NAME1, $WINNER
  echo $INSERT_NAME2, $OPPONENT

  #Get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #Get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #Insert in games

  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")





fi
done
echo "$($PSQL "SELECT * FROM games")"

