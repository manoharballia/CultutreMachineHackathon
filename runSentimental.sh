#!/bin/bash

#Removing exisitng/previous output
rm -f stats.tsv
rm -f twiiter.txt

#Extracting data from youtube
java -cp youtube_fetch_data.jar com.cm.hackathon.json_parser.youtube_json_parse /home/hduser/projects/R/inputs/



#Calling Twiter extract script
Rscript getTweets.R

if [ $? == 0 ];
	echo "########## Twiiter extraction is completed.########"
	echo ""
	echo "######### Sentimental analysis is started for youtube files.########"
then
	IFS=', ' read -ra ary <<< ${1}

	for key in "${!ary[@]}"; 
	do 
		#echo "${ary[$key]}";
		tot_count=`cat ${ary[$key]}|cut -d' ' -f1 `
		Rscript sentiment_analysis.R "${ary[$key]}" "$tot_count"
		 
	done
	echo "########## Sentimental analysis is completed.#########################"
else
 	echo "####Oops! Script getTweets is failed!##############"
fi
