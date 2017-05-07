#!/bin/bash

clear
rand=$RANDOM
if [[ ! -f score ]]
then
	echo 0 > score
fi
best=$(<score)

function game {
	read -p "How difficult would you like the game to be, from level 1-5? (1 = 1-digit random number, 5 = 5-digit random number) " diff
	secret=${rand:0:$diff}
	count=1

	if (($secret < 10000 && $diff == 5))
	then
		rand2=$RANDOM
		secret=$secret${rand2:0:1}
	fi

	showRandom

	read -p "Guess a random $diff digit number! " guess
	while [[ $guess != $secret ]]
	do
		((count++))
		if (($guess < $secret))
		then
			echo -n -e "\e[34m$guess\e[0m is \e[31mtoo low!\e[0m Try again! "
			read guess
		else
			echo -n -e "\e[34m$guess\e[0m is \e[31mtoo high!\e[0m Try again! "
			read guess
		fi
	done

	if [[ "$count" -eq "1" ]]
	then
		echo
		echo -e "\e[32mCorrect!\e[0m \e[34m$secret\e[0m was the right number! You got it in \e[96m$count guess\e[0m! How did you know?!"
	else
		echo
		echo -e "\e[32mCorrect!\e[0m \e[34m$secret\e[0m was the right number! It took you \e[96m$count guesses\e[0m! Good job!"
	fi

	#logic for output about their lowest number of guesses
	if [[ "$count" -eq "$best" ]] && [[ "$best" -eq "1" ]]
	then
		echo -e "Your lowest number of guesses was already \e[36m1\e[0m. A winner is still you! Try a higher difficulty, or delete the score file."
		echo
	elif [[ "$count" -eq "$best" ]] && [[ "$best" -ne "1" ]]
	then
		echo -e "Your current number of guesses was tied for your best at \e[36m$count guesses\e[0m. You were so close!"
		echo
	elif [[ "$count" -lt "$best" ]] || [[ "$best" -eq "0" ]]
	then
		prevBest=$best
		best=$count
		echo $best > score
		if [[ "$prevBest" -eq "0" ]] && [[ "$best" -ne "1" ]]
		then
			echo -e "You set a new record for the lowest number of guesses at \e[36m$best\e[0m. Play again and see if you can beat it!"
			echo
		elif [[ "$prevBest" -eq "0" ]] && [[ "$best" -eq "1" ]]
		then
			echo -e "You set a new record for the lowest number of guesses at \e[36m$best\e[0m. Try a higher difficulty, or delete the score file."
			echo
		else 
			echo -e "You beat your previous record of \e[36m$prevBest guesses\e[0m! Good job!"
			echo
		fi
	elif [[ "$count" -gt "$best" ]] && [[ "$best" -eq "1" ]]
	then
		echo -e "You did not beat your record of \e[36m$best guess\e[0m! Better luck next time!"
		echo
	else
		echo -e "You did not beat your record of \e[36m$best guesses\e[0m! Better luck next time!"
		echo
	fi
}

#Function to show the current Random Number, for testing
function showRandom {
	if (($secret < 10))
	then
		echo "$secret is 1 number long"
	elif (($secret < 100))
	then
		echo "$secret is 2 numbers long"
	elif (($secret < 1000))
	then
		echo "$secret is 3 numbers long"
	elif (($secret < 10000))
	then
		echo "$secret is 4 numbers long"
	elif (($secret < 100000))
	then
		echo "$secret is 5 numbers long"
	fi
}
game