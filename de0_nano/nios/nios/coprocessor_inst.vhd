	component coprocessor is
		port (
			clk_clk                : in  std_logic                     := 'X';             -- clk
			pio_addr_export        : out std_logic_vector(14 downto 0);                    -- export
			pio_control_export     : out std_logic_vector(5 downto 0);                     -- export
			pio_data_high_in_port  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- in_port
			pio_data_high_out_port : out std_logic_vector(31 downto 0);                    -- out_port
			pio_data_low_in_port   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- in_port
			pio_data_low_out_port  : out std_logic_vector(31 downto 0);                    -- out_port
			pio_riscv_flags_export : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			reset_reset_n          : in  std_logic                     := 'X'              -- reset_n
		);
	end component coprocessor;

	u0 : component coprocessor
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --             clk.clk
			pio_addr_export        => CONNECTED_TO_pio_addr_export,        --        pio_addr.export
			pio_control_export     => CONNECTED_TO_pio_control_export,     --     pio_control.export
			pio_data_high_in_port  => CONNECTED_TO_pio_data_high_in_port,  --   pio_data_high.in_port
			pio_data_high_out_port => CONNECTED_TO_pio_data_high_out_port, --                .out_port
			pio_data_low_in_port   => CONNECTED_TO_pio_data_low_in_port,   --    pio_data_low.in_port
			pio_data_low_out_port  => CONNECTED_TO_pio_data_low_out_port,  --                .out_port
			pio_riscv_flags_export => CONNECTED_TO_pio_riscv_flags_export, -- pio_riscv_flags.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n           --           reset.reset_n
		);

