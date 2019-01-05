Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

Entity Tribuff1 is
Port(
	A    : IN  Std_Logic;
	EN   : IN  Std_Logic;    
	Y    : OUT Std_Logic
);
End Tribuff1;

Architecture Behavioral of Tribuff1 is
begin
    Y <= A when (EN = '1') else 'Z';
end Behavioral;