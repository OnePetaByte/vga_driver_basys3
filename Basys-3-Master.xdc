## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk_in]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_in]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## Switches ##
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {sw[3]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {sw[4]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {sw[5]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {sw[6]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {sw[7]}]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {sw[8]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {sw[9]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {sw[10]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {sw[11]}]
#set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {sw[12]}]
#set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {sw[13]}]
#set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
#set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]

## LEDs ##
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {led[7]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {led[8]}]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {led[9]}]
set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {led[10]}]
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {led[11]}]
#set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
#set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
#set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
#set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {led[15]}]


## VGA ##
set_property IOSTANDARD LVCMOS33 [get_ports {red_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red_out[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {green_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green_out[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {blue_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue_out[3]}]

set_property PACKAGE_PIN G19 [get_ports {red_out[0]}]
set_property PACKAGE_PIN H19 [get_ports {red_out[1]}]
set_property PACKAGE_PIN J19 [get_ports {red_out[2]}]
set_property PACKAGE_PIN N19 [get_ports {red_out[3]}]

set_property PACKAGE_PIN J17 [get_ports {green_out[0]}]
set_property PACKAGE_PIN H17 [get_ports {green_out[1]}]
set_property PACKAGE_PIN G17 [get_ports {green_out[2]}]
set_property PACKAGE_PIN D17 [get_ports {green_out[3]}]

set_property PACKAGE_PIN N18 [get_ports {blue_out[0]}]
set_property PACKAGE_PIN L18 [get_ports {blue_out[1]}]
set_property PACKAGE_PIN K18 [get_ports {blue_out[2]}]
set_property PACKAGE_PIN J18 [get_ports {blue_out[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports hsync_out]
set_property IOSTANDARD LVCMOS33 [get_ports vsync_out]

set_property PACKAGE_PIN P19 [get_ports hsync_out]
set_property PACKAGE_PIN R19 [get_ports vsync_out]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
