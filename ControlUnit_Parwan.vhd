-------------------------------------------------------------------------------
-- Archivo:		Controler.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación de la unidad de control			 
------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

Entity Control_Unit is	 
generic (
	delay_start						: 		Time := 0NS;
	read_delay 						: 		Time := 3NS;
	write_delay 					: 		Time := 3NS
);

port(
		--CLK, mem y reset-----------------------------------------------------
		clk						:	 IN 	Std_Logic;	
		read_mem			    : 	 OUT 	Std_logic;
		write_mem			    :	 OUT 	Std_logic;
		reset					:	 IN		Std_logic;
		
		--Para el control de los registros-------------------------------------	  
		load_AC					:	 OUT 	Std_Logic; 
		zero_AC					:	 OUT 	Std_Logic;
		-----------------------------------------------------------------------
		load_IR					:	 OUT 	Std_Logic;
		-----------------------------------------------------------------------
		Incr_PC					:	 OUT 	Std_Logic;
		load_page_PC			:	 OUT 	Std_Logic;
		load_offset_PC			:	 OUT 	Std_Logic; 
		reset_PC				:	 OUT 	Std_Logic; 	 
		-----------------------------------------------------------------------	
		load_page_MAR			:	 OUT 	Std_Logic;
		load_offset_MAR			:	 OUT 	Std_Logic; 
		-----------------------------------------------------------------------
		load_SR 				:	 OUT 	Std_Logic;
		comp_carry_SR			:	 OUT 	Std_Logic;
		-----------------------------------------------------------------------
		
		--Conexiones a MAR-----------------------------------------------------
		PC_on_MAR_page			:	 OUT 	Std_Logic;
		PC_on_MAR_offset		:	 OUT 	Std_Logic;
		DBus_on_MAR_offset		:	 OUT 	Std_Logic;
		IR_on_MAR_page			:	 OUT 	Std_Logic;
		-----------------------------------------------------------------------
		
		--Conexiones en el data_bus--------------------------------------------	
		PC_offset_on_DBus		:	 OUT 	Std_Logic;
		OUTbus_on_DBus 			:	 OUT 	Std_Logic;	
		DBusMEM_on_DBus  		:	 OUT 	Std_Logic;
		-----------------------------------------------------------------------
		
		--Conexiones en el Address_Bus y Data_BusMEM---------------------------
		MAR_on_adbus 	 		:	 OUT 	Std_Logic;
		DBus_on_DBusMEM			:	 OUT 	Std_Logic;	
		-----------------------------------------------------------------------
		
		--Para control combOUTacional-------------------------------------------
		shif_L					:	 OUT 	Std_Logic;	
		shif_R					:	 OUT 	Std_Logic;
		ALU_CODE				:	 OUT 	Std_Logic_Vector(3-1 downto 0);
		-----------------------------------------------------------------------
		
		--Salidas para retroalimentar a la unidad de control-------------------
		IR_OUT					:	 IN	 	Std_Logic_Vector(8-1 downto 0);
		flag_status				:	 IN	 	Std_Logic_Vector(4-1 downto 0)
		
);
End Control_Unit;	   

Architecture State_Machine of Control_Unit is 
---------------------------------------------------------------------------------------------------
--Estados
type State_type is (ST0,ST1,ST2,ST3,ST4,ST5,ST6,ST7,ST8);
signal PS, NS  	  :  State_type; 
signal INT_STATE  :  Std_logic_vector(4-1 downto 0);
---------------------------------------------------------------------------------------------------
begin 
----------------------------------------------------------------------------------------------------
Seq_proc: process(Clk,Reset,NS) begin 	
--Proceso sensible al estado siguiente, las entradas asicronicas y el reloj	
		--Parte Asicronica---------------------------------------------------------------------------
		if (reset = '1') then          	--Accion asicronica
			PS <= ST0;
		---------------------------------------------------------------------------------------------		
		--Parte Sicronica----------------------------------------------------------------------------
		elsif (falling_edge(Clk)) then	--Evaluacion de estado sicronica, siempre presente en las FSM
			PS <= NS;
		----------------------------------------------------------------------------------------------
		end if;
end process;


