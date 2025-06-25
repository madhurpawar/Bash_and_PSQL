#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NO=$(($RANDOM % 1001))
NO_OF_GUESS=0

GET_DETAILS() {
echo "Enter your username:"
read USERNAME
VALIDATE_CREDENTIALS
}

VALIDATE_CREDENTIALS() {
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# Check if the user exists
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_INTO_NAMES=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
  # Get total games played by the username
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id='$USER_ID'")
  # Get best game (smallest guesses)
  BEST_GAME=$($PSQL "SELECT MIN(no_of_guesses) FROM games WHERE user_id='$USER_ID'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
GAME "Guess the secret number between 1 and 1000:"
}

GAME(){
# Print the argument
if [[ $1 ]]
then
  echo $1
fi
read GUESS

# Increment guess counter 
NO_OF_GUESS=$(($NO_OF_GUESS + 1))

# Check if the guess is a valid integer
if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
  GAME "That is not an integer, guess again:"
  return
fi

if [[ $GUESS -gt $RANDOM_NO ]]
then
  GAME "It's lower than that, guess again:"
else
  if [[ $GUESS -lt $RANDOM_NO ]]
  then
    GAME "It's higher than that, guess again:"
  else
    echo "You guessed it in $NO_OF_GUESS tries. The secret number was $RANDOM_NO. Nice job!"
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(user_id, random_no, no_of_guesses) VALUES($USER_ID, $RANDOM_NO, $NO_OF_GUESS)")
  fi
fi
}

GET_DETAILS