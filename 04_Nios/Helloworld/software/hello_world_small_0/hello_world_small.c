
#include "system.h"
#include "stdio.h"
#include "sys/alt_stdio.h"
#include "altera_avalon_pio_regs.h"
#include "io.h"
#include "stdbool.h"

void delay(int d){
    int delay0 = 0;
    int delay1 = 0;
    while(delay0 < d*1000){
        delay0 ++;
        delay1 = 0;
        while(delay1 < 1000){
            delay1 ++;
        }
    }
    return;
}

bool isEmpty(){
    unsigned long value = IORD(CAN_OPENER_0_BASE, 0x00);
    return ((value & 0x01000000) > 0);
}

bool available(){
    return !isEmpty();
}

bool isFull(){
    unsigned long value = IORD(CAN_OPENER_0_BASE, 0x00);
    return (value & 0x02000000) > 0;
}

bool checkCRC(){
    unsigned long value = IORD(CAN_OPENER_0_BASE, 0x00);
    return (value & 0x04000000) > 0;
}

void next(){
    IOWR(CAN_OPENER_0_BASE, 0, 0x00);
    return;
}

int getDataLen(){
    unsigned long value = IORD(CAN_OPENER_0_BASE, 0x00);
    value = (value & 0x000F0000) >> 16;
    if (value < 8){
        return value;
    } else {
        return 8;
    }
}

unsigned long getAddr(){
    unsigned long value = IORD(CAN_OPENER_0_BASE, 0x00);
    return value & 0x00007FF;
}

int getData(int i){
    if (i <= 8){
        unsigned long value = 0;
        if (i < 4){
            value = IORD(CAN_OPENER_0_BASE, 0x01);
        } else {
            value = IORD(CAN_OPENER_0_BASE, 0x02);
            i = i - 4;
        }
        return (value >> i*8) & 0x000000FF;
    } else {
        return 0;
    }
}

int main()
{ 
  alt_putstr("Hello CAN Opener!\n");
  
  // |_______________________________|_______________________________|_______________________________|_______________________________|
  // |_______________|_______________|_______________|_______________|_______________|_______________|_______________|_______________|
  // | 0 | 0 | 0 | 0 | 0 |CRC|FUL|EMP| 0 | 0 | 0 | 0 |      LEN      | 0 | 0 | 0 | 0 | 0 |               ADDRESS                     |
    
  /* Event loop never exits. */
  int count = 0;
  while (1){
    if (isFull()){
        printf("FIFO FULL!!\n");
    }
    
    if (available()){
        //if (checkCRC()){
            //printf("NEW: ");
            unsigned long addr = getAddr();
            int len = getDataLen();
            //printf("[%04lu](%u)",addr,len);
            printf("[%03X](%u)",addr,len);
            int i;
            for (i=7; i >= 0; i--){
                if (i >= len){
                    printf("     ");
                } else {
                    int data = getData(i);
                    //printf(" 0x%02X",data);
                    printf(" %02X",data);
                }
            }
        /*} else {
            printf("CRC ERROR");
        }*/
        if (!checkCRC()){printf(" CRC ERROR");};
        printf("\n");
        next();        
    }

    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, count & 0x01);
    count++;    
    delay(0);
  };

  return 0;
}
