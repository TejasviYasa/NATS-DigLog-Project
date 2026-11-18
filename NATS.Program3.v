
`timescale 1ns/1ps

//=======================================
// D Flip-Flop Module
//=======================================
module DFF(clk, in, out);
    parameter n = 1; //width
    input clk;
    input [n-1:0] in;
    output [n-1:0] out;
    reg [n-1:0] out;

    always @(posedge clk)
        out = in;
endmodule


//=======================================
// Breadboard Module
//=======================================
module Breadboard(clk, reset, T1, T0,
                  CS1, CS0, Out2, Out1, Out0);

    input clk, reset, T1, T0;
    output CS1, CS0;
    output Out2, Out1, Out0;

    reg NS1, NS0;

    // Next state equations
    always @(*) begin
        if (reset == 1'b1) begin
            NS1 = 1'b0;
            NS0 = 1'b0;
        end
        else begin
            // NS1 uses XOR
            NS1 = CS1 ^ T1 ^ (CS0 & T0);

            // NS0 uses AND, OR, NOT
            NS0 = (~CS0 & T0) | (CS0 & ~T0);
        end
    end

    // Two D Flip-Flops
    DFF FF1(clk, NS1, CS1);
    DFF FF0(clk, NS0, CS0);

    // Output equations
    assign Out2 = (~CS1) & CS0;
    assign Out1 = CS1 & (~CS0);
    assign Out0 = CS1 & CS0;

endmodule


//=======================================
// Test Bench Module
//=======================================
module TestBench;

    reg clk, reset;
    reg T1, T0;

    wire CS1, CS0;
    wire Out2, Out1, Out0;

    integer file;
    integer i;

    reg [1:0] old_state;
    reg [2:0] old_output;

    // Instantiate Breadboard
    Breadboard circuit(
        clk, reset, T1, T0,
        CS1, CS0, Out2, Out1, Out0
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset state machine to 00
    task reset_state;
        begin
            @(negedge clk);
            reset = 1;
            T1 = 0;
            T0 = 0;

            @(posedge clk);
            #1;
            reset = 0;
        end
    endtask

    // Perform a transition and display result
    task transition;
        input [1:0] trigger;
        begin
            @(negedge clk);

            T1 = trigger[1];
            T0 = trigger[0];

            #1;
            old_state = {CS1, CS0};
            old_output = {Out2, Out1, Out0};

            @(posedge clk);
            #1;

            $display("%b==%b/%b==>%b",
                old_state, trigger,
                old_output, {CS1, CS0});

            $fdisplay(file, "%b==%b/%b==>%b",
                old_state, trigger,
                old_output, {CS1, CS0});
        end
    endtask

    // Display headings in both outputs
    task heading;
        input [8*80-1:0] message;
        begin
            $display("%0s", message);
            $fdisplay(file, "%0s", message);
        end
    endtask

    // Main testing sequence
    initial begin
        reset = 0;
        T1 = 0;
        T0 = 0;

        file = $fopen("Cohort.Output3.txt", "w");

        if (file == 0) begin
            $display("Error opening output file");
            $finish;
        end

        //===============================
        // Phase 1: Test all 16 links
        //===============================
        heading("PHASE 1 TESTING TRANSITIONS");

        for (i = 0; i < 16; i = i + 1) begin

            if (i % 4 == 0) begin
                heading("");
                case (i / 4)
                    0: heading("Testing from state 00");
                    1: heading("Testing from state 01");
                    2: heading("Testing from state 10");
                    3: heading("Testing from state 11");
                endcase
            end

            heading("");

            $display("Case %0d", i);
            $fdisplay(file, "Case %0d", i);

            reset_state();

            // Move to the required state
            if (i >= 4)
                transition(i / 4);

            // Test the desired transition
            transition(i % 4);
        end

        //===============================
        // Phase 2: Test specified path
        //===============================
        heading("");
        heading("PHASE 2 TESTING PATH");
        heading("");

        reset_state();

        transition(2'b00);
        transition(2'b01);
        transition(2'b00);
        transition(2'b01);
        transition(2'b00);
        transition(2'b01);
        transition(2'b00);
        transition(2'b01);

        $fclose(file);
        $finish;
    end

endmodule
