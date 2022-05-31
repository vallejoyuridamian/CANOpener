-- controlador can --
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity controlador_can is
	generic (
	    largo_max_data							: positive := 64;
		largo									: positive := 80;
		unos_end_of_frame 						: positive := 7;
		largo_registro_control 					: positive := 6;
		largo_registro_crc						: positive := 15;
		largo_registro_end_of_frame				: positive := 2;
		max_stuffing							: positive := 5;
		largo_contadores						: positive := 127;
		largo_calculador_crc					: positive := 16;
		cnt_estados								: positive := 4;
		largo_registro_arbitraje				: positive := 12			
	);			
	port(			
		--/dbg			
		--contador_de_crc_dbg       			: out natural range 0 to largo_contadores; 
		--contador_de_data_dbg	  				: out natural range 0 to largo_contadores;
		--largo_data_dbg			  			: out natural range 0 to largo_contadores;
		--contador_de_control_dbg  				: out natural range 0 to largo_contadores;
		--contador_de_arbitraje_dbg				: out natural range 0 to largo_contadores;
		--contador_de_unos_dbg     				: out natural range 0 to largo_contadores;
		--contador_de_end_of_frame_dbg 			: out natural range 0 to largo_contadores;
		--contador_de_ceros_para_stuffing_dbg	: out natural range 0 to largo_contadores;
		--contador_de_unos_para_stuffing_dbg 	: out natural range 0 to largo_contadores;
		--flg_stuff_dbg							: out std_logic;
		--flg_crc_ok_dbg					 	: out std_logic;
		--calculador_crc_dbg		  	 		: out std_logic_vector (largo_calculador_crc - 1 downto 0);
		--registro_crc_dbg		     			: out std_logic_vector (largo_registro_crc -1 downto 0);
		--registro_data_dbg            			: out std_logic_vector (largo_max_data -1 downto 0);
		--registro_control_dbg	     			: out std_logic_vector (largo_registro_control -1 downto 0);
		--registro_arbitraje_dbg       			: out std_logic_vector (largo_registro_arbitraje -1 downto 0);
		--registro_end_of_frame_dbg    			: out std_logic_vector (largo_registro_end_of_frame -1 downto 0);
		--dbg
		--entradas--
		clk          							: in  std_logic;
		reset        							: in  std_logic;
		data_in      	  						: in  std_logic;
		--salidas--
		fifo_we									: out std_logic;
  		estado									: out std_logic_vector (cnt_estados - 1 downto 0);
		fifo_data								: out std_logic_vector (largo - 1 downto 0)		
	);