Comb_proc: process(PS,IR_OUT,flag_status) begin 	
--Pre asignación de salida para desactivar señales no usadas--------------------------------------------- 
		-----------------------------------------------------------------------
		read_mem			    <= '0' 		after delay_start;
		write_mem			    <= '0' 		after delay_start;
		--Para el control de los registros-------------------------------------	  
		load_AC					<= '0' 		after delay_start; 
		zero_AC					<= '0' 		after delay_start;
		-----------------------------------------------------------------------
		load_IR					<= '0' 		after delay_start;
		-----------------------------------------------------------------------
		Incr_PC					<= '0' 		after delay_start;
		load_page_PC			<= '0' 		after delay_start;
		load_offset_PC			<= '0' 		after delay_start; 
		reset_PC				<= '0' 		after delay_start; 	 
		-----------------------------------------------------------------------	
		load_page_MAR			<= '0' 		after delay_start;
		load_offset_MAR			<= '0' 		after delay_start; 
		-----------------------------------------------------------------------
		load_SR 				<= '0' 		after delay_start;
		comp_carry_SR			<= '0' 		after delay_start;
		-----------------------------------------------------------------------
		
		--Conexiones a MAR-----------------------------------------------------
		PC_on_MAR_page			<= '0' 		after delay_start;
		PC_on_MAR_offset		<= '0' 		after delay_start;
		DBus_on_MAR_offset		<= '0' 		after delay_start;
		IR_on_MAR_page			<= '0' 		after delay_start;
		-----------------------------------------------------------------------
		
		--Conexiones en el data_bus--------------------------------------------	
		PC_offset_on_DBus		<= '0' 		after delay_start;
		OUTbus_on_DBus 			<= '0' 		after delay_start;	
		DBusMEM_on_DBus  		<= '0' 		after delay_start;
		-----------------------------------------------------------------------
		
		--Conexiones en el Address_Bus y Data_BusMEM---------------------------
		MAR_on_adbus 	 		<= '0' 		after delay_start;
		DBus_on_DBusMEM			<= '0' 		after delay_start;	
		-----------------------------------------------------------------------
		
		--Para control combOUTacional-------------------------------------------
		shif_L					<= '0' 		after delay_start;	
		shif_R					<= '0' 		after delay_start;
		ALU_CODE				<= "000"	after delay_start;
