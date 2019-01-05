-------------------------------------------------------------------------------
-- Archivo:		SR.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del registro SR
-------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;  

--Declaracion de la Entidad
Entity Status_Reg is
port(
	Flag_In 	:	 IN     Std_Logic_Vector(4-1 downto 0);	
	Flag_Out	:	 OUT	Std_Logic_Vector(4-1 downto 0);	
----------------------------------------------------------------
	Clk			:	 IN 	Std_Logic;
	load		:	 IN 	Std_Logic;
	comp_carry	: 	 IN 	Std_Logic 
----------------------------------------------------------------
);
End Status_Reg;
Architecture Sequential of Status_Reg is  
--Señales
Signal 	 Flag_Out_S	:	Std_Logic_Vector(4-1 downto 0) := "0000";	 

Alias    n_in	 	: 	Std_logic is Flag_In(0);
Alias    z_in 		: 	Std_logic is Flag_In(1);
Alias    c_in 		: 	Std_logic is Flag_In(2);
Alias    v_in 		: 	Std_logic is Flag_In(3);

Alias    n_out	 	: 	Std_logic is Flag_Out_S(0);
Alias    z_out 		: 	Std_logic is Flag_Out_S(1);
Alias    c_out 		: 	Std_logic is Flag_Out_S(2);
Alias    v_out 		: 	Std_logic is Flag_Out_S(3);
Begin
--Hard Wire----------------------------------------
Flag_Out 	<= Flag_Out_S;

--Proceso------------------------------------------
SR_P : Process(Clk) begin
		if (falling_edge(Clk)) then
			if (load = '1') then
				n_out	<= n_in;
				z_out	<= z_in;
				v_out	<= v_in;
				c_out	<= c_in xor comp_carry;
			end if;
		end if;
	end process;
End Sequential;

