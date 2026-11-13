
module parity_generator_checker (
    input  wire [3:0] data_in,
    input  wire       odd_even,
    input  wire [4:0] received_code,

    output reg        parity_bit,
    output reg        error_detected,
    output reg  [3:0] data_out
);

    // Generate parity bit
    always @(*) begin
        if (odd_even == 1'b0)
            parity_bit = ^data_in;       // Even parity
        else
            parity_bit = ~(^data_in);    // Odd parity
    end

    // Check received code
    always @(*) begin
        if (odd_even == 1'b0)
            error_detected = ^received_code;
        else
            error_detected = ~(^received_code);

        // Extract the four data bits
        data_out = received_code[3:0];
    end

endmodule
