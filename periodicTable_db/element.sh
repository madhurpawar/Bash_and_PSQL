#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

MAIN_MENU(){

  if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  else
    # If argument is an integer
    if [[ $1 =~ ^[0-9]+$ ]]; then 
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$1'")
      # Check if it exists in the table
      if [[ -z $ATOMIC_NAME ]]
      then
        echo "I could not find that element in the database."
      else
        #Fetch other elements from elements table.
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$1'")
        ATOMIC_NO=$1
        PRINT_RESULT
      fi
      # If agument is a string 
    else
      # If argument is a symbol
      if [ ${#1} -le 2 ]
      then
        ATOMIC_NO=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
        # Check if it exists in the table
        if [[ -z $ATOMIC_NO ]]
        then
          echo "I could not find that element in the database."
        else
          #Fetch other elements from elements table.
          ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
          SYMBOL=$1
          PRINT_RESULT
        fi
      # If argument is name    
      else
        ATOMIC_NO=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
        # Check if it exists in table
        if [[ -z $ATOMIC_NO ]]
        then
          echo "I could not find that element in the database." 
        else
          #Fetch other elements from elements table.
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
          ATOMIC_NAME=$1
          PRINT_RESULT
        fi
      fi
    fi
  fi
}

PRINT_RESULT() {
  # Fetch data from properties and types table
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NO'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NO'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NO'")
  TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number='$ATOMIC_NO'")
  echo "The element with atomic number $ATOMIC_NO is $ATOMIC_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

MAIN_MENU $1