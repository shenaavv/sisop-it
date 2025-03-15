#!/bin/bash

# -- DEFAULT HELP COMMAND --
help() {
    echo -en "\e[33m"
cat << "EOF"
                                  ,'\  
    _.----.        ____         ,'  _\   ___    ___     ____  
_,-'       `.     |    |  /`.   \,-'    |   \  /   |   |    \  |`.  
\      __    \    '-.  | /   `.  ___    |    \/    |   '-.   \ |  |  
 \.    \ \   |  __  |  |/    ,','_  `.  |          | __  |    \|  |  
   \    \/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  |  
    \     ,-'/  /   \    ,'   | \/ / ,`.|         /  /   \  |     |  
     \    \ |   \_/  |   `-.  \    `'  /|  |    ||   \_/  | |\    |  
      \    \ \      /       `-.`.___,-' |  |\  /| \      /  | |   |  
       \    \ `.__,'|  |`-._    `|      |__| \/ |  `.__,'|  | |   |  
        \_.-'       |__|    `-._ |              '-.|     '-.| |   |  
                                `'                            '-._|  
EOF
    echo -e "\e[0m"

    echo "Usage: $0 <file_name> [options]"
    echo "Options:"
    echo "  -h, --help          Display this help message."
    echo "  -i, --info          Display the highest adjusted and raw usage."
    echo "  -s, --sort <col>    Sort the data by the specified column."
    echo "    name              Sort by Pokemon name."
    echo "    usage             Sort by Adjusted Usage."
    echo "    raw               Sort by Raw Usage."
    echo "    hp                Sort by HP."          
    echo "    atk               Sort by Attack."
    echo "    def               Sort by Defense."
    echo "    spatk             Sort by Special Attack."
    echo "    spdef             Sort by Special Defense."
    echo "    speed             Sort by Speed."
    echo "  -g, --grep <name>   Search for a specific Pokémon sorted by usage."
    echo "  -f, --filter <type> Filter by type of Pokémon sorted by usage."
    exit 0
}


# --  ARGUMENT PARSING -- 
if [[ $# -lt 1 ]]; then
    help
    exit 1
fi

if [[ $1 == "-h" || $1 == "--help" ]]; then
    help
    exit 0
fi

FILE=$1
shift

if [[ ! -f $FILE ]]; then
    echo -e "\e[31mError: file $FILE not found!\e[0m"
    exit 1
fi

if [[ ${FILE: -4} != ".csv" ]]; then
    echo -e "\e[31mError: file $FILE is not a CSV file!\e[0m"
    exit 1
fi

# -- COLUMN MAPPING --
function map_column {
  local col=$1
  case $col in
    "name") echo 1;;
    "usage") echo 2;;
    "raw") echo 3;;
    "hp") echo 6;;
    "atk") echo 7;;
    "def") echo 8;;
    "spatk") echo 9;;
    "spdef") echo 10;;
    "speed") echo 11;;
  esac
}


# -- SOAL A --
function info {
  awk -F ',' 'NR > 1 { if ($2+0 > max) { max=$2+0; name=$1 }}
  END { print "Highest Adjusted Usage :", name, "with", max "%" }' $FILE
  awk -F ',' 'NR > 1 { if ($3+0 > max) { max=$3+0; name=$1 }}
  END { print "Highest Raw Usage      :", name, "with", max, "uses" }' $FILE
}

# -- SOAL B --
function sorting {
  if [[ -z $1 ]]; then
    echo -e "\e[31mError: no column specified!\e[0m"
    exit 1
  fi

  local valid_cols=("name" "usage" "raw" "hp" "atk" "def" "spatk" "spdef" "speed")
  local col=$1

  if [[ ! " ${valid_cols[@]} " =~ " ${col} " ]]; then
    echo -e "\e[31mError: invalid column '$col'\e[0m"
    exit 1
  fi

  awk -F ',' -v col=$(map_column $col) 'NR == 1 { print $0 } NR > 1 { print $0 | "sort -t, -k"col"nr" }' $FILE
}

# -- SOAL C --
function grepping {
  if [[ -z $1 ]]; then
    echo -e "\e[31mError: no name specified!\e[0m"
    exit 1
  fi

  local name=$1
  awk -F ',' -v name=$name 'NR == 1 { print $0 } NR > 1 && tolower($1) ~ tolower(name) { print $0 | "sort -t, -k1nr" }' $FILE
}

# -- SOAL D --
function filtering {
  if [[ -z $1 ]]; then
    echo -e "\e[31mError: no type specified!\e[0m"
    exit 1
  fi

  local type=$1
  awk -F ',' -v type=$type 'NR == 1 { print $0 } NR > 1 && (tolower($4) ~ tolower(type) || tolower($5) ~ tolower(type)) { print $0 | "sort -t, -k2nr" }' $FILE
}


# -- MATCHING OPTIONS --
if [[ $# -eq 0 ]]; then
  echo -e "\e[31mError: no options provided!\e[0m"
  help
  exit 1
fi

while [[ $# -gt 0 ]];do
  case "$1" in
    -h|--help) help;;
    -i|--info) info;;
    -s|--sort) shift; sorting "$1" ;;
    -g|--grep) shift; grepping "$1" ;;
    -f|--filter) shift; filtering "$1" ;;
    *) echo -e "\e[31mError: unknown option '$1'\e[0m"; help; exit 1;;
  esac
  shift
done