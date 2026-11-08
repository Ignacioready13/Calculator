`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 06:19:45 PM
// Design Name: 
// Module Name: ExampleDesign
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


module oldALU(
    input logic [10:0] a, b , //11 bits
    input logic [1:0] op,
    output logic [10:0] y );
    always_comb begin
        case(op)
            2'b00: y = a + b;
            2'b01: y = a - b;
            2'b10: y = a * b;
            2'b11: y = a / b;
            default: y=0;
        endcase
    end
    
endmodule
