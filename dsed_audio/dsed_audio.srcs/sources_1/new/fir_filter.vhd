----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2020 13:13:33
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;
--           adder_res : out STD_LOGIC_VECTOR(sample_size*2 - 1 downto 0);
--           hm_res : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
--           ctrl : out STD_LOGIC_VECTOR (2 downto 0);
--           x00 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--           x01 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--           x02 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--           x03 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--           x04 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

    component fir_data_path is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               clear : in STD_LOGIC;
               ctrl : in STD_LOGIC_VECTOR (2 downto 0);
               filter_select : in STD_LOGIC; -- HIGH = 1   |  LOW = 0
               sample_enable : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
--               adder_res : out STD_LOGIC_VECTOR(sample_size*2 - 1 downto 0);
--               hm_res : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0);
--               x00 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x01 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x02 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x03 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
--               x04 : out STD_LOGIC_VECTOR(sample_size-1 downto 0);
               s : out STD_LOGIC_VECTOR (sample_size-1 downto 0)
           );
    end component;
    
    component controlador_fir is
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            clear : in STD_LOGIC;
            sample_in_enable : in STD_LOGIC;
            ctrl : out STD_LOGIC_VECTOR(2 downto 0);
            sample_out_ready :out STD_LOGIC
        );
    end component;
    
    -- fir_data_path signals:
        signal ctrl : STD_LOGIC_VECTOR(2 downto 0);
        signal clear_aux : STD_LOGIC;
        signal act_filter_select : STD_LOGIC;

begin

    U0 : fir_data_path port map(
        clk => clk,
        reset => reset,
        clear => clear_aux,
        ctrl => ctrl,
        filter_select => filter_select,
        sample_enable => sample_in_enable,
        sample_in => sample_in,
--        adder_res => adder_res,
--        hm_res => hm_res,
--        x00 => x00,
--        x01 => x01,
--        x02 => x02,
--        x03 => x03,
--        x04 => x04,
        s => sample_out
    );
    
    U1 : controlador_fir port map(
        clk => clk,
        reset => reset,
        clear => clear_aux,
        sample_in_enable => sample_in_enable,
        ctrl => ctrl,
        sample_out_ready => sample_out_ready
    );
    
    -- Logic that changes clear when filter_select changes
    -- Register
    process(clk)
    begin
        if rising_edge(clk) then
            act_filter_select <= filter_select;
        end if;
    end process;
    
    -- Output logic
    
    clear_aux <= '1' when act_filter_select /= filter_select else
             '0';       
    
--    ctrl <= ctrl_mid;


end Behavioral;
