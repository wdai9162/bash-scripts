# #!/bin/bash
# echo -n 'hello, $USER ='
# echo  "$USER"
# echo  "\$USER=$USER"   # "\" makes this line to do the same thing as above 


# X=""
# echo "$X"
# if [ -n "$X" ]            # "-n" tests to see if the length of string is greater than 0 
#   then   
#     echo "the variable X is not a empty string"
# fi 


# LS="ls"
# LS_FLAGS="-al"

# # $LS $LS_FLAGS $HOME 

# X=abc;

# echo "$Xabc"       #doesn't work because variable Xabc not exist 
# echo "${X}abc"

# # if condition
# # then
# # 	statement1
# # 	statement2
# # 	..........
# # else
# # 	statement3
# # fi
# # alternatively, it is p

# # if condition1
# # then
# # 	statement1
# # 	statement2
# # 	..........
# # elif condition2
# # then
# # 	statement3
# # 	statement4
# # 	........    
# # elif condition3
# # then
# # 	statement5
# # 	statement6
# # 	........    

# A=3
# B=4


# # if [ "$A" -lt "$B" ]
# #   then 
# #     echo "\$A=${A}, which is smaller than \$B=${B}"
# # fi 

# not_empty_string="abc"

# if [ -n "$not_empty_string" ]
#   then 
#     echo '$not_empty_string is NOT empty'
# fi

# empty_string=""

# if [ -z "$empty_string" ]
#   then 
#     echo '$empty_string is empty'
# fi

# NUM1=5
# NUM2=5

# if [ -d "/home/idd/bash_scripts" ]
#   then 
#     echo '/home/idd/bash_scripts exists'
# fi

# # if [ -e "$HOME/bash_shell/script.sh" ]               # file exists then return TRUE
# #   then 
# #     echo "you have bash_shell file"
# #     if [ -L "$HOME/bash_shell/script.sh" ]           # file is a symbolic link then return TRUE
# #       then 
# #         echo "it's a symbolic link"
# #     elif [ -f "$HOME/bash_shell/script.sh" ]         # file is a regular file then return TRUE 
# #       then 
# #         echo "it's a regular file"
# #     fi
# # else 
# #   echo ".fvwmrc doesn't exist"
# # fi


# ###################LOOPS############################.

# for X in red green blue
# do
# 	echo $X
# done

# for X in '~/bash_scripts/*.sh'
# do 
#   echo $X 
# done 


# X=ABC
# echo "${X}abc"

# # read -n1 input
# # if [[ "$input" == "Y" || "$input" == "y" ]];then
# #     echo "YES"
# #     elif [[ "$input" == "N" || "$input" == "n" ]];then
# #     echo "NO"
# # fi


# # IFS=$'\n' read -r -d '' -a my_array < <(seq 5 && printf '\0' )

# read -a my_array < <(seq 5 && printf)

# echo ${#my_array[@]}  

# # SUM=0
# # for i in ${!my_array[@]} 
# # do 
# #   SUM=$((SUM+i))
# # done

# # echo $((SUM/${my_array[0]}))


# # read -s -p "Please type your password: " password       #-s hide user input, i.e $password
# # echo $password

# # read -p "Please type your name: " firstname lastname    #-p prompt message and read the variable
# # echo $firstname
# # echo $lastname

# # echo “Please type your name, age, and email”            #-a read input as an array
# # read -a newArray name age email
# # echo “Your name, age, and email address are: ${newArray[@]}”



#Arithmetic Operations
read INPUT
printf "%.3f" $(echo "$INPUT"|bc -l)


#Compute the Average
#IFS=$'\n' read -r -d '' -a my_array < <( seq 10 )
# IFS=$'\n' read -r -d '' -a my_array
# read -r -d '' -a my_array

read -d '' -a my_array
NUM=${my_array[0]}
SUM=0  
for i in ${my_array[@]}
do 
  SUM=$((SUM+i))
done

printf "%.3f" $(echo "($SUM-$NUM)/$NUM" | bc -l)