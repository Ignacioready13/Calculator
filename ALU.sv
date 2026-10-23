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
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    input  logic [1:0] operator,
    output logic signed [WIDTH-1:0] y
);

    typedef enum logic [1:0] {
        ADD  = 2'b00,
        SUB  = 2'b01,
        MULT = 2'b10,
        DIV  = 2'b11
    } oper_t;

    always_comb //operator starts as 00, addition, so result may be BS until we get
    //the actual operator typed in. It's whatever.
        case (operator)
            ADD:  y = a + b;
            SUB:  y = a - b;
            MULT: y = a * b;
            DIV:  if (b == 0)
                      y = '0; //dont divide by 0
                  else
                      y = a / b;
            default: y = '0;
        endcase

endmodule
