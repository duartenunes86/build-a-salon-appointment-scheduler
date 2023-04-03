#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

LIST_OF_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo -e "\n~~~~~ MY SALON ~~~~~\n"

 MAIN_MENU(){
   if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
echo -e "\n Here are our services:\n"
echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR NAME
do
echo "$SERVICE_ID) $NAME"
echo -e "\n"
done
read SERVICE_ID_SELECTED
 

  
 
# if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      # send to main menu
      MAIN_MENU "That is not a valid number."
    else
    # get service availability
      SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      # if not available
      if [[ -z $SERVICE_AVAILABILITY ]]
      then
        # send to main menu
        MAIN_MENU "That service is not available."
        else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        echo $CUSTOMER_NAME
        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi 
          echo -e "\nWhat time do you want your service?"
          read SERVICE_TIME
          CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
       
          INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'") 
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."



        
      fi
    fi
}
MAIN_MENU
