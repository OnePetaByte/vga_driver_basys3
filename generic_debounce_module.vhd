--
-- Created:
--          by - ozkan akay
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY generic_debounce_module IS
    generic(
        G_DBF_WAIT		: integer range 0 to 31 := 20; -- EMP! 2^20 CLK WAIT
        G_DBF_VEC 		: integer range 0 to 63 := 4;
        G_SYNC_SEL      : integer range 1 to 3 	:= 2
    );
    PORT(
        FPGA_IN			: IN	std_logic_vector (G_DBF_VEC-1 DOWNTO 0);
        FPGA_OUT_DBF	: OUT	std_logic_vector (G_DBF_VEC-1 DOWNTO 0) := (others=>'0');
        clk_in			: IN	std_logic;
        rstn_in 		: IN	std_logic
    );
END generic_debounce_module;

ARCHITECTURE arc OF generic_debounce_module IS
    component debounce_filter is
        generic(
            G_DBF_RANGE  : integer range 0 to 31 := 19;
            G_SYNC_RANGE : integer range 1 to 3  := 3
        );
        Port(
            clk_in 	: in STD_LOGIC; -- Clock input
            rstn_in : in STD_LOGIC; -- rstn input
            dpf_in 	: in STD_LOGIC; -- Debounced input
            dpf_out : out STD_LOGIC := '0' -- Debounced output
        );
    end component;
BEGIN
    u2 : for i in 0 to (G_DBF_VEC-1) generate
        DBF : debounce_filter
            generic map (G_DBF_RANGE  => G_DBF_WAIT-1,
                         G_SYNC_RANGE => G_SYNC_SEL)
            port map (
                clk_in 	=> clk_in,
                rstn_in => rstn_in,
                dpf_in 	=> FPGA_IN(i),
                dpf_out => FPGA_OUT_DBF(i)
            );
    end generate;
END ARCHITECTURE arc;

