module regfile #(parameter BANK_WIDTH = 5, WIDTH = 64) 
                (input logic[BANK_WIDTH-1: 0] ra1, ra2, ra_db, wa3, wa_db,
                 input logic[WIDTH-1: 0] wd3, wd_db,
                 input logic we3, clk, we_db,
                 output logic[WIDTH-1: 0] rd1, rd2, rd_db);

    localparam int WORDS = 1 << BANK_WIDTH ;
    logic [WIDTH- 1:0] ram[0:WORDS-1] = '{
        'd0, 'd0, 'd768, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0
    };
    always_ff@(posedge clk) begin
        if (|{wa3[BANK_WIDTH-1:0]}) begin 
            if (we_db) begin
                ram[we_db] <= wd_db;
            end
            else if (we3) begin
                ram[wa3] <= wd3;
            end
        end
    end

    //negedge reads
    // always @(negedge clk) begin
    //     rd1 <= ram[ra1];
    //     rd2 <= ram[ra2];
    // end
    
    //async read
    assign rd1 = ram[ra1];
    assign rd2 = ram[ra2];
    assign rd_db = ram[ra_db];

    
endmodule