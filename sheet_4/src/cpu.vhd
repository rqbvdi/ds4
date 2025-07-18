--    iram (rx) : ORIGIN = 0x80000000, LENGTH = 0x6000
--    dram (rw): ORIGIN = 0x00000000, LENGTH = 0x600

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpu_constants_pkg.all;


entity cpu is
    port(        
        CLK : in std_logic;
        RESET : in std_logic;
        
        --BOOTLOADER
        INSTRUCTION_ADDRESS_IN : in INSTRUCTION_MEM_ADDRESS_TYPE;
        INSTRUCTION_DATA_IN : in std_logic_vector(7 downto 0);
        INSTRUCTION_WE_IN : in std_logic;
        DATA_ADDRESS_IN : in DATA_TYPE;
        DATA_DATA_IN : in std_logic_vector(7 downto 0);
        DATA_WE_IN :  in std_logic;
        
        
        INIT_IN : in std_logic;
        --PEREPHERIE
        GPO: out std_logic_vector(7 downto 0);
        GPO_WE: out std_logic      
    );
end entity cpu;

architecture ARCH of cpu is
    signal alu_mux_s, imm_gen_s, alu_out_s, reg_source_s, data_mem_address_in, data_mem_data_in: DATA_TYPE;
    signal instruction_s : INSTRUCTION_TYPE := (others => '0');
    signal alu_ctr_s : ALU_OP_TYPE;
    signal alu_src_s, jal_or_branch_taken_s, branch_s, branch_taken_s, jal_s, jalr_s, register_write_enable_s, data_mem_we_s, data_mem_data_we_s, data_mem_data_en_s, mem_2_reg_s, data_mem_en_s, data_en_s, data_we_s, gpo_we_s: std_logic;
    signal reg_a_s, reg_b_s, data_mem_out_s, write_back_s :  DATA_TYPE;
    signal register_file_write_source_s : REG_SOURCE_TYPE;
    signal instruction_address_pc_s, instruction_mem_address_s  : INSTRUCTION_MEM_ADDRESS_TYPE := (others => '0');
    signal data_mem_funct3: std_logic_vector(2 downto 0);