end controlador_can;
architecture arq_cc of controlador_can is
type state_type is (estado_inicial, espera_start_of_frame, lee_arbitraje, lee_control, lee_data, lee_crc, lee_end_of_frame, guardar_mensaje);
attribute enum_encoding : string;
attribute enum_encoding of state_type : type is "one-hot"; -- "default", "sequential", "gray", "johnson", or "one-hot"
signal state, nxstate : state_type;
signal contador_de_arbitraje	 		: natural range 0 to largo_contadores:= 0;
signal contador_de_control				: natural range 0 to largo_contadores:= 0;
signal contador_de_unos					: natural range 0 to largo_contadores:= 0;
signal contador_de_data					: natural range 0 to largo_contadores:= 0;
signal contador_de_crc 					: natural range 0 to largo_contadores:= 0;
signal contador_de_end_of_frame 		: natural range 0 to largo_contadores:= 0;
signal contador_de_ceros_para_stuffing	: natural range 0 to largo_contadores:= 0;
signal contador_de_unos_para_stuffing 	: natural range 0 to largo_contadores:= 0;
signal registro_data 					: std_logic_vector (largo_max_data - 1 downto 0);
signal registro_arbitraje 				: std_logic_vector (largo_registro_arbitraje - 1 downto 0);
signal registro_control 				: std_logic_vector (largo_registro_control - 1 downto 0);
signal registro_crc 					: std_logic_vector (largo_registro_crc - 1 downto 0);
signal registro_end_of_frame 			: std_logic_vector (largo_registro_end_of_frame - 1 downto 0);
signal calculador_crc					: std_logic_vector (largo_calculador_crc - 1 downto 0);
signal largo_data						: natural range 0 to largo_contadores :=0;
signal flg_stuff 						: std_logic;
signal flg_crc_ok 						: std_logic;
--descripcion de los estados
-- estado_inicial espera 7 unos consecutivos para empezar a esperar el inicio de un mensaje
-- espera_start_of_frame espera un 0 que indica el inicio de un mensaje
-- lee_arbitraje lee los 12 bits de arbitraje (11 de direccion y 1 de transmision de peticion remota) y habilita el shift register para que los guarde
-- lee_control lee los 6 bits de control (extension de identificador, reservado y 4 de longitud de datos
-- lee_data lee los 8*longitud de datos bits de payload
-- lee_crc lee los 15 bits de crc 
-- lee_end_of_frame lee el bit de delimitacion de crc y el hueco de ack, durante el delimitador de ack guardara los datos y los 7 bits de end of frame se leeran en el estado_inicial de la pasada siguiente
-- guardar_mensaje guarda todo el mensaje en un fifo 
begin
	estados: process (state, reset, data_in, contador_de_unos, contador_de_arbitraje, 
		contador_de_control, registro_control, contador_de_data, largo_data, contador_de_crc,
		contador_de_end_of_frame, contador_de_ceros_para_stuffing,contador_de_unos_para_stuffing,flg_stuff)
	begin
		case state is
		--estado inicial--
			when estado_inicial =>
			-- espera 7 unos consecutivos para empezar a esperar el inicio de un mensaje, si justo llega un 0 al final significa que empezó
			-- un mensaje y va a leer el arbitraje derecho
			if contador_de_unos = unos_end_of_frame then
				if data_in = '1' then
					nxstate <= espera_start_of_frame;
				else
					nxstate <= lee_arbitraje;
				end if;
			else
				nxstate <= estado_inicial;
			end if;
			-- espera_start_of_frame
			when espera_start_of_frame =>
			--espera un 0 que indica el inicio de un mensaje
				if data_in = '0' then
					nxstate <= lee_arbitraje;
					else
					nxstate <= espera_start_of_frame;
				end if;
			-- lee_arbitraje 
			when lee_arbitraje =>
			-- lee los 12 bits de arbitraje (11 de direccion y 1 de transmision de peticion remota) y habilita el shift register para que los guarde
			if (contador_de_arbitraje = largo_registro_arbitraje - 1) and flg_stuff = '0' then
				nxstate <= lee_control;
			else
				nxstate <= lee_arbitraje;
			end if;
			-- lee_control
			when lee_control =>
			-- lee los 6 bits de control (extension de identificador, reservado y 4 de longitud de datos
			if (contador_de_control = largo_registro_control - 1) and flg_stuff = '0' then
				nxstate <= lee_data;
				largo_data <=8*to_integer(unsigned( registro_control(largo_registro_control - 3 downto 0)));
			else
				nxstate <= lee_control;
			end if;
			-- lee_data
			when lee_data =>
			--lee los 8*longitud de datos bits de payload
			if ((contador_de_data = largo_data - 1) and flg_stuff = '0') or (largo_data = 0) or (largo_data > 64) then
				nxstate <= lee_crc;
			else
				nxstate <= lee_data;
			end if;
			-- lee_crc 
			when lee_crc =>
			--lee los 15 bits de crc
			if (contador_de_crc = largo_registro_crc - 1) and flg_stuff = '0' then
				nxstate <= lee_end_of_frame;
			else
				nxstate <= lee_crc;
			end if;
			--lee_end_of_frame 
			when lee_end_of_frame =>
			--lee el bit de delimitacion de crc y el hueco de ack, durante el delimitador de ack guardara los datos y los 7 bits de end of frame se leeran en el estado_inicial de la pasada siguiente
			if (contador_de_end_of_frame = largo_registro_end_of_frame - 1) then
				nxstate <= guardar_mensaje;
			else
				nxstate <= lee_end_of_frame;
			end if;
			--guardar_mensaje
			when guardar_mensaje =>
			--guarda todo el mensaje en un fifo 
				nxstate <= estado_inicial;
			when others =>     
				nxstate <= estado_inicial;
		end case;
		--logica de ignorar stuffing--
			if (contador_de_ceros_para_stuffing = max_stuffing) or (contador_de_unos_para_stuffing = max_stuffing) then
				flg_stuff <= '1';
			else 
				flg_stuff <= '0';
			end if;		
		end process;
	
	codificacion_estados: process (state)
	begin
		if state = estado_inicial			then
			estado <= "0000";
		end if;
		if state = espera_start_of_frame	then	
			estado <= "0001";
		end if;
		if state = lee_arbitraje			then	
			estado <= "0010";
		end if;
		if state = lee_control				then	
			estado <= "0011";
		end if;
		if state = lee_data					then
			estado <= "0100";
		end if;
		if state = lee_crc				    then
			estado <= "0101";
		end if;
		if state = lee_end_of_frame			then	
			estado <= "0110";
		end if;
		if state = guardar_mensaje			then	
			estado <= "0111";
		end if;
	end process;
	
	transiciones: process (clk, reset, state,data_in)
	begin
		if reset = '1' then
			state <= estado_inicial;
		elsif clk'event and clk = '1' then
			--contador del estado inicial--
			if state = estado_inicial then
				calculador_crc <= (others => '0');
				contador_de_unos_para_stuffing <= 0;
				contador_de_ceros_para_stuffing <= 0;
				fifo_we <= '0';
				fifo_data <= (others => '0');			
				if data_in = '1' then
					contador_de_unos <= contador_de_unos + 1;
				else
					contador_de_unos <= 0;
				end if;	
			else 	
				contador_de_unos <= 0;
			end if;

			--contador de bits del estado lee_arbitraje--
			if (state = lee_arbitraje) and (flg_stuff = '0') then
				contador_de_arbitraje <= contador_de_arbitraje + 1;
				-- shift register del arbitraje--
				registro_arbitraje(0) <= data_in;
				registro_arbitraje(largo_registro_arbitraje - 1 downto 1)  <= registro_arbitraje(largo_registro_arbitraje - 2 downto 0);
			else
				if  flg_stuff = '0' then
					contador_de_arbitraje <= 0;
				end if;
			end if;
			--contador de bits del estado lee_control--
			if (state = lee_control) and (flg_stuff = '0') then
				contador_de_control <= contador_de_control + 1;
				-- shift register del control--
				registro_control(0) <= data_in;
				registro_control(largo_registro_control - 1 downto 1)  <= registro_control(largo_registro_control - 2 downto 0);
			else
				if  flg_stuff = '0' then
					contador_de_control <= 0;
				end if;	
			end if;
			--contador de bits del estado lee_data--
			if (state = lee_data) and (flg_stuff = '0') then
				contador_de_data <= contador_de_data + 1;
				-- shift register del data--
				registro_data(0) <= data_in;
				registro_data(largo_max_data - 1 downto 1)  <= registro_data(largo_max_data - 2 downto 0);
			else
				if  flg_stuff = '0' then
					contador_de_data <= 0;
				end if;
			end if;					
			--contador de bits del estado lee_crc--
			if (state = lee_crc) and (flg_stuff = '0') then
				contador_de_crc <= contador_de_crc + 1;
				-- shift register del crc--
				registro_crc(0) <= data_in;
				registro_crc(largo_registro_crc - 1 downto 1)  <= registro_crc(largo_registro_crc - 2 downto 0);
			else
				if  flg_stuff = '0' then
					contador_de_crc <= 0;
				end if;
			end if;	
			--contador de bits del estado lee_end_of_frame--
			if state = lee_end_of_frame then
				contador_de_end_of_frame <= contador_de_end_of_frame + 1;
				-- shift register del end_of_frame--
				registro_end_of_frame(0) <= data_in;
				registro_end_of_frame(largo_registro_end_of_frame - 1 downto 1)  <= registro_end_of_frame(largo_registro_end_of_frame - 2 downto 0);
				-- seteo bandera de crc_ok --
				if calculador_crc = x"0000" then
					flg_crc_ok <= '1';
				else
					flg_crc_ok <= '0';
				end if;
			else
				contador_de_end_of_frame <= 0;	
			end if;
			--guardado del mensaje al fifo--
			if state = guardar_mensaje then
				-- guardo el mensaje en un fifo --
				fifo_we <= '1';
				-- en el fifo vamos a poner la direccion (arbitraje) [11], data_len [4], data [64] y flg_crc_ok[1], total 80 --
				fifo_data <= registro_arbitraje(largo_registro_arbitraje - 1 downto 1) & registro_control (largo_registro_control - 3 downto 0)& registro_data & flg_crc_ok;
			else
				fifo_we <= '0';
			end if;
			--contadores de ceros y unos para stuffing--
			if (((not(state = lee_end_of_frame) and not(state = estado_inicial) and not(state = espera_start_of_frame))) or ((state = estado_inicial) and (contador_de_unos = unos_end_of_frame))
				or ((state = espera_start_of_frame) and (data_in = '0'))) then
				if data_in = '1' then
				contador_de_unos_para_stuffing <= contador_de_unos_para_stuffing + 1;
				contador_de_ceros_para_stuffing <= 0;
				else 
					contador_de_ceros_para_stuffing <= contador_de_ceros_para_stuffing + 1;
					contador_de_unos_para_stuffing <= 0;
				end if;
			end if;
			--calculador de crc--
			if ((state = lee_arbitraje) or (state = lee_control) or (state = lee_data) or (state = lee_crc) or (state = espera_start_of_frame and  data_in = '0')
				or (state = estado_inicial and contador_de_unos = unos_end_of_frame and  data_in = '0')) and flg_stuff ='0' and calculador_crc(largo_calculador_crc - 2) = '0' then
				calculador_crc(0) <= data_in;
				calculador_crc(largo_calculador_crc - 1 downto 1)  <= calculador_crc(largo_calculador_crc - 2 downto 0);
			else 
				if (calculador_crc(largo_calculador_crc - 2) = '1') and flg_stuff = '0' then
					calculador_crc <= (calculador_crc(largo_calculador_crc - 2 downto 0)&data_in) xor x"c599";	
				end if;
			end if;
			state <= nxstate;
		end if;
	end process;
	-- dbg
	--contador_de_unos_dbg   <= contador_de_unos;  
	--contador_de_arbitraje_dbg   <= contador_de_arbitraje;  
	--registro_arbitraje_dbg <= registro_arbitraje;  
	--contador_de_control_dbg <= contador_de_control;
	--registro_control_dbg <= registro_control;  
	--largo_data_dbg <= largo_data;
	--contador_de_data_dbg <= contador_de_data;
	--registro_data_dbg <= registro_data;
	--registro_crc_dbg <= registro_crc;
	--contador_de_crc_dbg <= contador_de_crc;
	--contador_de_end_of_frame_dbg <= contador_de_end_of_frame;
	--registro_end_of_frame_dbg <= registro_end_of_frame;
	--contador_de_ceros_para_stuffing_dbg <= contador_de_ceros_para_stuffing;
	--contador_de_unos_para_stuffing_dbg  <= contador_de_unos_para_stuffing;
	--flg_stuff_dbg <= flg_stuff;
	--flg_crc_ok_dbg <=flg_crc_ok;
	--calculador_crc_dbg <= calculador_crc;
	-- /dbg
end arq_cc;