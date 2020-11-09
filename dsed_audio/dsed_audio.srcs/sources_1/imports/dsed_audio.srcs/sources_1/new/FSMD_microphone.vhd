----------------------------------------------------------------------------------
-- Company: Grupo 9
-- Engineer: CJLL & ITI
-- 
-- Create Date: 09.11.2020 11:03:24
-- Design Name: -
-- Module Name: FSMD_microphone - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
-- Target Devices: 
-- Tool Versions: 
-- Description: Microphone interface
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC
           -- Debugging outputs
--           count : out integer;
--           state_num : out integer
           );
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
    -- FSM state type declaration
    type state_type is (idle, track, show_data1, show_data2);
    
    -- Signal declaration
    signal count_reg, next_count_reg : integer;
    signal data1_reg, next_data1_reg, data2_reg, next_data2_reg, sample_out_unsig: unsigned (sample_size-1 downto 0);
    
    signal first_cycle : STD_LOGIC;
    
    -- FSM state declaration
    signal state, next_state : state_type;

begin
    -- Register
    -- Upload new register values at a 3 MHz rate
    process (clk_12megas)
    begin
        if (rising_edge(clk_12megas) and enable_4_cycles = '1') then
            state <= next_state;
            count_reg <= next_count_reg;
            data1_reg <= next_data1_reg;
            data2_reg <= next_data2_reg;
        end if;
    end process;
    
    -- Mealy FSMD
    process (state, reset, micro_data, count_reg, next_count_reg, first_cycle, enable_4_cycles)
    begin
        -- Default treatment
        next_count_reg <= count_reg;
        next_data1_reg <= data1_reg;
        next_data2_reg <= data2_reg;
        
        case (state) is
            
            -- Idle state reset every register and output value
            when idle =>
                next_count_reg <= 0;
                next_data1_reg <= to_unsigned(0,8);
                next_data2_reg <= to_unsigned(0,8);
                first_cycle <= '0';
                
                sample_out_unsig <= to_unsigned(0,8);
                sample_out_ready <= '0';
                
                if reset = '1' then
                    next_state <= idle;
                else
                    next_state <= track;
                end if;
            
            -- Track state registers if micro data is 1 and adds it to each counter
            when track =>
                if reset = '1' then
                    next_state <= idle;
                else
                    next_count_reg <= count_reg + 1;
                    
                    if micro_data = '1' then
                        next_data1_reg <= data1_reg + 1;
                        next_data2_reg <= data2_reg + 1;
                    end if;
                    
                    if ((0 <= next_count_reg and next_count_reg <= 105) or (150 <= next_count_reg and next_count_reg <= 255)) then
                        next_state <= track;
                    else
                        if (106 <= next_count_reg and next_count_reg <= 149) then
                            next_state <= show_data2;
                        else
                            next_state <= show_data1;
                        end if;
                    end if;
                end if;
            
            -- Show_data1 state stops micro data counting for counter 1 and uploads sample_out with counter 1 value
            when show_data1 =>
                if reset = '1' then
                    next_state <= idle;
                else
                    if count_reg = 299 then
                        next_count_reg <= 0;
                        first_cycle <= '1';
                    else
                        next_count_reg <= count_reg + 1;
                    end if;
                    
                    if micro_data = '1' then
                        next_data2_reg <= data2_reg + 1;
                    end if;
                    
                    if count_reg = 256 then
                        sample_out_unsig <= data1_reg;
                        sample_out_ready <= enable_4_cycles;
                    else
                        sample_out_ready <= '0';
                    end if;
                    
                    if (256 <= next_count_reg and next_count_reg <= 299) then
                        next_state <= show_data1;
                    else
                        next_state <= track;
                        next_data1_reg <= to_unsigned(0,8);
                    end if;
                end if;
            
            -- Show_data1 state stops micro data counting for counter 2 and uploads sample_out with counter 2 value
            when show_data2 =>
                if reset = '1' then
                    next_state <= idle;
                else
                    next_count_reg <= count_reg + 1;
                    
                    if micro_data = '1' then
                        next_data1_reg <= data1_reg + 1;
                    end if;
                    
                    if first_cycle = '1' and count_reg = 106 then
                        sample_out_unsig <= data2_reg;
                        sample_out_ready <= enable_4_cycles;
                    else
                        sample_out_ready <= '0';
                    end if;
                    
                    if (106 <= next_count_reg and next_count_reg <= 149) then
                        next_state <= show_data2;
                    else
                        next_state <= track;
                        next_data2_reg <= to_unsigned(0,8);
                    end if;
                end if;
                
            when others =>
                next_state <= idle;
                
        end case;
    end process;
    
    -- Output logic
    sample_out <= std_logic_vector(sample_out_unsig);

    -- Debugging logic
--    sample_out <= std_logic_vector(data2_reg);
--    count <= count_reg;
--    state_num <= 0 when state = idle else
--                 1 when state = track else
--                 2 when state = show_data1 else
--                 3 when state = show_data2 else
--                 4;
                 

end Behavioral;
