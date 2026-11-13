
module hamming_decoder (
    input  wire [6:0] rx_code,
    output reg  [2:0] syndrome,
    output reg  [6:0] corrected_code,
    output reg  [3:0] data_out,
    output reg        error_detected
);

    always @(*) begin

        // Calculate syndrome using even-parity checks
        // S1 checks Hamming positions 1, 3, 5, 7
        syndrome[0] =
            rx_code[0] ^ rx_code[2] ^
            rx_code[4] ^ rx_code[6];

        // S2 checks Hamming positions 2, 3, 6, 7
        syndrome[1] =
            rx_code[1] ^ rx_code[2] ^
            rx_code[5] ^ rx_code[6];

        // S4 checks Hamming positions 4, 5, 6, 7
        syndrome[2] =
            rx_code[3] ^ rx_code[4] ^
            rx_code[5] ^ rx_code[6];

        // A nonzero syndrome indicates a detected error
        error_detected = |syndrome;

        // Start with the received codeword
        corrected_code = rx_code;

        // Correct the bit identified by the syndrome
        if (syndrome != 3'b000)
            corrected_code[syndrome - 1'b1] =
                ~rx_code[syndrome - 1'b1];

        // Extract data from positions 3, 5, 6, 7
        data_out = {
            corrected_code[2],
            corrected_code[4],
            corrected_code[5],
            corrected_code[6]
        };

    end

endmodule
