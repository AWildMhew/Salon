#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -tc"


MAIN_MENU (){

  if [[ $1 ]]
  then
   echo -e "\n$1"
  fi
  echo -e "\nSelect a service\n"

echo "$($PSQL "SELECT * FROM services")" | while read ID NAME
do

if [[ $ID =~ ^[0-9]+$ ]]
then 
  echo $(echo "$ID) $NAME" | sed 's/ |//')
fi


done

read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
  MAIN_MENU "Please enter a number"
else
  SERVICE_MENU
fi

}

SERVICE_MENU() {
  echo -e "\nService menu"

  echo Please enter a phone number.
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo Not in database
    # get name
    echo Please enter your name.
    read CUSTOMER_NAME
    # insert name, phone into customers
    CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  # display name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo Hello $CUSTOMER_NAME
  # ask for time
  echo Please select a time
  read SERVICE_TIME
  # create appointment
  APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # display final message
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."

}


MAIN_MENU