#!/bin/bash
chmod u+x autosave.sh
PS3='Please enter your choice: '
echo "Setting Up.."

mv filech* ~/.config/DELTARUNE
sleep 1
options=("Deltarune Chapter 1" "Deltarune Chapter 2" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Deltarune Chapter 1")
            watch -n 30 /home/runner/Deltarune-Chapter-1-2/autosave.sh &
            cd Deltarune1 && ./runner
            ;;
        "Deltarune Chapter 2")
            watch -n 30 /home/runner/Deltarune-Chapter-1-2/autosave.sh &
            cd Deltarune2 && ./runner
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done