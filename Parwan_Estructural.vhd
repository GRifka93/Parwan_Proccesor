-------------------------------------------------------------------------------
-- Archivo:		Parwan CPU.vhd
-- Ingeniero:	Greg Rifka
-- Description:	Parwan_CPU		 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_unsigned.all;

entity Parwan_CPU_Estructural is
  port(
       clk 				: IN 		 Std_logic;
       reset 			: IN 		 Std_logic;
       read_mem 		: OUT 		 Std_logic;
       write_mem 		: OUT		 Std_logic;
	   DataBus 			: INOUT 	 Std_logic_vector(8-1  downto 0);
       AddrBus 			: OUT		 Std_logic_vector(12-1 downto 0)
  );
end Parwan_CPU_Estructural;

Architecture Estructural of Parwan_CPU_Estructural is	
---- Delclaracion de componentes-----------------------------------------------------
	--Control-----------------------------------------------------------------------
	Component Control_Unit
	  generic(
	       delay_start 		: TIME := 0 NS;
	       read_delay 		: TIME := 3 NS;
	       write_delay 		: TIME := 3 NS
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
	end component;

	--Datapath-----------------------------------------------------------------------
	Component Data_Path
		port( 
			--Conexiones a Memoria y CLK--------------------------------------------
			DataBus					:	 INOUT	Std_Logic_Vector(8-1 downto 0);
			AddrBus					:	 OUT 	Std_Logic_Vector(12-1 downto 0);
			clk						:	 IN 	Std_Logic;							  
			
			--Para el control de los registros-------------------------------------	  
			load_AC					:	 IN 	Std_Logic; 
			zero_AC					:	 IN 	Std_Logic;
			-----------------------------------------------------------------------
			load_IR					:	 IN 	Std_Logic;
			-----------------------------------------------------------------------
			Incr_PC					:	 IN 	Std_Logic;
			load_page_to_PC			:	 IN 	Std_Logic;
			load_offset_to_PC		:	 IN 	Std_Logic; 
			reset_PC				:	 IN 	Std_Logic; 	 
			-----------------------------------------------------------------------	
			load_page_to_MAR		:	 IN 	Std_Logic;
			load_offset_to_MAR		:	 IN 	Std_Logic; 
			-----------------------------------------------------------------------
			load_SR 				:	 IN 	Std_Logic;
			comp_carry_SR			:	 IN 	Std_Logic;
			-----------------------------------------------------------------------
			
			--Conexiones a MAR-----------------------------------------------------
			PC_on_MAR_page			:	 IN 	Std_Logic;
			PC_on_MAR_offset		:	 IN 	Std_Logic;
			DBus_on_MAR_offset		:	 IN 	Std_Logic;
			IR_on_MAR_page			:	 IN 	Std_Logic;
			-----------------------------------------------------------------------
			
			--Conexiones en el data_bus--------------------------------------------	
			PC_offset_on_DBus		:	 IN 	Std_Logic;
			OUTbus_on_DBus 			:	 IN 	Std_Logic;	
			DBusMEM_on_DBus  		:	 IN 	Std_Logic;
			-----------------------------------------------------------------------
			
			--Conexiones en el Address_Bus y Data_BusMEM---------------------------
			MAR_on_adbus 	 		:	 IN 	Std_Logic;
			DBus_on_DBusMEM			:	 IN 	Std_Logic;	
			-----------------------------------------------------------------------
			
			--Para control combinacional-------------------------------------------
			shif_L					:	 IN 	Std_Logic;	
			shif_R					:	 IN 	Std_Logic;
			ALU_CODE				:	 IN 	Std_Logic_Vector(3-1 downto 0);
			-----------------------------------------------------------------------
			
			--Salidas para retroalimentar a la unidad de control-------------------
			IR_lines				:	OUT	 Std_Logic_Vector(8-1 downto 0);
			flag_status				:	OUT	 Std_Logic_Vector(4-1 downto 0)
	);
	end component;
	---------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

---- Declaración de señales----------------------------------------------------------

Signal com_carry_SR 			: Std_logic;
Signal DBusMEM_on_DataBus 		: Std_logic;
Signal DataBus_on_DataBusMEM	: Std_logic;
Signal DataBus_on_MAR_offset 	: Std_logic;
Signal Inc_PC 					: Std_logic;
Signal IR_on_MAR_page 			: Std_logic;
Signal Load_AC 					: Std_logic;
Signal Load_IR 					: Std_logic;
Signal Load_Offset_MAR 			: Std_logic;
Signal Load_offset_PC 			: Std_logic;
Signal Load_page_MAR 			: Std_logic;
Signal load_Page_PC 			: Std_logic;
Signal Load_SR 					: Std_logic;
Signal MAR_on_adbus 			: Std_logic;
Signal OUT_on_DBUS 				: Std_logic;
Signal PC_offset_on_DataBus		: Std_logic;
Signal PC_on_MAR_offset 		: Std_logic;
Signal PC_on_MAR_page 			: Std_logic;
Signal reset_PC 				: Std_logic;
Signal shift_R 					: Std_logic;
Signal shif_L 					: Std_logic;
Signal Zero_AC 					: Std_logic;
Signal ALU_Code 				: Std_logic_vector(2 downto 0);
Signal flag_STATUS 				: Std_logic_vector(3 downto 0);
Signal IR_OUT 					: Std_logic_vector(7 downto 0);

-------------------------------------------------------------------------------------

Begin

----Componentes-------------------------------------------------------------------
----------------------------------------------------------------------------------
U0 : Control_Unit
  port map(
       ALU_CODE			 	=> ALU_Code,
       DBusMEM_on_DBus 		=> DBusMEM_on_DataBus,
       DBus_on_DBusMEM 		=> DataBus_on_DataBusMEM,
       DBus_on_MAR_offset 	=> DataBus_on_MAR_offset,
       IR_OUT 				=> IR_OUT,
       IR_on_MAR_page 		=> IR_on_MAR_page,
       Incr_PC 				=> Inc_PC,
       MAR_on_adbus 		=> MAR_on_adbus,
       OUTbus_on_DBus 		=> OUT_on_DBUS,
       PC_offset_on_DBus 	=> PC_offset_on_DataBus,
       PC_on_MAR_offset 	=> PC_on_MAR_offset,
       PC_on_MAR_page 		=> PC_on_MAR_page,
       clk 					=> clk,
       comp_carry_SR 		=> com_carry_SR,
       flag_status 			=> flag_STATUS,
       load_AC 				=> Load_AC,
       load_IR 				=> Load_IR,
       load_SR				=> Load_SR,
       load_offset_MAR 		=> Load_Offset_MAR,
       load_offset_PC 		=> Load_offset_PC,
       load_page_MAR 		=> Load_page_MAR,
       load_page_PC 		=> load_Page_PC,
       read_mem 			=> read_mem,
       reset 				=> reset,
       reset_PC 			=> reset_PC,
       shif_L				=> shif_L,
       shif_R				=> shift_R,
       write_mem 			=> write_mem,
       zero_AC				=> Zero_AC
);
----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
U1 : Data_Path
  port map(
       ALU_CODE 			=> ALU_Code,
       AddrBus 				=> AddrBus,
       DBusMEM_on_DBus 		=> DBusMEM_on_DataBus,
       DBus_on_DBusMEM 		=> DataBus_on_DataBusMEM,
       DBus_on_MAR_offset 	=> DataBus_on_MAR_offset,
       DataBus 				=> DataBus,
       IR_lines 			=> IR_OUT,
       IR_on_MAR_page 		=> IR_on_MAR_page,
       Incr_PC 				=> Inc_PC,
       MAR_on_adbus 		=> MAR_on_adbus,
       OUTbus_on_DBus 		=> OUT_on_DBUS,
       PC_offset_on_DBus 	=> PC_offset_on_DataBus,
       PC_on_MAR_offset 	=> PC_on_MAR_offset,
       PC_on_MAR_page 		=> PC_on_MAR_page,
       clk					=> clk,
       comp_carry_SR 		=> com_carry_SR,
       flag_status 			=> flag_STATUS,
       load_AC 				=> Load_AC,
       load_IR 				=> Load_IR,
       load_SR 				=> Load_SR,
       load_offset_to_MAR 	=> Load_Offset_MAR,
       load_offset_to_PC 	=> Load_offset_PC,
       load_page_to_MAR 	=> Load_page_MAR,
       load_page_to_PC 		=> load_Page_PC,
       reset_PC 			=> reset_PC,
       shif_L 				=> shif_L,
       shif_R 				=> shift_R,
       zero_AC			    => Zero_AC
  );
-----------------------------------------------------------------------------------

End Estructural;
