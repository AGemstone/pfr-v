module exceptDecode(input logic[15:0] signal,
                    input logic[2:0] breakSrc,
                    output logic [5:0] code);

    always_comb
        //instr address breakpoint
        if(signal[3] & breakSrc[0])
            code = 'h3;
        // instr access fault
        else if(signal[1])
            code = 'h1;
        // illegal instr
        else if(signal[2])
            code = 'h2;
        // instr address misalign
        else if(signal[0])
            code = 'h0;
        // U ecall
        else if(signal[8])
            code = 'h8;
        // S ecall
        else if(signal[9])
            code = 'h9;
        // M ecall
        else if(signal[11])
            code = 'hb;
        // ebreak
        else if(signal[3] & breakSrc[2])
            code = 'h3;
        // memory breakpoint aka watchpoint
        else if(signal[3] & breakSrc[1])
            code = 'h3;
        // load address misalign
        else if(signal[4])
            code = 'h4;
        // store address misalign
        else if(signal[6])
            code = 'h6;
        // load access fault
        else if(signal[5])
            code = 'h5;
        // store access fault
        else if(signal[7])
            code = 'h7;
        // if we reach this point either no exception or something went wrong
        else 
            code = {5{1'b1}};

endmodule