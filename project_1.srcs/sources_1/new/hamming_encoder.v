
module hamming_encoder (
    input  wire [3:0] data_in,
    output reg  [6:0] codeword
);

    always @(*) begin

        // Place the four data bits
        // Positions: 3, 5, 6, 7
        codeword[2] = data_in[3];  // D1
        codeword[4] = data_in[2];  // D2
        codeword[5] = data_in[1];  // D3
        codeword[6] = data_in[0];  // D4

        // Calculate the even-parity bits
        codeword[0] =
            codeword[2] ^ codeword[4] ^ codeword[6]; // P1

        codeword[1] =
            codeword[2] ^ codeword[5] ^ codeword[6]; // P2

        codeword[3] =
            codeword[4] ^ codeword[5] ^ codeword[6]; // P4

    end

endmodule
