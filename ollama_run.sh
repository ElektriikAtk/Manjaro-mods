#!/bin/zsh

ollama_out=~/Scripts/ollama_latest_output.txt
image=~/Pictures/ollama.png
image_done=~/Pictures/ollama-check.png
question=`kdialog --title "Ollama input box" --inputbox "What question would you like to ask?"`

# If no text is input then it should exit
if [ ${#question} -eq 0 ]
then
  kdialog --error "Input your question in the text field."
  exit 1
fi

notify_id=`notify-send --expire-time=0 -p -i $image "Ollama prompt" "Generating answer..."`

ollama run llama3.2:3b "$question" > $ollama_out

#Must have parenthesis to be array
logsDir=~/Scripts/ollama-logs
#           CHECK IF NOT EMPTY!!!
logs=($logsDir/*)
#Must be declared as int to increment
declare -i lenLogs=${#logs[@]}
newLog=$logsDir/$lenLogs.txt

for file in $logs
do
  #echo $logs
  if [[ $file == ${logs[-1]} ]]
  then
    lenLogs+=1
    echo $lenLogs
    touch "$newLog"
    chmod 777 "$newLog"
    # Use echo for adding variables to file
    echo "Question:\n$question" >> $newLog
  fi
done
# Use cat for adding .txt to files
echo "\nAnswer:" >> $newLog
cat $ollama_out >> $newLog

notify-send --expire-time=1000 -r $notify_id -i $image_done "Ollama prompt" "Finished"

kdialog --textbox $ollama_out

