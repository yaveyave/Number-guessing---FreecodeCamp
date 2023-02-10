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
    echo "Welcome, <username>! It looks like this is your first time here."
  else 
    #if found
    echo "Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
  fi
fi 

MAGIC_NUMBER=$((RANDOM % 1000 + 1))
echo "TEST $MAGIC_NUMBER"
echo "Guess the secret number between 1 and 1000:"
read CHOSEN_NUMBER

#if [[ $CHOSEN_NUMBER =~ ^[0-9]+$ ]]
#then  
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
  done

echo "You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"
#else 
#echo "End"
#fi




