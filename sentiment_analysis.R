#! /usr/bin/env Rscript 
# Author : (DataDriver/BigD Team)
# Description: This script 
#######################################

#Importing sentiment library
library(sentiment)

# Parsing Arguments
args<-commandArgs(TRUE)

#Setting Hadoop Environment
Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING='/usr/local/hadoop/share/hadoop/mapreduce/hadoop-streaming-2.7.2.jar')
Sys.setenv(HADOOP_HOME='/usr/local/hadoop')
options(warn=-1)


# Retrieving input file from argument
input <-file(args[1],"r")

#Itereating through line in an input file
while(length(line <- readLines(input,n=1)) > 0) {
  
  polarityvalues=classify_polarity(line,algorithm="bayes")
  emotionvalues<-classify_emotion(line,algorithm="bayes")
  
  #polarity scores related logic
  polarity_bestfit=polarityvalues[,4]
  polposval=as.numeric(polarityvalues[1])
  polnegval=as.numeric(polarityvalues[2])
  totalvalue=polposval+polnegval
  
  polpospercent=(polposval*100)/totalvalue
  polnegpercent=(polnegval*100)/totalvalue
  
  emotion_bestfit=emotionvalues[,7]
  
  Anger=as.numeric(emotionvalues[1])
  Disgust=as.numeric(emotionvalues[2])
  Fear=as.numeric(emotionvalues[3])
  Joy=as.numeric(emotionvalues[4])
  Sadness=as.numeric(emotionvalues[5])
  Surprise=as.numeric(emotionvalues[6])
  
  total_emotion_score=Anger+Disgust+Fear+Joy+Sadness+Surprise
  
  Anger=(Anger*100)/total_emotion_score
  Disgust=(Disgust*100)/total_emotion_score
  Fear=(Fear*100)/total_emotion_score
  Joy=(Joy*100)/total_emotion_score
  Sadness=(Sadness*100)/total_emotion_score
  Surprise=(Surprise*100)/total_emotion_score
  
  polpospercent=round(polpospercent,digits=2)
  polnegpercent=round(polnegpercent,digits=2)
  
  Anger=round(Anger,digits=2)
  Surprise=round(Surprise,digits=2)
  Joy=round(Joy,digits=2)
  Sadness=round(Sadness,digits=2)
  Disgust=round(Disgust,digits=2)
  Fear=round(Fear,digits=2)
  
  res<-c(args[2],polpospercent,polnegpercent,Anger,Surprise,Sadness,Joy,Disgust,Fear)

  #Writing Final Data
  write(res, file = "stats.tsv", ncolumns =9, append = TRUE, sep = "\t")

}


