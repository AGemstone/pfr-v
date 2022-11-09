module regfile #(parameter BANK_WIDTH = 5, WIDTH = 64) 
                (input logic[BANK_WIDTH-1: 0] ra1, ra2, wa3,
                 input logic[WIDTH-1: 0] wd3,
                 input logic we3, clk,
                 output logic[WIDTH-1: 0] rd1, rd2);

    localparam int WORDS = 1 << BANK_WIDTH ;
    logic [WIDTH- 1:0] ram[0:WORDS-1] = '{
        'd0, 'd0, 'd768, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
        'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0
    };
    
    always_ff@(posedge clk) begin
        // if(clk) begin
        if (we3 & (|{wa3[BANK_WIDTH-1:0]})) begin
            ram[wa3] <= wd3;
        end
        // end
    end

    //negedge reads
    // always @(negedge clk) begin
    //     rd1 <= ram[ra1];
    //     rd2 <= ram[ra2];
    // end
    
    //async read
    assign rd1 = ram[ra1];
    assign rd2 = ram[ra2];

    
endmodule