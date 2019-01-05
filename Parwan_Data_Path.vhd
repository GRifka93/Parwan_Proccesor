-------------------------------------------------------------------------------
-- Archivo:		Data_Path
-- Ingeniero:	Greg Rifka
-- Description:	Implementación del Data_Path para la Parwan 
-------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.ALL;
Use IEEE.NUMERIC_STD.ALL;


Entity Data_Path is
	port( 
		--Conexiones a Memoria y CLK--------------------------------------------
		DataBus					:	 INOUT	Std_Logic_Vector(8-1 downto 0) := (others => 'Z');
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
End Data_Path;		

Architecture Structural of Data_Path is  
	--Componentes--------------------------------------------																										 
	Component ALU is
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
	End Component; 
	
	Component Shifter is
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
	End Component; 		
	
	Component Status_Reg is
		port(
			Flag_In 	:	 IN     Std_Logic_Vector(4-1 downto 0);	
			Flag_Out	:	 OUT	Std_Logic_Vector(4-1 downto 0);	
			----------------------------------------------------------------
			clk			:	 IN 	Std_Logic;
			load		:	 IN 	Std_Logic;
			comp_carry	: 	 IN 	Std_Logic 
			----------------------------------------------------------------
			);
	End Component;	  
	
	Component AC is
		port(
			D		:	 IN 	Std_Logic_Vector(8-1 downto 0);
			clk		:	 IN 	Std_Logic;
			Reset	:	 IN 	Std_Logic;
			load	:	 IN 	Std_Logic;
			Q		: 	 OUT 	Std_Logic_Vector(8-1 downto 0)
			);
	End Component;	
	
	Component IR is
		port(
			D		:	 IN 	Std_Logic_Vector(8-1 downto 0);
			clk		:	 IN 	Std_Logic;
			load	:	 IN 	Std_Logic;
			Q		: 	 OUT 	Std_Logic_Vector(8-1 downto 0)
			);
	End Component;
	
	Component PC is
		port(
			D				:	 IN 	Std_Logic_Vector(12-1 downto 0);
			clk				:	 IN 	Std_Logic;
			inc				:	 IN 	Std_Logic;
			reset			:	 IN 	Std_Logic;
			Enable_Page		:	 IN 	Std_Logic;
			Enable_Offset	:	 IN 	Std_Logic;
			Q				: 	 OUT 	Std_Logic_Vector(12-1 downto 0)
			);
	End Component;	
	
	Component MAR is
		port(
			D				:	 IN 	Std_Logic_Vector(12-1 downto 0);
			clk				:	 IN 	Std_Logic;
			Enable_Page		:	 IN 	Std_Logic;
			Enable_Offset	:	 IN 	Std_Logic;
			Q				: 	 OUT 	Std_Logic_Vector(12-1 downto 0)
			);
	End Component;
	
	Component Tribuff1 is
		Port(
			A    : IN  Std_Logic;
			EN   : IN  Std_Logic;    
			Y    : OUT Std_Logic
			);
	End Component; 	
	
	Component Tribuff4 is
		Port(
			A    : IN  Std_Logic_Vector(4-1 downto 0);
			EN   : IN  Std_Logic;    
			Y    : OUT Std_Logic_Vector(4-1 downto 0)
			);
	End Component; 	
	
	Component Tribuff8 is
		Port(
			A    : IN  Std_Logic_Vector(8-1 downto 0);
			EN   : IN  Std_Logic;    
			Y    : OUT Std_Logic_Vector(8-1 downto 0)
			);
	End Component; 
	
	Component Tribuff12 is
		Port(
			A    : IN  Std_Logic_Vector(12-1 downto 0);
			EN   : IN  Std_Logic;    
			Y    : OUT Std_Logic_Vector(12-1 downto 0)
			);
	End Component; 
	
	--Señlaes----------------------------------------------  
	--Señales para las salidas de 8 bits-------------------  
	Signal AC_OUT 	  : Std_logic_vector(8-1 downto 0);
	Signal IR_OUT 	  : Std_logic_vector(8-1 downto 0);
	Signal ALU_OUT 	  : Std_logic_vector(8-1 downto 0);
	Signal OUTBUS	  : Std_logic_vector(8-1 downto 0);
	--Señales para las entradas 8 bits---------------------  
	Signal ALU_A_IN   : Std_logic_vector(8-1 downto 0);
	--Señales para las salidas de 12 bits------------------
	Signal PC_OUT 	  : Std_logic_vector(12-1 downto 0);
	Signal MAR_OUT 	  : Std_logic_vector(12-1 downto 0);
	--Data Bus---------------------------------------------
	Signal DBus		  : Std_logic_vector(8-1 downto 0);	
	--Flags------------------------------------------------
	Signal ALU_flags  : Std_logic_vector(4-1 downto 0);	
	Signal SHU_flags  : Std_logic_vector(4-1 downto 0);	
	Signal SR_out	  : Std_logic_vector(4-1 downto 0);	
	--MAR--------------------------------------------------
	Signal MAR_BUS 	  : Std_logic_vector(12-1 downto 0);	
	Signal MAR_IN     : Std_logic_vector(12-1 downto 0);	
	-------------------------------------------------------
Begin  
	--Conexiones de elementos al DBUS
	ALU_A_IN 	 	<=  DBus;
	T0: Tribuff8 	PORT MAP (DBus,DBus_on_MAR_offset,MAR_BUS(8-1 downto 0));	
	T1: Tribuff8 	PORT MAP (DBus,DBus_on_DBusMEM,DataBus); 
	--Drivers del DBUS
	T2: Tribuff8 	PORT MAP (OUTBUS,OUTbus_on_DBus,DBus);
	T3: Tribuff8 	PORT MAP (DataBus,DBusMEM_on_DBus,DBus);
	--MAR BUS
	MAR_IN		 	<= MAR_BUS;
	--Registros
	R1: AC 		 	PORT MAP (OUTBUS,clk,zero_AC,load_AC,AC_OUT);
	R2: IR 		 	PORT MAP (OUTBUS,clk,load_IR,IR_OUT);		
	
	T4: Tribuff4 	PORT MAP (IR_OUT(4-1 downto 0),IR_on_MAR_page,MAR_BUS(12-1 downto 8));
	
	R3: PC		 	PORT MAP (MAR_OUT,clk,Incr_PC,reset_PC,load_page_to_PC,load_offset_to_PC,PC_OUT); 
	
	T5: Tribuff4 	PORT MAP (PC_OUT(12-1 downto 8),PC_on_MAR_page,MAR_BUS(12-1 downto 8));
	T6: Tribuff8 	PORT MAP (PC_OUT(8-1 downto 0),PC_on_MAR_offset,MAR_BUS(8-1 downto 0));	 
	
	T7: Tribuff8 	PORT MAP (PC_OUT(8-1 downto 0),PC_offset_on_DBus,DBus);  
	
	R4: MAR		 	PORT MAP (MAR_IN,clk,load_page_to_MAR,load_offset_to_MAR,MAR_OUT);	
	
	T8: Tribuff12 	PORT MAP (MAR_OUT,MAR_on_adbus,AddrBus);
	
	R5: Status_Reg	PORT MAP (SHU_flags,SR_out,clk,load_SR,comp_carry_SR); 
	flag_status 	<= 	SR_out;	
	--Combinacionales
	A1: ALU			PORT MAP (ALU_A_IN,AC_OUT,ALU_CODE,SR_out,ALU_OUT,ALU_flags);
	S1: Shifter		PORT MAP (ALU_OUT,shif_L,shif_R,ALU_flags,OUTBUS,SHU_flags); 
	IR_lines 		<=  IR_OUT;
End Structural;