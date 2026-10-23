`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 06:52:27 PM
// Design Name: 
// Module Name: Memory
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


module Memory#(
    parameter int WIDTH = 11	// So we can change the width easily
)(
    input logic [0:0] CLK,
    input logic [3:0] digitIn,
    input logic signed [WIDTH-1:0] resultIntoMemory, //result from ALU
    input logic [1:0] whereToStore, //given by the controller.
    input logic [0:0] write,
    output logic signed [WIDTH-1:0] a = 0, b = 0, resultFromMemory = 0,
    output logic [1:0] op = 0
    );
    
    
     always_ff@(posedge CLK) begin
        if (write == 1'b1) begin //write is allowed
            case (whereToStore)
                //whereToStore is 4 bits.
                //00 and 01 are A and B. 10 is Operator. 11 is result.
                2'b00: a <= a*10 + digitIn;   
                2'b01: b <= b*10 + digitIn;

                //store the OPERATOR. 10 = + = 00.
                2'b10: op <= digitIn - 10; 

                //store RESULT (coming from ALU)
                2'b11: resultFromMemory <= resultIntoMemory; 
                //if you tell it whereToStore = b11 then it'll grab the current result from ALU and store it.
                //doesn't care what digitIn is.

                //you'll see resultIntoMemory is always updating; its just a BS value from ALU becasue it assumes
                //addition until you give it an operator.
            endcase
        end
        

        
    end        
endmodule
