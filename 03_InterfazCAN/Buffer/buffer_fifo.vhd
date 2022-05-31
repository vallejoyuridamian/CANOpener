-- buffer + fifo --
library ieee;
library work;

use ieee.std_logic_1164.all;
use work.controlador_can;
use work.fifo80;

entity buffer_fifo is
	generic(
		largo 			: positive := 80;
		largo_estado	: positive := 4
	);	
	port(
			--entradas--
			clk_can    		: in  std_logic;
			clk_nios   		: in  std_logic;
			reset			: in  std_logic;
			data_in    		: in  std_logic;
			fifo_rdrq		: in  std_logic;
			--salidas--
			fifo_empty 		: out  std_logic;
			fifo_full		: out  std_logic;
  			estado          : out std_logic_vector (largo_estado - 1 downto 0);
			fifo_data_out	: out std_logic_vector (largo -1 downto 0)				
			
	);
end buffer_fifo;

architecture arq_buffer_fifo of buffer_fifo is

signal s_fifo_we 	: std_logic;
signal s_fifo_data 	: std_logic_vector (largo -1 downto 0); 

begin 
	-------------------------------   	       
	inst_buffer: controlador_can
	-------------------------------
		port map (
			--entradas--
			clk   	=> clk_can,
			reset   => reset,
			data_in => data_in,
			--salidas--
			fifo_we => s_fifo_we,
  			estado => estado,
			fifo_data => s_fifo_data
		);   	     
	-------------------------------
	
	-------------------------------   	       
	inst_fifo: fifo80
	-------------------------------
		port map (
			--entradas--
			wrclk   	=> clk_can,
			rdclk   	=> clk_nios,
			aclr        => reset,
			data 	 	=> s_fifo_data,
			wrreq	 	=> s_fifo_we,
			rdreq		=> fifo_rdrq,
			--salidas--
			rdempty 	=> fifo_empty,
			rdfull		=> fifo_full,
			q		 	=> fifo_data_out
		);   	     
	-------------------------------


end arq_buffer_fifo;