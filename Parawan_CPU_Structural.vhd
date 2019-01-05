-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Design
-- Author      : Greg
-- Company     : INAOE
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Parawan_Procesor\Design\compile\Parawan_CPU_Estructural.vhd
-- Generated   : Thu Jul 19 15:53:54 2018
-- From        : c:\My_Designs\Parawan_Procesor\Design\src\Parawan_CPU_Estructural.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity Parawan_CPU_Estructural is
  port(
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       read_mem : out STD_LOGIC;
       write_mem : out STD_LOGIC;
	   Dbus : inout STD_LOGIC_VECTOR(7 downto 0)
       AddrBus : out STD_LOGIC_VECTOR(11 downto 0);
  );
end Parawan_CPU_Estructural;

architecture Parawan_CPU_Estructural of Parawan_CPU_Estructural is

---- Component declarations -----

component Control_Unit
-- synthesis translate_off
  generic(
       delay_start : TIME := 3 NS;
       read_delay : TIME := 3 NS;
       write_delay : TIME := 3 NS
  );
-- synthesis translate_on
  port (
       IR_OUT : in STD_LOGIC_VECTOR(8-1 downto 0);
       clk : in STD_LOGIC;
       flag_status : in STD_LOGIC_VECTOR(4-1 downto 0);
       reset : in STD_LOGIC;
       ALU_CODE : out STD_LOGIC_VECTOR(3-1 downto 0);
       DBusMEM_on_DBus : out STD_LOGIC;
       DBus_on_DBusMEM : out STD_LOGIC;
       DBus_on_MAR_offset : out STD_LOGIC;
       IR_on_MAR_page : out STD_LOGIC;
       Incr_PC : out STD_LOGIC;
       MAR_on_adbus : out STD_LOGIC;
       OUTbus_on_DBus : out STD_LOGIC;
       PC_offset_on_DBus : out STD_LOGIC;
       PC_on_MAR_offset : out STD_LOGIC;
       PC_on_MAR_page : out STD_LOGIC;
       comp_carry_SR : out STD_LOGIC;
       load_AC : out STD_LOGIC;
       load_IR : out STD_LOGIC;
       load_SR : out STD_LOGIC;
       load_offset_MAR : out STD_LOGIC;
       load_offset_PC : out STD_LOGIC;
       load_page_MAR : out STD_LOGIC;
       load_page_PC : out STD_LOGIC;
       read_mem : out STD_LOGIC;
       reset_PC : out STD_LOGIC;
       shif_L : out STD_LOGIC;
       shif_R : out STD_LOGIC;
       write_mem : out STD_LOGIC;
       zero_AC : out STD_LOGIC
  );
end component;
component Data_Path
  port (
       ALU_CODE : in STD_LOGIC_VECTOR(3-1 downto 0);
       DBusMEM_on_DBus : in STD_LOGIC;
       DBus_on_DBusMEM : in STD_LOGIC;
       DBus_on_MAR_offset : in STD_LOGIC;
       IR_on_MAR_page : in STD_LOGIC;
       Incr_PC : in STD_LOGIC;
       MAR_on_adbus : in STD_LOGIC;
       OUTbus_on_DBus : in STD_LOGIC;
       PC_offset_on_DBus : in STD_LOGIC;
       PC_on_MAR_offset : in STD_LOGIC;
       PC_on_MAR_page : in STD_LOGIC;
       clk : in STD_LOGIC;
       comp_carry_SR : in STD_LOGIC;
       load_AC : in STD_LOGIC;
       load_IR : in STD_LOGIC;
       load_SR : in STD_LOGIC;
       load_offset_to_MAR : in STD_LOGIC;
       load_offset_to_PC : in STD_LOGIC;
       load_page_to_MAR : in STD_LOGIC;
       load_page_to_PC : in STD_LOGIC;
       reset_PC : in STD_LOGIC;
       shif_L : in STD_LOGIC;
       shif_R : in STD_LOGIC;
       zero_AC : in STD_LOGIC;
       AddrBus : out STD_LOGIC_VECTOR(12-1 downto 0);
       IR_lines : out STD_LOGIC_VECTOR(8-1 downto 0);
       flag_status : out STD_LOGIC_VECTOR(4-1 downto 0);
       DataBus : inout STD_LOGIC_VECTOR(8-1 downto 0) := (others=>'Z')
  );
end component;

---- Signal declarations used on the diagram ----

