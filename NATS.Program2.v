`timescale 1ns/1ps

// Program 2: 4-to-16 Decoder and Seven-Segment Display
// Displays hexadecimal values 0 through F.

// Testbench
module testbench;
    integer i;
    reg [3:0] number;

    breadboard bb(number);

    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            number = i;
            #60;
        end
        #10;
        $finish;
    end
endmodule

// Breadboard
module breadboard(input [3:0] number);
    wire [15:0] onehot;
    wire a, b, c, d, e, f, g;

    decoder4to16 dec(number, onehot);
    sevenSegment seg(a, b, c, d, e, f, g);

    // Segment controls, active high
    or(a, onehot[0], onehot[2], onehot[3],
       onehot[5], onehot[6], onehot[7],
       onehot[8], onehot[9], onehot[10],
       onehot[14], onehot[15]);

    or(b, onehot[0], onehot[1], onehot[2],
       onehot[3], onehot[4], onehot[7],
       onehot[8], onehot[9], onehot[10],
       onehot[13]);

    or(c, onehot[0], onehot[1], onehot[3],
       onehot[4], onehot[5], onehot[6],
       onehot[7], onehot[8], onehot[9],
       onehot[10], onehot[11], onehot[13]);

    or(d, onehot[0], onehot[2], onehot[3],
       onehot[5], onehot[6], onehot[8],
       onehot[9], onehot[11], onehot[12],
       onehot[13], onehot[14]);

    or(e, onehot[0], onehot[2], onehot[6],
       onehot[8], onehot[10], onehot[11],
       onehot[12], onehot[13], onehot[14],
       onehot[15]);

    or(f, onehot[0], onehot[4], onehot[5],
       onehot[6], onehot[8], onehot[9],
       onehot[10], onehot[11], onehot[14],
       onehot[15]);

    or(g, onehot[2], onehot[3], onehot[4],
       onehot[5], onehot[6], onehot[8],
       onehot[9], onehot[10], onehot[11],
       onehot[12], onehot[13], onehot[14],
       onehot[15]);

    // Print once after signals settle
    always @(number) begin
        #1;
        $display("In Breadboard, decimal number is : %0d", number);
        $display("In Breadboard, binary number is : %04b", number);
        $display("In Breadboard, one hot number is : %016b", onehot);
        $display("In Breadboard, the segments are : [%b%b%b%b%b%b%b]",
                 a,b,c,d,e,f,g);
    end
endmodule

// Structural 4-to-16 Decoder
module decoder4to16(
    input [3:0] x,
    output [15:0] y
);
    wire n0, n1, n2, n3;

    not(n0, x[0]);
    not(n1, x[1]);
    not(n2, x[2]);
    not(n3, x[3]);

    and(y[0],  n3,n2,n1,n0);
    and(y[1],  n3,n2,n1,x[0]);
    and(y[2],  n3,n2,x[1],n0);
    and(y[3],  n3,n2,x[1],x[0]);
    and(y[4],  n3,x[2],n1,n0);
    and(y[5],  n3,x[2],n1,x[0]);
    and(y[6],  n3,x[2],x[1],n0);
    and(y[7],  n3,x[2],x[1],x[0]);
    and(y[8],  x[3],n2,n1,n0);
    and(y[9],  x[3],n2,n1,x[0]);
    and(y[10], x[3],n2,x[1],n0);
    and(y[11], x[3],n2,x[1],x[0]);
    and(y[12], x[3],x[2],n1,n0);
    and(y[13], x[3],x[2],n1,x[0]);
    and(y[14], x[3],x[2],x[1],n0);
    and(y[15], x[3],x[2],x[1],x[0]);
endmodule

// Seven-Segment Display
module sevenSegment(
    input a,b,c,d,e,f,g
);
    integer row;
    reg [5:0] pixels;

    always @(a or b or c or d or e or f or g) begin
        #2;
        $display("In SevenSegment, the segments are : [%b%b%b%b%b%b%b]",
                 a,b,c,d,e,f,g);

        // Each segment is represented using # symbols
        for (row = 0; row < 9; row = row + 1) begin
            pixels = 6'b000000;

            if (row == 0 && a)
                pixels = 6'b111111;
            else if (row >= 1 && row <= 3) begin
                if (f) pixels[5:4] = 2'b11;
                if (b) pixels[1:0] = 2'b11;
            end
            else if (row == 4 && g)
                pixels = 6'b111111;
            else if (row >= 5 && row <= 7) begin
                if (e) pixels[5:4] = 2'b11;
                if (c) pixels[1:0] = 2'b11;
            end
            else if (row == 8 && d)
                pixels = 6'b111111;

            // Print only # and spaces
            $display("%s%s%s%s%s%s",
                pixels[5] ? "#" : " ",
                pixels[4] ? "#" : " ",
                pixels[3] ? "#" : " ",
                pixels[2] ? "#" : " ",
                pixels[1] ? "#" : " ",
                pixels[0] ? "#" : " ");
        end
    end
endmodule