----------------------------------------------------------------------------------------------------------
		
	Case PS is	
	--Acciones en el estado Fetch----------------------------------------	
		when ST0 =>
			if (reset = '1') then      
				reset_PC <= reset;
			else
			--Prepar lectura y guardar en MAR-------------------------------
				PC_on_MAR_page 			<= '1';	
				PC_on_MAR_offset		<= '1';	
				load_page_MAR			<= '1';
				load_offset_MAR			<= '1';	 
				NS <= ST1;
			end if;			
	--Fin de las acciones en el estado---------------------------------
	
	--Acciones en el estado Leer instrución----------------------------------------	
		when ST1 =>	
	--Guardar instrucción en IR----------------------------------------
		MAR_on_adbus			<= '1';	
		read_mem 				<= '1' after read_delay; 
		DBusMEM_on_DBus			<= '1';	
		ALU_CODE 				<= "000";
		load_IR 				<= '1';
		Incr_PC 				<= '1';
	--Estado siguiente-------------------------------------------------
		NS <= ST2;
	--Fin de las acciones en el estado---------------------------------	  

	--Decodificador de instruccion y completación si es de 1 byte
		when ST2 =>	
	--Pre-establecer MAR para lectura de siguiente instruccion-----------
			PC_on_MAR_page 			<= '1';	
			PC_on_MAR_offset		<= '1';	
			load_page_MAR			<= '1';
			load_offset_MAR			<= '1';
	--Estados siguiente-------------------------------------------------
			if IR_OUT(8-1 downto 4) = "1110" then 
			--Instrucciones de 1 Byte
				Case IR_OUT(4-1 downto 0) is 
					when "0000" => 
						NULL;
					when "0001" =>	
						load_AC <= '1';
						zero_AC <= '1';
					when "0010" =>
						ALU_CODE <=	"011";
					when "0100" =>
						comp_carry_SR <= '1';  
					when "1000" =>
						shif_L	<= '1'; 
					when "1001" =>
						shif_R	<= '1';
					when others => 
						NULL;
				end case; 
				NS <= ST1; --Ya se precargo la instruccion por lo que no es necesario volver a ST0
			else
				NS <= ST3;
			end if;
	--Fin de las acciones en el estado---------------------------------	
	
	--Cargar segundo Byte y identificación de paradigma de memoria
		when ST3 =>	
	--Pre-establecer MAR para lectura----------------------------------
		MAR_on_adbus			<= '1';	
		read_mem 				<= '1' after read_delay; 
		DBusMEM_on_DBus			<= '1';	
	--Leer siguiente instrucción---------------------------------------
		DBus_on_MAR_offset	    <= '1';
		load_offset_MAR         <= '1';
	--Estados siguiente-------------------------------------------------
		if IR_OUT(8-1 downto 6) /= "11" then  --Instruccion de toda la memoria	   
			IR_on_MAR_page 	    <= '1';	 
			load_page_MAR 	    <= '1';	  
			if IR_OUT(4) = '1' then		
				NS <= ST4; --Lectura indirecta
			else
				NS <= ST5; --Lectura directa, pasar al estado de instrucción;  
			end if;
		else								  --Instrucción de la misma pagina
			if IR_OUT(5) = '0' then		
				NS <= ST6; --Subrutina 
			else
				NS <= ST7; --Bifurcación si;  
			end if;								  
		end if;									  
		Incr_PC <= '1';	
	--Fin de las acciones en el estado---------------------------------	  
	
	--Generar la lectura indirecta
		when ST4 =>
		--Prepar lectura y guardar en MAR-------------------------------
			MAR_on_adbus 			<= '1';	
			read_mem				<= '1';	
			DBusMEM_on_DBus			<= '1';
			DBus_on_MAR_offset		<= '1';
			load_offset_MAR 		<= '1';
		--Estado siguiente---------------------------------------------
				NS <= ST5;
	--Fin de las acciones en el estado---------------------------------	  

	--Instrucción de toda la memoria
		when ST5 =>
			if IR_OUT(8-1 downto 5) = "100" then --Instrucción SUBRUTINA  
				--Cargar brinco
				load_page_PC 			<= '1';
				load_offset_PC 			<= '1';	
				--Decodificar brinco
				NS 						<= ST1;	   
			elsif IR_OUT(8-1 downto 5) = "101" then	 --Salvar AC
				MAR_on_adbus			<= '1';	
				ALU_CODE 				<= "001";
				OUTbus_on_DBus          <= '1';
				DBus_on_DBusMEM         <= '1';
				write_mem				<= '1';
				NS 						<= ST0;	
			elsif IR_OUT(8-1) = '0' then	 		--Operación
				MAR_on_adbus			<= '1';
				read_mem				<= '1';
				DBusMEM_on_DBus         <= '1';
				Case IR_OUT(7-1 downto 5) is 
					when "00" => 
						ALU_CODE <= "000";
					when "01" =>	
						ALU_CODE <= "111";
					when "10" =>
						ALU_CODE <=	"100";
					when "11" =>
						ALU_CODE <=	"101";  
					when others => 
						ALU_CODE <=	"XXX"; 
				end case; 
				load_SR 		<= '1';
				load_AC 		<= '1';
				NS				<= ST0;		
			else
				NS				<= ST0;	  --No deberia pasar
			end if;
	--Fin de las acciones en el estado---------------------------------	 
	
	--Instrucción misma pagina, Subrutina
		when ST6 =>
		--Prepar lectura y guardar en MAR-------------------------------
			MAR_on_adbus 			<= '1';	
			PC_offset_on_DBus		<= '1';	
			DBus_on_DBusMEM			<= '1';
			write_mem				<= '1';
			load_offset_PC          <= '1';
		--Estado siguiente---------------------------------------------
				NS <= ST7;
	--Fin de las acciones en el estado---------------------------------
	
	--Instrucción misma pagina, Subrutina continuación
		when ST7 =>
		--Aumentar el contador para Subrutina--------------------------
			Incr_PC		 			<= '1';	
		--Estado siguiente---------------------------------------------
			NS <= ST0;
	--Fin de las acciones en el estado---------------------------------

	--Instrucción misma pagina, Brinco---------------------------------
		when ST8 =>	  
			--Brinco--------------------------------------------------------
			if 
				(IR_OUT(0) = '1' and flag_status(0) = '1') or --Brinco Si n
				(IR_OUT(1) = '1' and flag_status(1) = '1') or --Brinco Si z
				(IR_OUT(2) = '1' and flag_status(2) = '1') or --Brinco Si c
				(IR_OUT(3) = '1' and flag_status(3) = '1')   --Brinco Si v
			then 
				load_offset_PC <= '1';
				NS <= ST0;
			else
				load_offset_PC <= '0';
				NS <= ST0;	
			end if;
	--Fin de las acciones en el estado---------------------------------	
		when others =>
			NS <= ST0;
	end case;	  
End process; 

with PS select
INT_STATE <= 
		 "0000" when ST0,
		 "0001" when ST1,
		 "0010" when ST2,
		 "0011" when ST3,
		 "0100" when ST4,
		 "0101" when ST5,
		 "0110" when ST6,
		 "0111" when ST7,
		 "1000" when ST8,
		 "XXXX" when others;
End State_Machine;