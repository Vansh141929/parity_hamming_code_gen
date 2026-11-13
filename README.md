# Parity and Hamming Code Generator

A Verilog HDL project that demonstrates parity generation/checking and a combinational Hamming (7,4) encoder/decoder. The integrated top-level design can inject a single-bit error into an encoded word and exposes the received word, syndrome, corrected word, recovered data, and error flags for simulation.

## Objectives

- Generate and check even or odd parity for a 4-bit data input.
- Encode 4-bit data into a 7-bit Hamming codeword.
- Detect and correct a single-bit error using the Hamming syndrome.
- Simulate the individual modules and the integrated design in Vivado.

## Tools and HDL

- **AMD/Xilinx Vivado 2025.2** (project and simulator)
- **Verilog HDL**
- Vivado project: [`project_1.xpr`](project_1.xpr)
- The project file targets the **`xc7a12ticsg325-1L`** part; change the target in Vivado if your device differs.

## Design overview

### Parity generator and checker

[`parity_generator_checker`](project_1.srcs/sources_1/new/parity_generator_checker.v) takes 4-bit `data_in`, a parity mode `odd_even`, and a 5-bit `received_code`.

- `odd_even = 0`: generate an even-parity bit with XOR reduction (`^data_in`). The checker asserts `error_detected` when the received five-bit XOR reduction is 1.
- `odd_even = 1`: generate an odd-parity bit with the inverse XOR reduction (`~^data_in`). The checker asserts `error_detected` when the received five-bit XOR reduction is 0.
- `data_out` returns `received_code[3:0]`.

The top-level design currently instantiates this module in even-parity mode.

### Hamming (7,4) encoder

[`hamming_encoder`](project_1.srcs/sources_1/new/hamming_encoder.v) places the four input bits in Hamming positions 3, 5, 6, and 7. The parity bits occupy positions 1, 2, and 4, using even parity:

| Hamming position | Codeword bit | Role |
| --- | --- | --- |
| 1 | `codeword[0]` | P1 |
| 2 | `codeword[1]` | P2 |
| 3 | `codeword[2]` | D1 = `data_in[3]` |
| 4 | `codeword[3]` | P4 |
| 5 | `codeword[4]` | D2 = `data_in[2]` |
| 6 | `codeword[5]` | D3 = `data_in[1]` |
| 7 | `codeword[6]` | D4 = `data_in[0]` |

### Hamming (7,4) decoder

[`hamming_decoder`](project_1.srcs/sources_1/new/hamming_decoder.v) computes three even-parity checks to form the syndrome `{S4, S2, S1}`. A zero syndrome indicates no error; a nonzero syndrome identifies the 1-based Hamming position to flip. The decoder then extracts the data bits from positions 3, 5, 6, and 7.

This is a **single-error-correcting** Hamming (7,4) decoder. It is not designed to reliably detect or correct multiple simultaneous bit errors.

### Integrated top level and error injection

[`parity_hamming_top`](project_1.srcs/sources_1/new/parity_hamming_top.v) connects the encoder, decoder, and parity checker. With `inject_error` high and `error_position` set from 1 through 7, the top-level module flips the corresponding encoded bit. The `error_position` input uses 1-based Hamming positions; values outside 1–7 do not inject an error.

## Simulation

The project includes testbenches in [`project_1.srcs/sim_1/new`](project_1.srcs/sim_1/new):

- `tb_parity_generator_checker.v`
- `tb_hamming_encoder.v`
- `tb_hamming_decoder.v`
- `tb_parity_hamming_top.v`

The top-level testbench uses input data `1011` and runs four scenarios: no error, an injected error at position 3, an injected error at position 7, and error injection disabled. It prints the encoded/received codewords, syndrome, detection status, corrected codeword, and recovered data. The testbench uses `$display` output; it does not contain pass/fail assertions.

### Run in Vivado

1. Open Vivado 2025.2 and open `project_1.xpr` (**File → Project → Open**).
2. In **Sources**, expand **Simulation Sources** and select the testbench you want to run. For the end-to-end scenarios, select `tb_parity_hamming_top` as the simulation top.
3. Choose **Run Simulation → Run Behavioral Simulation**.
4. In the Tcl console, run `run all` if the simulation does not run to completion automatically. Review the transcript for the testbench `$display` lines and inspect signals in the waveform window.
5. Repeat with the other testbench as the simulation top to explore an individual module.

To reproduce the integrated test from the Tcl console after opening the project:

```tcl
set_property top tb_parity_hamming_top [get_filesets sim_1]
launch_simulation
run all
```

### Waveform screenshots

The repository currently contains the Vivado project and testbenches, but no exported waveform screenshot files. To add screenshots, run the behavioral simulation, arrange the relevant signals in the waveform window (for example `data_in`, `encoded_code`, `received_code`, `syndrome`, `corrected_code`, `data_out`, and `error_detected`), and export or capture the waveform. Save the images under a directory such as `docs/images/` and link them here, for example:

```markdown
![Top-level Hamming simulation waveform](docs/images/top-level-waveform.png)
```

## Repository layout

```text
project_1.xpr
project_1.srcs/
├── sources_1/new/   # RTL modules
└── sim_1/new/       # Verilog testbenches
```

## License

No license is currently specified. Unless a license is added, reuse and redistribution are not granted by default.
