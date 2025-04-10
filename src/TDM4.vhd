
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity TDM4 is
	generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    Port ( i_clk		: in  STD_LOGIC;
           i_reset		: in  STD_LOGIC; -- asynchronous
           i_D3 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_data		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_sel		: out STD_LOGIC_VECTOR (3 downto 0)	-- selected data line (one-cold)
	);
end TDM4;

architecture behavioral of TDM4 is

	signal   f_sel		 : unsigned(1 downto 0)	:= "00"; -- 2 bit counter output to select MUX input
	
begin	
	
	-- PROCESSES ----------------------------------------
	
	-- 2 Bit counter Process ----------------------------
	-- counter rolls over automatically
	-- asynchronous reset to "00"
	twoBitCounter_proc : process(i_clk, i_reset)
	begin
		if i_reset = '1' then
			f_sel <= "00";
		elsif rising_edge(i_clk) then
			f_sel <= f_sel + 1;
		end if;
	end process twoBitCounter_proc;
	-----------------------------------------------------
	

	-- CONCURRENT STATEMENTS ----------------------------
	
	-- output MUXs
	o_DATA <= i_D3 when f_sel = "11" else
			  i_D2 when f_sel = "10" else
			  i_D1 when f_sel = "01" else
			  i_D0;
			  
	o_SEL  <=  "0111" when f_sel = "11" else
			   "1011" when f_sel = "10" else
			   "1101" when f_sel = "01" else
			   "1110";
		
end behavioral;

