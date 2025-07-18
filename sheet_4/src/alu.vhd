library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.cpu_constants_pkg.all;

entity ALU is
    port (
        A_VALUE       : in  DATA_TYPE;
        B_VALUE       : in  DATA_TYPE;
        ALU_OPERATION : in  ALU_OP_TYPE;
        OUT_VALUE     : out DATA_TYPE
    );
end entity ALU;

architecture ARCH of ALU is
    signal out_value_s : DATA_TYPE;
begin
    ALU_P: process(A_VALUE, B_VALUE, ALU_OPERATION)
    begin
        case ALU_OPERATION is
            when ALU_AND =>
                out_value_s <= A_VALUE and B_VALUE;
            
            when ALU_OR =>
                out_value_s <= A_VALUE or B_VALUE;
            
            when ALU_XOR =>
                out_value_s <= A_VALUE xor B_VALUE;
            
            when ALU_ADD =>
                out_value_s <= std_logic_vector(unsigned(A_VALUE) + unsigned(B_VALUE));
            
            when ALU_SUB =>
                out_value_s <= std_logic_vector(unsigned(A_VALUE) - unsigned(B_VALUE));
            
            when ALU_SLL =>
                -- Logical left shift of value_a by lower 5 bits of value_b
                out_value_s <= std_logic_vector(shift_left(unsigned(A_VALUE), to_integer(unsigned(B_VALUE(4 downto 0)))));
            
            when ALU_SLT =>
                -- Set to 1 if value_a < value_b (signed), else 0
                if signed(A_VALUE) < signed(B_VALUE) then
                    out_value_s <= (0 => '1', others => '0');
                else
                    out_value_s <= (others => '0');
                end if;
            
            when ALU_SLTU =>
                -- Set to 1 if value_a < value_b (unsigned), else 0
                if unsigned(A_VALUE) < unsigned(B_VALUE) then
                    out_value_s <= (0 => '1', others => '0');
                else
                    out_value_s <= (others => '0');
                end if;
            
            when ALU_SRL =>
                -- Logical right shift of value_a by lower 5 bits of value_b
                out_value_s <= std_logic_vector(shift_right(unsigned(A_VALUE), to_integer(unsigned(B_VALUE(4 downto 0)))));
            
            when ALU_SRA =>
                -- Arithmetic right shift of value_a by lower 5 bits of value_b
                out_value_s <= std_logic_vector(shift_right(signed(A_VALUE), to_integer(unsigned(B_VALUE(4 downto 0)))));
            
            when others =>
                out_value_s <= (others => '0');
        end case;
    end process ALU_P;

    OUT_VALUE <= out_value_s;

end architecture ARCH;