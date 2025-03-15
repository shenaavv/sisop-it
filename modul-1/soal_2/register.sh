DATABASE="data/player.csv"

echo ""
echo "Requirement:"
echo "1) Email must contain '@' and '.' symbol."
echo "2) Passwords must have a minimum of 8 characters, at least one lowercase letter"
echo "   one uppercase letter, and one number."
echo ""

function email_constraint()
{
 if [[ ! "$1" =~ @.*\. ]]; then
    echo "Invalid Email Format"
    exit 1
 fi
}

function password_constraint()
{
 if [[ ! "$1" =~ [A-Z] || ! "$1" =~ [a-z] || ! "$1" =~ [0-9] || ${#1} -lt 8 ]]; then
   echo "Invalid Password Format"
   exit 1
 else 
   echo "Password meets all requirement"
 fi
}

read -p "Enter Email Address  : " email
email_constraint "$email"

if grep -q "$email," "$DATABASE"; then
    echo "Email is already registered"
    exit 1
fi

read -p "Enter username       : " username

read -sp "Enter Password       : " password
password_constraint ".$password"

password_hash=$(echo -n "$password" | sha256sum | awk '{print $1}')
echo ""

echo "$email,$username,$password_hash" >> "$DATABASE"

echo "Registration success!"
