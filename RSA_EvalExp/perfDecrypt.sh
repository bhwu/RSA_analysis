rm -f result.txt
for i in {1..100}
do
	sudo nice -n20 taskset -c 0  perf record -o garbage/perf.data -e cycles openssl rsautl -decrypt -inkey generatedSet/keys/key1.pem -in generatedSet/ciphers/cipher1.ssl -out garbage/garbage.txt
	sudo perf script -i garbage/perf.data -F period > garbage/trace.txt
	paste -sd+ garbage/trace.txt |bc >> result.txt
done