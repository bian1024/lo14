#!/bin/bash


# Function


function printSyntaxError {
	echo 'Syntax Error:'
	echo 'rvsh -c [--connect] machine_name user_name: connect an user to a machine'
	echo 'rvsh -a [--admin]: connect to admin'
}


function printFileError {
	echo 'File Error:'
	echo 'Make sure files admin, connect, log, users, machine are in the respertory!'
}


function adminLogin {
# $1: userName $2:machine to connect
	flag=flase

	while read login level password;
	do
		if [[ $login == $1 ]] && [[ $level == 0 ]] && [[ $password == $2 ]]
		then
			flag=true
			break
		fi
	done < users


	if [ $flag == true ]
	then
		echo 'Login admin successful'
		echo 'Hello admin'
		sleep 2
		clear
		./admin $1
	else
		echo 'login error or password error!'
		exit
	fi

}


function connectLogin {

# $1: userName $2:machine to connect $3: password
	flag1=false
	flag2=false
	flag3=false

	while read userName userLevel password
	do
		if [[ $userName == $1 ]] && [[ $password == $3 ]]
		then
			flag1=true
			echo 'Password right, search $2'

			while read machine levelMachine
			do

				if [ $machine == $2 ]
				then

					flag2=true
					echo 'Try to connect to $machine'
					
					if [ $userLevel -lt $levelMachine ] || [ $userLevel == $levelMachine ]
					then

						flag3=true
						break

					else
						echo "$userName haven't suffient right for $machine"
						exit
					fi

				fi

			done < machines
		fi

		if [[ $flag3 == true ]]
		then
			#statements
			break
		fi

	done < users

	if [ $flag1 == true ] && [ $flag2 == true ] && [ $flag3 == true ]
	then
		echo 'Connexion successful'
		echo 'We already connect $1 to $2'
		sleep 2
		clear
		./connect $1 $2

	
	elif [ $flag1 == false ]
	then

		#statements
		echo "User or password not correct!"
		exit

	elif [ $flag2 == false ]
	then

		#statements
		echo "We can't find $2"
		exit

	fi
}
# Main



if [ ! -f admin ] || [ ! -f connect ] || [ ! -f users ] 
then
	printFileError
else
	if [[ $1 == '--admin' ]] || [[ $1 == '-a' ]]; then

		#statements
		echo 'Mode Admin:'
		echo 'Password of admin:'
		read -s password
		echo 'Wait...'
		adminLogin 'admin' $password

	elif [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
		echo 'help....'
	elif [[ $1 == '--connect' ]] || [[ $1 == '-c' ]] && [[ $# -eq 3 ]]; then

		#statements
		echo "Mode Connect: connet to $2"
		echo "Password of $3:"
		read -s password
		echo 'Wait...'
		connectLogin $3 $2 $password

	else
		printSyntaxError
	fi

fi
