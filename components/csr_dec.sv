module csr_dec #(parameter N = 64, W_CSR = 256, HARTID = 0) 
               (input logic [11:0] addr,
                input logic[N-1:0] csr_out[0: W_CSR-1],
                output logic[N-1:0] csr_read);
    localparam logic[N-1:0] misa = {{2'b10},{36'b0},{26'b00000100000000000100000000}};
    always_comb 
        case(addr)
            // 'h300: csr_read = mstatus;
            // M mode read only
            'h301: csr_read = misa;
            'hf11: csr_read = 'b0;
            'hf12: csr_read = 'b0;
            'hf13: csr_read = 'b0;
            'hf14: csr_read = HARTID;  // csr_read = mhartid;
            // M mode read / write
            'h340: csr_read = csr_out[0]; 
            'h300: csr_read = csr_out[1]; 
            'h342: csr_read = csr_out[2];
            'h305: csr_read = csr_out[3];
            'h341: csr_read = csr_out[4];
            // U mode read only
            'hC00: csr_read = csr_out[5];
            default: csr_read = 'h0;
        endcase
endmodule
