#include "system.h"
#include "stdio.h"
#include "sys/alt_stdio.h"
#include "altera_avalon_pio_regs.h"
#include "io.h"
#include "stdbool.h"

/*void delay(int d){
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
}*/

bool isEmpty(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    return ((value & 0x01000000) > 0);
}

bool available(){
    return !isEmpty();
}

bool isFull(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    return (value & 0x02000000) > 0;
}

bool checkCRC(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    return (value & 0x04000000) > 0;
}

void next(){
    IOWR(CAN_OPENER_INST_BASE, 0, 0x00);
    return;
}

int getDataLen(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    value = (value & 0x000F0000) >> 16;
    if (value < 8){
        return value;
    } else {
        return 8;
    }
}

unsigned long getAddr(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    return value & 0x00007FF;
}

int getData(int i){
    if (i < 8){
        unsigned long value = 0;
        if (i < 4){
            value = IORD(CAN_OPENER_INST_BASE, 0x01);
        } else {
            value = IORD(CAN_OPENER_INST_BASE, 0x02);
            i = i - 4;
        }
        return (value >> i*8) & 0x000000FF;
    } else {
        return 0;
    }
}

int getState(){
    unsigned long value = IORD(CAN_OPENER_INST_BASE, 0x00);
    return (value & 0xFF000000) >> 24;
}

unsigned long recieve_buffer[32][10];

int main()
{ 
  printf("---------- CAN Opener ---------\n");
  
  // |_______________________________|_______________________________|_______________________________|_______________________________|
  // |_______________|_______________|_______________|_______________|_______________|_______________|_______________|_______________|
  // |    ESTADO     | 0 |CRC|FUL|EMP| 0 | 0 | 0 | 0 |      LEN      | 0 | 0 | 0 | 0 | 0 |               ADDRESS                     |
  
  //int count = 0;
  while (1){
    if (isFull()){
        printf("FIFO FULL!!\n");
    }
    
    if (available()){
        if (checkCRC()){
            bool save = true;
            
            unsigned long addr = getAddr();
            int len = getDataLen();
            
            int addr_exists = 0;
            int dato;
            for (dato=0; dato<32; dato++){
                if (recieve_buffer[dato][0] == addr){
                    addr_exists = addr;
                    if (recieve_buffer[dato][1] == len){
                        save = false;
                        int valor;
                        for(valor=2; valor<10; valor++){
                            if(recieve_buffer[dato][valor] != getData(valor - 2)){
                                save = true;
                            }
                        }
                    }
                }
            }
            
            if (save){
                int dato = 0;
                while ((recieve_buffer[dato][0] != addr_exists) && (dato < 32)){
                    dato++;
                }
                recieve_buffer[dato][0] = addr;
                recieve_buffer[dato][1] = len;
                int valor;
                for(valor=2; valor<10; valor++){
                    recieve_buffer[dato][valor] = getData(valor - 2);
                }
            }
            
           if (save){
                printf("|%03lX",addr);
                int i;
                for (i=7; i >= 0; i--){
                    if (i >= len){
                        printf("|  ");
                    } else {
                        int data = getData(i);
                        printf("|%02X",data);
                    }
                }
                printf("|\n");
            }
                
            
            /*printf ("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
            for (dato=0; dato<16; dato++){
                addr = recieve_buffer[dato][0];
                len = recieve_buffer[dato][1];
                printf("|%03lX",addr);
                //printf("| [%03lX](%u)",addr,len);
                int i;
                for (i=7; i >= 0; i--){
                    if (i >= len){
                        printf("|  ");
                    } else {
                        int data = recieve_buffer[dato][i+2];
                        printf("|%02X",data);
                    }
                }
                printf("|\n");
                delay(100);
            }*/
        }
        //if (!checkCRC()){printf(" CRC ERROR");};
        next();
    }
    
    // Imprime estado del decodificaro para saber si se tranca
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, getState());
    
    // Blink de LED para saber si el programa se tranca
    //IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, count & 0x01);
    //count++;    
    //delay(100);
  };

  return 0;
}