--    signal data_mem_busy: std_logic;
begin
    programm_counter_inst: entity work.PROGRAM_COUNTER
        port map(
            CLK                             => CLK,
            RESET                           => RESET,
            INSTRUCTION_ADDRESS_OFFSET_IN   => imm_gen_s,--instruction_address_offset_s,
            INSTRUCTION_ADDRESS_IN          => reg_a_s,
            JAL_OR_BRANCH_TAKEN_IN          => jal_or_branch_taken_s,
            JALR_IN                         => jalr_s,
            INSTRUCTION_ADDRESS_OUT         => instruction_address_pc_s
   
            --INSTRUCTION_ADDRESS_PLUS_4_OUT  => pc_plus_4
    );
        
    BOOTLOADER_MUX_P: process(INIT_IN, INSTRUCTION_ADDRESS_IN, instruction_address_pc_s, alu_out_s, data_mem_en_s, data_mem_we_s, instruction_s(14 downto 12), reg_b_s, DATA_ADDRESS_IN, DATA_DATA_IN, DATA_WE_IN)
    begin
        if INIT_IN = '1' then
            instruction_mem_address_s <= INSTRUCTION_ADDRESS_IN;
            data_mem_address_in <= DATA_ADDRESS_IN;
            data_mem_data_in(7 downto 0) <= DATA_DATA_IN;
            data_mem_data_we_s <= DATA_WE_IN;
            data_mem_data_en_s <= '1';
            data_mem_funct3 <= "000";
        else
            instruction_mem_address_s <= X"0000" & "0" & instruction_address_pc_s(14 downto 0);
            data_mem_address_in <= alu_out_s;
            data_mem_data_in <= reg_b_s;
            data_mem_data_we_s <= data_mem_we_s;
            data_mem_data_en_s <= data_mem_en_s;
            data_mem_funct3 <= instruction_s(14 downto 12);
        end if;
    end process BOOTLOADER_MUX_P; 
        
    intruction_memory_inst: entity work.I_MEMORY
        port map(
            CLK        => CLK,
            ADDRESS_IN =>  X"0000" & "0" & instruction_mem_address_s(14 downto 0),
            DATA_in    => INSTRUCTION_DATA_IN,
            DATA_out   => instruction_s, 
            WE         => INSTRUCTION_WE_IN
    );
        
    data_mem_inst: entity work.D_MEMORY
        port map(
            CLK        => CLK,
            ADDRESS_IN => X"00000" & "0" & data_mem_address_in(10 downto 0),
            DATA_in    => data_mem_data_in,
            DATA_out   => data_mem_out_s,
            WE         => data_mem_data_we_s,
            EN         => data_mem_data_en_s,
            FUNCT3 => data_mem_funct3
    );
    
    DATA_MEM_GPO_DECODER_P: process(data_en_s, data_we_s, alu_out_s) 
    begin
        if alu_out_s = X"00005000" and data_en_s = '1' and data_we_s = '1' then
            gpo_we_s <= '1';
            data_mem_en_s <= '0';
            data_mem_we_s <= '0';
        else
            gpo_we_s <= '0';
            data_mem_en_s <= data_en_s;   
            data_mem_we_s <= data_we_s;
        end if;
    end process DATA_MEM_GPO_DECODER_P;
    GPO_WE <= gpo_we_s;
    GPO_P: process(CLK)
    begin
        if(CLK'event and CLK = '1') then
            if RESET = '1' then
                GPO <= (others => '0');
            elsif gpo_we_s = '1' then
                GPO <= reg_b_s(7 downto 0);
            end if;
        end if;
    end process GPO_P;
    
    
    
    control_uinit_int: entity work.CONTROL_UNIT
        port map(
            OPCODE    => instruction_s(6 downto 0), -- TODO
            FUNCT3    => instruction_s(14 downto 12), -- TODO
            FUNCT7_30 => instruction_s(30), -- TODO
            BRANCH_OUT => branch_s,
            REG_WRITE_SOURCE => register_file_write_source_s,
            JAL_OUT => jal_s,
            JALR_OUT => jalr_s,
            ALU_CTR_OUT   => alu_ctr_s,
            ALU_SRC_OUT   => alu_src_s,
            REG_WRITE_ENABLE => register_write_enable_s,
            DATA_MEM_EN => data_en_s,
            DATA_MEM_WRITE => data_we_s,
            DATA_MEM_2_REG => mem_2_reg_s
    );
          
    register_file_inst: entity work.REGISTER_FILE
        port map(
            CLK               => CLK,
            REG_A_ADDRESS     => instruction_s(19 downto 15), -- TODO
            REG_A             => reg_a_s,
            REG_B_ADDRESS     => instruction_s(24 downto 20), -- TODO
            REG_B             => reg_b_s,
            REG_WRITE_ADDRESS => instruction_s(11 downto 7), -- TODO
            WRITE_DATA        => reg_source_s,
            WRITE_ENABLE      => register_write_enable_s
    );
         
    alu_inst: entity work.ALU
        port map(
            A_VALUE       => reg_a_s,
            B_VALUE       => alu_mux_s,
            ALU_OPERATION => alu_ctr_s,
            OUT_VALUE        => alu_out_s
        );
        
    branch_comp_inst:    entity work.BRANCH_COMPARATOR
        port map(  
            FUNCT3 => instruction_s(14 downto 12), -- TODO
            REG_A => reg_a_s,
            REG_B =>reg_b_s,
            BRANCH_TAKEN => branch_taken_s
        );  
    
    jal_or_branch_taken_s <= (branch_taken_s and branch_s) or  jal_s;
       
    imm_gen_inst: entity work.IMMEDIATE_EXT
        port map(
            INSTRUCTION_IN => instruction_s, -- TODO
            IMMEDIATE      => imm_gen_s
    );
        
    REG_SOURCE_MUX_P: process(imm_gen_s, register_file_write_source_s, instruction_mem_address_s, write_back_s)
    begin
        case register_file_write_source_s is
            when FROM_WRITE_BACK =>
                reg_source_s <= write_back_s;
            when FROM_IMMEDIATE =>
                reg_source_s <= imm_gen_s;
            when FROM_PC_PLUS_4 =>
                reg_source_s <=  std_logic_vector(signed(instruction_mem_address_s) + 4);
            when FROM_PC_PLUS_IMM =>
                reg_source_s <= std_logic_vector(signed(instruction_mem_address_s) + signed(imm_gen_s));
            when others =>
                reg_source_s <= (others => '0');
        end case;
    end process REG_SOURCE_MUX_P;
    
    
    ALU_MUX_P: process(alu_src_s, reg_b_s, imm_gen_s)
    begin
        -- TODO
        if alu_src_s = '1' then
            alu_mux_s <= imm_gen_s;
        else
            alu_mux_s <= reg_b_s;
        end if;
    end process ALU_MUX_P;
    
    
    WRITE_BACK_MUX_P: process(alu_out_s, data_mem_out_s, mem_2_reg_s)
    begin
        if mem_2_reg_s = '1' then
            write_back_s <= data_mem_out_s;
        else
            write_back_s <= alu_out_s;
        end if;
    end process WRITE_BACK_MUX_P;

    
    
end architecture ARCH;