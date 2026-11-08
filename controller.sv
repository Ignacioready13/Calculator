`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 12:45:45 PM
// Design Name: 
// Module Name: controller
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


module controller#(
    parameter int WIDTH = 11	// So we can change the width easily
)(
    input logic [0:0] CLK,
    //inputs coming from keypad
    input logic [0:0] is_it_a_digit_being_typed, //should start 0
    output logic [1:0] whereToStore //tell the memory what ts is

);

    logic [1:0] state = 2'b00; //states 0-3.

    //controller never actually gets to see the number or operator that's getting passed around. we just know about it.

    //whereToStore needs to be updated soon enough so Memory sees it. memory sees it on clock.

    //We need to IMMEDIATELY update whereToStore based on is_it_a_digit_being_typed. ok if state takes a sec

    //whereToStore is a 'sticky' variable that retains its value til we overwrite it. its ok cuz memory only does a write on edge where we tell it to.

    always_comb begin
        case ({state, is_it_a_digit_being_typed})
            {2'b00, 1'b1}: begin
                //state 0 and they typed a digit.
                state = 2'b01;
                whereToStore = 2'b00; //A
            end
            {2'b01, 1'b0}: begin
                //state 1 and they typed an operator
                state = 2'b10;
                whereToStore = 2'b10; //operator
            end
            {2'b10, 1'b1}: begin
                //state 2 and they typed a digit
                //gets stuck here til you clear. which i didnt implement yet. lol.
                state = 2'b11;
                whereToStore = 2'b01; //B
            end
            
        endcase   
    end

    always_ff@(posedge CLK) begin
        
    end
    

endmodule
