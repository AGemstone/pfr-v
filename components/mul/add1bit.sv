module add1bit(
    input logic a, b, cin,
    output logic y, cout
);
    logic xorab;
    assign xorab = (a ^ b); 
    assign y = xorab ^ cin;
    assign cout = (a & b) ^ (xorab & cin);
	 

endmodule