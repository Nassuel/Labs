--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;
   signal dummie: integer range 0 to 127;
	
begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
	
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	if WE = '1' then
		for i in 0 to 127 loop       
			i_ram (i) <= DataIn(31 downto 0);
 		end loop;
	end if;
	
    end if;
	-- Rest of the RAM implementation
    
    if OE = '0' then
	dummie <= to_integer(unsigned(Address));
	DataOut <= i_ram(dummie);

	else
      	for i in 0 to 127 loop   
        	i_ram(i) <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
     	end loop;
    end if;

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic; --active low
		 writein32, writein16, writein8: in std_logic; --active high
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	signal uno, dos, tres, cuatro, cinco, seis, siete, ocho: std_logic_vector (31 downto 0);
	signal escribe : std_logic_vector (7 downto 0);
	signal zero : std_logic := '0';
	signal one : std_logic := '1';
	

begin
    -- Add your code here for the Register Bank implementation
	with ReadReg1 select
	ReadData1<= uno when "01010",
		dos	when "01011",
		tres	when "01100",
		cuatro 	when "01101",
		cinco	when "01110",
		seis	when "01111",
		siete	when "10000",
		ocho	when "10001",
		X"00000000" when others;

	with ReadReg2 select
	ReadData2 <=uno	when "01010",
		dos	when "01011",
		tres	when "01100",
		cuatro 	when "01101",
		cinco	when "01110",
		seis	when "01111",
		siete	when "10000",
		ocho	when "10001",
		X"00000000" when others;

	with WriteCmd & WriteReg select
	escribe<="00000001" when "101010",
		"00000010" when "101011",
		"00000100" when "101100",
		"00001000" when "101101",
		"00010000" when "101110",
		"00100000" when "101111",
		"01000000" when "110000",
		"10000000" when "110001",
		"00000000" when others;
							   --escribe
	a0: register32 port map(WriteData, zero, one, one, escribe(0), zero, zero, uno);
	a1: register32 port map(WriteData, zero, one, one, escribe(1), zero, zero, dos);
	a2: register32 port map(WriteData, zero, one, one, escribe(2), zero, zero, tres);
	a3: register32 port map(WriteData, zero, one, one, escribe(3), zero, zero, cuatro);
	a4: register32 port map(WriteData, zero, one, one, escribe(4), zero, zero, cinco);
	a5: register32 port map(WriteData, zero, one, one, escribe(5), zero, zero, seis);
	a6: register32 port map(WriteData, zero, one, one, escribe(6), zero, zero, siete);
	a7: register32 port map(WriteData, zero, one, one, escribe(7), zero, zero, ocho);


end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
