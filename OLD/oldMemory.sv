`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 04:22:28 PM
// Design Name: 
// Module Name: oldMemory
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


module oldMemory(
    input logic [0:0] CLK,
    input logic [4:0] digitIn,
    output logic [10:0] a, b, result,
    output logic [1:0] op,
    output logic [0:0] showResult,
    int tempDigit,
    logic [1:0] tempOp,
    logic [0:0] equals,
    logic [0:0] isOnA,
    logic [0:0] didUpdateOp
    );
        
    always_comb begin
        didUpdateOp = 0;
        if(digitIn <= 4'b1001) begin //less than or equal to 9
            tempDigit = digitIn;
        end else begin
            isOnA = 1'b0;
            case(digitIn)
                
                4'b1010: begin tempOp = 2'b00; didUpdateOp = 1; end //add
                4'b1011: begin tempOp = 2'b01; didUpdateOp = 1; end //subtract
                4'b1100: begin tempOp = 2'b10; didUpdateOp = 1; end //multiply
                4'b1101: begin tempOp = 2'b11; didUpdateOp = 1; end //divide
                4'b1110: equals = 1'b1;
                
                4'b1111: tempDigit = 15;
             endcase;
         end
    end
                
     always_ff@(posedge CLK) begin
        if (!tempDigit == 15) begin
            
            //NEW digit input
            if (isOnA == 1'b1) begin     
                a <= a*10 + tempDigit;
            end
            else begin
                b <= b*10 + tempDigit;
            end
                
         end 
         else begin
            //either the user typed NOTHING or they typed a special digit
            if (didUpdateOp == 1) begin
                //user just updated operator
                op <= tempOp;
            end 
            else if (equals == 1) begin
                //user just pressed EQUALS
                showResult <= equals;
            end
        end
    end        
endmodule
