-- can_opener.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity can_opener is

	port (
		-- clock interface
		clk 	: in  std_logic;
		reset 	: in  std_logic;		
		-- slave interface
		slave_address 		: in  std_logic_vector(1 downto 0);
		slave_read 			: in  std_logic;
		slave_write 		: in  std_logic;
		slave_readdata 		: out  std_logic_vector(31 downto 0);
		slave_writedata 	: in  std_logic_vector(31 downto 0);
		slave_byteenable 	: in  std_logic_vector(3 downto 0);
		-- user interface
		can_address : in  std_logic_vector(10 downto 0);
		can_length 	: in  std_logic_vector(3 downto 0);
		can_data 	: in  std_logic_vector(63 downto 0);
		can_crc 	: in  std_logic;
		can_estado	: out std_logic_vector(3 downto 0);
		fifo_empty 	: in  std_logic;
		fifo_full 	: in  std_logic;
		fifo_read 	: out  std_logic
	);

end entity can_opener;

architecture rtl of can_opener is
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
					when 0 =>		slave_readdata <= '0'&'0'&'0'&'0'&'0'&can_crc&fifo_full&fifo_empty&'0'&'0'&'0'&'0'&can_length&'0'&'0'&'0'&'0'&'0'&can_address;
					when 1 => 		slave_readdata <= can_data(31 downto 0);
					when 2 => 		slave_readdata <= can_data(63 downto 32);
					--when 3 => 		slave_readdata <= x"00000000";
					when others => 	slave_readdata <= x"FFFFFFFF";
					end case;
				else
					slave_readdata <= x"00000000";
				end if;
				if slave_write = '1' then
					fifo_read <= '1';
				else
					fifo_read <= '0';
				end if;
			end if;
		end if;
	end process;

end architecture rtl; -- of can_opener
