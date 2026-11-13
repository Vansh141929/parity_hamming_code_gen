
`timescale 1ns / 1ps

module tb_hamming_decoder;

    reg  [6:0] rx_code;

    wire [2:0] syndrome;
    wire [6:0] corrected_code;
    wire [3:0] data_out;
    wire error_detected;

    integer i;

    // Design Under Test (DUT)
    hamming_decoder dut (
        .rx_code(rx_code),
        .syndrome(syndrome),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .error_detected(error_detected)
    );

    initial begin

        // Test 1: No error
        rx_code = 7'b1100110;
        #10;
        $display("NO ERROR: RX=%b SYNDROME=%b DETECTED=%b CORRECTED=%b DATA=%b",
                 rx_code, syndrome, error_detected,
                 corrected_code, data_out);

        // Tests 2-8: Flip each bit position individually
        for (i = 0; i < 7; i = i + 1) begin
            rx_code = 7'b1100110 ^ (7'b0000001 << i);
            #10;
            $display("ERROR AT POSITION %0d: RX=%b SYNDROME=%b DETECTED=%b CORRECTED=%b DATA=%b",
                     i + 1, rx_code, syndrome,
                     error_detected, corrected_code, data_out);
        end

        $finish;

    end

endmodule
