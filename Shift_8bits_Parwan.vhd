-------------------------------------------------------------------------------
-- Archivo:		Shift.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del Shift para el procesador
-------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

Entity Shifter is 
port(	
----------------------------------------------------------------
	A			:	 IN 	Std_Logic_Vector(8-1 downto 0);
	L			:	 IN     Std_Logic;	
	R			:	 IN     Std_Logic;
----------------------------------------------------------------
    Flag_In    	:	 IN     Std_Logic_Vector(4-1 downto 0);
----------------------------------------------------------------
	Y			:	 OUT	Std_Logic_Vector(8-1 downto 0);
	Flag_Out	:	 OUT	Std_Logic_Vector(4-1 downto 0)
----------------------------------------------------------------
);
End Shifter;		

Architecture Dataflow of Shifter is 
--Señales
Signal 	 Flag_Out_S	:	Std_Logic_Vector(4-1 downto 0) := "0000";	 
Signal 	 Y_S		:	Std_Logic_Vector(8-1 downto 0);	 
Signal 	 OPCOD		:	Std_Logic_Vector(2-1 downto 0);	

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
Y	 		<= Y_S;
n_out    	<= Y_S(8-1);
OPCOD	    <= (R & L);
With Y_S select
	z_out <= 
				'1'  when (others => '0'),
                '0'  when others;
---------------------------------------------------	  
Shifter_P: Process(A,OPCOD) 	
Begin
--Operación
	Case OPCOD is 
		when "00" | "11" => 	   
			Y_S 	  <= A;
			c_out	  <= c_in;
			v_out	  <= v_in; 
		when "01" => 	   
			Y_S 	  <= (A(7-1 downto 0) & '0');		--Corrimiento a la izquierda <-
			c_out	  <= Y_S(8-1); 				 		--Mueve el MSB al carry
			v_out	  <= Y_S(8-1) xor Y_S(7-1);  		--El numero cambio de signo, mandar overflow!
		when "10" => 	   
			Y_S 	  <= ( A(8-1) & A(8-1 downto 1) );	--Corrimiento a la derecha -> (se repite el signo)
			c_out	  <= c_in;					   		
			v_out	  <= v_in;
		when others => 
			Y_S 	  <= (others => 'X'); 
			c_out	  <= 'X';
			v_out	  <= 'X';
	end case;
end process;		 
End DataFlow;