gcc -o genset genset.c
rm generatedSet/keys/*
rm generatedSet/ciphers/*
./genset > run.sh
chmod +x run.sh
./run.sh
rm garbage/*