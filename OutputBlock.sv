`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 01:37:00 PM
// Design Name: 
// Module Name: OutputBlock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OutputBlock#(
    parameter int WIDTH = 11	// So we can change the width easily
)(
    input logic [WIDTH-1:0] numberIn,
    input logic [0:0] CLK
);

    //10 bit array holds 0-9
    //Each index holds A-G, plus the period, which is 8

    bit [9:0] [7:0] digitMap = '{
        9: 8'b00001001,
        8: 8'b00000001,
        7: 8'b00011111,
        6: 8'b01000001,
        5: 8'b01001001,
        4: 8'b10011001,
        3: 8'b00001101,
        2: 8'b00100101,
        1: 8'b10011111,
        0: 8'b00000011
    };
    int multiplier = 1;
        int total = 0;
        for (int i = 0; i<WIDTH; i=i+1) begin
            total = multiplier * numberIn[WIDTH - i];
            multiplier = multiplier * 2;
            
        end
    always_ff@(posedge CLK) begin
        


    end


endmodule
