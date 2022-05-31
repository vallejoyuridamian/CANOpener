# CANOpener

CANOpener is a 2017 FPGA project made by Jose Bentancour and myself

It consists on a CAN sniffer for a car.

The goal of this project was to be able to connect to the CAN bus of a car and get out the information, from the OBDII protocol or the car's electrical systems. The electrical system's siganls that are not available in the OBDII port were scanned to reverse engineer the information.

OBDII is a vehicle failure diagnose system, succesor of OBDI. It allows to detect electrical, chemical and mechanical failures that can affect the vehicle's level of emissions. 

The ELM327 scanner was used to identify the bus to investigate: ISO 15765-4 (CAN 11/500). A system was implemented connecting the CAN bus (CAN_H and CAN_L), with the help of a SN65HVD230 chip which allows to obtain a 3.3 V binary signal from the differential lines, which was connected to a DE0 board.

Only the message reception was implemented.

Finally, a reception stage was realized made from an input buffer which reads the bits transmitted in the CAN network, identifies the beginning and end of a message, its different parts and stores the information in a FIFO register. A data processing and display was later developed which takes the FIFO register through an Avalon interface and a program is executed in the NIOS proceesor of the DE0 board and displays it in a computer console.
