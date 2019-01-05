-------------------------------------------------------------------------------
-- Archivo:		Registro para acceso de memoria.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del contador de programa para la Parwan 
-------------------------------------------------------------------------------

Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

--Declaracion de la Entidad
Entity MAR is
port(
	D				:	 IN 	Std_Logic_Vector(12-1 downto 0);
	Clk				:	 IN 	Std_Logic;
	Enable_Page		:	 IN 	Std_Logic;
 	Enable_Offset	:	 IN 	Std_Logic;
	Q				: 	 OUT 	Std_Logic_Vector(12-1 downto 0)
);
End MAR;

Architecture Sequential of MAR is 
----------------------------------------------------------------
Signal 	 Q_S			:	Std_Logic_Vector(12-1 downto 0);  

Alias    IN_Page	 	: 	Std_logic_vector(4-1 downto 0) is D(12-1 downto 8);
Alias    IN_Offset		: 	Std_logic_vector(8-1 downto 0) is D(8-1 downto 0);

Alias    OUT_Page	 	: 	Std_logic_vector(4-1 downto 0) is Q_S(12-1 downto 8);
Alias    OUT_Offset		: 	Std_logic_vector(8-1 downto 0) is Q_S(8-1 downto 0);
-----------------------------------------------------------------
Begin 												 
	Q <= Q_S;
	PC_P : Process(Clk) begin  
		if (falling_edge(Clk)) then
			if 	Enable_Page = '1' then
				OUT_Page <= IN_Page;
			end if;
			if  Enable_Offset = '1' then
				OUT_Offset <= IN_Offset;
			end if;
		end if;
	end process;
End Sequential;