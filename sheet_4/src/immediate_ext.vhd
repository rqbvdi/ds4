library ieee;
use ieee.std_logic_1164.all;
use work.cpu_constants_pkg.INSTRUCTION_TYPE;
use work.cpu_constants_pkg.DATA_TYPE;

entity IMMEDIATE_EXT is
    port(
        INSTRUCTION_IN : in INSTRUCTION_TYPE;
        IMMEDIATE : out DATA_TYPE
    );
end entity IMMEDIATE_EXT;

architecture ARCH of IMMEDIATE_EXT is
begin
    imm_gen_p: process(INSTRUCTION_IN)
    begin
        case (INSTRUCTION_IN(6 downto 0)) is
            -- S-Type STORE (opcode: 0100011)
            when "0100011" => 
                IMMEDIATE <= (31 downto 12 => INSTRUCTION_IN(31)) & 
                           INSTRUCTION_IN(31 downto 25) & 
                           INSTRUCTION_IN(11 downto 7);
            
            -- I-Type instructions (opcodes: 0010011, 0000011, 1100111)
            when "0010011" | "0000011" | "1100111" => 
                IMMEDIATE <= (31 downto 12 => INSTRUCTION_IN(31)) & 
                           INSTRUCTION_IN(31 downto 20);
            
            -- B-Type BRANCH (opcode: 1100011)
            when "1100011" => 
                IMMEDIATE <= (31 downto 13 => INSTRUCTION_IN(31)) & 
                           INSTRUCTION_IN(31) & 
                           INSTRUCTION_IN(7) & 
                           INSTRUCTION_IN(30 downto 25) & 
                           INSTRUCTION_IN(11 downto 8) & 
                           '0';
            
            -- J-Type JUMP (opcode: 1101111)
            when "1101111" => 
                IMMEDIATE <= (31 downto 21 => INSTRUCTION_IN(31)) & 
                           INSTRUCTION_IN(31) & 
                           INSTRUCTION_IN(19 downto 12) & 
                           INSTRUCTION_IN(20) & 
                           INSTRUCTION_IN(30 downto 21) & 
                           '0';
            
            -- U-Type UPPER (opcodes: 0110111, 0010111)
            when "0110111" | "0010111" => 
                IMMEDIATE <= INSTRUCTION_IN(31 downto 12) & 
                           (11 downto 0 => '0');
            
            -- Default case: output 0 for unrecognized instructions
            when others =>
                IMMEDIATE <= (others => '0');
        end case;
    end process imm_gen_p;
end architecture ARCH;