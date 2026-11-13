
`timescale 1ns / 1ps

module tb_parity_hamming_top;

    reg  [3:0] data_in;
    reg        inject_error;
    reg  [2:0] error_position;

    wire [6:0] encoded_code;
    wire [6:0] received_code;
    wire [2:0] syndrome;
    wire [6:0] corrected_code;
    wire [3:0] data_out;
    wire       error_detected;

    // Complete system under test
    parity_hamming_top dut (
        .data_in(data_in),
        .inject_error(inject_error),
        .error_position(error_position),
        .encoded_code(encoded_code),
        .received_code(received_code),
        .syndrome(syndrome),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .error_detected(error_detected)
    );

    initial begin

        // Test 1: No error
        data_in = 4'b1011;
        inject_error = 1'b0;
        error_position = 3'd3;
        #10;

        $display("NO ERROR: DATA=%b ENCODED=%b RECEIVED=%b SYNDROME=%b DETECTED=%b CORRECTED=%b RECOVERED=%b",
                 data_in, encoded_code, received_code,
                 syndrome, error_detected, corrected_code, data_out);

        // Test 2: Inject an error at Hamming position 3
        inject_error = 1'b1;
        error_position = 3'd3;
        #10;

        $display("ERROR AT POSITION 3: DATA=%b ENCODED=%b RECEIVED=%b SYNDROME=%b DETECTED=%b CORRECTED=%b RECOVERED=%b",
                 data_in, encoded_code, received_code,
                 syndrome, error_detected, corrected_code, data_out);

        // Test 3: Inject an error at Hamming position 7
        error_position = 3'd7;
        #10;

        $display("ERROR AT POSITION 7: DATA=%b ENCODED=%b RECEIVED=%b SYNDROME=%b DETECTED=%b CORRECTED=%b RECOVERED=%b",
                 data_in, encoded_code, received_code,
                 syndrome, error_detected, corrected_code, data_out);

        // Test 4: Disable error injection
        inject_error = 1'b0;
        #10;

        $display("ERROR DISABLED: DATA=%b ENCODED=%b RECEIVED=%b SYNDROME=%b DETECTED=%b CORRECTED=%b RECOVERED=%b",
                 data_in, encoded_code, received_code,
                 syndrome, error_detected, corrected_code, data_out);

        $finish;
    end

endmodule

