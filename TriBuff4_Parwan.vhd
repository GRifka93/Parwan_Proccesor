Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

Entity Tribuff4 is
Port(
	A    : IN  Std_Logic_Vector(4-1 downto 0);
	EN   : IN  Std_Logic;    
	Y    : OUT Std_Logic_Vector(4-1 downto 0)
);
End Tribuff4;

Architecture Behavioral of Tribuff4 is
begin
    Y <= A when (EN = '1') else (others => 'Z');
end Behavioral;