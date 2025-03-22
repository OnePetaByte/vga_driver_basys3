--
-- Created:
--          by - ozkan akay
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

ENTITY vga_top IS
   PORT( 
      clk_in    : IN     std_logic;
	  
      sw        : IN     std_logic_vector (11 DOWNTO 0);
	  led       : OUT    std_logic_vector (11 DOWNTO 0);
	  
	  red_out   : OUT    std_logic_vector (3 DOWNTO 0) := (others => '0');
	  green_out : OUT    std_logic_vector (3 DOWNTO 0) := (others => '0');
      blue_out  : OUT    std_logic_vector (3 DOWNTO 0) := (others => '0');
      hsync_out : OUT    std_logic                     := '1';
      vsync_out : OUT    std_logic                     := '1'
   );
   
END ENTITY vga_top ;

ARCHITECTURE struct OF vga_top IS

   -- Internal signal declarations
   SIGNAL clk_out1        : std_logic;
   SIGNAL rgb_out         : std_logic_vector(11 DOWNTO 0) := (others => '0');
   SIGNAL rstn_prob       : std_logic_vector(0 DOWNTO 0);
   SIGNAL system_rstn_out : std_logic                     := '0';

   -- Implicit buffer signal declarations
   SIGNAL led_internal : std_logic_vector (11 DOWNTO 0);

   -- Component Declarations
   COMPONENT clk_wiz_108Mhz
   PORT (
      clk_in1  : IN     std_logic;
      clk_out1 : OUT    std_logic
   );
   END COMPONENT clk_wiz_108Mhz;
   COMPONENT generic_debounce_module
   GENERIC (
      G_DBF_WAIT : integer range 0 to 31 := 20;      -- EMP! 2^20 CLK WAIT
      G_DBF_VEC  : integer range 0 to 63 := 4;
      G_SYNC_SEL : integer range 1 to 3  := 2
   );
   PORT (
      FPGA_IN      : IN     std_logic_vector (G_DBF_VEC-1 DOWNTO 0);
      clk_in       : IN     std_logic;
      rstn_in      : IN     std_logic;
      FPGA_OUT_DBF : OUT    std_logic_vector (G_DBF_VEC-1 DOWNTO 0) := (others=>'0')
   );
   END COMPONENT generic_debounce_module;
   COMPONENT system_starter
   GENERIC (
      G_SYSTEM_START_TIME : integer range 0 to 31 := 17
   );
   PORT (
      clk_in          : IN     std_logic;
      rstn_in         : IN     std_logic;
      system_rstn_out : OUT    std_logic  := '0'
   );
   END COMPONENT system_starter;
   COMPONENT vga_driver
   PORT (
      clk_in    : IN     std_logic;
      pixel_in  : IN     std_logic_vector (11 DOWNTO 0);
      rstn_in   : IN     std_logic;
      blue_out  : OUT    std_logic_vector ( 3 DOWNTO 0) := (others => '0');
      green_out : OUT    std_logic_vector ( 3 DOWNTO 0) := (others => '0');
      hsync_out : OUT    std_logic                      := '1';
      red_out   : OUT    std_logic_vector ( 3 DOWNTO 0) := (others => '0');
      vsync_out : OUT    std_logic                      := '1'
   );
   END COMPONENT vga_driver;
   COMPONENT vio_0
   PORT (
      clk        : IN     std_logic;
      probe_in0  : IN     std_logic_vector (11 DOWNTO 0);
      probe_out0 : OUT    std_logic_vector (0 DOWNTO 0)
   );
   END COMPONENT vio_0;

BEGIN

   -- Instance port mappings.
   U_4 : clk_wiz_108Mhz
      PORT MAP (
         clk_out1 => clk_out1,
         clk_in1  => clk_in
      );
   U_2 : generic_debounce_module
      GENERIC MAP (
         G_DBF_WAIT => 20,         -- 2^20 CLK WAIT
         G_DBF_VEC  => 12,         -- port range
         G_SYNC_SEL => 2
      )
      PORT MAP (
         FPGA_IN      => sw,
         FPGA_OUT_DBF => led_internal,
         clk_in       => clk_out1,
         rstn_in      => system_rstn_out
      );
   U_1 : system_starter
      GENERIC MAP (
         G_SYSTEM_START_TIME => 17 -- init time 2^17
      )
      PORT MAP (
         clk_in          => clk_out1,
         rstn_in         => rstn_prob(0),
         system_rstn_out => system_rstn_out
      );
   U_0 : vga_driver
      PORT MAP (
         clk_in    => clk_out1,
         rstn_in   => system_rstn_out,
         pixel_in  => led_internal,
         hsync_out => hsync_out,
         vsync_out => vsync_out,
         red_out   => red_out,
         green_out => green_out,
         blue_out  => blue_out
      );
   U_3 : vio_0
      PORT MAP (
         clk        => clk_out1,
         probe_in0  => rgb_out,
         probe_out0 => rstn_prob
      );

   -- Implicit buffered output assignments
   led <= led_internal;

END ARCHITECTURE struct;
