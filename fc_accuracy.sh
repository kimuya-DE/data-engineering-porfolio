#! bin/bash

#Look up the record from yesterday.
#Extract the forecast from the appropriate field.
yesterday_fc=$(tail -2 rx_poc.log | head -1 | cut -d " " -f5)


#First extract today's observed temperature. Then calculate the difference between the forecasted and observed temperatures.
today_temp=$(tail -1 rx_poc.log | cut -d " " -f4)
accuracy=$(($yesterday_fc-$today_temp))
echo "accuracy is $accuracy"

#Use two conditions to compare the accuracy sizes to each positive and negative integer range, accordingly.
if [ -1 -le $accuracy ] && [ $accuracy -le 1 ]
then
   accuracy_range=excellent
elif [ -2 -le $accuracy ] && [ $accuracy -le 2 ]
then
    accuracy_range=good
elif [ -3 -le $accuracy ] && [ $accuracy -le 3 ]
then
    accuracy_range=fair
else
    accuracy_range=poor
fi

echo "Forecast accuracy is $accuracy"


#Extract the right row and remaining data you need to populate all fields.
row=$(tail -1 rx_poc.log)
year=$( echo $row | cut -d " " -f1)
month=$( echo $row | cut -d " " -f2)
day=$( echo $row | cut -d " " -f3)
echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$accuracy_range" >> historical_fc_accuracy.tsv
