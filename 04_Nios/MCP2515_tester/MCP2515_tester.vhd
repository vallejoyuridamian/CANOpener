library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.freq_div;

entity MCP2515_tester is
   	port(
		 clk_in		: in  std_logic;
   		 data_out	: out std_logic
   	);
end MCP2515_tester;

architecture arq of MCP2515_tester is

	signal	clk_can		: std_logic;
	signal 	can_frame	: std_logic_vector(82 downto 0):= "00000100101000001000100000100111101110101001110111111111111111111111111111111111111";
	signal	can_i		: natural range 0 to 82 := 0;

begin

	can_clock_div : freq_div
		port map (
			CLK_IN		=> clk_in,
			CLK_OUT		=> clk_can
		);

	test:
		process(clk_can)
		begin
			if clk_can'event and clk_can = '1' then
				data_out <= can_frame(82 - can_i);
				can_i <= can_i + 1;
			end if;
		end process;
	
end arq;