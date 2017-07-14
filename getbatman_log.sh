#!/bin/bash
echo "The log will be written into: " $1
timestamp=$(date +%c)
echo "===============" >> "$1_creating.txt"
echo $timestamp >> "$1_creating.txt"
echo "==================" >> "$1_creating.txt"
counter=1
for pos_name in $(kubectl get pods -a |awk '{if ($3=="ContainerCreating") print $1;}' | grep 'batman'); do 

   echo $counter "========= Error ==========" >>"$1_creating.txt"
   echo $pos_name >> "$1_creating.txt"
   kubectl describe pod $pos_name  >> "$1_creating.txt"
   #echo "===================================">>"$1_creating.txt"

   #kubectl logs $pos_name >> "$1_creating.txt"
   let counter=counter+1
   echo "===================================">>"$1_creating.txt"
done 

echo "===============" >> "$1_running.txt"
echo $timestamp >> "$1_running.txt"
echo "==================" >> "$1_running.txt"
counter=1
for pos_name in $(kubectl get pods -a |awk '{if ($3=="Running") print $1;}' | grep 'batman'); do

   echo $counter "========= Error ==========" >>"$1_running.txt"
   echo $pos_name >> "$1_running.txt"
   kubectl describe pod $pos_name  >> "$1_running.txt"
   #echo "===================================">>"$1_running.txt"

   #kubectl logs $pos_name >> "$1_running.txt"
   let counter=counter+1
   echo "===================================">>"$1_running.txt"
done

echo "===============" >>"$1_Unknown.txt"
echo $timestamp >> "$1_Unknown.txt"
echo "==================" >> "$1_Unknown.txt"
counter=1
for pos_name in $(kubectl get pods -a |awk '{if ($3=="Unknown") print $1;}' | grep 'batman'); do

   echo $counter "========= Error ==========" >>"$1_Unknown.txt"
   echo $pos_name >> "$1_Unknown.txt"
   kubectl describe pod $pos_name  >> "$1_Unknown.txt"
   #echo "===================================">>"$1_Unknown.txt"

   #kubectl logs $pos_name >> "$1_Unknown.txt"
   let counter=counter+1
   echo "===================================">>"$1_Unknown.txt"
done

echo "===============" >>"$1_Error.txt"
echo $timestamp >> "$1_Error.txt"
echo "==================" >> "$1_Error.txt"
counter=1
for pos_name in $(kubectl get pods -a |awk '{if ($3=="Error") print $1;}' | grep 'batman'); do

   echo $counter "========= Error ==========" >>"$1_Error.txt"
   echo $pos_name >> "$1_Error.txt"
   kubectl describe pod $pos_name  >> "$1_Error.txt"
   #echo "===================================">>"$1_Error.txt"

   #kubectl logs $pos_name >> "$1_Error.txt"
   let counter=counter+1
   echo "===================================">>"$1_Error.txt"
done


#ContainerCreating
#counter=1
#for pos_name in $(kubectl get pods -a |awk '{if ($3=="Unknown") print $1;}' | grep 'batman'); do
#   echo $counter "========= Unknown ==========">>$1
#   kubectl get pods -a |awk '{if ($1==$pos_name) print $1,"up time:", $5 ;}' | grep 'batman' >> $1
#   kubectl logs $pos_name >> $1
#   let counter=counter+1
#   echo "===================================">>$1
#done

echo "===============" >> $1
echo $timestamp >> $1
echo "==================" >> $1


counter=1
for pos_name in $(kubectl get pods -a |awk '{if ($3=="Completed") print $1;}' | grep 'batman'); do
   echo $counter "========= Successful ==========">>$1
   echo $pos_name  >> $1
   kubectl describe pod $pos_name |sed -n '/Node:/p' >> $1
   kubectl describe pod $pos_name |sed -n '/-r/,/Volume Mounts:/p' >> $1
   echo "========================================">>$1
   kubectl logs $pos_name >> $1
   let counter=counter+1
   echo "========================================">>$1
done

#get nodes only
for pos_name in $(kubectl get pods -a |awk '{if ($3=="Completed") print $1;}' | grep 'batman'); do
   kubectl describe pod $pos_name |sed -n '/Node:/p' >> "$1_output_nodes.txt"
done

#get each worker starting and finishing time
sed -n '/Finished:/p' $1 >"$1_output_finish_time.txt"
sed -n '/Started:/p' $1 >"$1_output_start_time.txt"

#get spectra range
sed -n '/-r/,/Requests:/p' $1 >output_specRange.txt
cat output_specRange.txt |grep '[0-9]-[0-9]' > "$1_output_specRange.txt"
rm output_specRange.txt

#get batman  MCMC time
sed -n '/elapsed/,/second./p' $1 > output_batman_mcmc.txt
cat output_batman_mcmc.txt |grep '[0-9]' > "$1_output_batman_mcmc.txt"
rm output_batman_mcmc.txt



