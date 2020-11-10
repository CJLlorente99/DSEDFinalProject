----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 16:50:05
-- Design Name: 
-- Module Name: enable_generator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enable_generator is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC;
           counter_out : out unsigned(2 downto 0));
end enable_generator;

architecture Behavioral of enable_generator is
    -- Signals
    signal count, next_count : unsigned(2 downto 0);
    
begin
    -- Register
    process (clk_12megas, reset)
    begin
        if reset = '1' then
            count <= "000";
        elsif rising_edge(clk_12megas) then
            count <= next_count;
        end if;
    end process;
    
    -- Next-state logic
    next_count <= count + 1 when count < 4 else
                  "001";
    
    -- Output logic
    clk_3megas <= '1' when (count = 2 or count = 3) else
                  '0';
                  
    en_2_cycles <= '1' when (count = 1 or count = 3) else
                   '0';
                   
    en_4_cycles <= '1' when count = 2 else
                   '0';
    
    counter_out <= count;
    
end Behavioral;
