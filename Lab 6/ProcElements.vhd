--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
begin
-- Add your code here
	with opcode & funct3 select
	Branch <= "10" when "1100011000", --beg
		"01" when "1100011001", --bne 
		"00" when others;

	with opcode & funct3 select
	MemRead <= '0' when "0000011010", --lui
		 '1' when others;

	with opcode & funct3 select
	MemtoReg <='1' when "0000011010", --lw
     		   '1' when "0100011010", --sw
		   '1' when "1100011000", --beq
		   '1' when "1100011001", --bne
		 '0' when others;

	with opcode & funct3 & funct7 select
	ALUCtrl <= "00000" when "01100110000000000", --add
		 "00001" when "01100110000100000", --sub
		 "00010" when "0010011000-------",  --addi
		 "00011" when "01100111110000000", --and
		 "00100" when "0010011111-------", 	   --andi
		 "00101" when "01100111100000000", --or
		 "00110" when "0010011110-------", 	   --ori
		 "00111" when "01100110010000000", --sll
		 "01000" when "00100110010000000", --slli
		 "01001" when "01100111000000000", --srl
		 "01010" when "00100111010100000", --srli
		 "00000" when "0000011010-------", 	   --lw
		 "00000" when "0100011010-------", 	   --sw
		 "00001" when "1100011000-------", 	   --beq
		 "00001" when "1100011001-------", 	   --bne
		 "00000" when "0110111----------", 	   --lui
		 "11111" when others;

	with opcode & funct3 select
	MemWrite <= '1' when "0100011010", 	   --sw
		 '0' when others;

	with opcode & funct3 & funct7 select
 	ALUSrc <= '0' when "01100110000000000",	   --add
	          '0' when "01100110000100000",    --sub
	          '0' when "01100111110000000",	   --and
	          '0' when "01100111100000000",     --or
		  '0' when "1100011000-------",	   --beq
		  '0' when "1100011001-------",	   --bne
		  '0' when "0110111----------",		   --lui
	          '1' when others;

	with opcode & funct3 select
	RegWrite <='0' when "0100011010",	   --sw	
		   '0' when "1100011000", 		   --beq
		   '0' when "1100011001",		   --bne
		   '0' when "0110111---",		   --lui
		(not Clk) when others;

	--with opcode & funct3 & funct7 select
	--ImmGen <= when "0110111", 		  --lui
	       --when others;
--

end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here
	process(Reset, Clock)
	begin
		if (Reset = '1') then
			PCout <= "00000000010000000000000000000000"; --reset to start at address 0x00400000
		elsif falling_edge(Clock) then --not sure if falling_edge or rising_edge
			PCout <= PCin; --maintains the address of the next instruction
		end if;
	end process;
end executive;
--------------------------------------------------------------------------------
