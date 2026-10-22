
`timescale 1ns/1ps

// ============================================================
// CS 4341 - Digital Logic Project Part 2
// Seven-Segment Display Using a 4-to-16 Decoder
// Cohort: NATS
//
// Module 1: Testbench
// Module 2: 4-to-16 Decoder
// Module 3: Breadboard
// Module 4: Seven-Segment Display
//
// Main: Display digits 0 through 9
// Bonus: Display hexadecimal values A through F
// ============================================================


// ============================================================
// STEP 1: TESTBENCH MODULE
// ============================================================
// Generates input values for the breadboard.
// Each value is held for 60 simulation time units.
// The simulation ends after an additional 10 units.
// ============================================================

module testbench;

    // STEP 1A: Declare the loop variable
    integer i;

    // STEP 1B: Instantiate the breadboard
    // The lower four bits represent values 0 through 15
    breadboard b1(i[3:0]);

    // STEP 1C: Generate the input values
    initial begin

        // Loop through values 0 to 14
        for (i = 0; i < 15; i = i + 1) begin
            #60;
        end

        // Hold value 15 for the bonus
        // Prevent the input from wrapping back to 0
        #60;

        // STEP 1D: End the simulation
        #10;
        $finish;

    end

endmodule


// ============================================================
// STEP 2: 4-TO-16 DECODER MODULE
// ============================================================
// Converts a 4-bit binary input into a 16-bit one-hot output.
// Exactly one output bit is HIGH for each input value.
//
// This module uses structural Verilog with NOT and AND gates.
// ============================================================

module decoder4to16(
    input [3:0] number,
    output [15:0] onehot
);

    // STEP 2A: Declare inverted input wires
    wire [3:0] not_num;

    // STEP 2B: NOT gates for each input bit
    not (not_num[0], number[0]);
    not (not_num[1], number[1]);
    not (not_num[2], number[2]);
    not (not_num[3], number[3]);

    // STEP 2C: AND gates for all 16 outputs
    // Each output corresponds to one binary input value

    // Inputs 0000 - 0011
    and (onehot[0], not_num[3], not_num[2],
                     not_num[1], not_num[0]);

    and (onehot[1], not_num[3], not_num[2],
                     not_num[1], number[0]);

    and (onehot[2], not_num[3], not_num[2],
                     number[1], not_num[0]);

    and (onehot[3], not_num[3], not_num[2],
                     number[1], number[0]);

    // Inputs 0100 - 0111
    and (onehot[4], not_num[3], number[2],
                     not_num[1], not_num[0]);

    and (onehot[5], not_num[3], number[2],
                     not_num[1], number[0]);

    and (onehot[6], not_num[3], number[2],
                     number[1], not_num[0]);

    and (onehot[7], not_num[3], number[2],
                     number[1], number[0]);

    // Inputs 1000 - 1011
    and (onehot[8], number[3], not_num[2],
                     not_num[1], not_num[0]);

    and (onehot[9], number[3], not_num[2],
                     not_num[1], number[0]);

    and (onehot[10], number[3], not_num[2],
                      number[1], not_num[0]);

    and (onehot[11], number[3], not_num[2],
                      number[1], number[0]);

    // Inputs 1100 - 1111
    and (onehot[12], number[3], number[2],
                      not_num[1], not_num[0]);

    and (onehot[13], number[3], number[2],
                      not_num[1], number[0]);

    and (onehot[14], number[3], number[2],
                      number[1], not_num[0]);

    and (onehot[15], number[3], number[2],
                      number[1], number[0]);

endmodule


// ============================================================
// STEP 3: BREADBOARD MODULE
// ============================================================
// Connects the decoder to the seven-segment display.
//
// The decoder produces a 16-bit one-hot number.
// OR gates determine which display segments turn ON.
//
// Segment order: a, b, c, d, e, f, g
// ============================================================

module breadboard(
    input [3:0] number
);

    // STEP 3A: Declare local wires

    // 16-bit one-hot decoder output
    wire [15:0] onehot;

    // Seven individual segment control wires
    wire a, b, c, d, e, f, g;

    // STEP 3B: Instantiate the 4-to-16 decoder
    decoder4to16 decoder1(number, onehot);

    // STEP 3C: Implement the seven OR-gate equations

    // Segment A: Top horizontal segment
    or (a, onehot[0], onehot[2], onehot[3],
           onehot[5], onehot[6], onehot[7],
           onehot[8], onehot[9], onehot[10],
           onehot[14], onehot[15]);

    // Segment B: Upper-right vertical segment
    or (b, onehot[0], onehot[1], onehot[2],
           onehot[3], onehot[4], onehot[7],
           onehot[8], onehot[9], onehot[10],
           onehot[13]);

    // Segment C: Lower-right vertical segment
    or (c, onehot[0], onehot[1], onehot[3],
           onehot[4], onehot[5], onehot[6],
           onehot[7], onehot[8], onehot[9],
           onehot[10], onehot[11], onehot[13]);

    // Segment D: Bottom horizontal segment
    or (d, onehot[0], onehot[2], onehot[3],
           onehot[5], onehot[6], onehot[8],
           onehot[9], onehot[11], onehot[12],
           onehot[13], onehot[14]);

    // Segment E: Lower-left vertical segment
    or (e, onehot[0], onehot[2], onehot[6],
           onehot[8], onehot[10], onehot[11],
           onehot[12], onehot[13], onehot[14],
           onehot[15]);

    // Segment F: Upper-left vertical segment
    or (f, onehot[0], onehot[4], onehot[5],
           onehot[6], onehot[8], onehot[9],
           onehot[10], onehot[11], onehot[14],
           onehot[15]);

    // Segment G: Middle horizontal segment
    or (g, onehot[2], onehot[3], onehot[4],
           onehot[5], onehot[6], onehot[8],
           onehot[9], onehot[10], onehot[11],
           onehot[12], onehot[13], onehot[14],
           onehot[15]);

    // STEP 3D: Instantiate the seven-segment display
    sevensegment display1(a, b, c, d, e, f, g);

    // STEP 3E: Print the breadboard information
    always @(number) begin

        // Allow decoder and segment signals to settle
        #1;

        // Display the decimal input
        $display("In Breadboard, decimal number is : %0d",
                 number);

        // Display the 4-bit binary input
        $display("In Breadboard, binary number is : %04b",
                 number);

        // Display the 16-bit one-hot output
        $display("In Breadboard, one hot number is : %016b",
                 onehot);

        // Display the seven segment control bits
        $display("In Breadboard, the segments are : [%b%b%b%b%b%b%b]",
                 a, b, c, d, e, f, g);

    end

endmodule


// ============================================================
// STEP 4: SEVEN-SEGMENT DISPLAY MODULE
// ============================================================
// Receives seven one-bit segment control inputs.
//
// A value of 1 turns a segment ON.
// A value of 0 turns a segment OFF.
//
// Uses conditional statements to create the display
// using # symbols.
// ============================================================

module sevensegment(
    input a, b, c, d, e, f, g
);

    // STEP 4A: Detect changes in the segment inputs
    always @(a or b or c or d or e or f or g) begin

        // Allow breadboard information to print first
        #2;

        // STEP 4B: Display the seven control bits
        $display("In SevenSegment, the segments are : [%b%b%b%b%b%b%b]",
                 a, b, c, d, e, f, g);

        // STEP 4C: Display the top horizontal segment
        if (a)
            $display("######");
        else
            $display("      ");

        // STEP 4D: Display upper vertical segments
        // Segment F is left; Segment B is right
        repeat (3) begin

            if (f && b)
                $display("##  ##");
            else if (f)
                $display("##    ");
            else if (b)
                $display("    ##");
            else
                $display("      ");

        end

        // STEP 4E: Display the middle horizontal segment
        if (g)
            $display("######");
        else
            $display("      ");

        // STEP 4F: Display lower vertical segments
        // Segment E is left; Segment C is right
        repeat (3) begin

            if (e && c)
                $display("##  ##");
            else if (e)
                $display("##    ");
            else if (c)
                $display("    ##");
            else
                $display("      ");

        end

        // STEP 4G: Display the bottom horizontal segment
        if (d)
            $display("######");
        else
            $display("      ");

        // Separate consecutive displays
        $display("");

    end

endmodule
