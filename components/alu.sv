module alu #(parameter N=64) 
            (input logic[N-1:0] a, b,
            input logic wArith,
            input logic[3:0] ALUControl,
            output logic zero, overflow, sign,
            output logic[N-1:0] result);

    logic[N-1:0] sltResult;

    always_comb
    case(ALUControl) 
        4'b0000 : begin 
            result = a & b; 
            overflow = 0; 
        end

        4'b0001 : begin 
            result = a | b; 
            overflow = 0; 
        end

        4'b1001 : begin 
            result = a ^ b;
            overflow = 0; 
        end

        4'b0010 : {overflow, result} = a + b; 
        4'b0110 : {overflow, result} = a - b;
        // slt
        4'b1110 : begin  
            result = $signed(a) < $signed(b);
            overflow = 0;
        end
        //sltu
        4'b1010 : begin  
            result = a < b;
            overflow = 0;
        end

        4'b0011 : begin 
            if (wArith)
                result = a >> b[4:0];
            else
                result = a >> b[5:0];
            overflow = 0; 
        end
        4'b1011 : begin 
            if (wArith)
                result = $signed(a) >>> b[4:0];
            else
                result = $signed(a) >>> b[5:0];
            overflow = 0; 
        end
        4'b0111 : begin 
            if (wArith)
                result = a << b[4:0];
            else
                result = a << b[5:0];
            overflow = 0; 
        end
        default begin 
            result = b; 
            overflow = 0; 
        end
    endcase

    assign zero = ~(|{result[N-1:0]});
    assign sign = result[N-1];
endmodule