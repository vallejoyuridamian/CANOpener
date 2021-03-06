-- can_opener_0.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.buffer_fifo;
use work.freq_div;

entity can_opener_0 is
	port (
		clk              : in  std_logic                     := '0';             --    clock_reset.clk
		reset            : in  std_logic                     := '0';             --               .reset
		slave_address    : in  std_logic_vector(1 downto 0)  := (others => '0'); -- avalon_slave_0.address
		slave_read       : in  std_logic                     := '0';             --               .read
		slave_write      : in  std_logic                     := '0';             --               .write
		slave_readdata   : out std_logic_vector(31 downto 0);                    --               .readdata
		slave_writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		slave_byteenable : in  std_logic_vector(3 downto 0)  := (others => '0'); --               .byteenable
		can_address      : in  std_logic_vector(10 downto 0) := (others => '0'); --    conduit_end.export
		can_length       : in  std_logic_vector(3 downto 0)  := (others => '0'); --               .export
		can_data         : in  std_logic_vector(63 downto 0) := (others => '0'); --               .export
		can_crc          : in  std_logic                     := '0';             --               .export
		can_estado       : out std_logic_vector(3 downto 0);                     --               .export
		fifo_empty       : in  std_logic                     := '0';             --               .export
		fifo_full        : in  std_logic                     := '0';             --               .export
		fifo_read        : out std_logic                                         --               .export
	);
end entity can_opener_0;

architecture rtl of can_opener_0 is
	component can_opener is
		port (
			clk              : in  std_logic                     := 'X';             --    clock_reset.clk
			reset            : in  std_logic                     := 'X';             --               .reset
			slave_address    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- avalon_slave_0.address
			slave_read       : in  std_logic                     := 'X';             --               .read
			slave_write      : in  std_logic                     := 'X';             --               .write
			slave_readdata   : out std_logic_vector(31 downto 0);                    --               .readdata
			slave_writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); --               .writedata
			slave_byteenable : in  std_logic_vector(3 downto 0)  := (others => 'X'); --               .byteenable
			can_address      : in  std_logic_vector(10 downto 0) := (others => 'X'); --    conduit_end.export
			can_length       : in  std_logic_vector(3 downto 0)  := (others => 'X'); --               .export
			can_data         : in  std_logic_vector(63 downto 0) := (others => 'X'); --               .export
			can_crc          : in  std_logic                     := 'X';             --               .export
			can_estado       : out std_logic_vector(3 downto 0);                     --               .export
			fifo_empty       : in  std_logic                     := 'X';             --               .export
			fifo_full        : in  std_logic                     := 'X';             --               .export
			fifo_read        : out std_logic                                         --               .export
		);
	end component can_opener;
	
signal	clk_can 		   : std_logic;
signal	can_rx 		   	   : std_logic := 'X';
signal	s_can_address 	   : std_logic_vector(10 downto 0);
signal	s_can_length       : std_logic_vector(3 downto 0);
signal	s_can_data         : std_logic_vector(63 downto 0);
signal	s_can_crc          : std_logic;
signal	s_fifo_empty       : std_logic;
signal	s_fifo_full        : std_logic;
signal	s_fifo_read        : std_logic;

begin

	can_opener_0 : component can_opener
		port map (
			clk              => clk,                --    clock_reset.clk
			reset            => reset,              --               .reset
			slave_address    => slave_address,      -- avalon_slave_0.address
			slave_read       => slave_read,         --               .read
			slave_write      => slave_write,        --               .write
			slave_readdata   => slave_readdata,     --               .readdata
			slave_writedata  => slave_writedata,    --               .writedata
			slave_byteenable => slave_byteenable,   --               .byteenable
			can_address      => s_can_address,      --    conduit_end.export
			can_length       => s_can_length,       --               .export
			can_data         => s_can_data,         --               .export
			can_crc          => s_can_crc,          --               .export
			fifo_empty       => s_fifo_empty,       --               .export
			fifo_full        => s_fifo_full,        --               .export
			fifo_read        => s_fifo_read         --               .export

		);
	
	buffer_fifo_0 : buffer_fifo
		port map (
			clk_can			 				=> clk_can,
			clk_nios           				=> clk,
			reset							=> reset,
			--data_in			 				=> can_rx,
			data_in			 				=> can_crc,     ---- PRUEBA
			fifo_data_out(79 downto 69)	 	=> s_can_address,
			fifo_data_out(68 downto 65)		=> s_can_length,
			fifo_data_out(64 downto 1)		=> s_can_data,
			fifo_data_out(0)				=> s_can_crc,
			fifo_empty						=> s_fifo_empty,
			fifo_full						=> s_fifo_full,
			--estado							=> can_estado,
			fifo_rdrq						=> s_fifo_read
		);
	
	can_clock_0 : freq_div
		port map (
			CLK_IN		=> clk,
			CLK_OUT		=> clk_can
		);

--test:
--	process(clk_can)
--	begin
--		if clk_can'event and clk_can = '1' then
--			can_rx <= can_frame(82 - can_i);
--			can_i <= can_i + 1;
--		end if;
--	end process;

end architecture rtl; -- of can_opener_0
