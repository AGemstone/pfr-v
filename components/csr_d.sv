module csr_d #(parameter N = 64) (
    input logic [12:0] addr,
    input logic op, clk, reset,
    input logic [N-1:0] din,
    output logic[N-1:0] dout
);

    always_comb 
    begin
        case(addr)
        // 'h300: dout <= mstatus;
        // 'h301: dout <= misa;
        // 'hf11: dout <= mvendorid;
        // 'hf12: dout <= marchid;
        // 'hf13: dout <= mimpid;
        // 'hf14: dout <= mhartid;
        default: dout <= 0;
        endcase
    end

    
endmodule
