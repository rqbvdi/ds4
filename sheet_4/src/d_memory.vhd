use std.textio.all;
use std.env.finish;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_constants_pkg.DATA_TYPE;
use work.cpu_constants_pkg.INSTRUCTION_MEM_ADDRESS_TYPE;


entity D_MEMORY is --XILINX BLOCK RAM INST
    port(
        CLK : in std_logic;
        ADDRESS_IN : in DATA_TYPE;
        DATA_in : in DATA_TYPE;
        DATA_out : out DATA_TYPE;
        WE : in std_logic;
        EN : in std_logic;
        FUNCT3: in std_logic_vector(2 downto 0)
    );
end entity D_MEMORY;

architecture ARCH of D_MEMORY is
    type ram_type is array (0 to 4096) of std_logic_vector(7 downto 0);--2**(13+1)
    signal MYRAM : ram_type :=  (others => (x"00"));
    signal adress_in_s : unsigned(14 downto 0);
    signal data_val_s : DATA_TYPE;
--    signal we_s: std_logic;
begin

    adress_in_s <= unsigned(ADDRESS_IN(14 downto 0));
    
    get_data_p: process(CLK, EN, MYRAM, WE, adress_in_s)
    begin
        if CLK'event and CLK = '1' then
            if EN = '1' then
                if WE = '1' then
                    
                    case FUNCT3 is
                        when "000" =>
                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);
                        when "001" =>    
                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);        
                            MYRAM(to_integer(adress_in_s) +1) <= DATA_in(15 downto 8);
                        when "010" =>
                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);        
                            MYRAM(to_integer(adress_in_s) +1) <= DATA_in(15 downto 8);
                            MYRAM(to_integer(adress_in_s) +2) <= DATA_in(23 downto 16);
                            MYRAM(to_integer(adress_in_s) +3) <= DATA_in(31 downto 24);
                        when others =>
                            MYRAM(to_integer(adress_in_s)) <= (others => 'Z');
                    end case;
                end if;
            end if;
        end if;
        if EN = '1' then
            if WE = '0' then 
--                else
                            data_val_s(7 downto 0) <= MYRAM(to_integer(adress_in_s));       
                            data_val_s(15 downto 8) <= MYRAM(to_integer(adress_in_s) +1);
                            data_val_s(23 downto 16) <= MYRAM(to_integer(adress_in_s) +2);
                            data_val_s(31 downto 24) <= MYRAM(to_integer(adress_in_s) +3);
--                            write(buf_out, now);
--                            write(buf_out, to_hstring(data_val_s));
--                            writeline(output, buf_out);
--                end if;
            end if;
        end if;
    end process get_data_p;
    
    data_out_p: process(data_val_s, EN, WE, FUNCT3)
    begin
        
        if EN = '1' and WE = '0' then
            case FUNCT3 is
                when "000" =>
                    DATA_out(7 downto 0) <= data_val_s(7 downto 0);
                    DATA_out(31 downto 8)  <= (others => data_val_s(7));
                when "001" =>
                    DATA_out(15 downto 0) <= data_val_s(15 downto 0);
                    DATA_out(31 downto 16) <= (others => data_val_s(15));
                when "010" =>
                    DATA_out <= data_val_s;
                when "100" =>
                    DATA_out(7 downto 0) <= data_val_s(7 downto 0);
                    DATA_out(31 downto 8)  <= (others => '0');
                when "101" =>
                    DATA_out(15 downto 0) <= data_val_s(15 downto 0);
                    DATA_out(31 downto 16) <= (others => '0');
                when others =>
                    DATA_out <= (others => 'Z');
            end case;              
        
        end if;
    end process data_out_p;
    
    
    


    
        
--    get_data_p: process(ADDRESS_IN, FUNCT3, EN, WE, MYRAM, CLK, value_s(15 downto 0), value_s(15), value_s(7 downto 0), value_s(7))
--    begin
--        if CLK'event and CLK = '0' then    
--            if EN = '1' and WE = '1' then
--                
--                    case FUNCT3 is
--                        when "000" =>
--                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);
--                        when "001" =>    
--                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);        
--                            MYRAM(to_integer(adress_in_s) +1) <= DATA_in(15 downto 8);
--                        when "010" =>
--                            MYRAM(to_integer(adress_in_s))    <= DATA_in(7 downto 0);        
--                            MYRAM(to_integer(adress_in_s) +1) <= DATA_in(15 downto 8);
--                            MYRAM(to_integer(adress_in_s) +2) <= DATA_in(23 downto 16);
--                            MYRAM(to_integer(adress_in_s) +3) <= DATA_in(31 downto 24);
--                        when others =>
--                            MYRAM(to_integer(adress_in_s)) <= (others => 'Z');
--                    end case;
--            end if;
            