signal com_carry_SR : STD_LOGIC;
signal DBusMEM_on_Dbus : STD_LOGIC;
signal Dbus_on_DbusMEM : STD_LOGIC;
signal Dbus_on_MAR_offset : STD_LOGIC;
signal Inc_PC : STD_LOGIC;
signal IR_on_MAR_page : STD_LOGIC;
signal Load_AC : STD_LOGIC;
signal Load_IR : STD_LOGIC;
signal Load_Offset_MAR : STD_LOGIC;
signal Load_offset_PC : STD_LOGIC;
signal Load_page_MAR : STD_LOGIC;
signal load_Page_PC : STD_LOGIC;
signal Load_SR : STD_LOGIC;
signal MAR_on_adbus : STD_LOGIC;
signal OUT_on_DBUS : STD_LOGIC;
signal PC_offset_on_Dbus : STD_LOGIC;
signal PC_on_MAR_offset : STD_LOGIC;
signal PC_on_MAR_page : STD_LOGIC;
signal reset_PC : STD_LOGIC;
signal shift_R : STD_LOGIC;
signal shif_L : STD_LOGIC;
signal Zero_AC : STD_LOGIC;
signal ALU_Code : STD_LOGIC_VECTOR(2 downto 0);
signal flag_STATUS : STD_LOGIC_VECTOR(3 downto 0);
signal IR_OUT : STD_LOGIC_VECTOR(7 downto 0);

begin

----  Component instantiations  ----

U2 : Control_Unit
  port map(
       ALU_CODE => ALU_Code(2 downto 0),
       DBusMEM_on_DBus => DBusMEM_on_Dbus,
       DBus_on_DBusMEM => Dbus_on_DbusMEM,
       DBus_on_MAR_offset => Dbus_on_MAR_offset,
       IR_OUT => IR_OUT(7 downto 0),
       IR_on_MAR_page => IR_on_MAR_page,
       Incr_PC => Inc_PC,
       MAR_on_adbus => MAR_on_adbus,
       OUTbus_on_DBus => OUT_on_DBUS,
       PC_offset_on_DBus => PC_offset_on_Dbus,
       PC_on_MAR_offset => PC_on_MAR_offset,
       PC_on_MAR_page => PC_on_MAR_page,
       clk => clk,
       comp_carry_SR => com_carry_SR,
       flag_status => flag_STATUS(3 downto 0),
       load_AC => Load_AC,
       load_IR => Load_IR,
       load_SR => Load_SR,
       load_offset_MAR => Load_Offset_MAR,
       load_offset_PC => Load_offset_PC,
       load_page_MAR => Load_page_MAR,
       load_page_PC => load_Page_PC,
       read_mem => read_mem,
       reset => reset,
       reset_PC => reset_PC,
       shif_L => shif_L,
       shif_R => shift_R,
       write_mem => write_mem,
       zero_AC => Zero_AC
  );

U4 : Data_Path
  port map(
       ALU_CODE => ALU_Code(2 downto 0),
       AddrBus => AddrBus(11 downto 0),
       DBusMEM_on_DBus => DBusMEM_on_Dbus,
       DBus_on_DBusMEM => Dbus_on_DbusMEM,
       DBus_on_MAR_offset => Dbus_on_MAR_offset,
       DataBus => Dbus(7 downto 0),
       IR_lines => IR_OUT(7 downto 0),
       IR_on_MAR_page => IR_on_MAR_page,
       Incr_PC => Inc_PC,
       MAR_on_adbus => MAR_on_adbus,
       OUTbus_on_DBus => OUT_on_DBUS,
       PC_offset_on_DBus => PC_offset_on_Dbus,
       PC_on_MAR_offset => PC_on_MAR_offset,
       PC_on_MAR_page => PC_on_MAR_page,
       clk => clk,
       comp_carry_SR => com_carry_SR,
       flag_status => flag_STATUS(3 downto 0),
       load_AC => Load_AC,
       load_IR => Load_IR,
       load_SR => Load_SR,
       load_offset_to_MAR => Load_Offset_MAR,
       load_offset_to_PC => Load_offset_PC,
       load_page_to_MAR => Load_page_MAR,
       load_page_to_PC => load_Page_PC,
       reset_PC => reset_PC,
       shif_L => shif_L,
       shif_R => shift_R,
       zero_AC => Zero_AC
  );


end Parawan_CPU_Estructural;
