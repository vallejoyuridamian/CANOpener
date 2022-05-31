-- can_opener.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.buffer_fifo;
use work.freq_div;

entity can_opener is

	port (
		-- clock interface
		clk 				: in  std_logic;
		reset 				: in  std_logic;
		-- slave interface
		slave_address 		: in  std_logic_vector(1 downto 0);
		slave_read 			: in  std_logic;
		slave_write 		: in  std_logic;
		slave_readdata 		: out  std_logic_vector(31 downto 0);
		slave_writedata 	: in  std_logic_vector(31 downto 0);
		slave_byteenable 	: in  std_logic_vector(3 downto 0);
		-- user interface
		can_rx			 	: in  std_logic
	);

end entity can_opener;

architecture rtl of can_opener is

signal	clk_can 		   : std_logic;
signal	s_can_address 	   : std_logic_vector(10 downto 0);
signal	s_can_length       : std_logic_vector(3 downto 0);
signal	s_can_data         : std_logic_vector(63 downto 0);
signal	s_can_crc          : std_logic;
signal	s_fifo_empty       : std_logic;
signal	s_fifo_full        : std_logic;
signal	s_fifo_read        : std_logic;
signal  s_estado 		   : std_logic_vector (3 downto 0);

begin

	cycle:
		process(clk, reset, slave_address, slave_read)
		begin
			if reset = '1' then
				slave_readdata <= x"00000000";
			else
				if clk'event and clk = '1' then
					if slave_read = '1' then
						case to_integer(unsigned(slave_address)) is
						when 0 =>		slave_readdata <= s_estado&'0'&s_can_crc&s_fifo_full&s_fifo_empty&'0'&'0'&'0'&'0'&s_can_length&'0'&'0'&'0'&'0'&'0'&s_can_address;
						when 1 => 		slave_readdata <= s_can_data(31 downto 0);
						when 2 => 		slave_readdata <= s_can_data(63 downto 32);
						when others => 	slave_readdata <= x"FFFFFFFF";
						end case;
					else
						slave_readdata <= x"00000000";
					end if;
					if slave_write = '1' then
						s_fifo_read <= '1';
					else
						s_fifo_read <= '0';
					end if;
				end if;
			end if;
		end process;
	
	buffer_fifo_inst : buffer_fifo
		port map (
			clk_can			 				=> clk_can,
			clk_nios           				=> clk,
			reset							=> reset,
			data_in			 				=> can_rx,
			fifo_data_out(79 downto 69)	 	=> s_can_address,
			fifo_data_out(68 downto 65)		=> s_can_length,
			fifo_data_out(64 downto 1)		=> s_can_data,
			fifo_data_out(0)				=> s_can_crc,
			fifo_empty						=> s_fifo_empty,
			fifo_full						=> s_fifo_full,
			fifo_rdrq						=> s_fifo_read,
			estado							=> s_estado
		);
	
	can_clock_gen : freq_div
		port map (
			CLK_IN		=> clk,
			CLK_OUT		=> clk_can
		);

end architecture rtl; -- of can_opener
