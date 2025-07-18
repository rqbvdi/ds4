use std.textio.all;

use std.env.finish;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_constants_pkg.INSTRUCTION_MEM_SIZE;
use work.cpu_constants_pkg.INSTRUCTION_TYPE;
use work.cpu_constants_pkg.INSTRUCTION_MEM_ADDRESS_TYPE;


entity I_MEMORY is --XILINX BLOCK RAM INST
    port(
        CLK : in std_logic;
        ADDRESS_IN : in INSTRUCTION_MEM_ADDRESS_TYPE;--ADDRESS_IN
        DATA_in : in std_logic_vector(7 downto 0);
        DATA_out : out INSTRUCTION_TYPE;
        
        WE : in std_logic
    );
end entity I_MEMORY;

architecture ARCH of I_MEMORY is
    type ram_type is array (0 to 2**(INSTRUCTION_MEM_SIZE+1)-1) of std_logic_vector(7 downto 0);
    signal MYRAM : ram_type :=  (others => (x"00"));
    signal adress_in_s : std_logic_vector(14 downto 0);
begin
    adress_in_s <= ADDRESS_IN(14 downto 0);
    get_instruction_p: process(CLK)
--            variable buf_out: LINE;
    begin
        if CLK'event and CLK = '0' then
            if WE = '1' then
                MYRAM(to_integer(unsigned(adress_in_s))) <= DATA_in;
            else
               DATA_out(7 downto 0) <= MYRAM(to_integer(unsigned(adress_in_s)));
               DATA_out(15 downto 8) <= MYRAM(to_integer(unsigned(adress_in_s) +1));
               DATA_out(23 downto 16) <= MYRAM(to_integer(unsigned(adress_in_s) +2));
               DATA_out(31 downto 24) <= MYRAM(to_integer(unsigned(adress_in_s) +3));
                --write(buf_out, to_hstring(DATA_out));
                --writeline(output, buf_out);


           end if;
       end if;
       end process get_instruction_p;
end architecture ARCH;
