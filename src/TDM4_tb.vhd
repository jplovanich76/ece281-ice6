
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity TDM4_tb is
end TDM4_tb;

architecture test_bench of TDM4_tb is 	
	component TDM4 is
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
	end component TDM4;

	constant k_clk_period : time := 20 ns;
	constant k_IO_WIDTH : natural := 4;
	
	signal w_clk : std_logic := '0';
	signal w_reset : std_logic := '0';
	signal w_D3, w_D2, w_D1, w_D0 : std_logic_vector(k_IO_WIDTH - 1 downto 0);
	signal f_data : std_logic_vector(k_IO_WIDTH - 1 downto 0);
	signal f_sel_n : std_logic_vector(3 downto 0);

	
begin
	-- PORT MAPS ----------------------------------------
	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : TDM4 
	generic map ( k_WIDTH => k_IO_WIDTH)
	port map ( 
       i_clk   => w_clk,
       i_reset => w_reset,
       i_D3    => w_D3,
       i_D2    => w_D2,
       i_D1    => w_D1,
       i_D0    => w_D0,
       o_data  => f_data,
       o_sel   => f_sel_n
	);
	-----------------------------------------------------	
	
	-- PROCESSES ----------------------------------------	
	-- Clock Process ------------------------------------
	clk_process : process
	begin
	   while true loop
	       w_clk <= '0';
	       wait for k_clk_period / 2;
	       w_clk <= '1';
	       wait for k_clk_period / 2;
	      end loop;

	end process clk_process;
	-----------------------------------------------------	
	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
		w_D3 <= "1100";
		w_D2 <= "1001";
		w_D1 <= "0110";
		w_D0 <= "0011";

				
		-- reset the system first
		w_reset <= '1';
		wait for 10ns;		
		w_reset <= '0';
		wait for 150ns;
		assert false report "done" severity failure;
	end process;	
	-----------------------------------------------------	
	
end test_bench;
