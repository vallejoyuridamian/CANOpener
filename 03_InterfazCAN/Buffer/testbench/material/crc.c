#include <stdio.h>
#include <stdint.h>

uint16_t can_crc_next(uint16_t crc, uint8_t data)
{
    uint8_t i, j;

    crc ^= (uint16_t)data << 7;
    
    
    for (i = 0; i < 8; i++) {
        crc <<= 1;
        if (crc & 0x8000) {
            crc ^= 0xc599;
        }
    }

    
    return crc & 0x7fff;
}

int main()
{
    int i;
    //uint8_t data[] = {0x02, 0xAA, 0x80}; //mensaje en http://blog.qartis.com/can-bus/
    //uint8_t data[] = {0xA, 0x01, 0x01}; //mensaje ejemplo de Wikipedia
    //uint8_t data[] = {0x05, 0x00, 0x80, 0xF7, 0x53}; //con CRC para que de 0	
	uint8_t data[] = {0x03, 0xEF, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; //mensaje que tira el OBD
	
    uint16_t crc;

    crc = 0;

    for (i = 0; i < sizeof(data); i++) {
        crc = can_crc_next(crc, data[i]);
        
    }

    printf("%x\n", crc);
}