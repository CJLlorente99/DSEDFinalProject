----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2020 11:56:40
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

    signal next_count, count : unsigned(8 downto 0) := (others => '0');
    signal togle : STD_LOGIC := '0';
    signal sample, next_sample : STD_LOGIC_VECTOR(sample_size - 1 downto 0) := (others => '0');

begin

    -- Register
    process (clk_12megas, reset) 
    begin
        if reset = '1' then
            count <= (others => '0');
            togle <= '0';
            sample <= (others => '0');
        elsif rising_edge(clk_12megas) then
        
            togle <= '0';
            sample <= next_sample;
        
            if en_2_cycles = '1' then
                count <= next_count;
                togle <= '1';
            end if;
        end if;
    end process;
    
    -- Next state logic
    next_count <= count + 1 when count < 299 else (others => '0');
    next_sample <= sample_in when (count = 299) else
                   sample;
    
    --Output logic
    pwm_pulse <= '1' when (unsigned(sample) > count) else '0';
    sample_request <= '1' when (count = 299) and (togle = '1') else '0';


end Behavioral;
