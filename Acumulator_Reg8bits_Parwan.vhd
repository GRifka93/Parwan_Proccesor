-------------------------------------------------------------------------------
-- Archivo:		Acumulador.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del Acumulador para la Parwan 
-------------------------------------------------------------------------------

Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

--Declaracion de la Entidad
Entity AC is
port(
	D		:	 IN 	Std_Logic_Vector(8-1 downto 0);
	Clk		:	 IN 	Std_Logic;
	Reset	:	 IN 	Std_Logic;
	load	:	 IN 	Std_Logic;
	Q		: 	 OUT 	Std_Logic_Vector(8-1 downto 0)
);

End AC;

Architecture Sequential of AC is begin 
AC_P : Process(Clk) begin  
	if (falling_edge(Clk)) then
		if    (Reset = '1' and load='1' ) then
			Q  <= (others => '0');
		elsif (Reset = '0' and load='1' ) then
			Q  <= D; 
		end if;
	end if;
end process;
End Sequential;