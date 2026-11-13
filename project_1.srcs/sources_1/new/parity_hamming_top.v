
module parity_hamming_top (
    input  wire [3:0] data_in,

    // Error injection controls
    input  wire       inject_error,
    input  wire [2:0] error_position,

    // Encoder and error-injection outputs
    output wire [6:0] encoded_code,
    output wire [6:0] received_code,

    // Decoder outputs
    output wire [2:0] syndrome,
    output wire [6:0] corrected_code,
    output wire [3:0] data_out,
    output wire error_detected,
    output wire parity_bit,
    output wire parity_error
);

    // 1. Hamming (7,4) encoder
    hamming_encoder encoder_inst (
        .data_in(data_in),
        .codeword(encoded_code)
    );

    // 2. Inject a single-bit error when enabled
    // error_position uses Hamming positions 1 through 7
    assign received_code =
        (inject_error && error_position >= 3'd1
                      && error_position <= 3'd7)
        ? (encoded_code ^ (7'b0000001 << (error_position - 1'b1)))
        : encoded_code;

    // 3. Hamming (7,4) decoder
    hamming_decoder decoder_inst (
        .rx_code(received_code),
        .syndrome(syndrome),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .error_detected(error_detected)
    );
// Parity checker integration
    parity_generator_checker parity_inst (
    .data_in(data_in),
    .odd_even(1'b0),
    .received_code({received_code[6], received_code[3:0]}),
    .parity_bit(parity_bit),
    .error_detected(parity_error),
    .data_out()
);
endmodule
