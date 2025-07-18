library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.cpu_constants_pkg.ALL;


entity BRANCH_COMPARATOR is
  port ( FUNCT3   : in  STD_LOGIC_VECTOR(2 downto 0);
         REG_A,  REG_B                : in  DATA_TYPE;      
         BRANCH_TAKEN        : out STD_LOGIC); 
end entity;


architecture Behavioral of BRANCH_COMPARATOR is

--    BRANCH_TEST_EQ    "000";
--    BRANCH_TEST_NE    "001";
--    BRANCH_TEST_TRUE  "010";
--    BRANCH_TEST_FALSE "011";
--    BRANCH_TEST_LT    "100";
--    BRANCH_TEST_GE    "101";
--    BRANCH_TEST_LTU   "110";
--    BRANCH_TEST_GEU   "111";


begin

    process(FUNCT3, REG_A, REG_B)
        variable branch_taken_v: boolean;
    begin

        case FUNCT3 is
            when "000" => -- EQ
                branch_taken_v := (REG_A = REG_B);
            when "001" => -- NE
                branch_taken_v := (REG_A /= REG_B);
            when "100" => -- LT
                branch_taken_v := (signed(REG_A) < signed(REG_B));
            when "101" => -- GE
                branch_taken_v := (signed(REG_A) >= signed(REG_B));
            when "110" => -- LTU
                branch_taken_v := (unsigned(REG_A) < unsigned(REG_B));
            when "111" => -- GEU
                branch_taken_v := (unsigned(REG_A) >= unsigned(REG_B));
            when others =>
                branch_taken_v := false;
            end case;
            
            if branch_taken_v then
                BRANCH_TAKEN <= '1';
            else
                BRANCH_TAKEN <= '0';
            end if;
            
    end process;

end Behavioral;