#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else 
  get_input=""
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    get_input=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$1")
    diff_input=$get_input
  fi
  if [[ -z $get_input ]]
  then
    get_input=$($PSQL "SELECT name FROM elements WHERE name='$1'") 
    diff_input=$($PSQL "SELECT atomic_number FROM elements WHERE name='$get_input'")
  fi
  if [[ -z $get_input ]]
  then
    get_input=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    diff_input=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$get_input'")
  fi
  if [[ -z $get_input ]] 
  then
    echo I could not find that element in the database.
  else
    get_atomic_num=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$diff_input")
    get_atomic_name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$diff_input")
    get_atomic_symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$diff_input")
    get_atomic_type=$($PSQL "SELECT types.type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$diff_input")
    get_atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$diff_input")
    get_atomic_melting_point=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$diff_input")
    get_atomic_boiling_point=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$diff_input")

    echo "The element with atomic number $get_atomic_num is $get_atomic_name ($get_atomic_symbol). It's a $get_atomic_type, with a mass of $get_atomic_mass amu. $get_atomic_name has a melting point of $get_atomic_melting_point celsius and a boiling point of $get_atomic_boiling_point celsius."
  fi
fi
