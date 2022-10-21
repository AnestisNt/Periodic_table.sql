#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SELECT_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1" | sed 's/|/ /g')

    if [[ -z $SELECT_ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.
    else
      echo $SELECT_ATOMIC_NUMBER | while read TYPE_ID ATOMIC_ID SYMBOL NAME MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  
  else
    SELECT_SYMBOL_OR_NAME=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'" | sed 's/|/ /g')
    
    if [[ -z $SELECT_SYMBOL_OR_NAME ]]
    then
      echo I could not find that element in the database.
    else
      echo $SELECT_SYMBOL_OR_NAME | while read TYPE_ID ATOMIC_ID SYMBOL NAME MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi

else
  echo Please provide an element as an argument.
fi
