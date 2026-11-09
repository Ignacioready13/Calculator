`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 09:37:51 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(
    parameter int WIDTH = 11
)(
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic [1:0] operator,
    output logic signed [WIDTH-1:0] resultIntoMemory
);

    always_comb begin
        case(operator)
            2'b00: resultIntoMemory = a + b; //add
            2'b01: resultIntoMemory = a - b; //subtract
            2'b10: resultIntoMemory = a * b; //multiply
            2'b11: begin 
                if (b == 0) begin
                    resultIntoMemory = 0; //don't divide by 0.
                end else begin
                    resultIntoMemory = a / b; //divide
                end
                
            end 
        endcase
    end

endmodule


