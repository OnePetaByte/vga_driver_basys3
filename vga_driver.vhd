-- vga driver 
--
-- Created:
--          by - ozkan akay
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_driver is
    Port (
        clk_in      : in    std_logic;                                          -- system clock
        rstn_in     : in    std_logic;                                          -- Synchronous rstn
        pixel_in    : in    std_logic_vector(11 downto 0);                      -- 12-bit pixel data
        hsync_out   : out   std_logic                       := '1';             -- Horizontal sync
        vsync_out   : out   std_logic                       := '1';             -- Vertical sync
        red_out     : out   std_logic_vector( 3 downto 0)   := (others => '0');	-- 4-bit Red output
        green_out	: out   std_logic_vector( 3 downto 0)   := (others => '0');	-- 4-bit Green output
        blue_out	: out   std_logic_vector( 3 downto 0)   := (others => '0')  -- 4-bit Blue output
    );
end vga_driver;

architecture Behavioral of vga_driver is
	-- VGA 640x480 @ 60Hz with 25MHz pixel clock timing parameters (Hexadecimal)
	--constant H_SYNC_PULSE   : std_logic_vector(11 downto 0)  := X"060";          -- 96  (0x60)
	--constant H_BACK_PORCH   : std_logic_vector(11 downto 0)  := X"030";          -- 48  (0x30)
	--constant H_ACTIVE       : std_logic_vector(11 downto 0)  := X"280";          -- 640 (0x280)
	--constant H_FRONT_PORCH  : std_logic_vector(11 downto 0)  := X"010";          -- 16  (0x10)
	--constant H_TOTAL        : std_logic_vector(11 downto 0)  := X"320";          -- 800 (0x320)
	--
	--constant V_SYNC_PULSE   : std_logic_vector(11 downto 0)  := X"002";          -- 2   (0x2)
	--constant V_BACK_PORCH   : std_logic_vector(11 downto 0)  := X"021";          -- 33  (0x21)
	--constant V_ACTIVE       : std_logic_vector(11 downto 0)  := X"1E0";          -- 480 (0x1E0)
	--constant V_FRONT_PORCH  : std_logic_vector(11 downto 0)  := X"00A";          -- 10  (0xA)
	--constant V_TOTAL        : std_logic_vector(11 downto 0)  := X"20D";          -- 525 (0x20D)

    -- VGA 1280x1024 @ 60Hz with 108MHz pixel clock timing parameters
     constant H_SYNC_PULSE   : std_logic_vector(11 downto 0)  := X"070";   -- 112
     constant H_BACK_PORCH   : std_logic_vector(11 downto 0)  := X"0F8";   -- 248
     constant H_ACTIVE       : std_logic_vector(11 downto 0)  := X"500";   -- 1280
     constant H_FRONT_PORCH  : std_logic_vector(11 downto 0)  := X"030";   -- 48
     constant H_TOTAL        : std_logic_vector(11 downto 0)  := X"698";   -- 1688
	 
     constant V_SYNC_PULSE   : std_logic_vector(11 downto 0)  := X"003";   -- 3
     constant V_BACK_PORCH   : std_logic_vector(11 downto 0)  := X"026";   -- 38
     constant V_ACTIVE       : std_logic_vector(11 downto 0)  := X"400";   -- 1024
     constant V_FRONT_PORCH  : std_logic_vector(11 downto 0)  := X"001";   -- 1
     constant V_TOTAL        : std_logic_vector(11 downto 0)  := X"42A";   -- 1066

    signal h_count          : std_logic_vector(11 downto 0) := (others => '0'); 
    signal v_count          : std_logic_vector(11 downto 0) := (others => '0');
    signal rgb_temp         : std_logic_vector(11 downto 0) := (others => '0');

begin
    -- VGA timing generator
    process (clk_in) is
    begin
        if (rising_edge(clk_in)) then
            if (rstn_in = '0') then
                h_count <= (others => '0');
                v_count <= (others => '0');
            else
                if (h_count = H_TOTAL - 1) then
                    h_count <= (others => '0');

                    if (v_count = V_TOTAL - 1) then
                        v_count <= (others => '0');
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Horizontal and vertical sync generation
    hsync_out <= '0' when (h_count < H_SYNC_PULSE) else '1';
    vsync_out <= '0' when (v_count < V_SYNC_PULSE) else '1';

    -- Output RGB signal only in active display area
    process (clk_in) is
	begin
		if rising_edge(clk_in) then
			if (rstn_in = '0') then
				red_out     <= (others => '0');
				green_out	<= (others => '0');
				blue_out	<= (others => '0');
				rgb_temp    <= (others => '0');
			else
				if  (v_count >= V_SYNC_PULSE + V_BACK_PORCH) and
					(v_count <  V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE) and
					(h_count >= H_SYNC_PULSE + H_BACK_PORCH) and
					(h_count <  H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE) then
	
					red_out		<=	rgb_temp( 3 downto 0);	-- SADECE aktif bölgede sür
					green_out	<=	rgb_temp( 7 downto 4);	
					blue_out	<=	rgb_temp(11 downto 8);	
				else
					red_out		<=	(others => '0');		-- Siyah (blank)
					green_out	<=	(others => '0');		
					blue_out	<=	(others => '0');		
					rgb_temp 	<=	pixel_in;  				-- pixeller güncelleniyor!
				end if;
			end if;
		end if;
	end process;
end Behavioral;
