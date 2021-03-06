library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CanOpener;

entity CanOpener_top is
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		can_rx : in std_logic;
		leds : out std_logic_vector (7 downto 0)
	);
end CanOpener_top;

architecture arq of CanOpener_top is
begin	
	
  CanOpener_inst : CanOpener
    port map(
      out_port_from_the_pio_led => leds,
      can_rx_to_the_can_opener_inst => can_rx,
      clk_0 => clk,
      reset_n => reset_n
    );
	
end arq;