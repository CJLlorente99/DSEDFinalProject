-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_12mhz is
  Port ( 
    clk_12Mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_100Mhz : in STD_LOGIC
  );

end clk_wiz_12mhz;

architecture stub of clk_wiz_12mhz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
begin
end;
