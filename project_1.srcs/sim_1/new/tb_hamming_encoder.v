
`timescale 1ns / 1ps

module tb_hamming_encoder;

    reg  [3:0] data_in;
    wire [6:0] codeword;

    // Design Under Test (DUT)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword(codeword)
    );

    initial begin
        // Test 1
        data_in = 4'b1011;
        #10;
        $display("Input = %b | Codeword = %b",
                 data_in, codeword);

        // Test 2
        data_in = 4'b0000;
        #10;
        $display("Input = %b | Codeword = %b",
                 data_in, codeword);

        // Test 3
        data_in = 4'b1111;
        #10;
        $display("Input = %b | Codeword = %b",
                 data_in, codeword);

        // Test 4
        data_in = 4'b0101;
        #10;
        $display("Input = %b | Codeword = %b",
                 data_in, codeword);

        $finish;
    end

endmodule
