#Author: DataDriver/BigD Team
#Desc : This script pull the tweets using twitter API 

##############################

#Importing Credential file.
source("TwitterCredential.R")

# Importing dependent libraries
library(twitteR)
library(plyr)
library(stringr)


#Authentication throuh twitter API
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#Start extracting twiter for specific keywords
tweets = searchTwitter("#mamakabirthday", n=1000) #n=Number of tweets

strbuilder="";
count=0

#Itterating through Tweets
for(row in tweets) {
	count <- count+1
	name <- row$text
	strbuilder <- paste(strbuilder, name, sep=" ")
}

final_string <- paste(count, str_replace_all(strbuilder, "[\r\n]" , ""), sep=" ")

#Writing final output to the file
cat(final_string,file="twiiter.txt",sep="\n",append=TRUE)
