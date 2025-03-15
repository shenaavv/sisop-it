DATABASE="data/player.csv"

read -p "Enter your email        : " email
read -sp "Enter your password     : " password

password_hash=$(echo -n "$password" | sha256sum | awk '{print $1}')
username=$(grep "$email," "$DATABASE" | awk 'BEGIN {FS=","} {print $2}')

export SESSION="$email,$username"

if grep -qr "$email,.*,$password_hash$" $DATABASE;
then
   bash scripts/manager.sh
else
   echo "Invalid email or password."
fi
