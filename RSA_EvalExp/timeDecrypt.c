// This program uses the keys and ciphertexts in the generatedSet directory to perform the first numSamples decryptions. 
//If the number of key-cipher pairs is less than numSamples, then the program simply aborts.
//Finally, the duration of each decryption (along with an index) is written to decryptTime.txt
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

const int numSamples = 50000;
const int trialsPer = 100;

unsigned long long int rdtsc(void)
{
   unsigned long long int x;
   unsigned a, d;
 
   __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));
 
   return ((unsigned long long)a) | (((unsigned long long)d) << 32);
}

int decryptOne(int index){
    char keyfilename[256]; //generate file name containing the key
    sprintf(keyfilename, "generatedSet/keys/key%d.pem", index);
    char cipherfilename[256]; // generate file name containng the ciphertext
    sprintf(cipherfilename, "generatedSet/ciphers/cipher%d.ssl",index);
    FILE* keyfile;
    FILE* cipherfile;
    if(keyfile = fopen(keyfilename,"r")){ //Check if key file exists
        if(cipherfile = fopen(cipherfilename,"r")){ //Check if ciphertext file exists
            //Generate decryption command
            char command[256];
            sprintf(command, "openssl rsautl -decrypt -inkey generatedSet/keys/key%d.pem -in generatedSet/ciphers/cipher%d.ssl -out garbage.txt", index, index);
            //printf("%d", index);
            unsigned long long int tic;
            unsigned long long int toc;
            for(int i=0; i<trialsPer; i++){
                //tic
                //tic = rdtsc();
                //run decryption command
                system(command);
                //toc
                //toc = rdtsc();
                //printf(",%llu", toc-tic);
                //sleep(0.1);
            }
            //printf("\n");
            fclose(cipherfile);
            fclose(keyfile);
            return 1;
        }
        else{
            fclose(keyfile);
            return 0;
        }
    }
    else{
        return 0;
    }
}

int main(){
    for(int i = 0; i<numSamples; i++){
        decryptOne(i);
    }
    
}