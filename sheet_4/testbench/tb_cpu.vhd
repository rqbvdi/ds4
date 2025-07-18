use std.textio.all;

use std.env.finish;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_constants_pkg.DATA_TYPE;
use work.cpu_constants_pkg.INSTRUCTION_TYPE;
use work.cpu_constants_pkg.INSTRUCTION_MEM_ADDRESS_TYPE;
use work.cpu_constants_pkg.ALU_OP_TYPE;

entity tb_cpu is

end entity tb_cpu;

architecture RTL of tb_cpu is

    signal clk: std_logic;
    signal instr_mem_address_bootloader : INSTRUCTION_MEM_ADDRESS_TYPE := x"00000000";--std_logic_vector(15 downto 0);
    signal data_mem_address_bootloader : INSTRUCTION_MEM_ADDRESS_TYPE := x"00000000";
    signal instr_data_in_s : std_logic_vector(7 downto 0) := (others => '0');
    signal intr_mem_we_s : std_logic := '1';
    signal data_data_in_s : std_logic_vector(7 downto 0):= (others => '0');
    signal init_s : std_logic := '1';
    signal reset_s : std_logic := '1';
    signal data_mem_we_s : std_logic := '1';
 --   signal data_mem_en_s : std_logic := '1';
    signal gpo_s : std_logic_vector(7 downto 0):= (others => '0');
    signal gpo_we_s : std_logic := '1';

begin

    clk_p: process
    begin
        clk <= '1'; wait for 5 ns;
        clk <= '0'; wait for 5 ns;
    end process clk_p;
    
    gpio_tb_p: process(gpo_s, gpo_we_s)
        variable buf_out: LINE;
        variable trap: std_logic := '1';
    begin
        if gpo_we_s = '1' and trap = '1' then
            if gpo_s = x"0a" then
                WRITELINE(output, buf_out);
            elsif gpo_s = x"FF" then
                finish;
            else
                WRITE(output, "" & character'val(to_integer(unsigned(gpo_s))) );
            end if;
            trap := '0';
        else trap := '1';
        end if;
    end process gpio_tb_p;

    cpu_dut: entity work.cpu

    port map(

        CLK                    => clk,
        RESET                  => reset_s,
        INSTRUCTION_ADDRESS_IN => instr_mem_address_bootloader,
        INSTRUCTION_DATA_IN    => instr_data_in_s,
        INSTRUCTION_WE_IN      => intr_mem_we_s,
        DATA_ADDRESS_IN => data_mem_address_bootloader,
        DATA_DATA_IN => data_data_in_s,
        DATA_WE_IN => data_mem_we_s,
        INIT_IN                => init_s,
        GPO => gpo_s,
        GPO_WE => gpo_we_s
    );

    bootloader_p : process is
    type char_file_t is file of character;
    file char_file : char_file_t;
    variable char_v : character;
    subtype byte_t is natural range 0 to 255;
    variable byte_v  : byte_t;
    variable byte_std_v : std_logic_vector (7 downto 0);
    variable counter : integer := 0;
    variable buf_out: LINE;
    begin

        if init_s = '1' then
            --------------------------------Instruction Memory-------------------------------
            file_open(char_file, "instruction_mem.bin"); -- instruction_mem.bin "fibonacci.bin");--instruction_mem.bin
            while not endfile(char_file) loop
                read(char_file, char_v);
                byte_v := character'pos(char_v);
                --write(buf_out, now);
                --write(buf_out, string'(" instr_mem byte: "));
                byte_std_v := std_logic_vector(to_unsigned(byte_v,8));
                --write(buf_out, to_hstring(byte_std_v));
                --write(buf_out, string'(" counter: "));
                --write(buf_out, counter);
                --writeline(output, buf_out);
                instr_data_in_s <= byte_std_v;
                wait for 10 ns;
                counter := counter +1;
                instr_mem_address_bootloader <= std_logic_vector(unsigned(instr_mem_address_bootloader) + 1);
            end loop;

            file_close(char_file);
            --write(buf_out, counter);
            --writeline(output, buf_out);
            intr_mem_we_s <= '0';

            --------------------------------Data Memory-------------------------------------

            counter := 0;
            file_open(char_file, "data_mem.bin"); 
            while not endfile(char_file) loop
                read(char_file, char_v);
                byte_v := character'pos(char_v);
--                write(buf_out, now);
--                write(buf_out, string'(" data_mem byte: "));
                byte_std_v := std_logic_vector(to_unsigned(byte_v,8));
--                write(buf_out, to_hstring(byte_std_v));
--                write(buf_out, string'(" counter: "));
--                write(buf_out, counter);
--                writeline(output, buf_out);
                data_data_in_s <= byte_std_v;
                wait for 10 ns;
                counter := counter +1;
                data_mem_address_bootloader <= std_logic_vector(unsigned(data_mem_address_bootloader) + 1);

            end loop;

            file_close(char_file);
            --write(buf_out, counter);
            --writeline(output, buf_out);
            data_mem_we_s <= '0';
            wait for 10 ns;
            init_s <= '0';
            wait for 30 ns;
            reset_s <= '0';
            wait;

        end if;

    end process bootloader_p;

    --reg_a_s <= x"0000000F",x"00000013" after 30 ns, x"C001CAFE" after 71 ns, x"0000000A" after 80 ns;

    --reg_b_s <= x"00000010" , x"00000003" after 39 ns,x"DEADBEEF" after 73 ns;

    --INSTRUCTION <= x"00B60633" ,x"40b60633" after 20 ns, x"010716b3" after 40 ns, x"00632e33" after 60 ns, x"00C7E793" after 80 ns, x"00C2cc13" after 90 ns, x"00CCF813" after 100 ns, x"00C30593" after 110 ns, x"00000000" after 115 ns;

--                    add          sub                       sll                      slt                     ori C                     xori C                 andi C                      addi C

end architecture RTL;