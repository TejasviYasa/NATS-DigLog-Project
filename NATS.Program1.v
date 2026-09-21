/*
Cohort: NATS
Language: Verilog
Simulator: Icarus Verilog 13

Software selection:
We selected Icarus Verilog because it is free, supports the Verilog
features required for this project, and can compile and run locally.
*/

module breadboard(
    input w,
    input x,
    input y,
    input z,
    output f0,
    output f1,
    output f2,
    output f3,
    output f4,
    output f5,
    output f6,
    output f7,
    output f8,
    output f9
);

    // f0 = Σm(0,1,3,7,12,15)
    assign f0 = (~w & ~x & ~y & ~z) |
            (~w & ~x & ~y & z) |
            (~w & ~x & y & z) |
            (~w & x & y & z) |
            (w & x & ~y & ~z) |
            (w & x & y & z);

    // f1 = Σm(0,1,6,7,8,10,13)
    assign f1 = (~w & ~x & ~y & ~z) |
                (~w & ~x & ~y & z) |
                (~w & x & y & ~z) |
                (~w & x & y & z) |
                (w & ~x & ~y & ~z) |
                (w & ~x & y & ~z) |
                (w & x & ~y & z);

    // f2 = Σm(0,1,2,6,8,10,11,13,14,15)
    assign f2 = (~w & ~x & ~y & ~z) |
                (~w & ~x & ~y & z) |
                (~w & ~x & y & ~z) |
                (~w & x & y & ~z) |
                (w & ~x & ~y & ~z) |
                (w & ~x & y & ~z) |
                (w & ~x & y & z) |
                (w & x & ~y & z) |
                (w & x & y & ~z) |
                (w & x & y & z);

    // f3 = Σm(0,1,7,10,15)
    assign f3 = (~w & ~x & ~y & ~z) |
                (~w & ~x & ~y & z) |
                (~w & x & y & z) |
                (w & ~x & y & ~z) |
                (w & x & y & z);

    // f4 = Σm(0,2,4,5,7,9,10,12,13,14)
    assign f4 = (~w & ~x & ~y & ~z) |
                (~w & ~x & y & ~z) |
                (~w & x & ~y & ~z) |
                (~w & x & ~y & z) |
                (~w & x & y & z) |
                (w & ~x & ~y & z) |
                (w & ~x & y & ~z) |
                (w & x & ~y & ~z) |
                (w & x & ~y & z) |
                (w & x & y & ~z);

    // f5 = Σm(0,3,4,5,6,7,10,11,12,13,15)
    assign f5 = (~w & ~x & ~y & ~z) |
                (~w & ~x & y & z) |
                (~w & x & ~y & ~z) |
                (~w & x & ~y & z) |
                (~w & x & y & ~z) |
                (~w & x & y & z) |
                (w & ~x & y & ~z) |
                (w & ~x & y & z) |
                (w & x & ~y & ~z) |
                (w & x & ~y & z) |
                (w & x & y & z);

    // f6 = Σm(0,3,5,6,9,10,12,13,14)
    assign f6 = (~w & ~x & ~y & ~z) |
                (~w & ~x & y & z) |
                (~w & x & ~y & z) |
                (~w & x & y & ~z) |
                (w & ~x & ~y & z) |
                (w & ~x & y & ~z) |
                (w & x & ~y & ~z) |
                (w & x & ~y & z) |
                (w & x & y & ~z);

  
    // f7 = Σm(1,5,10,14,15)
    assign f7 = (~w & ~x & ~y & z) |
            (~w & x & ~y & z) |
            (w & ~x & y & ~z) |
            (w & x & y & ~z) |
            (w & x & y & z);

    // f8 = Σm(1,2,4,9,10,11,12,13,14)
    assign f8 = (~w & ~x & ~y & z) |
                (~w & ~x & y & ~z) |
                (~w & x & ~y & ~z) |
                (w & ~x & ~y & z) |
                (w & ~x & y & ~z) |
                (w & ~x & y & z) |
                (w & x & ~y & ~z) |
                (w & x & ~y & z) |
                (w & x & y & ~z);

    // f9 = Σm(1,2,5,6,11,13,14,15)
    assign f9 = (~w & ~x & ~y & z) |
            (~w & ~x & y & ~z) |
            (~w & x & ~y & z) |
            (~w & x & y & ~z) |
            (w & ~x & y & z) |
            (w & x & ~y & z) |
            (w & x & y & ~z) |
            (w & x & y & z);

endmodule


module testbench;

    reg w, x, y, z;
    wire f0, f1, f2, f3, f4, f5, f6, f7, f8, f9;

    // Connect testbench to breadboard
    breadboard b1(
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .f0(f0),
        .f1(f1),
        .f2(f2),
        .f3(f3),
        .f4(f4),
        .f5(f5),
        .f6(f6),
        .f7(f7),
        .f8(f8),
        .f9(f9)
    );

    integer i;

    // Stimulus
    initial begin

        $display("w x y z | f0 f1 f2 f3 f4 f5 f6 f7 f8 f9");
        $display("--------------------------------------------");

        for (i = 0; i < 16; i = i + 1) begin

            {w,x,y,z} = i;

            #10;

            $display("%b %b %b %b |  %b  %b  %b  %b  %b  %b  %b  %b  %b  %b",
                     w, x, y, z,
                     f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);

        end

        $finish;

    end

endmodule