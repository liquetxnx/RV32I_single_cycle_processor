#include <stdint.h>

volatile unsigned *P = (unsigned*)0x1000;

uint32_t add1(uint32_t x);// jalr 감지 위한 함수

uint32_t main(void){
    uint32_t A=3, B=7, C;
    uint32_t (*fp)(uint32_t) = add1;
    uint32_t z;
    while (A<B){ //branch 확인
        z=fp(A); //jalr 확인
        if(z==C) break;
    }

//LUI, AUIPC 큰 상수/주소 강제로 확인
unsigned x = 0x123456;
*P=x;
unsigned y = *P;


    return 0;
}

uint32_t add1(uint32_t x){return x+1;}
