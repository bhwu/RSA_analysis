// This program generates numSamples random 1024-bit private keys (key<number>.pem) and numSamples 1024-bit random byte streams (cipher<number>.txt)
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

const int numSamples = 50000;
const int keySize = 1024;

int generateOne(int index){
	//Generate private key
	printf("openssl genrsa -out generatedSet/keys/key%d.pem %d\n",index,keySize);
	//Extract the public key from the private key
	printf("openssl rsa -in generatedSet/keys/key%d.pem -out garbage/pubkey%d.pem -outform PEM -pubout\n", index, index);
	//system(command2);
	//Generate cipher text
	//First, randomly generate a plaintext
	unsigned char* plaintext = malloc(keySize/8);
	size_t i;
	char newbyte;
	for(i =0; i<keySize/8-11; i++){
		plaintext[i] = rand();
	}
	char plainFileName[20];
	sprintf(plainFileName, "garbage/plain%d.txt",index);
	FILE *plainFile = fopen(plainFileName,"w");
	fputs(plaintext, plainFile);
	fclose(plainFile);
	free(plaintext);

	//Second, encrypt the random plaintext with the extracted public key
	printf("openssl rsautl -encrypt -inkey garbage/pubkey%d.pem -pubin -in garbage/plain%d.txt -out generatedSet/ciphers/cipher%d.ssl\n", index, index, index);
	//system(command3);

	//char command4[512];
	//sprintf(command4, "openssl rsautl -decrypt -inkey generatedSet/keys/key%d.pem -in generatedSet/ciphers/cipher%d.ssl -out garbage/plainout.txt", index, index);
	//system(command4);


	return 0;
}

int main(int index){
	for(int i = 0; i<numSamples; i++){
		generateOne(i);
	}
}