-- Shift register --

-----------------------------------------------------------
----- shift_register
-----------------------------------------------------------

-----------------------------------------------------------
----- PACKAGE pk_shift_register
-----------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE pk_shift_register IS
	COMPONENT shift_register IS
		GENERIC (
			largo: POSITIVE := 108
		);
		PORT(
			clear_in      : IN  STD_LOGIC;
			enable_in     : IN  STD_LOGIC;
			clk_in        : IN  STD_LOGIC;
			reset_in      : IN  STD_LOGIC;
			data_in		  : IN  STD_LOGIC;			
			data_out      : OUT STD_LOGIC_VECTOR(largo - 1 downto 0)
		);
	END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY shift_register
-----------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY shift_register IS
		GENERIC (
			largo: POSITIVE := 108
		);
		PORT(
			clear_in      : IN  STD_LOGIC;
			enable_in     : IN  STD_LOGIC;
			clk_in        : IN  STD_LOGIC;
			reset_in      : IN  STD_LOGIC;
			data_in		  : IN  STD_LOGIC;
			data_out      : OUT STD_LOGIC_VECTOR(largo - 1 downto 0)
		);
END shift_register;

ARCHITECTURE arq_sr OF shift_register IS

SIGNAL 	s_data_out: STD_LOGIC_VECTOR(largo - 1 downto 0);


BEGIN

shift_register:
	PROCESS (clear_in, enable_in, clk_in)
	BEGIN
		IF reset_in = '1' THEN
			s_data_out  <= (OTHERS => '0');
		ELSIF (clk_in'event AND clk_in='1') THEN
            IF (clear_in='1') THEN
                s_data_out  <= (OTHERS => '0');
            ELSIF (enable_in='1') THEN
				s_data_out(largo - 1) <= data_in;
                s_data_out(largo - 2 downto 0)  <= s_data_out(largo - 1 downto 1);
			END IF;
		END IF;				
		data_out <= s_data_out;
	END PROCESS;    	
END arq_sr;