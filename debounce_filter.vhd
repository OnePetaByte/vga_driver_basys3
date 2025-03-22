--
-- Created:
--          by - ozkan akay
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce_filter is
generic(G_DBF_RANGE		: integer range 0 to 31 := 20; -- 
		G_SYNC_RANGE	: integer range 1 to 3 	:= 3); -- 
Port (
    clk_in 	: in	STD_LOGIC;			-- Clock input
    rstn_in : in	STD_LOGIC;			-- rstn input
    dpf_in 	: in	STD_LOGIC;			-- Debounced input
    dpf_out : out	STD_LOGIC := '0'	-- Debounced output
);
end debounce_filter;

architecture arc of debounce_filter is 
    signal synchronizer_s	: std_logic_vector(G_SYNC_RANGE		downto 0)	:=	(others => '0');
    signal counter			: std_logic_vector(G_DBF_RANGE		downto 0)	:=	(others => '0');
    signal diff_detect		: std_logic 									:=	'0';
    signal diff_detect_s	: std_logic 									:=	'0';
    signal dpf_out_s    	: std_logic 									:=	'0';
begin
diff_detect <= synchronizer_s(G_SYNC_RANGE) xor synchronizer_s(G_SYNC_RANGE-1);	-- To detect signal difference
process (clk_in) is
begin
    if (rising_edge(clk_in)) then
		if (rstn_in = '0') then
			synchronizer_s	<=	(others => '0');
			counter			<=	(others => '0');
			dpf_out			<=	'0';
		else	
			diff_detect_s	<=	diff_detect;
			if		(G_SYNC_RANGE = 3)	then	
				synchronizer_s(3)	<= synchronizer_s(2); 
				synchronizer_s(2)	<= synchronizer_s(1); 
				synchronizer_s(1)	<= synchronizer_s(0); 
				synchronizer_s(0)	<= dpf_in;
			elsif 	(G_SYNC_RANGE = 2) 				then	
				synchronizer_s(2)	<= synchronizer_s(1);
				synchronizer_s(1)	<= synchronizer_s(0); 
				synchronizer_s(0)	<= dpf_in;
			elsif 	(G_SYNC_RANGE = 1) 				then	
				synchronizer_s(1)	<= synchronizer_s(0); 
				synchronizer_s(0)	<= dpf_in;
			else	
				synchronizer_s		<= synchronizer_s;
			end if;
			dpf_out	<=	dpf_out_s;
			if 		(diff_detect_s			= '1')	then
				counter	    <=	(others => '0');
				dpf_out_s	<=	dpf_out_s;
			elsif	(counter(G_DBF_RANGE)	= '1') then
				counter	    <=	counter;
				dpf_out_s	<=	synchronizer_s(G_SYNC_RANGE);
			else
				counter	    <=	counter+1;
				dpf_out_s	<=	dpf_out_s;
			end if;
		end if;
    end if;
end process;
end arc;