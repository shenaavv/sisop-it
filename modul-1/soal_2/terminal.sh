#!/bin/bash

while true; do
clear
echo "╔════════════════════════════════════════════╗"
echo "║              ARCAEA TERMINAL               ║"
echo "╠════╦═══════════════════════════════════════╣"
echo "║ ID ║ OPTION                                ║"
echo "╠════╬═══════════════════════════════════════╣"
echo "║  1 ║ Register New Account                  ║"
echo "║  2 ║ Login to Existing Account             ║"
echo "║  3 ║ Exit Arcaea Terminal                  ║"
echo "╚════╩═══════════════════════════════════════╝"

read -p "Enter option [1-3]: " option

case $option in
   1) bash register.sh
      ;;
   2) bash login.sh
      ;;
   3) exit 0
      # export SESSION=""
      ;;
   *) echo "Invalid option!"
      ;;
esac

read -p "Press enter to return to terminal"
done
