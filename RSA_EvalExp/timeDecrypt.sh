gcc -o timeDecrypt timeDecrypt.c
nice -n20 taskset -c 0 ./timeDecrypt > timeDecrypt.csv
