#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~ Salon Services ~~~\n"
SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # List of services
  echo -e "1) haircut\n2) trimming\n3) massage"
  echo -e "\nPlease enter the service_id:"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) REGISTER_APPOINTMENT ;;
    2) REGISTER_APPOINTMENT ;;
    3) REGISTER_APPOINTMENT ;;
    *) SERVICE_MENU "Invalid option selected please try again!" ;;
  esac

}

REGISTER_APPOINTMENT() {
  # enter phone number
  echo -e "\nPlease enter your phone number\n"
  read CUSTOMER_PHONE

  # get name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo $CUSTOMER_NAME
  # if name not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    # ask for name
    echo -e "\nWhat is your name?\n"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # ask for time
  echo -e "\nWhat is the service time that you are looking for?(Enter in format 12:00)\n"
  read SERVICE_TIME

  # Enter appointment
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  #Output message
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE_MENU