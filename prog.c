#include <stdint.h>

#define SIG_ADDR 0x00000200u

volatile uint32_t * const sig = (uint32_t*) SIG_ADDR;

uint32_t add1(uint32_t x);// jalr 감지 위한 함수

uint32_t main(void){
    int32_t A=6, B=-10, D=8, F=2;
    uint32_t C=-10;

    uint32_t (*fp)(uint32_t) = add1;


    //R-type 확인
    sig[0]=A+B; // -4
    sig[1]=A-B; // 16

    
    sig[2]=A<<D; //1536
    sig[3]=C>>F; //3FFFFFFD
    sig[4]=B>>F; //FFFFFFFD

    A=sig[4]; B=sig[2];

    sig[5]=A<B; //1
    sig[6]=(uint32_t)A<(uint32_t)B; // 0
    sig[7]= A^B; // FFFFF9FD
    sig[8]= A|B; // FFFFFFFD
    sig[9]= A&B; // 00000600


    //I-type 확인
    A=6; B=-10;
    sig[10]=A-10;
    sig[11]=A<<8;
    sig[12]=B>>2;
    sig[13]=(uint32_t)B>>2;
    sig[14]=B<8; 
    sig[15]=(uint32_t)B<8;
    sig[16]=A^8;
    sig[17]=A|8;
    sig[18]=A&8;

    A=fp(A); //jalr 확인
    //A=7
    sig[19]=A;

    //branch 확인 및 jal 확인 A=7, B=-10
    if(A==B) sig[20]=0;
    else sig[20]=1;

    if(A<B) sig[21]=0;
    else sig[21]=1;

    if((uint32_t)A<(uint32_t)B) sig[22]=0;
    else sig[22]=1;






    //LUI 큰 상수 강제로 확인
    unsigned x = 0x123456;

    sig[23]=x;   
    sig[24]=0x7FFFFFFF;

    //AUIPC는 하드코딩으로 tb에서 직접확인
    return 0;
}

uint32_t add1(uint32_t x){return x+1;}
