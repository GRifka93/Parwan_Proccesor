-------------------------------------------------------------------------------
-- Archivo:		Registro_Instruccion.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del Registro Instruccion para la Parwan 
-------------------------------------------------------------------------------

Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

--Declaracion de la Entidad
Entity IR is
port(
	D		:	 IN 	Std_Logic_Vector(8-1 downto 0);
	Clk		:	 IN 	Std_Logic;
	load	:	 IN 	Std_Logic;
	Q		: 	 OUT 	Std_Logic_Vector(8-1 downto 0)
);

End IR;

Architecture Sequential of IR is begin 
AC_P : Process(Clk) begin  
	if (falling_edge(Clk)) then
		if (load='1' ) then
			Q  <= D;
		end if;
	end if;
end process;
End Sequential;