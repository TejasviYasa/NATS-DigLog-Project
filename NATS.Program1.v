/*
Cohort: NATS
Language: Verilog
Simulator: Icarus Verilog 13

Software selection:
We selected Icarus Verilog because it is free, supports the Verilog
features required for this project, and can compile and run locally.
*/

module breadboard(
    input  wire w, x, y, z,
    output wire f0, f1, f2, f3, f4,
                f5, f6, f7, f8, f9
);

    // The ten minimized Boolean equations will go here.

endmodule


module testbench;

    reg w, x, y, z;
    wire f0, f1, f2, f3, f4;
    wire f5, f6, f7, f8, f9;
    integer row;

    breadboard dut(
        .w(w), .x(x), .y(y), .z(z),
        .f0(f0), .f1(f1), .f2(f2), .f3(f3), .f4(f4),
        .f5(f5), .f6(f6), .f7(f7), .f8(f8), .f9(f9)
    );

    initial begin
        $display("w x y z | f0 f1 f2 f3 f4 f5 f6 f7 f8 f9");

        for (row = 0; row < 16; row = row + 1) begin
            {w, x, y, z} = row;
            #1;
            $display(
                "%b %b %b %b | %b  %b  %b  %b  %b  %b  %b  %b  %b  %b",
                w, x, y, z,
                f0, f1, f2, f3, f4, f5, f6, f7, f8, f9
            );
        end

        $finish;
    end

endmodule