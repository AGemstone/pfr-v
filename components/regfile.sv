module regfile #(parameter BANK_WIDTH = 5, WIDTH = 64) 
                (input logic[BANK_WIDTH-1: 0] ra1, ra2, wa3,
                 input logic[BANK_WIDTH-1: 0] ra_db,
                 input logic[WIDTH-1: 0] wd3,
                 input logic we3, clk,
                 output logic[WIDTH-1: 0] rd1, rd2, rd_db);

    localparam int WORDS = 1 << BANK_WIDTH ;
    logic [WIDTH- 1:0] ram[0:WORDS-1] = '{
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0
    };
    always_ff@(posedge clk) begin
            if (we3 & |{wa3[BANK_WIDTH-1:0]}) begin
                ram[wa3] <= wd3;
            end
    end

    //async read
    assign rd1 = ram[ra1];
    assign rd2 = ram[ra2];
    assign rd_db = ram[ra_db];

    
endmodule