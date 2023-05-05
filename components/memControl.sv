module memControl #(parameter N = 64) 
                    (input logic clk, reset,
                     input logic[1:0] op,
                     input logic[17:0] dataAddr,
                     input logic[N-1:0] dataWrite,
                     output logic[N-1:0] dataRead,
                     output logic[12:0] dramAddr,
                     output logic[15:0] dramData,
                     output logic[1:0] bankSel,
                     output logic readReady,
                     output logic[1:0] dataMask,
                     output logic CS_N, WE_N, CAS_N, RAS_N);
    
    // read / write signals
    logic [N-1:0] writeOut;
    logic [1:0] bank;
    logic [12:0] active_row;
    logic [N-1:0] write_16;
    
    mux4 mw(.s(bank),
        .d0(dataWrite[15:0]),
        .d1(dataWrite[31:16]),
        .d2(dataWrite[47:32]),
        .d3(dataWrite[63:48]),
        .y(write_16));

    assign dramData = op[0] ? write_16 : {N{1'bZ}};
    always_comb
    begin
        if (op[1]) begin
            if (~bank[1] & ~bank[0])
            begin
                dataRead[15:0] <= dramData;
                dataRead[63:16] <= 'Z;
            end
            else if (~bank[1] & bank[0]) 
            begin
                dataRead[31:16] <= dramData;
                dataRead[63:32]<= 'Z;
                dataRead[15:0] <= 'Z;
            end
            else if (bank[1] & ~bank[0])
            begin
                dataRead[47:32] <= dramData;
                dataRead[63:48] <='Z;
                dataRead[31:0] <='Z;
            end
            else 
            begin
                dataRead[63:48] <= dramData;
                dataRead[47:0] <= 'Z;
            end
        end
        else begin
            dataRead <= 'Z;
        end
    end
    // timing, adjusted for CAS: 2 - 125MHz
    // for testbench
    localparam int init_time_ns = 16;
    // for fpga
    // localparam int init_time_ns = 200000;
    localparam int clk_period_ns = 8;
    localparam int tInit = init_time_ns / clk_period_ns + 1;
    localparam int tRP = 2;
    localparam int tRC = 8;
    localparam int tMRD = 2;
    localparam int tRCD = 3;
    localparam int tRRD = 2;
    localparam logic [15:0] modeRegsiter = 'b00000_0_00_010_0_111;

    // timers
    logic [15:0] timer_init;
    logic [1:0] timer_tRP, timer_tMRD, timer_tRCD, timer_tRRD;
    logic [3:0] timer_tRC;
    logic [4:0] counter_RefreshInit;
    logic stat_modeRegSet, stat_rowActive;
    logic enable_tRC, enable_tRP, enable_tRAS, enable_tRCD, enable_tMRD;
    logic enable_RefreshInit, enable_tRRD;
    
    typedef enum logic[3:0] {
        DESL  = 4'b1000,
        NOP   = 4'b0111,
        BST   = 4'b0110,
        READ  = 4'b0101,
        WRITE = 4'b0100,
        ACT   = 4'b0011,
        PRE   = 4'b0010,
        REF   = 4'b0001,
        MRS   = 4'b0000
    } dramCommand;
    dramCommand command;

    typedef enum logic[3:0] {
        INIT,
        IDLE,
        ACTIVATING,
        ACTIVE,
        READING,
        WRITING,
        // PRECHARGE,
        PRECHARGE_ALL,
        REGSET,
        // SELFREF,
        AUTOREF,
        AUTOREF_INIT
        // POWEROFF
    } state;
    state currState, nextState; 

    always @(posedge clk or posedge reset) begin 
        if(reset) begin
            currState <= INIT;
            timer_init <= tInit;
            timer_tRC <= tRC;
            timer_tRP <= tRP;
            timer_tMRD <= tMRD;
            timer_tRRD <= tRRD;
            timer_tRCD <= tRCD;
            counter_RefreshInit <= 'h8;
        end
        else begin
            currState <= nextState;
            timer_init <= (|{timer_init[15:0]}) ? timer_init - 1 : 0;
            timer_tRC <= enable_tRC ? timer_tRC - 1 : tRC;
            timer_tRP <= enable_tRP ? timer_tRP - 1 : tRP;
            timer_tMRD <= enable_tMRD ? timer_tMRD - 1 : tMRD;
            timer_tRRD <= enable_tRRD ? timer_tRRD - 1 : tRRD;
            timer_tRCD <= enable_tRCD ? timer_tRCD - 1 : tRCD;
            counter_RefreshInit <= enable_RefreshInit ? counter_RefreshInit - 1 : counter_RefreshInit;
        end
    end
    always @* begin 
        case (currState)
        INIT: 
        begin
            if(timer_init == 0) begin
                command <= PRE;
                // args
                dramAddr <= 13'b0;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 1;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= PRECHARGE_ALL;
            end
            else begin
                command <= NOP;
                // args
                dramAddr <= 13'b0;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= INIT;
            end
        end
        PRECHARGE_ALL: 
        begin
            if(timer_tRP == 0) begin
                command <= NOP;
                // args
                dramAddr <= 13'b0;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= IDLE;
            end
            else begin
                command <= NOP; 
                // args
                dramAddr <= 13'b00_1_0000000000;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 1;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= PRECHARGE_ALL;
            end
        end
        IDLE:
        begin
            if (counter_RefreshInit != 0) begin
                command <= REF;
                // args
                dramAddr <= 13'b00_1_0000000000;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 1;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 1;
                stat_rowActive <= 0;
                nextState <= AUTOREF_INIT;
            end
            // regset
            else if (stat_modeRegSet) begin
                command <= MRS;
                // args
                dramAddr <= modeRegsiter[13:0];
                bank <= modeRegsiter[15:14];
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 1;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 1;
                stat_rowActive <= 0;
                nextState <= REGSET;
            end
            //begin read/write
            else if (|{op[1:0]}) begin
                command <= ACT;
                // args
                dramAddr <= 13'b00_1_0000000000;
                bank <= 2'b0;
                dataMask <= 2'b00;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= ACTIVE;

            end

            // else if refresh timer is up
            // nop
            else begin
                command <= NOP;
                // args
                dramAddr <= 13'b00_1_0000000000;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= IDLE;
            end
        end
        AUTOREF_INIT:
        begin
            if (timer_tRC == 0) begin
                command <= NOP;
                // args
                dramAddr <= 13'b0;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 1;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 1;
                stat_rowActive <= 0;
                nextState <= IDLE;
            end
            else begin
                command <= NOP;
                // args
                dramAddr <= 13'b0;
                bank <= 2'b0;
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 1;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 1;
                stat_rowActive <= 0;
                nextState <= AUTOREF_INIT;
            end

        end
        REGSET:
        begin
            if(timer_tMRD == 0) begin
                command <= NOP;
                // args
                dramAddr <= modeRegsiter[13:0];
                bank <= modeRegsiter[15:14];
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 0;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= IDLE;
            end
            else begin
                command <= NOP;
                // args
                dramAddr <= modeRegsiter[13:0];
                bank <= modeRegsiter[15:14];
                dataMask <= 2'b11;
                // timer enable
                enable_tRC <= 0;
                enable_tRP <= 0;
                enable_RefreshInit <= 0;
                enable_tMRD <= 1;
                enable_tRRD <= 0;
                enable_tRCD <= 0;
                // transition
                stat_modeRegSet <= 0;
                stat_rowActive <= 0;
                nextState <= REGSET;
            end
        end

        default begin 
            command <= DESL;
            // args
            dramAddr <= 13'b0;
            bank <= 2'b0;
            dataMask <= 2'b11;
            // timer enable
            enable_tRC <= 0;
            enable_tRP <= 0;
            enable_RefreshInit <= 0;
            enable_tMRD <= 0;
            enable_tRRD <= 0;
            enable_tRCD <= 0;
            // transition
            stat_modeRegSet <= 0;
            stat_rowActive <= 0;
            nextState <= IDLE;
        end
        endcase
    end

    // 4 banks
    // 67,108,864 bit banks, 4M = 2**22 words of 16 bits
    // 2**13 = 8,192 rows by 2**9 = 512 columns by 16 bits

    // ignore alignment issues
    // row addr dataAddr[8:0]
    // col addr dataAddr[17:9]
    /*
        byteaddr 0_1000_0000_0001__0_1000_xxxx

                          0_1000_xxxx
        starting column   0 1000 0000

                 0_1000_0000_0001
        row      0 1000 0000 0001

        if we do:
        - access byteaddr 0_0000_0000__0_0000_0001_0000
        - access byteaddr 0_0001_0000__0_0000_0001_0000
        then we dont need to precharge since its on the same row

    */
    assign bankSel = bank;
    assign CS_N  = command[3];
    assign RAS_N = command[2];
    assign CAS_N = command[1];
    assign WE_N  = command[0];
    
endmodule