#!/bin/bash

# -- MEMPROSES DAN MENGAMBIL ARGUMENT DATA --
if [ "$#" -eq 0 ]; then
  echo 'Usage: dsotm.sh --play="<tracker>"'
  exit 1
fi

VALID_ARGS=$(getopt -o '' -l play: -- "$@") || exit 1
eval set -- "$VALID_ARGS"

while true; do
  case "$1" in
    --play)
        play="$2"
        shift 2
        ;;
    --) shift; 
        break 
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
  esac
done

# -- FUNCTION API CALL --
function handle_speak {
    clear
    figlet "Affirmation" 
    local emojis=(💡 🔥 ✨ 🎉 🔮 🗿)

    while true; do
        local selected=${emojis[$RANDOM % ${#emojis[@]}]};
        local result=$(curl -H "Content-Type: application/json" "https://www.affirmations.dev" 2>/dev/null)
        local affirmation=$(echo $result | awk -F '"' '{print $4}')
        echo -n "[$selected] "
        for ((i=0; i<${#affirmation}; i++)); do
            echo -n "${affirmation:$i:1}"
            sleep 0.05  # Adjust typing speed here
        done
        echo ""
        sleep 1
    done
}

# -- FUNCTION PROGRESS BAR --
function progress_bar {
    local width=100
    local spinner="/-\|"
    local total_time=0
    for((progress = 0; progress <= 100; progress+=1)); do
        clear
        local filled=$(( progress * width / 100 ))
        local empty=$(( width - filled ))
        local spin_char="${spinner:progress%4:1}"
        local sleepness=$(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
        
        local bar_filled=$(printf "%0.s " $(seq 1 $filled))
        local bar_empty=$(printf "%0.s " $(seq 1 $empty))
        if [ $progress -eq 100 ]; then
            bar_empty=""
        fi

        printf "\e[33m%s\e[0m \e[42m%s\e[0m\e[107m%s\e[0m \e[32m%d%%\e[0m" "$spin_char" "$bar_filled" "$bar_empty" "$progress"
        printf "\nTotal time elapsed: %f seconds\n" $total_time
        total_time=$(echo "$total_time + $sleepness" | bc)
        sleep $sleepness
    done
    echo 
}

# -- FUNCTION SHOW TIME --
function show_time {
    while true; do
        clear
        local part1=$(TZ="Asia/Jakarta" date +"%H:%M:%S")
        local part2=$(TZ="Asia/Jakarta" date +"%A %B %d, %Y %Z (Asia/Jakarta)")
        echo -e "$part2"
        
        echo -en "\e[36m"
        echo -en "$part1" | figlet -f lean
        echo -en "\e[0m"
        sleep 1
    done
}


# -- FUNCTION MONEY CMATRIX -- 
money_cmatrix() {
    clear
    local symbols=('$' '€' '£' '¥' '¢' '₹' '₩' '₿' '₣')
    local colors=('\e[31m' '\e[32m' '\e[33m' '\e[34m' '\e[35m' '\e[36m')
    local rows=$(tput lines)  
    local cols=$(tput cols)

    local i=0
    while true; do
        local rand_row=$(( RANDOM % rows + 1 ))  
        local rand_col=$(( RANDOM % cols + 1 ))  
        local rand_color="${colors[RANDOM % ${#colors[@]}]}"
        local symbol="${symbols[RANDOM % ${#symbols[@]}]}" 
        printf "\033[%d;%dH${rand_color}%s\e[0m" "$rand_row" "$rand_col" "$symbol"
        if [ $((i % 2)) -eq 0 ]; then
            printf "\033[%dH%s\e[0m\n" "$rand_col" ""
        fi 
        sleep 0.03
        i=$((i+1))
    done
}

# -- FUNCTION SHOW PROCESS --
function show_process {
    while true; do
        clear
        echo -en "\e[32m"
        printf -- '-%.0s' {1..40}; printf " System Info "; printf -- '-%.0s' {1..40}; echo
        echo "Time: $(date)"
        echo "Uptime: $(uptime -p)"
        echo "Hostname: $(hostname)"
        echo -en "\e[33m"
        printf -- '-%.0s' {1..41}; printf " CPU Usage "; printf -- '-%.0s' {1..41}; echo
        awk '{if($1=="cpu") printf "User: %.2f%%, System: %.2f%%, Idle: %.2f%%\n", $2*100/($2+$4+$5), $4*100/($2+$4+$5), $5*100/($2+$4+$5)}' /proc/stat
        echo -en "\e[34m"
        printf -- '-%.0s' {1..39}; printf " Memory Usage "; printf -- '-%.0s' {1..40}; echo
        free -h
        echo -en "\e[35m"
        printf -- '-%.0s' {1..38}; printf " Top 10 Processes "; printf -- '-%.0s' {1..37}; echo
        ps -eo pid,user,command,time,%cpu,%mem, --sort=-%cpu | head -10
        sleep 1
    done
}

# -- MEMPROSES PILIHAN -- 
case $play in
    "Speak to Me")
        handle_speak
        ;;
    "On the Run")
        progress_bar
        ;;
    "Time")
        show_time
        ;;
    "Money")
        money_cmatrix
        ;;
    "Brain Damage")
        show_process
        ;;
    *)
        echo "Invalid"
        ;;
esac
