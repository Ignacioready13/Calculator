`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 09:42:53 PM
// Design Name: 
// Module Name: calculator
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


module calculator #(
    parameter int WIDTH = 11	// So we can change the width easily
)(
    //inputs are coming from the testbench
    // input logic [3:0] digitIn, 
    // input logic [1:0] whereToStore,

    input logic [0:0] CLK,
    

    //inputs from the constraints file

    output logic [3:0] D0_AN,
    output logic [7:0] D0_SEG,

    output logic [3:0] rowSet, //connected to hardware via constraints
    input logic [3:0] columnGet
);

    //the 'middle connector wires'
    logic signed [WIDTH-1:0] a, b;
    logic [1:0] operator;
    logic [WIDTH-1:0] resultIntoMemory;
    logic [WIDTH-1:0] resultFromMemory;

    logic [2:0] keyType; //between controller and keypad

    logic [WIDTH-1:0] digit_from_keypad_to_memory;

    logic [1:0] whereToStore;

    

    ALU #(.WIDTH(WIDTH)) alu_instance (
        .a(a),
        .b(b),
        .operator(operator),
        .y(resultIntoMemory)
    );
    Memory #(.WIDTH(WIDTH)) memory_instance (
        .CLK(CLK),
        .resultIntoMemory(resultIntoMemory),
        .resultFromMemory(resultFromMemory),
        .digitIn(digit_from_keypad_to_memory),
        .whereToStore(whereToStore), //output from controller into here
        .a(a),
        .b(b),
        .op(operator)
    );
    keypad #(.WIDTH(WIDTH)) keypad_instance (
        .CLK(CLK),
        .digitOut(digit_from_keypad_to_memory), //connect .innerVar(outerVar)
        .rowSet(rowSet),
        .columnGet(columnGet),
        .keyType(keyType)
    );

    controller #(.WIDTH(WIDTH)) controller_instance (
        .CLK(CLK),
        .whereToStore(whereToStore),
        .keyType(keyType)

   
    );

    OutputBlock #(.WIDTH(WIDTH)) display_instance (
        .CLK(CLK),
        
        .D0_AN(D0_AN),
        .D0_SEG(D0_SEG)
    ); //pass in width parameter so we can use it




endmodule
