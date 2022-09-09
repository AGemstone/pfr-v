module mul #(parameter N = 64)(
    input logic[N/2-1:0] a, b,
    output logic[N-1:0] y);

    logic[N/2-1:1][N/2-1:0] carry;
    logic[N/2-1:1][N/2-1:0] rowOut;

    generate
    genvar i, j;
    for (j = 0; j < N/2 ; j = j + 1) begin : i_1
        if (j == 0)
            mulCell mc(.a(a[j]),
                       .b(b[1]),
                       .c(a[j] & b[0]),
                       .y(y[1]),
                       .cin(1'b0),
                       .cout(carry[1][0]));
        else if (j == N/2 - 1)
            mulCell mc(.a(a[j]),
                       .b(b[1]),
                       .c(carry[1][j-1]),
                       .y(rowOut[1][j]),
                       .cin(1'b0),
                       .cout(carry[1][j]));
        else
            mulCell mc(.a(a[j]),
                       .b(b[1]),
                       .c(a[j+1] & b[0]),
                       .y(rowOut[1][j]),
                       .cin(carry[1][j-1]),
                       .cout(carry[1][j]));
    end

    for (i = 2; i < N/2 ; i = i + 1) begin : _i
        for (j = 0; j < N/2 ; j = j + 1) begin : _j
            if (j == 0)
                mulCell mc(.a(a[j]),
                           .b(b[i]),
                           .c(rowOut[i-1][1]),
                           .y(y[i]),
                           .cin(1'b0),
                           .cout(carry[i][0])
                           );
            else if (j == N/2 - 1)
                mulCell mc(.a(a[j]),
                           .b(b[i]),
                           .c(carry[i-1][j]),
                           .y(rowOut[i][j]),
                           .cin(carry[i][j-1]),
                           .cout(carry[i][j])
                           );
            else
                mulCell mc(.a(a[j]),
                           .b(b[i]),
                           .c(rowOut[i-1][j+1]),
                           .y(rowOut[i][j]),
                           .cin(carry[i][j-1]),
                           .cout(carry[i][j])
                           );
        end
    end
    endgenerate

    assign y[0] = a[0] & b[0];
    assign y[N-2:N/2] = rowOut[N/2-1][N/2-1:1];
    assign y[N-1] = carry[N/2-1][N/2-1];

endmodule
