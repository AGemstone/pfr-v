module atom_alu #(parameter N=64) 
                (input logic [N-1:0] a, b,
                 input logic [3:0] ALUControl,
                 output logic [N-1:0] result0, result1
                );
    always_comb
    case(ALUControl)
    
    // csrrw
    'b0000: begin 
        result0 = b;
        result1 = a;
    end
    // csrrs
    'b0001: begin
        result0 = b;
        result1 = a | b;
    end
    
    // csrrc
    'b0011: begin
        result0 = b;
        result1 = ~a & b;
    end
    
    // nop, just passthrough
    default: begin
        result0 = a;
        result1 = b;
    end
    endcase
    
endmodule