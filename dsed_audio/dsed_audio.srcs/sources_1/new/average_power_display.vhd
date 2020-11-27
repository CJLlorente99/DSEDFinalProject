----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2020 19:02:33
-- Design Name: 
-- Module Name: average_power_display - Behavioral
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

entity average_power_display is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           sample_request : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end average_power_display;

architecture Behavioral of average_power_display is
    
    signal total_power, total_power_next : unsigned((sample_size + 9) downto 0) := (others => '0');
    signal count, count_next : unsigned(9 downto 0) := (others => '0');
    signal LED_output, LED_output_next : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
begin

    -- Register
    process(clk_12megas) begin
        if reset = '1' then
            count <= (others => '0');
            total_power <= (others => '0');
            LED_output <= (others => '0');
        elsif rising_edge(clk_12megas) then
            if (sample_request = '1') then
                count <= count_next;
                total_power <= total_power_next;
                if count = 1023 then
                    LED_output <= LED_output_next;
                end if;
            end if;
        end if;
    end process;
    -- Next state logic
    count_next <= count + 1;
    total_power_next <= (total_power + unsigned(sample_in)) when count /= 1023 else to_unsigned(to_integer(unsigned(sample_in)), (sample_size + 10));
    
    LED_output_next <= STD_LOGIC_VECTOR(total_power((sample_size + 9) downto (sample_size + 2)));
    
    
    
    -- Output logic
    LED <= LED_output;

end Behavioral;
