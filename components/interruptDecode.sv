module interruptDecode(input logic[15:0] signal,
                       output logic [5:0] code);

    always_comb
        // software interrupts
        // S mode
        if(signal[0])
            code = 'h1;
        // M mode
        else if(signal[1])
            code = 'h3;
        // timer interrupts
        // S mode
        else if(signal[2])
            code = 'h5;
        // M mode
        else if(signal[3])
            code = 'h7;
        // external interrupts
        // S mode
        else if(signal[4])
            code = 'h9;
        // M mode
        else if(signal[5])
            code = 'hb;
        // define custom interrupts here, code > 0xf

        // if we reach this point either no interrupt or something went wrong
        else 
            code = {5{1'b1}};

endmodule