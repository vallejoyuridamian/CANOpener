// slave_template_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module slave_template_0 (
		input  wire        clk,              //    clock_reset.clk
		input  wire        reset,            //               .reset
		input  wire [8:0]  slave_address,    //             s0.address
		input  wire        slave_read,       //               .read
		input  wire        slave_write,      //               .write
		output wire [15:0] slave_readdata,   //               .readdata
		input  wire [15:0] slave_writedata,  //               .writedata
		input  wire [1:0]  slave_byteenable, //               .byteenable
		output wire [15:0] user_dataout_0,   // user_interface.export
		output wire [15:0] user_dataout_10,
		output wire [15:0] user_chipselect,
		output wire [15:0] user_dataout_11,
		output wire        user_write,
		input  wire [15:0] user_datain_10,
		output wire        user_read,
		output wire [15:0] user_dataout_13,
		input  wire [15:0] user_datain_13,
		output wire [15:0] user_dataout_12,
		input  wire [15:0] user_datain_14,
		output wire [15:0] user_dataout_15,
		input  wire [15:0] user_datain_11,
		output wire [15:0] user_dataout_14,
		input  wire [15:0] user_datain_12,
		input  wire [15:0] user_datain_15,
		output wire        slave_irq,
		input  wire [15:0] user_datain_9,
		input  wire [15:0] user_datain_8,
		output wire [15:0] user_dataout_8,
		input  wire [15:0] user_datain_7,
		output wire [15:0] user_dataout_7,
		input  wire [15:0] user_datain_6,
		input  wire [15:0] user_datain_5,
		output wire [15:0] user_dataout_9,
		input  wire [15:0] user_datain_4,
		output wire [15:0] user_dataout_4,
		input  wire [15:0] user_datain_3,
		output wire [15:0] user_dataout_3,
		input  wire [15:0] user_datain_2,
		output wire [15:0] user_dataout_6,
		input  wire [15:0] user_datain_1,
		output wire [15:0] user_dataout_5,
		input  wire [15:0] user_datain_0,
		output wire [15:0] user_dataout_2,
		output wire [15:0] user_dataout_1
	);

	slave_template #(
		.DATA_WIDTH          (16),
		.ENABLE_SYNC_SIGNALS (0),
		.MODE_0              (0),
		.MODE_1              (4),
		.MODE_2              (4),
		.MODE_3              (4),
		.MODE_4              (4),
		.MODE_5              (4),
		.MODE_6              (4),
		.MODE_7              (4),
		.MODE_8              (4),
		.MODE_9              (4),
		.MODE_10             (4),
		.MODE_11             (4),
		.MODE_12             (4),
		.MODE_13             (4),
		.MODE_14             (4),
		.MODE_15             (4),
		.IRQ_EN              (0)
	) slave_template_0 (
		.clk              (clk),                  //    clock_reset.clk
		.reset            (reset),                //               .reset
		.slave_address    (slave_address),        //             s0.address
		.slave_read       (slave_read),           //               .read
		.slave_write      (slave_write),          //               .write
		.slave_readdata   (slave_readdata),       //               .readdata
		.slave_writedata  (slave_writedata),      //               .writedata
		.slave_byteenable (slave_byteenable),     //               .byteenable
		.user_dataout_0   (user_dataout_0),       // user_interface.export
		.slave_irq        (),                     //    (terminated)
		.user_dataout_1   (),                     //    (terminated)
		.user_dataout_2   (),                     //    (terminated)
		.user_dataout_3   (),                     //    (terminated)
		.user_dataout_4   (),                     //    (terminated)
		.user_dataout_5   (),                     //    (terminated)
		.user_dataout_6   (),                     //    (terminated)
		.user_dataout_7   (),                     //    (terminated)
		.user_dataout_8   (),                     //    (terminated)
		.user_dataout_9   (),                     //    (terminated)
		.user_dataout_10  (),                     //    (terminated)
		.user_dataout_11  (),                     //    (terminated)
		.user_dataout_12  (),                     //    (terminated)
		.user_dataout_13  (),                     //    (terminated)
		.user_dataout_14  (),                     //    (terminated)
		.user_dataout_15  (),                     //    (terminated)
		.user_datain_0    (16'b0000000000000000), //    (terminated)
		.user_datain_1    (16'b0000000000000000), //    (terminated)
		.user_datain_2    (16'b0000000000000000), //    (terminated)
		.user_datain_3    (16'b0000000000000000), //    (terminated)
		.user_datain_4    (16'b0000000000000000), //    (terminated)
		.user_datain_5    (16'b0000000000000000), //    (terminated)
		.user_datain_6    (16'b0000000000000000), //    (terminated)
		.user_datain_7    (16'b0000000000000000), //    (terminated)
		.user_datain_8    (16'b0000000000000000), //    (terminated)
		.user_datain_9    (16'b0000000000000000), //    (terminated)
		.user_datain_10   (16'b0000000000000000), //    (terminated)
		.user_datain_11   (16'b0000000000000000), //    (terminated)
		.user_datain_12   (16'b0000000000000000), //    (terminated)
		.user_datain_13   (16'b0000000000000000), //    (terminated)
		.user_datain_14   (16'b0000000000000000), //    (terminated)
		.user_datain_15   (16'b0000000000000000), //    (terminated)
		.user_write       (),                     //    (terminated)
		.user_read        (),                     //    (terminated)
		.user_chipselect  ()                      //    (terminated)
	);

endmodule
