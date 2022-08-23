module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);

    logic [N - 1:0] rom [0 : 63];

    // test addi/cbnz
	// localparam int prog_leng = 16;
	// assign rom[0:prog_leng-1] = '{
	//  'h8b1f03fe, 	// add	x30, xzr, xzr
	//  'h91003c0a, 	// add	x10, x0, #0xf
	//  'haa14018b, 	// orr	x11, x12, x20
	//  'h8a14018c, 	// and	x12, x12, x20
	//  'h00000000,	// nop. hazard x10
	//  'h8b0a0000, 	// add	x0, x0, x10
	//  'hcb01014a, 	// sub	x10, x10, x1
	//  'hf80003cb, 	// stur	x11, [x30]
	//  'hf80083cc, 	// stur	x12, [x30, #8]
	//  'h00000000, 	// nop. hazard x10
	//  'hb5ffff6a, 	// cbnz	x10, 10 <loop>
	//  'h00000000, 	// nop. hazard de control
	//  'h00000000, 	// nop. hazard de control
	//  'h00000000, 	// nop. hazard de control
	//  'hf80103c0, 	// stur	x0, [x30, #16]
	//  'hb400001f 	// loop <3
	// };

	// stallout aka stall at every instruction
	// localparam int prog_leng = 51;
	// assign rom[0:prog_leng-1] = '{
	// 	'h00000000,
	// 	'h00000000,
	// 	'h91002be9,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hcb09014a,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hb400004a, 
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hf800002a,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h9100cbea,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hf8000001,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h8b010002,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hf8408001,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h8b010042,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h91004000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hd100054a,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hb5ffff4a,
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hb400001f
	// };
	localparam int prog_leng = 14;
	assign rom[0:prog_leng-1] = '{
   	'hd1000484, 	// sub	x4, x4, #0x1
   	'h0, 	// add	xzr, xzr, xzr
   	'h0, 	// add	xzr, xzr, xzr
   	'h0, 	// add	xzr, xzr, xzr
  	'h91000421, 	// add	x1, x1, #0x1
  	'h0, 	// add	xzr, xzr, xzr
  	'h0, 	// add	xzr, xzr, xzr
  	'h0, 	// add	xzr, xzr, xzr
  	'hb5ffff04, 	// cbnz	x4, 0 <loop>
  	'h0, 	// add	xzr, xzr, xzr
  	'h0, 	// add	xzr, xzr, xzr
  	'h0, 	// add	xzr, xzr, xzr
  	'hf8000001, 	// stur	x1, [x0]
  	'hb400001f  	// cbz	xzr, 34 <infl>

	};

	// subitest
	// localparam int prog_leng = 8;
	// assign rom[0:prog_leng-1] = '{
	// 	'h00000000,
	// 	'h00000000,
	// 	'hd1000c42, //subi x2, x2, #3
	// 	'h00000000,
	// 	'h00000000,
	// 	'h00000000,
	// 	'hf8000102, //stur x2, [x8, #0]
	// 	'hb400001f
	// };
	// 1101 0001 00 _ 000000000011 _ 00010_ 00010

	// f8000102
	// 1111 1000 000 0 0000 0000 00 01000 00010

    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    
    assign q = rom[addr];
    
endmodule