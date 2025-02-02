#include <stdio.h>

#define MAX_BIN 32

void dec2bin(long num){
    char bin[MAX_BIN + 1];
    int flag = 0;

    if (num < 0) {
        flag = 1;
        num = -num;
    }

    for (int i = MAX_BIN - 1; i >= 0; i--) {
        bin[i] = (num & 1) + '0';
        num >>= 1;
    }
    bin[MAX_BIN] = '\0';
    
    char sm_bin[MAX_BIN + 1];
    char ones_complement[MAX_BIN + 1];
    char twos_complement[MAX_BIN + 1];

    sm_bin[0] = flag ? '1' : '0';
    for (int i = 1; i < MAX_BIN; i++) {
        sm_bin[i] = bin[i];
    }
    sm_bin[MAX_BIN] = '\0';

    for (int i = 0; i < MAX_BIN; i++) {
        ones_complement[i] = (bin[i] == '1') ? '0' : '1';
    }
    ones_complement[MAX_BIN] = '\0';

    int carry = 1;
    for (int i = MAX_BIN - 1; i >= 0; i--) {
        if (ones_complement[i] == '1' && carry == 1) {
            twos_complement[i] = '0';
        }
        else if (ones_complement[i] == '0' && carry == 1) {
            twos_complement[i] = '1';
            carry = 0;
        }
        else {
            twos_complement[i] = ones_complement[i];
        }
    }
    twos_complement[MAX_BIN] = '\0';

    printf("sign and magnitude: %s\nOne's complement: %s\n2nd complement: %s\n", sm_bin, ones_complement, twos_complement);
}

int main(){
    long decNum;
    printf("Input decimal number in rage -2147483648 to 2147483647: ");
    scanf("%lu", &decNum);
    dec2bin(decNum);

    return 0;
}