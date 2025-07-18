library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_constants_pkg.all;

-- Notiz: ALU operation für 'Durchzug' - dadurch nur MUX mit zwei Eingänge vor Regfile - auch besser fürs Pipelining; 
entity CONTROL_UNIT is
    port(
        OPCODE     : in std_logic_vector(6 downto 0);
        FUNCT3     : in std_logic_vector(2 downto 0);
        FUNCT7_30  : in std_logic;
        BRANCH_OUT : out std_logic;
        REG_WRITE_SOURCE : out REG_SOURCE_TYPE;
        JAL_OUT    : out std_logic;
        JALR_OUT   : out std_logic;
--        MEM_READ :std_logic;
--        MEM_TO_REG : out std_logic;
        ALU_CTR_OUT : out ALU_OP_TYPE;-- std_logic_vector(3 downto 0);
--        MEM_WRITE : std_logic;
        ALU_SRC_OUT: out std_logic;
        REG_WRITE_ENABLE: out std_logic;
        DATA_MEM_EN: out std_logic;
        DATA_MEM_WRITE: out std_logic;
        DATA_MEM_2_REG: out std_logic
        
    );
end entity CONTROL_UNIT;

architecture ARCH of CONTROL_UNIT is
    
begin
    gen_contorl_sig_p: process( OPCODE, FUNCT3, FUNCT7_30 )
    begin
        case OPCODE is        -- R-Type
            when "0110011" =>
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '0';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_WRITE_BACK;
                JAL_OUT <= '0';
                JALR_OUT <= '0';
                REG_WRITE_ENABLE <= '1';
                case FUNCT3 is
                    when "000" =>
                        if FUNCT7_30 = '1' then
                             ALU_CTR_OUT <= ALU_SUB;
                        else
                            ALU_CTR_OUT <= ALU_ADD;
                        end if;
                    when "001" =>
                        ALU_CTR_OUT <= ALU_SLL;
                    when "010" =>
                        ALU_CTR_OUT <= ALU_SLT;
                    when "011" =>
                        ALU_CTR_OUT <= ALU_SLTU;
                    when "100" =>
                        ALU_CTR_OUT <= ALU_XOR;
                    when "101" =>
                        if FUNCT7_30 = '1' then
                            ALU_CTR_OUT <= ALU_SRA;
                        else
                            ALU_CTR_OUT <= ALU_SRL;
                        end if;
                    when "110" =>
                        ALU_CTR_OUT <= ALU_OR;
                    when "111" =>
                        ALU_CTR_OUT <= ALU_AND;
                    when others =>
                        ALU_CTR_OUT <= ALU_UNUSED;
                end case;

            when "0010011" => --I Type
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '1';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_WRITE_BACK;
                JAL_OUT <= '0';
                JALR_OUT <= '0';
                REG_WRITE_ENABLE <= '1';
                case FUNCT3 is
                    when "000" =>
                        ALU_CTR_OUT <= ALU_ADD;
                    when "001" =>
                        ALU_CTR_OUT <= ALU_SLL;
                    when "010" =>
                        ALU_CTR_OUT <= ALU_SLT;
                    when "011" =>
                        ALU_CTR_OUT <= ALU_SLTU;
                    when "100" =>
                        ALU_CTR_OUT <= ALU_XOR;
                    when "101" =>
                        if FUNCT7_30 = '1' then
                            ALU_CTR_OUT <= ALU_SRA;
                        else
                            ALU_CTR_OUT <= ALU_SRL;
                        end if;
                    when "110" =>
                        ALU_CTR_OUT <= ALU_OR;
                    when "111" =>
                        ALU_CTR_OUT <= ALU_AND;
                    when others =>
                        ALU_CTR_OUT <= ALU_UNUSED;
                end case;
                
            when "1100011" =>-- B-Type Branches
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '0';
                BRANCH_OUT <= '1';
                REG_WRITE_SOURCE <= "--";
                JAL_OUT <= '0';
                JALR_OUT <= '0';
                REG_WRITE_ENABLE <= '0';
--                case FUNCT3 is
--                    when "000" => --BEQ
--                        ALU_CTR_OUT <= ALU_SUB;
--                        ZERO_CTR <= '0';
--                    when "001" => --BNQ
--                        ALU_CTR_OUT <= ALU_SUB;
--                        ZERO_CTR <= '1';
--                    when "100" => --BLT
--                        ALU_CTR_OUT <= ALU_SLT;
--                        ZERO_CTR <= '1';
--                    when "101" => --BGE
--                        ALU_CTR_OUT <= ALU_SLT;
--                        ZERO_CTR <= '0';
--                    when "110" => --BLTU
--                        ALU_CTR_OUT <= ALU_SLTU;
--                        ZERO_CTR <= '1';
--                    when "111" => --BGEU
--                        ALU_CTR_OUT <= ALU_SLTU;
--                        ZERO_CTR <= '0';
--                    when others =>
--                        ZERO_CTR <= '-';
--                        ALU_CTR_OUT <= ALU_INVALID;
--                end case;

            when "1101111" => --JAL
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '-';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_PC_PLUS_4;
                JAL_OUT <= '1';
                JALR_OUT <= '0';
                REG_WRITE_ENABLE <= '1';
                
            when "1100111" => --JALR
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '-';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_PC_PLUS_4;
                JAL_OUT <= '0';
                JALR_OUT <= '1';
                REG_WRITE_ENABLE <= '1';
                
            when "0010111" => --AUIPC
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '-';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_PC_PLUS_IMM;
                JAL_OUT <= '0';
                JALR_OUT <= '0';
                REG_WRITE_ENABLE <= '1'; 
                
            when "0110111" => --LUI
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '0';
                ALU_SRC_OUT <= '-';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_IMMEDIATE;
                JAL_OUT <=  '0';
                JALR_OUT <=  '0';
                REG_WRITE_ENABLE <=  '1';
                
            when "0000011" =>--LOAD
                ALU_CTR_OUT <= ALU_ADD;
                DATA_MEM_EN <= '1';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '1';
                ALU_SRC_OUT <= '1';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= FROM_WRITE_BACK;
                JAL_OUT <=  '0';
                JALR_OUT <=  '0';
                REG_WRITE_ENABLE <=  '1';

                
            when "0100011" => -- STORE
                ALU_CTR_OUT <= ALU_ADD;
                DATA_MEM_EN <= '1';
                DATA_MEM_WRITE <= '1';
                DATA_MEM_2_REG <= '-';
                ALU_SRC_OUT <= '1';
                BRANCH_OUT <= '0';
                REG_WRITE_SOURCE <= "--";
                JAL_OUT <=  '0';
                JALR_OUT <=  '0';
                REG_WRITE_ENABLE <=  '0';


             
            when others =>
                ALU_CTR_OUT <= ALU_UNUSED;
                DATA_MEM_EN <= '0';
                DATA_MEM_WRITE <= '0';
                DATA_MEM_2_REG <= '-';
                ALU_SRC_OUT <= '-';
                BRANCH_OUT <= '-';
                REG_WRITE_SOURCE <= "--";
                JAL_OUT <= '-';
                JALR_OUT <= '-';
                
        end case;
    end process gen_contorl_sig_p;
end architecture ARCH;