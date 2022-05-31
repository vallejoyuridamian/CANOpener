  //Example instantiation for system 'DE0_SOPC'
  DE0_SOPC DE0_SOPC_inst
    (
      .can_address_to_the_can_opener_0  (can_address_to_the_can_opener_0),
      .can_crc_to_the_can_opener_0      (can_crc_to_the_can_opener_0),
      .can_data_to_the_can_opener_0     (can_data_to_the_can_opener_0),
      .can_estado_from_the_can_opener_0 (can_estado_from_the_can_opener_0),
      .can_length_to_the_can_opener_0   (can_length_to_the_can_opener_0),
      .clk_0                            (clk_0),
      .fifo_empty_to_the_can_opener_0   (fifo_empty_to_the_can_opener_0),
      .fifo_full_to_the_can_opener_0    (fifo_full_to_the_can_opener_0),
      .fifo_read_from_the_can_opener_0  (fifo_read_from_the_can_opener_0),
      .out_port_from_the_pio_led        (out_port_from_the_pio_led),
      .reset_n                          (reset_n)
    );

