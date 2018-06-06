--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;
	
	-- Program Counter Output
	signal PCOut       : std_logic_vector(29 downto 0);	-- Program Counter to Instruction Memory

	-- Adders signals
	signal AddOut1	   : std_logic_vector(31 downto 0);
	signal AddOut2	   : std_logic_vector(31 downto 0);
	signal c01, c02	   : std_logic;
	
	-- Intruction Memory Output
	signal instruction : std_logic_vector(31 downto 0); 	-- Instruction Memory to Control, Registers, ImmGen

	-- Control Output
	signal CtrlBranch  : std_logic_vector(1 downto 0);	-- Control to Branch (Eq | Not Eq)
	signal CtrlMemRead : std_logic;				-- Control to Data Memory
	signal CtrlMemtoReg: std_logic;				-- Control to Mux after Data Memory
	signal CtrlALUCtrl : std_logic_vector(4 downto 0);	-- Control to ALU
	signal CtrlMemWrite: std_logic;				-- Control to Data Memory
	signal CtrlALUSrc  : std_logic;				-- Control to Mux before ALU
	signal CtrlRegWrite: std_logic;				-- Control to Registers
	signal CtrlImmGen  : std_logic_vector(1 downto 0);	-- Control to ImmGen

	-- Registers Output
	signal ReadD1      : std_logic_vector(31 downto 0);	-- Registers to ALU
	signal ReadD2      : std_logic_vector(31 downto 0);	-- Registers to ALUMux

	-- Data Memory Output
	signal ReadD	   : std_logic_vector(31 downto 0);	-- 

	-- Muxes output
	signal ALUMuxOut   : std_logic_vector(31 downto 0);	-- Mux to ALU
	signal DMemMuxOut  : std_logic_vector(31 downto 0);	-- Mux to Register Write Data
	signal AddSumMuxOut: std_logic_vector(31 downto 0);	-- Mux to PC

	signal ALUZero     : std_logic;
begin
	-- Add your code here
	-- TO DO: 1) write all internal in/out signals for components
        --        2) port map all signals
	-- Muxes
	ALUMux: BusMux2to1   port map(CtrlALUSrc, ReadD2, here, ALUMuxOut); -- ImmGen output goes into the missing port
	AddMux: BusMux2to1   port map(BranchOut, AddOut1, AddOut2, AddSumMuxOut);
	DMemMux: BusMux2to1  port map(CtrlMemtoReg, ALUResultOut, ReadD, DMemMuxOut);

	-- Adders
	PreAdder: adder_subtracter port map(PCOut, "100", '0', AddOut1, c01);
	AddSumAdder: adder_subtacter port map(PCOut, here, '0', AddOut2, c02); -- ImmGen output should be on missing spot

	-- Major components
	PC: ProgramCounter   port map(reset, clock, AddSumMuxOut, PCOut);

	IMEM: InstructionRAM port map(reset, clock, PCOut, instruction);

	Ctrl: Control 	     port map(clock, instruction(6 downto 0), instruction(14 downto 12), instruction(31 downto 27), CtrlBranch, CtrlMemRead, CtrlMemtoReg, CtrlALUCtrl, CtrlRegWrite, CtrlImmGen);

	Regs: Registers      port map(instruction(19 downto 15), instruction(24 downto 20), instruction(11 downto 7), DMemMuxOut, CtrlRegWrite, ReadD1, ReadD2);

	-- Donde esta el componente ImmGen?

	ArithLU: ALU         port map(ReadD1, ALUMuxOut, ALUZero, ALUResultOut);

	DMem: RAM	     port map(reset, clock, CtrlMemRead, CtrlMemWrite, ALUResultOut(29 downto 0), ReadD2, ReadD);
end holistic;
