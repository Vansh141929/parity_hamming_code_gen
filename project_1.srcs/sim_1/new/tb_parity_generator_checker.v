
`timescale 1ns / 1ps

module tb_parity_generator_checker;

    reg [3:0] data_in;
    reg       odd_even;
    reg [4:0] received_code;

    wire      parity_bit;
    wire      error_detected;
    wire [3:0] data_out;

    // Connect the design under test
    parity_generator_checker dut (
        .data_in(data_in),
        .odd_even(odd_even),
        .received_code(received_code),
        .parity_bit(parity_bit),
        .error_detected(error_detected),
        .data_out(data_out)
    );

    initial begin
        // Test 1: Even parity, valid received code
        data_in = 4'b1011;
        odd_even = 1'b0;
        received_code = 5'b11011;
        #10;
        $display("TEST 1: EVEN | parity=%b error=%b data=%b",
                 parity_bit, error_detected, data_out);

        // Test 2: Even parity, one corrupted bit
        received_code = 5'b01011;
        #10;
        $display("TEST 2: EVEN ERROR | error=%b", error_detected);

        // Test 3: Odd parity, valid received code
        odd_even = 1'b1;
        received_code = 5'b01011;
        #10;
        $display("TEST 3: ODD | parity=%b error=%b data=%b",
                 parity_bit, error_detected, data_out);

        // Test 4: Odd parity, one corrupted bit
        received_code = 5'b11011;
        #10;
        $display("TEST 4: ODD ERROR | error=%b", error_detected);

        $finish;
    end

endmodule
