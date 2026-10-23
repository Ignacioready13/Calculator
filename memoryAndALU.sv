`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 09:18:23 PM
// Design Name: 
// Module Name: memoryAndALU
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


module memoryAndALU #(
    parameter int WIDTH = 11
)(
    input  logic CLK,
    input  logic [3:0] digitIn,
    input  logic [1:0] whereToStore,
    // ...your held-key / reset ports go here...
    output logic signed [WIDTH-1:0] result   // whatever you want to watch
);

    // wires that run BETWEEN the two chips
    logic signed [WIDTH-1:0] a, b, aluOut;
    logic [1:0] op;

    Memory #(.WIDTH(WIDTH)) u_mem (
        .CLK(CLK),
        .digitIn(digitIn),
        // ...
    );

    ALU #(.WIDTH(WIDTH)) u_alu (
        .a(___),
        // ...
    );

endmodule