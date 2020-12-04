----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2020 13:37:21
-- Design Name: 
-- Module Name: fir_data_path - Behavioral
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

entity fir_data_path is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           filter_select : in STD_LOGIC; -- HIGH = 1   |  LOW = 0
           sample_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           s : out STD_LOGIC_VECTOR (sample_size-1 downto 0));
end fir_data_path;

architecture Behavioral of fir_data_path is

    component half_mul is
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            a : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
            b : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
            c : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0));
    end component;
    
    
    --Signals
        signal mul1, mul2 : signed (sample_size-1 downto 0) := (others => '0');
        signal sum1, sum2 : signed (sample_size*2 - 2 downto 0) := (others => '0');
        signal s_out, next_s_out :  signed (sample_size-1 downto 0) := (others => '0');
        signal sum1_std : STD_LOGIC_VECTOR(sample_size*2 - 2 downto 0) := (others => '0');
        signal auxiliar_sum, next_auxiliar_sum : signed(sample_size*2 - 1 downto 0) := (others => '0');
        
        -- Filter coefs
        signal c0, c1, c2, c3, c4 : signed(sample_size-1 downto 0);
        
        -- Samples
        signal x0, x1, x2, x3, x4 : signed(sample_size-1 downto 0);
        
        constant MAX_SAT : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (sample_size-1 => '0' , others => '1');
        constant MIN_SAT : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (sample_size-1 => '1' , others => '0');

begin

    U0 : half_mul port map(
        clk => clk,
        reset => reset,
        a => std_logic_vector(mul1),
        b => std_logic_vector(mul2),
        c => sum1_std
    );
    
    
    -- Coef selecction
        c0 <= c0_low when filter_select = '0' else c0_high;
        c1 <= c1_low when filter_select = '0' else c1_high;
        c2 <= c2_low when filter_select = '0' else c2_high;
        c3 <= c3_low when filter_select = '0' else c3_high;
        c4 <= c4_low when filter_select = '0' else c4_high;
        
        
    -- Register
        process (clk, reset) begin
            if reset = '1' then
                mul1 <= (others => '0');
                mul2 <= (others => '0');
                sum1 <= (others => '0');
                sum2 <= (others => '0');
                auxiliar_sum <= (others => '0');
            elsif rising_edge(clk) then
                auxiliar_sum <= next_auxiliar_sum;
                
                if sample_enable = '1' then
                    x0 <= signed(sample_in);
                    x1 <= x0;
                    x2 <= x1;
                    x3 <= x2;
                    x4 <= x3;
                end if;
                
            end if;
        end process;
    
    
    -- Next state logic
        mul1 <= c0 when ctrl = "000" else 
                c1 when ctrl = "001" else 
                c2 when ctrl = "010" else 
                c3 when ctrl = "011" else 
                c4 when ctrl = "100" else 
                c4;
                
        mul2 <= x0 when ctrl = "000" else 
                x1 when ctrl = "001" else 
                x2 when ctrl = "010" else 
                x3 when ctrl = "011" else 
                x4 when ctrl = "100" else 
                x4;
                
        sum2 <= (others => '0') when ctrl = "001" else
                auxiliar_sum(sample_size * 2 - 2 downto 0);
                
        sum1 <= signed(sum1_std);
    
        next_auxiliar_sum <= resize(sum1, next_auxiliar_sum'length) + resize(sum2, next_auxiliar_sum'length);
    
    
    -- Output logic
        s <=  MAX_SAT when auxiliar_sum(sample_size*2 - 1 downto sample_size*2 - 2) = "01" else
              MIN_SAT when auxiliar_sum(sample_size*2 - 1 downto sample_size*2 - 2) = "10" else
              std_logic_vector(auxiliar_sum(sample_size*2-2 downto sample_size-1));

end Behavioral;