--            if WE = '1' and EN = '1' then
--                case FUNCT3 is
--                    when "000" =>
--                        MYRAM(to_integer(unsigned(ADDRESS_IN))) <= DATA_in(7 downto 0);
--                    when "001" =>
--                        MYRAM(to_integer(unsigned(ADDRESS_IN))) <= DATA_in(7 downto 0);
--                        MYRAM(to_integer(unsigned(ADDRESS_IN)+1)) <= DATA_in(15 downto 8);
--                    when "010" =>
--                        MYRAM(to_integer(unsigned(ADDRESS_IN))) <= DATA_in(7 downto 0);
--                        MYRAM(to_integer(unsigned(ADDRESS_IN)+1)) <= DATA_in(15 downto 8);
--                        MYRAM(to_integer(unsigned(ADDRESS_IN)+2)) <= DATA_in(23 downto 16);
--                        MYRAM(to_integer(unsigned(ADDRESS_IN)+3)) <= DATA_in(31 downto 24);
--                    when others =>
--                        MYRAM(to_integer(unsigned(ADDRESS_IN))) <= (others => 'Z');
--                end case;
--            end if;
--         end if;   
--
--        if WE = '0' and EN = '1' then
----            write(buf_out, now);
----                write(buf_out, string'("ADDRESS_IN: "));
----                write(buf_out, to_integer(unsigned(ADDRESS_IN)));
----                writeline(output, buf_out);
--        case FUNCT3 is
--            when "000" =>
--                value_s(7 downto 0) <= MYRAM(to_integer(unsigned(ADDRESS_IN)));
--                DATA_out <= (31 downto 8 => value_s(7)) & value_s(7 downto 0);
--            when "001" =>
--                value_s(7 downto 0) <= MYRAM(to_integer(unsigned(ADDRESS_IN)));
--                value_s(15 downto 8) <= MYRAM(to_integer(unsigned(ADDRESS_IN) +1));
--                DATA_out <= (31 downto 16 => value_s(15)) & value_s(15 downto 0);
--            when "010" =>
--                DATA_out(7 downto 0) <= MYRAM(to_integer(unsigned(ADDRESS_IN))); --report "adresse: " & to_string(to_integer(unsigned(ADDRESS_IN))) & "funct3: " & to_string(FUNCT3) & " val: " & to_string(MYRAM(to_integer(unsigned(ADDRESS_IN)+3)) & MYRAM(to_integer(unsigned(ADDRESS_IN) +2)) & MYRAM(to_integer(unsigned(ADDRESS_IN) + 1)) & MYRAM(to_integer(unsigned(ADDRESS_IN))));
--                DATA_out(15 downto 8) <= MYRAM(to_integer(unsigned(ADDRESS_IN) +1));
--                DATA_out(23 downto 16) <= MYRAM(to_integer(unsigned(ADDRESS_IN) +2));
--                DATA_out(31 downto 24) <= MYRAM(to_integer(unsigned(ADDRESS_IN) +3));
--            when "100" =>
--                --report "adresse: " & to_string((unsigned(ADDRESS_IN)));
--                value_s(7 downto 0) <= MYRAM(to_integer(unsigned(ADDRESS_IN)));
--                DATA_out <= (31 downto 8 => '0') & value_s(7 downto 0);
--            when "101" =>
--                value_s(7 downto 0) <= MYRAM(to_integer(unsigned(ADDRESS_IN)));
--                value_s(15 downto 8) <= MYRAM(to_integer(unsigned(ADDRESS_IN) +1));
--                DATA_out <= (31 downto 16 => '0') & value_s(15 downto 0);
--            when others =>
--                DATA_out <= (others => 'Z');
--          end case;
--          end if;
--          
--       end process get_data_p;
end architecture ARCH;