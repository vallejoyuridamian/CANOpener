-- can_opener_inst.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity can_opener_inst is
	port (
		clk              : in  std_logic                     := '0';             -- clock_reset.clk
		reset            : in  std_logic                     := '0';             --            .reset
		slave_address    : in  std_logic_vector(1 downto 0)  := (others => '0'); --       slave.address
		slave_read       : in  std_logic                     := '0';             --            .read
		slave_write      : in  std_logic                     := '0';             --            .write
		slave_readdata   : out std_logic_vector(31 downto 0);                    --            .readdata
		slave_writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --            .writedata
		slave_byteenable : in  std_logic_vector(3 downto 0)  := (others => '0'); --            .byteenable
		can_rx           : in  std_logic                     := '0'              -- conduit_end.export
	);
end entity can_opener_inst;

architecture rtl of can_opener_inst is
	component can_opener is
		port (
			clk              : in  std_logic                     := 'X';             -- clock_reset.clk
			reset            : in  std_logic                     := 'X';             --            .reset
			slave_address    : in  std_logic_vector(1 downto 0)  := (others => 'X'); --       slave.address
			slave_read       : in  std_logic                     := 'X';             --            .read
			slave_write      : in  std_logic                     := 'X';             --            .write
			slave_readdata   : out std_logic_vector(31 downto 0);                    --            .readdata
			slave_writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); --            .writedata
			slave_byteenable : in  std_logic_vector(3 downto 0)  := (others => 'X'); --            .byteenable
			can_rx           : in  std_logic                     := 'X'              -- conduit_end.export
		);
	end component can_opener;

begin

	can_opener_inst : component can_opener
		port map (
			clk              => clk,              -- clock_reset.clk
			reset            => reset,            --            .reset
			slave_address    => slave_address,    --       slave.address
			slave_read       => slave_read,       --            .read
			slave_write      => slave_write,      --            .write
			slave_readdata   => slave_readdata,   --            .readdata
			slave_writedata  => slave_writedata,  --            .writedata
			slave_byteenable => slave_byteenable, --            .byteenable
			can_rx           => can_rx            -- conduit_end.export
		);

end architecture rtl; -- of can_opener_inst
