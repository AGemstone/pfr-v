module regfile #(parameter BANK_WIDTH = 5, WIDTH = 64) 
                (input logic[BANK_WIDTH-1: 0] ra1, ra2, wa3,
                 input logic[WIDTH-1: 0] wd3,
                 input logic we3, clk,
                 output logic[WIDTH-1: 0] rd1, rd2);

    localparam int WORDS = 1 << BANK_WIDTH ;
    logic [WIDTH- 1:0] ram[0:WORDS-1] = '{
        'd0, 'd1, 'd2, 'd3, 'd4, 'd5, 'd6, 'd7, 'd8, 'd9, 'd10, 'd11, 'd12,
        'd13, 'd14, 'd15, 'd16, 'd17, 'd18, 'd19, 'd20, 'd21, 'd22, 'd23, 'd24,
        'd25, 'd26, 'd27, 'd28, 'd29, 'd30, 'd31
    };
    
    always_ff@(posedge clk) begin
        if(clk) begin
            if (we3 && wa3 != 5'b0) begin
                ram[wa3] <= wd3;
            end
        end
    end

    assign rd1 = ram[ra1];
    assign rd2 = ram[ra2];

    
endmodule