#include <stdint.h>
volatile uint32_t *TOHOST = (uint32_t*)0x100;

int main(void){
    int A=3, B=7, C;
    C = (A>=B) ? 2 : 0;
    *TOHOST = (uint32_t)C;   // TB가 이 store 보면 종료/PASS판정
    
    return 0;
}
