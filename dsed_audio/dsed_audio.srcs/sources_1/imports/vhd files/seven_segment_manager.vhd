----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2021 14:24:43
-- Design Name: 
-- Module Name: seven_segment_manager - Behavioral
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
use work.package_dsed.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_manager is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           volume_info : in STD_LOGIC_VECTOR (6 downto 0);
           level : in STD_LOGIC_VECTOR (4 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_manager;

architecture Behavioral of seven_segment_manager is
    -- FSM state type declaration
--        type state_type is (idle, volume1, volume2);
--        type state_type is (idle, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7);
        signal state, next_state : unsigned(2 downto 0) := (others => '0');
        
    -- Signal definition
        -- Register
        signal count_an, next_count_an : UNSIGNED (14 downto 0); -- 366 Hz for all all AN displays (45 Hz for each display)
        signal count_info, next_count_info : UNSIGNED (23 downto 0); -- Swap info showing each 1.4 seconds
        
        signal eco_0_vol_1, next_eco_0_vol_1 : STD_LOGIC := '0';
        
        -- FSM state declaration
--        signal state, next_state : state_type;
    
    -- Auxiliar signals
        signal info_to_be_shown : UNSIGNED (6 downto 0);

begin
    -- Register
        process (clk, reset)
        begin
            if reset = '1' then
                state <= "000";
                count_an <= (others => '0');
                count_info <= (others => '0');
                eco_0_vol_1 <= '0';
            elsif rising_edge(clk) then
                state <= next_state;
                count_an <= next_count_an;
                count_info <= next_count_info;
                eco_0_vol_1 <= next_eco_0_vol_1;
            end if;
        end process;
        
    -- Next sate logic
        next_count_an <= count_an + 1;
        next_count_info <= count_info + 1;
        next_state <= state + 1 when count_an = 10 else
                      state;
        next_eco_0_vol_1 <= not eco_0_vol_1 when count_info = 10 else
                      eco_0_vol_1;
        
    -- FSMD
        process (state, eco_0_vol_1, level, volume_info)
        begin
            -- Default treatment
                an <= (others => '1');
                info_to_be_shown <= (others => '0');
                        
            case state is     
                when "000" =>
                    an <= "01111111";
                    if eco_0_vol_1 = '0' then
                        info_to_be_shown <= to_unsigned(15, 7); -- e
                    else
                        info_to_be_shown <= to_unsigned(11, 7); -- v
                    end if;
                    
                when "001" =>
                    an <= "10111111";
                    if eco_0_vol_1 = '0' then
                        info_to_be_shown <= to_unsigned(16, 7); -- c
                    else
                        info_to_be_shown <= to_unsigned(12, 7); -- o
                    end if;
                    
                when "010" =>
                    an <= "11011111";
                    if eco_0_vol_1 = '0' then
                        info_to_be_shown <= to_unsigned(12, 7); -- o
                    else
                        info_to_be_shown <= to_unsigned(13, 7); -- l
                    end if;
                    
                when "011" =>
                    an <= "11101111";
                    info_to_be_shown <= to_unsigned(10, 7); -- space
                    
                when "100" =>
                    an <= "11110111";
                        info_to_be_shown <= to_unsigned(14, 7); -- equal
                        
                when "101" =>
                    an <= "11111011";
                    info_to_be_shown <= to_unsigned(10, 7); -- space
                    
                when "110" =>
                    an <= "11111101";
                    if eco_0_vol_1 = '0' then
                        info_to_be_shown <= unsigned("00" & level)/10; -- tens
                    else
                        info_to_be_shown <= unsigned(volume_info)/10; -- tens
                    end if;
                    
                when "111" =>
                  
                    an <= "11111110";
                    if eco_0_vol_1 = '0' then
                        info_to_be_shown <= unsigned("00" & level) mod 10; -- units
                    else
                        info_to_be_shown <= unsigned(volume_info) mod 10; -- units
                    end if;
                    
                when others =>
                    next_state <= "000";
            
            end case;
        end process;
        
        -- Output Logic
            seven_seg <= zero_7_seg when info_to_be_shown = 0 else
                         one_7_seg when info_to_be_shown = 1 else
                         two_7_seg when info_to_be_shown = 2 else
                         three_7_seg when info_to_be_shown = 3 else
                         four_7_seg when info_to_be_shown = 4 else
                         five_7_seg when info_to_be_shown = 5 else
                         six_7_seg when info_to_be_shown = 6 else
                         seven_7_seg when info_to_be_shown = 7 else
                         eight_7_seg when info_to_be_shown = 8 else
                         nine_7_seg when info_to_be_shown = 9 else
                         space_7_seg when info_to_be_shown = 10 else
                         v_7_seg when info_to_be_shown = 11 else
                         o_7_seg when info_to_be_shown = 12 else
                                           
                         l_7_seg when info_to_be_shown = 13 else
                         equal_7_seg when info_to_be_shown = 14 else
                         e_7_seg when info_to_be_shown = 15 else
                         c_7_seg when info_to_be_shown = 16 else
                         zero_7_seg; -- Aqui se deberia poner "space" como default
                         
                      
end Behavioral;
