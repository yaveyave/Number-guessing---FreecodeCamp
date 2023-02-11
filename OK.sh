#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#funtion


echo "Enter your username:"
read USER_NAME
if [[ ! "${#USER_NAME}" -le 22 ]]
then
  echo "No allowed!, User Name have to contain 22 characters"
else
  QUERY_NAME=$($PSQL "SELECT name FROM users WHERE name='$USER_NAME'")
  if [[ -z "$QUERY_NAME" ]]
  then
    #user not found
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    INSERT_USER_NAME=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME')")
  else 
    #if found
    QUERY_USER_ID=($($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME'"))  
    #QUERY_GAMES_PLAYED=$($PSQL "SELECT game_played FROM games INNER JOIN users USING(user_id) WHERE user_id = '$QUERY_USER_ID'")
    QUERY_GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games WHERE user_id = '$QUERY_USER_ID'")
    QUERY_GAMES_PLAYED=$($PSQL "SELECT game_played FROM games WHERE game_id = '$QUERY_GAME_ID'")
    QUERY_BEST_GAME=$($PSQL "SELECT MIN(attemps) FROM games INNER JOIN users USING(user_id) WHERE user_id = '$QUERY_USER_ID'")
    echo "Welcome back, $QUERY_NAME! You have played $QUERY_GAMES_PLAYED games, and your best game took $QUERY_BEST_GAME guesses."
  fi
 

  MAGIC_NUMBER=$((RANDOM % 1000 + 1))
  echo "TEST $MAGIC_NUMBER"
  echo "Guess the secret number between 1 and 1000:"
  read CHOSEN_NUMBER


  COUNT=1
  while [[ $CHOSEN_NUMBER -ne $MAGIC_NUMBER ]]
  do
    if [[ $CHOSEN_NUMBER =~ ^[0-9]+$ && $CHOSEN_NUMBER -gt $MAGIC_NUMBER ]]; then
      #if is -gt
      echo "It's lower than that, guess again:"
      read CHOSEN_NUMBER
    elif [[ $CHOSEN_NUMBER =~ ^[0-9]+$ && $CHOSEN_NUMBER -lt $MAGIC_NUMBER ]]; then
      #if is -lt
      echo "It's higher than that, guess again:"
      read CHOSEN_NUMBER
    else
      echo "That is not an integer, guess again:"
      read CHOSEN_NUMBER
    fi
    COUNT=$(( COUNT + 1 ))
    #INSERT_ATTEMP=$($PSQL "UPDATE games SET attemps = $COUNT WHERE user_id = $QUERY_USER_ID")  
  done
fi
#INSERT_ATTEMP=$($PSQL "INSERT INTO games(attemps) VALUES('$COUNT')")
QUERY_USER_ID=($($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME'"))
#QUERY_COUNT_GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = '$QUERY_USER_ID'")
QUERY_COUNT_GAMES_PLAYED=$(( $($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = '$QUERY_USER_ID'") + 1 ))
INSERT_GAMES=$($PSQL "INSERT INTO games(user_id, game_played, attemps) VALUES('$QUERY_USER_ID', '$QUERY_COUNT_GAMES_PLAYED', '$COUNT')")

echo "You guessed it in $COUNT tries. The secret number was $MAGIC_NUMBER. Nice job!"







