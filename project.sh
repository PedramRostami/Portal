#!/bin/bash
#project.sh
#function login()
#{

#}
function register()
{
	username=$2
	password=$3
	touch users.txt
	input="users.txt"
	isNew="1"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		linelen=${#line}
		if [[ "$linelen" -gt 1 ]]; then
			key="$(cut -d':' -f1 <<<$line)"
			if [ $key == "user" ]; then
				value="$(cut -d':' -f2 <<<$line)"
				if [[ "$value" == "$username" ]]; then
					isNew="0"
				fi
			fi
		fi
	done < "$input"
	if [ $isNew = "1" ]; then
		echo "user:$username" >> users.txt
		echo $'\r' >> users.txt
		echo "pass:$password" >> users.txt
		echo $'\r' >> users.txt
		echo "User Added Successfully!"
		mkdir $username
	else
		echo "Adding User Occurs Problem"
	fi
}
function login()
{
	username=$2
	password=$3
	rightUser="0"
	rightPassword="0"
	input="users.txt"
	isLogin="0"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		linelen=${#line}
		if [[ "$linelen" -gt 1 ]]; then
			key="$(cut -d':' -f1 <<<$line)"
			if [ $key == "user" ]; then
				value="$(cut -d':' -f2 <<<$line)"
				if [[ "$value" == "$username" ]]; then
					rightUser="1"
				fi
			fi
			if [ $key == "pass" ] && [ $rightUser == "1" ]; then
				value="$(cut -d':' -f2 <<<$line)"
				if [[ "$value" == "$password" ]]; then
					rightPassword="1"
				else
					rightUser="0"
				fi
			fi
			if [ $rightUser == "1" ] && [ $rightPassword == "1" ]; then
				isLogin="1"
				break;
			fi
		fi
	done < "$input"
	if [ $isLogin == "1" ]; then
		echo $username
	else
		echo $isLogin
	fi
}
function makeDirectory()
{
	directoryName=$2
	mkdir $directoryName
}
function makeFile()
{
	fileName=$2
	if [[ $fileName == *"."* ]]; then
		touch $fileName
	else
		fileName="$fileName.txt"
		touch $fileName
	fi
}
function write()
{
	errorCode="0"
	fileName=$2
	for i in `ls`; do 
		file=$i; 
		if [[ $file == *"."* ]]; then
			#file
			value="$(cut -d'.' -f1 <<<$file)"
			if [ $value == $fileName ]; then
				errorCode="1"
				while true; do
					echo "write in $value :"
					read line
					if [ $line == "endwriting" ]; then
						break;
					else
						echo "$line" >> $file
					fi
				done
			fi
		else
			#directory
			cd $file
			for j in `ls`; do
				innerFile=$j
				if [[ $innerFile == *"."* ]]; then
					value="$(cut -d'.' -f1 <<<$innerFile)"
					if [ $value == $fileName ]; then
						errorCode="1"
						while true; do
							echo "write in $value :"
							read line
							if [ $line == "endwriting" ]; then
								break;
							else
								echo "$line" >> $innerFile
							fi
						done
					fi
				fi
			done;
			cd "../"
		fi
	done;
	if [ $errorCode == "0" ]; then
		echo "Not Founded"
	fi 
}
function open()
{
	errorCode="0"
	fileName=$2
	for i in `ls`; do
		file=$i
		if [[ $file == *"."* ]]; then
			#user root directory
			name="$(cut -d'.' -f1 <<<$file)"
			format="$(cut -d'.' -f2 <<<$file)"
			if [ $format == "zip" ] && [ $name == $fileName ]; then
				unzip -l $file
				errorCode="1"
			fi
			if [ $format == "txt" ] && [ $name == $fileName ]; then
				input=$file
				while IFS='' read -r line || [[ -n "$line" ]]; do
					echo $line
				done < "$input"
				errorCode="1"
			fi
		else
			#user inner directory
			cd $file
			for j in `ls`; do
				innerFile=$j
				innerName="$(cut -d'.' -f1 <<<$innerFile)"
				innerFormat="$(cut -d'.' -f2 <<<$innerFile)"
				if [ $innerFormat == "zip" ] && [ $innerName == $fileName ]; then
					errorCode="1"
					unzip -l $innerFile
				fi
				if [ $innerFormat == "txt" ] && [ $innerName == $fileName ]; then
					input=$innerFile
					while IFS='' read -r line || [[ -n "$line" ]]; do
						echo $line
					done < "$input"
					errorCode="1"
				fi
			done;
			cd "../"
		fi
	done;
	if [ $errorCode == "0" ];then
		echo "Not Founded"
	fi
}
function list()
{
	ls
}
function math()
{
	operand=$2
	operator1=$3
	operator2=$4
	num_reg='^[-+]?[0-9]+'
	zero_reg='^[-+]?[0]+'
	if [ $operand == "+" ] || [ $operand == "-" ] || [ $operand == "*" ] || [ $operand == "/" ]; then
		if [[ $operator1 =~ $num_reg ]] && [[ $operator2 =~ $num_reg ]]; then
			if [ $operand == "+" ]; then
				res=$((operator1+operator2))
				echo $res
			elif [ $operand == "-" ]; then
				res=$((operator1-operator2))
				echo $res
			elif [ $operand == "x" ]; then
				res=$((operator1*operator2))
				echo $res
			elif [ $operand == "/" ]; then
				if [[ $operator2 =~ $zero_reg ]]; then
					echo "math error: division by zero"
				else
					res=$((operator1/operator2))
					echo $res
				fi
			fi
		else
			echo "input error"
		fi
	else
		echo "operand error"
	fi;
}
function retrieve() 
{
	word=$2
	containFiles=""
	for i in `ls`; do
		file=$i
		if [[ $file == *"."* ]]; then
			#file
			filename="$(cut -d'.' -f1 <<<$file)"
			fileFormat="$(cut -d'.' -f2 <<<$file)"
			if [ $fileFormat == "txt" ]; then
				input=$file
				while IFS='' read -r line || [[ -n "$line" ]]; do
					if [[ $line == *"$word"* ]]; then
						containFiles="$containFiles $filename"
						break
					fi
				done < "$input"
			fi
		else
			#directory
			cd $file
			for j in `ls`; do
				innerFile=$j
				if [[ $innerFile == *"."* ]]; then
					innerFilename="$(cut -d'.' -f1 <<<$innerFile)"
					innerFileFormat="$(cut -d'.' -f2 <<<$innerFile)"
					if [ $innerFileFormat == "txt" ]; then
					input=$innerFile
						while IFS='' read -r line || [[ -n "$line" ]]; do
							if [[ $line == *"$word"* ]]; then
								containFiles="$containFiles $innerFilename"
								break
							fi
						done < "$input"
					fi
				fi
			done;
			cd "../"
		fi
	done;
	echo $containFiles
}
function f1()
{
	reg='L\s*'
	#[[ $1 =~ $kREGEX_DATE ]]
	[[ $1 =~ $reg ]]
	echo $?
}

clear;
loginUser="0"
login_reg='Login\s*'
register_reg='Register\s*'
make_directory_reg='maked\s*'
make_file_reg='makef\s*'
write_reg='write\s*'
open_reg='open\s*'
list_reg='list'
math_reg='math\s*'
retrieve_reg='retrieve\s*'
logout_reg='Logout\s*'
exit_reg='exit\s*'
while true; do
	echo "enter your command :"
	read cmdline;
	if [[ $cmdline =~ $register_reg ]]; then
		if [ $loginUser == "0" ]; then
			register $cmdline
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $login_reg ]]; then
		if [ $loginUser == "0" ]; then
			loginUser=$(login $cmdline)
			if [ $loginUser != "0" ]; then
				echo "wellcome $loginUser"
				cd $loginUser
			else
				echo "wrong password or username"
			fi
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $make_directory_reg ]]; then
		if [ $loginUser != "0" ]; then
			makeDirectory $cmdline
			echo "your directory created!"
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $make_file_reg ]]; then
		if [ $loginUser != "0" ]; then
			makeFile $cmdline
			echo "your file created!"
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $write_reg ]]; then
		if [ $loginUser != "0" ]; then
			write $cmdline
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $open_reg ]]; then
		if [ $loginUser != "0" ]; then
			open $cmdline
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $list_reg ]]; then
		if [ $loginUser != "0" ]; then
			list $cmdline
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $math_reg ]]; then
		if [ $loginUser != "0" ]; then
			math $cmdline
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $retrieve_reg ]]; then
		if [ $loginUser != "0" ]; then
			containFiles=$(retrieve $cmdline)
			echo $containFiles
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $logout_reg ]]; then
		if [ $loginUser != "0" ]; then
			echo "Goodbye $loginUser"
			loginUser="0"
			cd "../"
		else
			echo "access deny"
		fi
	fi
	if [[ $cmdline =~ $exit_reg ]]; then
		exit
	fi
done
