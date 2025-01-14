#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
#Move else into a fucntion and reffer function from else.
#This way i can also reffer to the else function if i in the if part select a customr that already exist

# Source other bash scripts
MYDIR="$(dirname "$(realpath "$0")")"
. $MYDIR/log.sh

# Initialize FZF_DEFAULT_OPTS if not already defined
: ${FZF_DEFAULT_OPTS:=""}

# Set the options
FZF_DEFAULT_OPTS+=" --color=fg:-1,fg+:#af5fff,bg:-1,bg+:-1"
FZF_DEFAULT_OPTS+=" --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00"
FZF_DEFAULT_OPTS+=" --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf"
FZF_DEFAULT_OPTS+=" --color=border:-1,label:#aeaeae,query:#d9d9d9"
FZF_DEFAULT_OPTS+=" --border=\"rounded\""
FZF_DEFAULT_OPTS+=" --border-label=\"\""
FZF_DEFAULT_OPTS+=" --preview-window=\"border-rounded\""
FZF_DEFAULT_OPTS+=" --prompt=\"> \""
FZF_DEFAULT_OPTS+=" --marker=\"> \""
FZF_DEFAULT_OPTS+=" --pointer=\"◆\""
FZF_DEFAULT_OPTS+=" --separator=\"─\""
FZF_DEFAULT_OPTS+=" --scrollbar=\"|\""
FZF_DEFAULT_OPTS+=" --layout=\"reverse-list\""

# Export FZF_DEFAULT_OPTS
export FZF_DEFAULT_OPTS

base_path=$CUSTOMERS_PATH
script_dir="$(dirname "$0")"
pretty_date=$(date +"%Y-%m-%d")
qdate=$(date +"%Y%m%d")

exit_on_empty() {
    if [[ -z "$1" ]]; then
        elog "No valid customer chosen"
        exit 1
    fi
}
check_if_folder_exist() {
    if [[ -d "$1" ]]; then
        elog "Directory already exists: $1"
        exit 1
    fi
}

check_if_file_exist() {
    if [[ -e "$1" ]]; then
        elog "File already exist: $1"
        exit 1
    fi
}
launch_file_nvim() {
    nvim "$1" -c ":NoNeckPain" -c ":set linebreak"
}

# This function is used to create files
# Parameters:
# $1 takes in the customer folder where the file is to be placed
create_file() {
    read -p "Enter name of file: " new_file_name
    new_file_name_system=$(echo "$new_file_name" | sed -e 's/ /-/g' -e 's/[[:upper:]]/\L&/g')
    new_file_path="$base_path/$1/$qdate-$new_file_name_system.md"
    cp "$script_dir/templates/customers.txt" "$new_file_path"
    sed -i "s/REPLACE_TITLE/$new_file_name/g;" $new_file_path
    sed -i "s/REPLACE_DATE/$pretty_date/g;" $new_file_path
    echo "$new_file_path"

}
# Sends the inputted items into fzf for selecting
# takes a array passed like ${array[@]}
select_from_list() {
    printf "%s\n" "$@" | fzf --height 40% --layout=reverse --border -i
}

main() {
    menu_items=('-- New customer --')
    menu_items+=($(ls $base_path))
    selected_customer=$(select_from_list ${menu_items[@]})
    exit_on_empty $selected_customer
    elog "Selected customer: $selected_customer"
    

    if [[ "$selected_customer" == "-- New customer --" ]]; then
        read -p "Enter name of new customer: " newcust
        check_if_folder_exist "$base_path/$newcust"
        mkdir "$base_path/$newcust"
        selected_customer=$newcust
        selected_file=$(create_file $newcust)


    else
        customer_path="$base_path/$selected_customer"
        elog "customer path is: $customer_path"
        custfiles=('-- New file --')
        custfiles+=($(ls $customer_path -pr | grep -v /))
        
        selected_file=$(select_from_list ${custfiles[@]})

        if [[ "$selected_file" == "-- New file --" ]]; then
            selected_file=$(create_file $selected_customer)
        else
            selected_file="$base_path/$selected_customer/$selected_file"
        fi
    fi
    cd "$base_path"
    launch_file_nvim $selected_file

}

main
