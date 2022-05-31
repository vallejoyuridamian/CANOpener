  --Example instantiation for system 'CanOpener'
  CanOpener_inst : CanOpener
    port map(
      out_port_from_the_pio_led => out_port_from_the_pio_led,
      can_rx_to_the_can_opener_inst => can_rx_to_the_can_opener_inst,
      clk_0 => clk_0,
      reset_n => reset_n
    );


