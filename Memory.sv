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

    //HOW TO USE THIS MEMORY BLOCK
    //1. set write to true
    //2. want to give us a digit? set digitIn to 0-9, set whereToStore to 00 or 01 (A or B)
    //3. give us an operator? set digitIn to 11 12 13 or 14. and whereToStore to 10 (meaning its an op).

    //send things in order please.

    input logic [0:0] CLK,
    input logic [3:0] digitIn,
    input logic signed [WIDTH-1:0] resultIntoMemory, //result from ALU
    input logic [1:0] whereToStore, //given by the controller.
    //input logic [0:0] write, //i dont think we need this, if digitIn only activates when we want it


    output logic [WIDTH-1:0] a = 0, b = 0,
    output logic signed [WIDTH-1:0] resultFromMemory = 0, //resultFromMemory: our output result, read by Memory
    output logic [1:0] op = 0
    );
    
    //we need for whereToStore and digitIn to be ready at the same time. 

     always_ff@(posedge CLK) begin
        if (digitIn == 4'd14) begin
            //CLEAR pulse. only happens for one clock.
            a <= 0;
            b <= 0;
            op <= 0;
            resultFromMemory <= 0;
            //result automatically updates combinationally.
            
        end else if (digitIn != 4'd15) begin //gate: if digitIn is dead value, then don't write.
            case (whereToStore)
                //whereToStore is 4 bits.
                //00 and 01 are A and B. 10 is Operator. 11 is result.
                2'b00: a <= a*10 + digitIn;   
                2'b01: b <= b*10 + digitIn;

                //store the OPERATOR. 10 = + = 00.
                2'b10: op <= digitIn - 10; 
                
                //store RESULT (coming from ALU)
                //also allow RESULT to be used in future calculations: store it in A and clear the rest
                2'b11: begin 
                    resultFromMemory <= resultIntoMemory;
                end 
                //if you tell it whereToStore = b11 then it'll grab the current result from ALU and store it.
                //doesn't care what digitIn is.

                //you'll see resultIntoMemory is always updating; its just a BS value from ALU becasue it assumes
                //addition until you give it an operator.
            endcase
        end
        
       
        

        
    end        
endmodule
