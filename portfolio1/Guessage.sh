#!/bin/bash
# CSP2101 Portfolio Assessment 1
# +++++++++++++++++++++++++++++++
# Name:         Matthew HARRINGTON
# Student ID:   2001901
#
#
#=================FUNCTIONS=======================+
#
#++++++++++++++++++++++++++++++++++++++++++++++++++
# Function to randomly generate the age           |
#++++++++++++++++++++++++++++++++++++++++++++++++++
#
# function adapted from a script sample from http://tldp.org/LDP/abs/html/randomvar.html, "9.3. $RANDOM: generate random integer "

Generate_Random_Age()
{
upper=71
lower=20
number=0
remainder=0
while [ "$remainder" -lt "$lower" ] ;  # this condition ensures that the value is above the set minimum.
do
    number=$RANDOM

remainder=$(($number % $upper)) # modulus used as $RANDOM value is based on 16 bits therefore maximum value is 2^16, by using a modulus of 71 we can ensure that the final amount is no larger than 70
done }

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function that validates the input as being an integer that falls within the scope of the age range |
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# function adapted from code from https://stackoverflow.com/questions/29647586/validate-input-in-bash-script and http://tldp.org/LDP/Bash-Beginners-Guide/html/chap_04.html
# https://regular-expressions.info/posixbrackets.html was also used for reference regarding POSIX character sets

Validate_Input()
{
(( upper_limit=upper-1 )) # this value will show the actual upper age limit for the game if a player makes a guess greater than 70
    while :
    do read -p "$name, please enter your guess: " age
    if [[ $age =~ [[:punct:]+] ]]; then                                                     #checks for any punctuations characters in the user input.
        echo -e "$name, No decimal points, negative signs or other special characters; integers only.\n" 
    elif [[ $age =~ [[:space:]+] ]]; then                                                   #checks for any white space characters in the user input.
        echo -e "$name, no white space characters, integers only.\n"                                     
    elif [[ $age =~ [[:alpha:]+] ]]; then                                                   #checks for any alphabet characters in the user input.
        echo -e "$name, no alphabet characters only integers.\n"
        
    elif [[ $age =~ [[:digit:]+] ]]; then
        if [ $age -gt $upper_limit ]; then                                                  #nested if statement that checks that the user input is within the defined boundaries of the age range.
        echo -e "$name, your guess is greater than $upper_limit!\n"
        elif [ $age -lt $lower ]; then
        echo -e "$name, your guess is less than $lower!\n"
        else return $age
        fi
    else
    echo -e "Integers only, try again $name.\n"
    fi
    done 
}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function that validates the players name contains at least one alphanumeric character |
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Validate_Name()
{
# https://regular-expressions.info/posixbrackets.html, https://devhints.io/bash and http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_03.html were used for reference

valid_name=1                                                    #inital valid_name value ensures that while lopp is run at least once
read -p "What is your name?: " name

while (( $valid_name !=0 )); do
if [[ ${#name} -lt 1 ]]; then                                   #checks that the user input contains at least one character.
echo -e "Your name needs to have at least one character.\n\n"
read -p "What is your name?: " name
elif [[ $name =~ [[:punct:]+] ]]; then                          #checks the user input for any punctuation characters such as ?,!^% etc.
echo -e "Your name can not contain any punctuation characters\n\n"
read -p "What is your name?: " name
elif [[ $name =~ [[:space:]+] ]]; then                          #checks the user input for any white space characters.
echo -e "Please enter your first name only\n\n"
read -p "What is your name?: " name
elif [[ $name =~ [[:blank:]+] ]]; then                          #checks that the user input is not blank
echo -e "please enter at least one visible character for your name\n\n"
read -p "What is your name?: " name
else
(( valid_name=valid_name-1 ))                                   #if user input passes all the checks the valid_name variable is set to 0 which will exit the validation While loop.
fi
done
}

#=================SCRIPT=======================+

# This section welcomes the user to game and advises them of the basic rules
echo -e "\nWelcome to the Guess Age Game"
echo -e "=============================\n"
echo -e "The rules are simple:\n---------------------\n1) The age is between 20 and 70.\n2) The age is a whole number. No decimal number guesses will be accepted.\n3) Have fun!\n\n"

#intialise values:
Generate_Random_Age
random_age=$remainder;

#Prompts user to enter their name
Validate_Name

#Starts the loop that continues until the customer gets the answer. As no conditions are set it is an infinite loop as it will alway be TRUE.
while :  

#prompts user to enter their guess
do #echo -e "$name, what is your guess?: "

# Runs validate function for all the guesses
Validate_Input

if  [ $random_age -eq $age ]; then
    break                                       #this break is how the user will exit the infinite loop i.e when they correctly guess the age
elif [ $random_age -gt $age ] ; then
echo -e "Guess is lower than the mystery age.\n"
elif [ $random_age -lt $age ] ; then
echo -e "Guess is higher than the mystery age.\n"
else
echo -e "not valid.\n"
fi
done
echo -e "Well done $name!, you correctly guessed that the mystery age was $random_age."