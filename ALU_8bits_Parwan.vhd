-------------------------------------------------------------------------------
-- Archivo:		ALU.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del ALU para el procesador

--Codigos de operación

--000 Salida A
--001 Salida B

--010 Salida not A
--011 Salida not B

--100 Salida A+B
--101 Salida A-B  

--110 Salida  A OR B
--111 Salida  A and B		  

--Notas
---Algo a destacar en la ALU es el uso de las flags, dichas señales
---No son inteligentes y su uso debe ser entendido y aprovechado por 
---el programador, por ejemplo la suma 01111111 + 00000001 claramente
---produccira un numero 10000000, el activara el Flag_Out negativo, lo cual
---es correcto si se esta pensando los numeros como complemento a dos, como
---dos numeros positivos generaron uno negativo claramente hubo un 
--desbordamiento sin embargo la ALU no activa la Flag_Out desbordamiento.

---Lo anterior se debe a que la ALU no utiliza un formato para representar numeros
---el circuito no sabe si realiza operaciónes de complemento a uno o a dos, o cualquier otro,
---el interpretar las flags depende mucho del programador y su conocimiento de la microarquitectura.   

---Notese que la ALU tienen entradas flag_in las cuales
---son utiles para conexion en cascada de las mismas.
------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;

Entity ALU is 
port(	
----------------------------------------------------------------
	A			:	 IN 	Std_Logic_Vector(8-1 downto 0);
	B			:	 IN 	Std_Logic_Vector(8-1 downto 0);  
	OPCOD		:	 IN     Std_Logic_Vector(3-1 downto 0);	 
----------------------------------------------------------------
    Flag_In    	:	 IN     Std_Logic_Vector(4-1 downto 0);
----------------------------------------------------------------
	Y			:	 OUT	Std_Logic_Vector(8-1 downto 0);
	Flag_Out	:	 OUT	Std_Logic_Vector(4-1 downto 0)
----------------------------------------------------------------
);
End ALU;	

Architecture Dataflow of ALU is   
--Señales
Signal 	 Flag_Out_S	:	Std_Logic_Vector(4-1 downto 0) := "0000";	 
Signal 	 Y_S		:	Std_Logic_Vector(8-1 downto 0);	 

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

With Y_S select
	z_out <= 
				'1'  when (others => '0'),
                '0'  when others;
---------------------------------------------------	  
ALU_P: Process(A,B,OPCOD) 	
Variable temp	:	unsigned(10-1 downto 0); 
Begin
--Operación
	Case OPCOD is 
		when "000" => 	   
			Y_S 	  <= A;
			c_out	  <= c_in;
			v_out	  <= v_in;
		when "001" => 	   
			Y_S 	  <= B;
			c_out	  <= c_in;
			v_out	  <= v_in;
		when "010" => 	   
			Y_S 	  <= NOT A;
			c_out	  <= c_in;
			v_out	  <= v_in;
		when "011" =>
			Y_S 	  <= NOT B;
			c_out	  <= c_in;
			v_out	  <= v_in;
		when "100" =>
			temp  	  :=  unsigned('0' & c_in & B)+unsigned('0' & '0' & A);   
			Y_S	  	  <= Std_logic_vector( temp(7 downto 0) );
			c_out	  <= Std_logic(temp(8));   
			v_out	  <= Std_logic(temp(9)); 
		when "101" =>
			temp  	  :=  unsigned('0' & c_in & B)-unsigned('0' & '0' & A);   
			Y_S	  	  <= Std_logic_vector( temp(7 downto 0) );
			c_out	  <= Std_logic(temp(8));
			v_out	  <= Std_logic(temp(9));
		when "110" =>
			Y_S 	  <= A or B; 
			c_out	  <= c_in;
			v_out	  <= v_in;
		when "111" =>
			Y_S 	  <= A and B; 			
			c_out	  <= c_in;	
			v_out	  <= v_in;
		when others => 
			Y_S 	  <= (others => 'X');
	end case;
end process;		 
End DataFlow;