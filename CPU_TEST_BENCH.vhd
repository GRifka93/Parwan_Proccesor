Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL; 

--Simulado en Active HDL

Entity TEST_BENCH_CPU is	 
End TEST_BENCH_CPU;

Architecture TEST of TEST_BENCH_CPU is   
-------------------------------------------------------	
--Configuracion inicial
-------------------------------------------------------																										 -------------------------------------------------------------------------------
Component Parwan_CPU_Estructural is	 
  port(
       clk 				: IN 		 Std_logic;
       reset 			: IN 		 Std_logic;
       read_mem 		: OUT 		 Std_logic;
       write_mem 		: OUT		 Std_logic;
	   DataBus 			: INOUT 	 Std_logic_vector(8-1  downto 0);
       AddrBus 			: OUT		 Std_logic_vector(12-1 downto 0)
  );
End Component; 					
-------------------------------------------------------	
--Fin de configuracion inicial	 
type memory is array (0 to 20) of Std_logic_vector(8-1 downto 0); 
-------------------------------------------------------																										 -------------------------------------------------------------------------------
Signal clk							 :	 Std_Logic := '0'; 
Signal reset, read, write   	 	 :	 Std_Logic;
Signal data   						 :	 Std_Logic_Vector(8-1 downto 0):="ZZZZZZZZ";
Signal addr  						 :	 Std_Logic_Vector(12-1 downto 0) := "000000000000";	   
Signal VerSalida			 		 :   Std_Logic_Vector(8-1 downto 0):="00000000";
--------------------------------------------------------  
--------------------------------------------------------
BEGIN	
U0: Parwan_CPU_Estructural PORT MAP (clk,reset,read,write,data,addr);	 
reset <= '1', '0' after 10uS;	
clk		  <= not clk after 1.5us;
Mem: Process	   	   
--Establecer estado de memoria-------------------------------------- 
--25(00011001) en posicion de memoria 10 --> 00001010
--Salida en 15		   		   --> 00001111
Variable my_ram : memory := (
"11100001",     --0 Limpiar AC
"11101000",		--1 Limpiar Carry  
"01000000",	    --2 Sumar directo AC y 
"00001010",	    --3 Posición 10	
"10100000",     --4 Guardar en
"00001111",	    --5 Posicion 15 
"11100000",		--6	FIN
"00000000",		--7
"00000000",		--8
"00000000",		--9 	
"00011001",		--10 aqui hay 25 DEC o 19 HEX
"00000000",		--11
"00000000",		--12
"00000000",		--13	
"00000000",		--14 
"00000000",		--15 salida
"00000000",		--16
"00000000",		--17
"00000000",		--18	
"00000000",		--19 	 
"00000000" 		--20
);		   		
--------------------------------------------------------------------
variable mem_add : integer;
begin		  
--------------------------------------------------------------------
mem_add := to_integer(unsigned(addr));

if read = '1' then
	data <= my_ram(mem_add);
	
elsif write = '1' then 
	data <= "ZZZZZZZZ";	 --Esperando datos
	my_ram(mem_add):= data;
	report "Estoy guardando";

else 
	data <= "ZZZZZZZZ";
end if;

VerSalida <= my_ram(15);

wait for 80ns;

END Process;
End TEST;
---------------------------------------------------------------------