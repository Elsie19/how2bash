#!/bin/bash

tabs -4

speed=35
while getopts ':ps:' OPTION; do
    case "${OPTION}" in
        p) SPEED=1 ;;
        s) speed="${OPTARG}" ;;
        *) exit 1 ;;
    esac
done
if [[ ${1} == "-p" ]]; then SPEED=1; fi

function print() {
    if command -v pv &> /dev/null && [[ -z $SPEED ]]; then
        echo -e "${@}" | pv -qL "${speed}"
    else
        echo -e "${@}"
    fi
}

function print_no_line() {
    if command -v pv &> /dev/null && [[ -z $SPEED ]]; then
        echo -ne "${@}" | pv -qL "${speed}"
    else
        echo -ne "${@}"
    fi
}

function println() {
    local i
    for ((i = 0; i < ${1}; i++)); do
        echo
    done
}

function span() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

function code() {
    print "\t\t\$ ${*}"
}

function code_output() {
    print "\t\t${*}"
}

function display_center() {
    local line
    while IFS= read -r line; do
        printf "%*s\n" $(((${#line} + COLUMNS) / 2)) "${line}"
    done <<< "${1}"
}

function next_section_prompt() {
    read -n 1 -s -r -p "> Press any character to go to the next lesson"
}

function countdown() {
    for i in $(seq "${1}" -1 1); do
        echo -ne "\rStarting in $i "
        sleep 1
    done
}

function press_continue() {
    read -n 1 -s -r -p $'\tPress any character to continue.'
}

print "Welcome to how2bash!"
print "Lets learn the basics. You are encouraged to run these examples in a separate terminal and experiment with them."
press_continue
println 1
clear

# 1.0
span
display_center "[ 1.0 PRINTING OUTPUT TO THE CONSOLE ]"
println 2
print_no_line "\t\t\$ echo \"Here is input that will be printed to the screen. Press enter to run\""
read -n 1 -s -r
println 1
code_output "Here is input that will be printed to the screen. Press enter to run"
println 2
sleep 0.3
print "\tHere we use 'echo' to print text to the screen followed by the text we want enclosed in double quotes."
print "\tIf we use single quotes, we can do literal strings and prevent variable and command substitution (this will be explained later)."
println 1
span
next_section_prompt

# 1.1
clear
span
display_center "[ 1.1 VARIABLES ]"
println 2
print "\tVariables in bash behave slightly differently than most programming languages."
print "\tTo declare a variable, we use the syntax: 'var_name=foo'."
print "\tWhen used, they should look like: \${var_name}. You can do things like 'echo \"\${var_name}\"'!"
print "\tNow, I will drop you into a bash shell where you can experiment with variables. Press '<ctrl> D' when you are finished testing."
press_continue
println 2
span
PS1='$ ' bash --norc -r
span
println 1
print "\tHopefully you have experimented with variables enough now!"
print "\tYou could even assign a variable to another variable with 'var_name=\"\${foo}\"'"
println 1
span
next_section_prompt

# 1.2
clear
span
display_center "[ 1.2 VARIABLE EXPANSION ]"
println 2
print "\tThis is one of the hardest parts about bash imo, so pay attention."
print "\tSometimes assigning variables to static text and other variables is limiting, so bash has some facilities to make variables more powerful."
print "\tWe're only going to cover the main ones that you are most likely to use."
println 1
print "\t\t  - \${}   - Variable substitution"
print "\t\t  - \$()   - Command substitution"
print "\t\t  - \$(()) - Arithmetic substitution"
println 1
print "\tWe've already covered the *basics* of variable substitution so we'll skip that for now."
print "\tCommand substitution is essentially a way of assigning the output of a command to a variable."
println 1
code "foo=\"\$(pwd)\" # This will assign the variable 'foo' to the output of the command 'pwd'."
println 1
print "\tArithmetic substitution evaluates math into a variable. One thing to note is that variables inside do not need variable substitution!"
println 1
span
code "num=256"
code 'echo $((num + 4))'
code_output "260"
span
println 1
span
next_section_prompt

# 1.3
clear
span
display_center "[ 1.3 STRING SPLITTING ]"
println 2
print "\tIn the last section, I mentioned that variable expansion is one of the hardest parts about bash. This section will be the hardest :)"
print "\tEvery string in bash can be split, meaning that spaces will be evaluated differently dependening on many factors at play."
print "\tTo put it bluntly, string splitting is a demon inside bash that will devour you if you do not pay attention..."
print "\tLet's start with a simple example:"
println 1
span
print_no_line "\t\t\$ echo Push that word         away from me. Press      enter   to         run"
read -n 1 -s -r
println 1
code_output "Push that word away from me. Press enter to run"
span
println 1
print "\tThat's weird... None of the spacing was preserved. Let's try with quotes instead:"
println 1
span
print_no_line "\t\t\$ echo \"Push that word         away from me. Press      enter   to         run\""
read -n 1 -s -r
println 1
code_output "Push that word         away from me. Press      enter   to         run"
span
println 1
print "\tSo if we put quotes around it, we don't split strings and we never have to worry about this again?"
sleep 0.8
print "\tYes, but there are times where we must use string splitting, so let's examine *why* and *how* it happens."
println 1
print "\tEvery single word that was passed to the unquoted echo was an 'argument'. Bash determines what an argument is by it's whitespace."
print "\tSo what really happened in the first example was that every word was split into individual arguments, disregarding the whitespace."
print "\tIn the second argument, we quoted the arguments, forcing bash to make that a single argument spanning multiple words and whitespace."
println 1
sleep 0.5
print "\tTo make things more complicated, string splitting doesn't just happen on literal strings..."
print "\tIt can happen after parameter expansion!!"
println 1
span
code 'sentence="Push that word         away from me."'
code 'echo ${sentence}'
code_output "Push that word away from me."
span
println 1
print "\tWe're smarter than this though, so let's add those double quotes to the variable."
println 1
span
code 'echo "${sentence}"'
code_output "Push that word         away from me."
span
println 1
print "\tWhat happened was that bash expanded the sentence and split it up into individual arguments by whitespace, meaning that every *word* is an argument, discluding the whitespace."
print "\tIn the quoted example, the quotes forced bash to accept that as a *single* argument, without string splitting."
println 1
print "\tTo make matters worse, string splitting happens not only on whitespace, but tabs, newlines, and any character in the 'IFS' variable."
print_no_line "\tLet's take a breather before we go to the next example..."
read -n 1 -s -r
println 1
print "\tLet's combine all our knowledge of the past 3 lessons into one example:"
println 1
span
print_no_line "\t\t\$ echo \"\$(ls -al /)\""
read -n 1 -s -r
println 1
exec 3>&1
exec 1> >(paste /dev/null -)
echo "$(ls -al /)"
exec 1>&3 3>&-
span
println 2
print "\tLet's unquote it now:"
println 1
span
print_no_line "\t\t\$ echo \$(ls -al /)"
read -n 1 -s -r
println 1
exec 3>&1
exec 1> >(paste /dev/null -)
echo $(ls -al /)
exec 1>&3 3>&-
span
println 1
print "\tOk... So what about when we do need to split strings?"
print "\tIn this next example, we will use a for loop, which we will discuss later, but hopefully you can follow."
println 1
span
code 'friends="Lily Oren AJ Sourajyoti"'
code 'for friend in ${friends}; do'
print "\t\t> echo \"\${friend} is my friend\"; done"
for i in {Lily,Oren,AJ,Sourajyoti}; do
    code "${i} is my friend"
done
span
println 1
print "\tDid you understand how the string splitting worked on our favor?"
print "\tBecause we didn't quote the variable in the for loop line, it split by whitespace, leaving the loop to run through each name!"
print "\t*However*, you should be very careful and intentional about using this behavior in your favor, because any malformed input will blow up in your face."
println 1
span
next_section_prompt

# 1.4
clear
span
display_center "[ 1.4 ARRAYS ]"
println 2
print "\tSo far we've been using variables to do all our heavy work, but you can only get so far with variables, so bash has arrays that we can use."
print "\tWe declare an array like so:"
println 1
span
code "names=('Lily' 'Oren' 'AJ' 'Sourajyoti')"
span
println 1
print "\tLet's try interacting with it like it's a variable first, which will print the first element:"
println 1
span
code 'echo ${names}'
code_output "Lily"
span
println 1
print "\tIf we want to access the elements in the array, we have 3 options:"
println 1
print "\t\t  - [*] - Unquoted subscript"
print "\t\t  - [@] - Quoted subscript"
print "\t\t  - [i] - Number subscript"
println 1
print "\tLet's start with the unquoted subscript. You can simply think of it like an unquoted variable."
print "\tWhen we use it, it will print the entire array. If we quote the array, it will act like a single argument."
print "\tIf we do not quote, it will act like multiple arguments."
println 1
span
code 'names=("John           Doe" "Jane    Doe")'
code 'echo ${names[*]}'
code_output "John Doe Jane Doe"
span
println 1
print "\tLet's try quoting it now:"
println 1
span
code 'echo "${names[*]}"'
code_output "John           Doe Jane    Doe"
span
println 1
print "\tThe gist of unquoted subscripts is to use it when you need an array to act like a string."
println 1
print "\tLet's do quoted subscripts. These are much nicer than unquoted subscripts."
print "\tBoth unquoted and quoted subscripts act the exact same when unquoted. Quoted subscripts will behave differently when quoted, as the name implies."
print "\tQuoted subscripts will expand each element of the array to individual arguments."
print "\tIf that's confusing, we'll walk through an example of how bash would \"see\" a quoted subscript:"
println 1
span
code "perls=(perl-one perl-two)"
code 'echo "${perls[*]}"'
code_output "perl-one perl-two"
code 'echo "${perls[@]}"'
code_output "perl-one perl-two"
span
println 1
print "\tDid you catch it? Probably not, because bash didn't show you what it was doing."
print "\tIn the unquoted subscript, 'echo' was being passed this string:"
println 1
span
code 'echo "perl-one perl-two"'
span
println 1
print "\tAnd in the quoted subscript it was being passed this:"
println 1
span
code 'echo "perl-one" "perl-two"'
span
println 1
print "\tPretty neat huh?"
println 1
print "\tAfter all that explaining, we still have one last way to access elements, but it's the easiest."
print "\tWe can use [i] to access the element in that position in the array."
print "\tLike most programming languages, bash uses a zero-indexed array, meaning that the first element is index 0."
print "\tTo better show this, let's do an example:"
println 1
span
code "perls=(perl-one perl-two perl-three perl-four)"
print_no_line "\t\t\$ declare -p perls"
read -n 1 -s -r
println 1
code_output 'declare -a perls=([0]="perl-one" [1]="perl-two" [2]="perl-three" [3]="perl-four")'
code 'echo "${perls[2]}"'
code_output "perl-three"
span
println 1
print "\tTo sum up:"
print "\t\t  - [*] - Use when you want array to act like a variable"
print "\t\t  - [@] - Use when you want array to act like an array"
print "\t\t  - [i] - Use to get individual element"
println 1
print "\tSo we can now create arrays and use them, but how do we make use of them?"
print "\tWe're going to explore three things:"
print "\t\t - 'unset' command"
print "\t\t - associative arrays"
print "\t\t - += operator"
println 1
press_continue
println 2
print "\tThe unset command is used to remove an element from an index. Suppose we have the following array:"
println 1
span
code "perls=(perl-one perl-two perl-three perl-four)"
code "unset 'perls[1]'"
span
println 1
print "\tWhat that did was remove index 1 of perls, which was the element 'perl-two'. One important thing to note is that bash will not shift the indices when using 'unset'."
print "\tWe can see this with 'declare -p perls':"
println 1
span
print_no_line "\t\t\$ declare -p perls"
read -n 1 -s -r
println 1
code_output 'declare -a perls=([0]="perl-one" [2]="perl-three" [3]="perl-four")'
span
println 1
print "\tNow what we *could* do to shift the array is by reassigning perls to perls:"
println 1
span
code 'perls=("${perls[@]}")'
span
println 1
print "\tThis should be familiar. If we were to use [*] instead, what would it do?"
PS3="Enter a number: "
options=(
    "Split every element into a new argument"
    "Split array into one argument"
)
select num in "${options[@]}"; do
    case "${num}" in
        "Split every element into a new argument")
            print "\tYou are incorrect." && break
            ;;
        "Split array into one argument")
            print "\tYou are correct!" && break
            ;;
        *) echo "Invalid option ${REPLY}" ;;
    esac
done
print "\t[@] will expand to every element as it's own quoted string!"
println 1
print "\tLet's move onto associative arrays."
print "\tThese are useful when you want to have known indices:"
println 1
span
code 'declare -A capitals=([US]="Washington DC" [Spain]="Madrid" [India]="New Delhi")'
code "echo \"\${capitals['Spain']}\""
code_output "Madrid"
code "echo \"\${capitals['India']}\""
code_output "New Delhi"
span
println 1
print "\tWe can also use 'unset' on associative arrays, but we'd use the named index instead of a number."
println 1
print "\tLast is the += operator. This is used to add elements to an array:"
println 1
span
code "nums=(1 2 3 4)"
print_no_line "\t\t\$ nums+=(5)"
read -n 1 -s -r
println 1
code 'echo "${nums[*]}"'
code_output "1 2 3 4 5"
span
println 1
span
next_section_prompt

# 1.5
clear
span
display_center "[ 1.5 LOOPS ]"
println 2
print "\tIn this lesson, we'll look at a couple types of loops:"
println 1
print "\t\t  - For loops"
print "\t\t  - While loops"
print "\t\t  - Until loops"
println 1
print "\tLet's start with the most complicated loop in bash, which is the for loop."
print "\tThis is the basic structure of a for loop:"
println 1
print "\t\tfor <structure>; do"
print "\t\t  [COMMANDS]"
print "\t\tdone"
println 1
print "\tThe <structure> can be one of three things:"
println 1
print "\t\t  - C-style"
print "\t\t  - Ranges"
print "\t\t  - Brace"
println 1
press_continue
println 2
print "\tThe C-style should be the easiest if you are coming from a C-inspired language:"
println 1
print "\t\t((initialize ; condition ; increment))"
println 1
print "\tIf we wanted to loop from 0-10, including 10, we could write:"
println 1
print "\t\tfor ((i=0; i <= 10; i++)); do"
print "\t\t  [COMMANDS]"
print "\t\tdone"
println 1
press_continue
println 2
print "\tThe most common type of loop is the range loop, used with arrays and items:"
println 1
print "\t\tvar in [LIST]/\"\${array[@]}\""
println 1
print "\tIf we wanted to loop from 0-10, including 10, we could write:"
println 1
span
print "\t\tfor i in 0 1 2 3 4 5 6 7 8 9 10; do"
print "\t\t  array+=(\"\${i}\")"
print "\t\tdone"
print "\t\tfor i in \"\${array[@]}\"; do"
print "\t\t  echo \"\${i}\""
print "\t\tdone"
span
println 1
press_continue
println 2
print "\tBrace syntax is simple yet static, you cannot make a dynamic range without a range loop:"
println 1
print "\t\t{start..end[..increment]}"
println 1
print "\tIf we wanted to loop from 0-10, including 10, we could write:"
println 1
print "\t\tfor i in {0..10}; do"
print "\t\t  [COMMANDS]"
print "\t\tdone"
println 1
print "\tIf we wanted to loop from 0-10, including 10, incrementing by 2, we could write:"
println 1
span
print "\t\tfor i in {0..10..2}; do"
print "\t\t  [COMMANDS]"
print "\t\tdone"
span
println 1
press_continue
println 2
print "\tNext we have while loops:"
println 1
print "\t\twhile <condition>; do"
print "\t\t  [COMMANDS]"
print "\t\tdone"
println 1
print "\tIf we wanted to print 1-100, we could write:"
println 1
span
print "\t\twhile ((i != 100)); do"
print "\t\t  echo \"\${i}\""
print "\t\t  ((i++))"
print "\t\tdone"
span
println 1
print "\tThe until loop is the same as a while loop, but the test condition runs as long as it's false, rather than true."
println 1
span
next_section_prompt

# 1.6
clear
span
display_center "[ 1.6 FUNCTIONS ]"
println 2
print "\tIn this lesson, we'll look at functions:"
println 1
print "\t\t  - Function declaration"
print "\t\t  - Positional parameters"
print "\t\t  - Return vs stdout"
print "\t\t  - Local variables"
println 1
print "\tFunction declarations are very simple. You have 3 ways of specifying one:"
println 1
code "function foo() [{}/()]"
code "function foo [{}/()]"
code "foo() [{}/()]"
println 1
print "\tMost people should use the first option, and use the last one for maximum POSIX compliance."
print "\tYou may notice that you have the option of {} or () for function openings. In short:"
println 1
print "\t\t  - Brace syntax: {}"
print "\t\t\tUsed for functions that can effect the global state"
print "\t\t  - Subshell syntax: ()"
print "\t\t\tUsed for functions that you do not *want* effecting the global state or to create a temporary copy of the global state"
println 1
print "\tThe rule of thumb is to use {} unless you can think of a reason to use ()."
println 1
span
print "\t\tfunction multiply_five() {"
print "\t\t  echo \$((\${1} * 5))"
print "\t\t}"
code 'output="$(multiply_five 5)"'
span
println 1
print "\tNow that's weird... Didn't you say that we don't need variable expansion in arithmetic substitution? And why is the number '1' a variable???"
print "\tBasically, disregard the fact that '1' is a variable for now. Arithmetic substitution says we don't have to include variable expansion, but if we dropped it"
print "\twe'd be left with the *number* 1, which bash will interpret as a number, not the variable."
println 1
print "\tLet's get to the big issue now, what the heck is \${1}? That's called a positional parameter, and they're bash's way of function parameters in other languages."
print "\tThey can go from 1 to infinity if you really wanted. One important thing to know is that parameters 1-9 can be a bare variable (\$1, \$9), but once you hit 10, you must"
print "\tuse variable expansion (\${10}), but since we've been using variable expansion for everything, you don't have to worry about that!"
print "\tThere are two more positional parameters to know about:"
println 1
print "\t\t  - All input as array, treat as [@] array:  \${@}"
print "\t\t\tYou can get the count of arguments (argc) like \${#@} (we'll discuss later in 1.8)"
print "\t\t  - All input as string, treat as [*] array: \${*}"
println 1
print "\tSo in the multiply_five() example, it takes the first argument passed and multiplies it by 5 and prints it back out!"
print "\tThere is one command that you will probably use later, called 'shift'. You can think of it like 'unset positional_parameters[0]' with reindexing!"
print "\tYou can even pass a number to 'shift' to shift the argument list *x* parameters:"
println 1
span
print "\t\tfunction shifting() {"
print "\t\t  echo \"\${1}\""
print "\t\t  shift"
print "\t\t  echo \"\${1}\""
print "\t\t}"
code "shifting foo bar"
code_output "foo bar"
span
println 1
print "\tNow an interesting thing about bash is that 'return' does not return information like most languages; It functions like 'exit' for functions instead."
print "\tWe use stdout in order to pass information out of a function."
println 1
press_continue
println 2
print "\tTo show this, let's write a function to check if a number is even or odd. If you're familiar with the modulo operator, this should be easy."
print "\tThis will use an if statement, which we will discuss next chapter:"
println 1
span
print "\t\tfunction is_even() {"
print "\t\t  if ((\${1} % 2 == 0)); then"
print "\t\t    return 0"
print "\t\t  else"
print "\t\t    return 1"
print "\t\t  fi"
print "\t\t}"
span
println 1
print "\tNow if we run:"
println 1
span
code "is_even 10"
code 'echo $?'
code_output "0"
code "is_even 11"
code 'echo $?'
code_output "1"
span
println 1
print "\tIf we wanted to pass out information alongside the return statement, we'd just add an 'echo' above 'return'."
println 1
press_continue
println 2
print "\tLast part of functions are local variables."
print "\tAn annoying part of bash is that all variables are global by default, including those in functions."
print "\tWe can get localized variables using the 'local' keyword:"
println 1
span
print "\t\tfunction is_even() {"
print "\t\t  local number=\"\${1}\""
print "\t\t  if ((number % 2 == 0)); then"
print "\t\t    return 0"
print "\t\t  else"
print "\t\t    return 1"
print "\t\t  fi"
print "\t\t}"
span
println 1
print "\tIt's good practice to declare all local variables at the top of the function and then use them normally after."
print "\tRemember that loops create variables, so those loop variables should be localized as well."
print "\thttps://github.com/Henryws/clam/blob/c259489d0bc707851fda081143be1740672586b6/headers/cmds/cat.sh#L4 for an example."
println 1
span
next_section_prompt

# 1.7
clear
span
display_center "[ 1.6 IF AND CASE STATEMENTS ]"
println 2
print "\tIn this lesson, we'll look at two types of control flow:"
println 1
print "\t\t  - If statemements"
print "\t\t  - Case statements"
println 1
print "\tIf statements are pretty simple, they can take 3 forms:"
println 1
code "if <condition>; then"
print "\t\t>   [COMMANDS]"
print "\t\t> fi"
println 1
code "if <condition>; then"
print "\t\t>   [COMMANDS]"
print "\t\t> else"
print "\t\t>   [COMMANDS]"
print "\t\t> fi"
println 1
code "if <condition>; then"
print "\t\t>   [COMMANDS]"
print "\t\t> elif <condition>; then"
print "\t\t>   [COMMANDS]"
print "\t\t> fi"
println 1
print "\t<condition> is a construct that must return true or false. It could be commands, conditionals, arithmetic conditionals, or a combination of those."
print "\tThese are a few of the ways to satisfy <condition>:"
println 1
print "\t\t  - Conditionals           : [[ ]]"
print "\t\t  - Arithmetic conditionals: (( ))"
print "\t\t  - Commands               : grep, find, etc"
println 1
print "\tConditionals are the hardest and **most** powerful part of bash, right after parameter expansion, so pay attention:"
println 1
code '[[ ${var} == "string" ]] # Equal to string'
code '[[ ${var} != "string" ]] # Not equal to string'
code '[[ ${var} =~ regex ]]    # Equal to regex'
code '[[ ${var} < "string" ]]  # Var sorts before string lexicographically'
code '[[ ${var} > "string" ]]  # Var sorts after string lexicographically'
code '[[ ${var} -eq num ]]     # Equal to number'
code '[[ ${var} -ne num ]]     # Not equal to number'
code '[[ ${var} -lt num ]]     # Less than number'
code '[[ ${var} -gt num ]]     # Greater than number'
code '[[ ${var} -ge num ]]     # Greater or equal to number'
code '[[ ${var} -le num ]]     # Less than or equal to number'
println 1
print "\tEvery single right side argument can be a variable as well. We don't have to quote the left hand argument, but we need to for the right side if we use a variable. We can even use globs (*) on string operations."
print "\tLet's take a breather, because we're not done yet with conditionals :)"
println 1
press_continue
println 2
print "\tThe next set of conditionals are flags, which are useful for checking the status of files, directories, variables, etc."
print "\tI'll print every single flag conditional, but I'll separate the most used ones for you."
println 1
print "\t String and file/directory flags (most commonly used)"
println 1
code '[[ -n ${var} ]]          # If string length is non-zero'
code "[[ -v varname ]]         # If varname is set"
code '[[ -z ${var} ]]          # If string length is zero'
code "[[ -f file ]]            # If regular file exists"
code "[[ -d dir ]]             # If directory exists"
println 1
print "\tFile and file descriptor flags (not used commonly)"
println 1
code "[[ -a/-e file ]]         # If file exists"
code "[[ -b file ]]            # If file exists and block special file"
code "[[ -g file ]]            # If file exists and has set-group-id bit set"
code "[[ -h/-L file ]]         # If file exists and is symbolic link"
code "[[ -k file ]]            # If file exists and sticky bit set"
code "[[ -p file ]]            # If file exists and is named pipe"
code "[[ -r file ]]            # If file exists and is readable"
code "[[ -s file ]]            # If file exists and size is greater than zero"
code "[[ -t fd ]]              # If file descriptor is open and refers to a terminal"
code "[[ -u file ]]            # If file exists and has set-user-id bit set"
code "[[ -w file ]]            # If file exists and is writable"
code "[[ -x file ]]            # If file exists and is executable"
code "[[ -G file ]]            # If file exists and is owned by effective group ID"
code "[[ -N file ]]            # If file exists and has been modified since last read"
code "[[ -O file ]]            # If file exists and is owned by effective user ID"
code "[[ -S file ]]            # If file exists and is socket"
println 1
print "\tThe rest of the flags (rarely used)"
println 1
code "[[ file1 -ef file2 ]]    # If file1 and file2 refer to same device and inode numbers"
code "[[ file1 -nt file2 ]]    # If file1 is newer than file2, or if file1 exists and file2 doesn't"
code "[[ file1 -ot file2 ]]    # If file1 is older than file2, or if file2 exists and file1 doesn't"
code "[[ -o optname ]]         # If optname is enabled (using 'set' builtin)"
code "[[ -R varname ]]         # If varname is set and is a name reference"
println 1
print "\tWe're now done with conditionals. If this is overwhelming, then forget the last two sections entirely. Next we have arithmetic conditionals, which should be used for"
print "\tall numerical conditions."
println 1
press_continue
println 2
print "\tArithmetic conditionals operate exactly like they do in C, besides the fact that bash cannot do floating point math."
print "\tArithmetic conditionals use (( )) to function, whereas in C they use ( )."
println 1
press_continue
println 2
print "\tFinally we have command conditionals, which are very simple. For example:"
println 1
span
code "if ping 1.1.1.1 -c1 > /dev/null; then"
print "\t\t>   echo \"We pinged cloudflare!\""
print "\t\t>   exit 0"
print "\t\t> else"
print "\t\t>   echo \"We failed!!!\""
print "\t\t>   exit 1"
print "\t\t> fi"
span
println 1
press_continue
println 2
print "\tAnd that's really all there is to if statements and conditionals. We have two last things, which are very simple, so don't worry."
println 1
print "\t\t - What if we wanted to invert the result of one of these conditionals/commands?"
print "\t\t - What if I want to check for multiple conditions at once?"
println 1
print "\tFor the first part, we have the bang operator: '!'. All we do is prefix the conditional with it:"
println 1
span
code "if ! ping 1.1.1.1 -c1 > /dev/null; then"
span
println 1
print "\tAnd that's all it takes to invert the result, so we are checking if it fails now, rather than if it succeeds."
println 1
print "\tThe last part, which is chaining, is super easy. We have two operators: '||' and '&&':"
println 1
span
code "if [[ -d /bedrock ]] && which brl || (( somevar == 5 )); then"
span
println 1
print "\tWhat this checks for is that '/bedrock' directory exists, that the 'brl' binary exists, but also that 'somevar' does not equal 5"
print "\tAnd that's all for if statements! Time for case statements."
println 1
press_continue
println 2
print "\tCase statments come in a couple forms:"
println 1
span
code 'case "${variable}" in'
print "\t\t>   match) # Equals"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;; # End of match. Same as 'break' in C"
print "\t\t>   match2 | match3) # Combine two matches in one group"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;& # Fallthrough. Same as not adding 'break' in C"
print "\t\t>   match4)"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;;& # Fallthrough but check next pattern"
print "\t\t>   [1-6]*) # Range of matches with a glob"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;;"
print "\t\t>   ?) # Covers non-{lowercase,uppercase,digits} single characters"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;;"
print "\t\t>   *) # Catch all"
print "\t\t>     [COMMANDS]"
print "\t\t>   ;;"
print "\t\t> esac"
span
println 1
print "\tMost of the time you will be using single or combined matches with ';;' to terminate a case. Rarely will you ever use ';&'. Always include a '*)' for safety."
println 1
span
next_section_prompt

# 1.8
clear
span
display_center "[ 1.8 REDIRECTION ]"
println 2
print "\tIn this section, we will go over redirection of output."
print "\tIn bash, we have a couple ways that output can go or come from:"
println 1
print "\t\t - stdin  (standard input)"
print "\t\t - stdout (standard output)"
print "\t\t - stderr (standard error)"
print "\t\t - heredocs"
print "\t\t - herestrings"
println 1
print "\tMost of what we've been dealing with is stdout, which simply prints to an output device, usually a terminal."
print "\tstdin is what programs accept as input from pipes."
print "\tstderr functions like stdout, but goes through a different stream so it *can* be filtered out if needed."
println 1
print "\tWe can see stdin in action by simply catting a file into less. Let's try with your '/etc/os-release':"
println 1
span
print_no_line "\t\t\$ cat /etc/os-release | less"
read -n 1 -s -r
println 1
cat /etc/os-release | less
span
println 1
print "\tSo what happened was that cat printed the contents of '/etc/os-release' to stdout, which the pipe picked up and passed as stdin to 'less'."
print "\tNow let's see how we can redirect output/input in our own programs!"
print "\tWe have 3 primary ways of redirecting IO:"
println 1
print "\t\t - '>'"
print "\t\t - '>>'"
print "\t\t - '<'"
println 1
print "\tLet's try the first one:"
println 1
span
print_no_line "\t\t\$ echo \"foo bar\" > /dev/null"
read -n 1 -s -r
println 1
sleep 1
span
println 1
print "\tWait, nothing happened..? Yep! Let's see how that happened."
print "\tThat '>' is what we call a redirect. It's job is to send stdout to a file, in our case, '/dev/null', which is a special file that swallows input it's given, like a blackhole."
print "\tWe mainly use '> /dev/null' to silence the stdout of a program, like we saw in the last chapter in the 'ping' example, but we could also redirect it to a file, which will be overwritten with the stdout."
print "\tLet's try '>>' now."
println 1
span
print_no_line "\t\t\$ echo \"foo bar\" >> my_file"
read -n 1 -s -r
println 1
print_no_line "\t\t\$ echo \"foo bar\" >> my_file"
read -n 1 -s -r
println 1
print_no_line "\t\t\$ cat my_file"
read -n 1 -s -r
println 1
code_output "foo bar"
code_output "foo bar"
span
println 1
print "\tThe '>>' redirect will redirect stdout to a file by appending, rather than overwritting with '>'."
println 1
print "\tThe last part is the '<' redirect. It's job is to redirect input:"
println 1
span
print_no_line "\t\t\$ less < /etc/os-release"
read -n 1 -s -r
println 1
less < /etc/os-release
span
println 1
print "\tSo what we did is bypassed the need to pipe cat into less but just redirecting the file contents as the input for less."
print "\tNow that we have the 3 basic redirects, we can start operating on more than just stdout and stdin. We can start to mess with stderr, or even a combination of them."
print "\tWe know that stderr will usually print just like stdout, but it has a separate stream it goes through before. Let's view an example of that."
print "\tBefore we start, we need to know a couple things:"
println 1
print "\t\t - 0: stdin"
print "\t\t - 1: stdout"
print "\t\t - 2: stderr"
println 1
print "\tThese numbers are what we call file descriptors. The first 3 file descriptors are set aside by bash for redirection purposes."
print "\tSo let's say we want to append stderr to a file, we would do '2>>', and if we wanted to overwrite, we'd use '2>'."
print "\tNow we know that programs can print to different streams, so how does bash do it?"
print "\tLet's think about this logically: if '2>' moves stderr to a stdout, how would we flip it? In other words, how would we move stdout to stderr?"
println 1
read -n 1 -s -r -p $'\tWhen you think of a solution, press any character to continue'
println 1
print "\tYou probably thought '>2', and you'd be correct! However, that really doesn't do us much good if we want to inform the user of an error if they can't see stderr."
print "\tWhat most programs do is merge stderr with stdout, and in bash that's accomplished by making a copy of stderr, and pushing that to stdout."
print "\tWe use this with the '&' character, when used alongside a redirect, will merge a file descriptor stream into another one:"
println 1
span
code 'echo "error" >&2'
span
println 1
print "\tThis merges stdout (1, but this is implicit) into stderr (2) and prints the whole thing out."
print "\tAll this will finally show 1 stream to the user (stdout), but 2 behind the scenes (stdout+stderr)."
print "\tThis is probably the hardest part to conceptualize, so let's use a graph:"
println 1
print '        echo "error"        >&2           ---
          |                  |  |------> ( 2 )
          v                  |  |         ---
         ---                 v  |
        ( 1 ) ------------------|
         ---                    |
                                |         ---
                                |------> ( 1 )
                                          ---'
println 1
print "\tSo that's how we print stdout and stderr while maintaining a copy of stderr. What if we don't want stderr at all? I want *everything* to go to stdout!"
print "\tThis can be accomplished with '2>&1'. We merge stderr (2) with stdout (1), and that all is printed to stdout."
print "\tBoth '>&2' and '2>&1' do roughly the same thing with just one subtle difference:"
print "\t'2>&1' removes all stderr from the stream, while '>&2' merges stderr into stdout but maintains a copy of stderr:"
println 1
print "        sudo apt afffafa        2>&1
        |           |<----------|
        v           v
       ---         ---
      ( 1 )       ( 2 )
       ---         ---
        |           |
        |           v               ---
        |------------------------> ( 1 )
                                    ---"
println 1
print "\tIf you still don't understand, I'll be printing a cheatsheet of stuff you can copy-paste:"
println 1
print "\t\t - cmd >&2    : Print to stdout and stderr while keeping a copy of stderr (Recommended)"
print "\t\t - cmd > file : Redirect stdout to file"
print "\t\t - cmd 2> file: Redirect stderr to file"
print "\t\t - cmd 2>&1   : Combine stderr and stdout into a single stdout and print"
println 1
press_continue
println 2
print "\tNow we have heredocs, which are a subgroup of '<'. They are the same as '<' but they use strings instead of files as input. Here is how they look:"
println 1
span
print "\t\tcmd <<[-]word"
print "\t\t   text"
print "\t\t   text"
print "\t\tdelimiter"
span
println 1
print "\tThe optional dash will dedent tabs. Word is a word that will be used to terminate the heredoc. Delimiter is used to terminate the heredoc:"
println 1
span
code "cat <<ENDING"
print "\t\t> foo"
print "\t\t> bar"
print_no_line "\t\t> ENDING"
read -n 1 -s -r
println 1
print "\t\tfoo\n\t\tbar"
span
println 1
print "\tIf we don't want to allow variable or command expansion, we can simply quote 'word':"
println 1
span
code "cat <<'ENDING'"
print "\t\t> \${bar}"
print "\t\t> \$(baz)"
print_no_line "\t\t> ENDING"
read -n 1 -s -r
println 1
print "\t\t\${foo}\n\t\t\$(bar)"
span
println 1
print "\tWe can even pass the output to a command:"
println 1
span
code "cat <<EOF | base64 -d"
print "\t\t> SGVsbG8KV29ybGQK"
print_no_line "\t\t> EOF"
read -n 1 -s -r
println 1
code_output "Hello"
code_output "World"
span
println 1
press_continue
println 2
print "\tNext are herestrings, which take the form '<<<'. This script uses herestrings in fact!"
println 1
span
declare -f display_center
span
println 1
print "\tThis function uses a while loop to iterate over input passed into 'read' by a herestring from the first input given to it."
println 1
span
next_section_prompt

# 1.9
clear
span
display_center "[ 1.8 PARAMETER EXPANSION ]"
println 2
print "\tParameter expansion is used in variables to interact with strings and do operations on them."
print "\tThere are a *lot* so we'll just cover the basic ones:"
println 1
print "\t\t - \${var:-replace}                : Tests for parameters existence and value is not null"
print "\t\t - \${var-replace}                 : Tests that value is not null"
print "\t\t - \${var:+replace}                : If var is null or unset, nothing is substituted, otherwise it will be substituted"
print "\t\t - \${parameter:?word}             : Error out if parameter is null or unset"
print "\t\t - \${var:offset[:length]}         : Expands to length characters of value var starting at offset (string splicing)"
print "\t\t - \${#parameter}                  : Get length of characters. If parameter is [@/*], get number of elements"
print "\t\t - \${parameter[/]/pattern/string} : Replace first instance of pattern with string. If //, replace all instances"
print "\t\t - \${parameter,,}                 : Lowercase all of parameter"
print "\t\t - \${parameter,}                  : Lowercase first character in parameter"
print "\t\t - \${parameter^^}                 : Uppercase all of parameter"
print "\t\t - \${parameter^}                  : Uppercase first character in parameter"
print "\t\t - \${!parameter}                  : Indirect reference"
println 1
print "\tWe're going to be going over just a couple of these, as some are easy to understand."
print "\tLet's start with the indirect reference:"
println 1
span
code "NUMBER=3.5"
code 'echo ${NUMBER}'
code_output "3.5"
code "var=NUMBER"
code 'echo ${var}'
code_output "NUMBER"
code 'echo ${!var}'
code_output "3.5"
span
println 1
press_continue
println 2
print "\tNext we'll do splicing:"
println 1
span
code "string=01234567890abcdefgh"
code 'echo ${string:7}'
code_output "7890abcdefgh"
code 'echo ${string:7:2}'
code_output "78"
code 'echo ${string:7:-2}'
code_output "7890abcdef"
code 'echo ${string: -7}'
code_output "bcdefgh"
code "# We had to add a space to a negative offset to avoid bash getting confused with :- expansion."
span
println 1
span
next_section_prompt

# 2.0
clear
span
display_center "[ 2.0 BEST PRACTICES ]"
println 2
print "\tThis is a non-exhaustive list of things you should never ever ever do:"
println 1
print "\t\t - Parsing 'ls'"
print "\t\t - 'cat' files into other programs"
print "\t\t - For loop from reading file"
print "\t\t - For loop with 'seq'"
print "\t\t - For loops over '\$*'"
print "\t\t - Arrays from raw commands"
println 1
print "\tWe're going to go over all these to explain exactly why these are bad. Bash *will* let you do these, and many online tutorials"
print "\twill use these methods, so I'm preparing you to be smart about bash before you see any articles that spread bad practices."
println 1
press_continue
println 2
print "\tFirst we have parsing 'ls'. Let's look at an example:"
println 1
span
print_no_line "\t\t\$ ls"
read -n 1 -s -r
println 1
code_output "\"'\"  'foo bar.txt'  '*glob.mp3'  'new'\$'\\\n''line.txt'"
span
println 1
print "\tWow... That looks really bad. Now if you're running ls >= 8.25, it will correctly escape filenames when printing to a terminal, but not in a script:"
println 1
span
code 'for f in $(ls); do'
print "\t\t> echo \"file: \${f}\""
print "\t\t> done"
print "\t\tfile: '
\t\tfile: foo
\t\tfile: bar.txt
\t\tfile: *glob.mp3
\t\tfile: new
\t\tfile: line.txt"
span
println 1
print "\tIt completely crapped out in the loop! It printed that we have 6 files, but we only have 4!"
print "\tSo it failed on the files with spaces and a newline (yes, you can do that), because of string splitting."
print "\tSo can we quote it to stop the splitting? No, if we do that, everything is passed as one argument."
print "\tCould we change 'IFS' to a newline? Nope, files can contain newlines as well."
print "\tSo what's the right way??? Well, we use globs:"
println 1
span
print_no_line "\t\t\$ for f in *; do echo \"file: \${f}\"; done"
read -n 1 -s -r
println 1
print "\t\tfile: '
\t\tfile: foo bar.txt
\t\tfile: *glob.mp3
\t\tfile: new
\t\tline.txt"
span
println 1
print "\tAnd there we go, we avoid word splitting, a subshell, *and* an external tool, all with one character!"
println 1
press_continue
println 2
print "\tNext we have catting into other programs:"
println 1
span
print_no_line "\t\t\$ cat foo | grep 'bar'"
read -n 1 -s -r
println 1
code_output "barrier"
span
println 1
print "\tWe wasted an external command along with a pipe, where we could have just passed the file 'foo' into grep:"
println 1
span
code "grep 'bar' foo"
code_output "barrier"
span
println 1
print "\tMost of the time, you should either be using '<' or passing the filename to the program."
println 1
press_continue
println 2
print "\tNext we have looping over file contents with cat:"
println 1
span
code 'for line in $(cat file); do echo "${line}"; done'
span
println 1
print "\tIf you do this on a file that contains any spacing, it will all be subjected to string splitting, and quoting the subshell will pass the contents as one argument."
print "\tThe correct way is this:"
println 1
span
code "while IFS= read -r line; do"
print "\t\t>  echo \"\${line}\""
print "\t\t> done < file"
span
println 1
print "\tWhat this does is set 'IFS=', which will disable string splitting, so that it reads the entire line as is."
print "\tThe next is 'read', which will read the line into the variable 'line'."
print "\tThen we print the full line with 'echo', and finally the '<' redirect which you should be familiar with."
println 1
press_continue
println 2
print "\tNext we have for loop with 'seq', which is a command that produces a sequence of numbers:"
println 1
span
print_no_line "\t\t\$ seq 1 10"
read -n 1 -s -r
println 1
for i in {1..10}; do
    code_output "${i}"
done
span
println 1
print "\tThis might seem tempting to run a loop, especially because brace syntax {} is static, but bash can do the same without an external command and a subshell."
print "\tWe do C-style for loops to get around this."
println 1
press_continue
println 2
print "\tNow we'll do looping through unquoted subscript arrays. This should be very easy to figure out why this is wrong:"
println 1
span
code "array=('foo bar' 'baz' 'ba ng le')"
code 'for var in ${array[*]}; do'
print "\t\t>   echo \"\${var}\""
print "\t\t> done"
print "\t\tfoo
\t\tbar
\t\tbaz
\t\tba
\t\tng
\t\tle"
span
println 1
print "\tThe solution is to use quoted subscript arrays:"
println 1
span
code "array=('foo bar' 'baz' 'ba ng le')"
code 'for var in "${array[@]}"; do'
print "\t\t>   echo \"\${var}\""
print "\t\t> done"
print "\t\tfoo bar
\t\tbaz
\t\tba ng le"
span
println 1
press_continue
println 2
print "\tLastly we have raw commands into an array:"
println 1
span
code 'array=($(cmd))'
span
println 1
print "\tThis will incur string splitting on all whitespace, even ones in quotes, and will trigger globs if they exist."
print "\tTo get around this, we use 'mapfile', a builtin that turns command output into an array:"
println 1
span
code "mapfile -t array < <(cmd)"
span
println 1
print "\tThat funny looking redirect '<()' is what bash calls process substitution. The way we'd do without that is:"
println 1
span
code "cmd | mapfile -t array"
span
println 1
print "\tThis can lead to some intersting commands, like this one:"
println 1
span
code "tar -cf >(ssh server tar xf -) ."
span
println 1
print "\tYep, we can even reverse the '<()' into '>()'!"
print "\tThat command will transfer the current directory to a remote server and extract on the server."
print "\tYou'll be using '<()' more than '>()' though."
print "\tIf this is hard to understand, you can think of '<()' as passing input to a program as if it came from a file:"
println 1
span
code "cmd > file"
code "mapfile -t array < file"
span
println 1
span
code "mapfile -t array < <(cmd)"
span
println 1
print "\tThese are the same."
