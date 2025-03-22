--
-- Created:
--          by - ozkan akay
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity system_starter  is
    generic(G_SYSTEM_START_TIME : integer range 0 to 31 := 17); -- 131072 - 1,31 ms
    Port (
            clk_in          : in    std_logic;          -- system clock
            rstn_in         : in    std_logic;          -- Synchronous rstn in
            system_rstn_out : out   std_logic   := '0'  -- System Synchronous rstn out
        );
end system_starter;

architecture Behavioral of system_starter is

    signal counter : std_logic_vector(G_SYSTEM_START_TIME downto 0) := (others => '0');

begin

    process (clk_in) is
    begin
        if (rising_edge(clk_in)) then
            if (rstn_in = '0') then
                counter         <= (others => '0');
                system_rstn_out <= '0';
            else
                if (counter(G_SYSTEM_START_TIME) = '1') then
                    counter         <= counter;
                    system_rstn_out <= '1';
                else
                    counter         <= counter + 1;
                    system_rstn_out <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;