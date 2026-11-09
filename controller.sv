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
    input logic [2:0] keyType, //should start 0
    //instead of passing in the entire number; makes synthesized circuit lighter

    output logic [1:0] whereToStore = 2'b00, //A slot by default.
    //00: A
    //01: B
    //10: OP
    //11: RESULT

    output logic [1:0] memorySlotToDisplay = 2'b00
    //same convention as whereToStore.
    //except we never display the operator. Can't do on a 7-segment.

);

    logic [2:0] currentState = 3'd0; 
    logic [2:0] nextState = 3'd0; //states 0-4.
    //0: waiting for first digit
    //1: waiting for operator
    //2: waiting for second digit
    //3: waiting for equals to be pressed
    //4: equals was pressed

    //controller never actually gets to see the number or operator that's getting passed around. we just know about it.

    //whereToStore needs to be updated soon enough so Memory sees it. memory sees it on clock.

    //We need to IMMEDIATELY update whereToStore based on is_it_a_digit_being_typed. ok if state takes a sec

    //whereToStore is a 'sticky' variable that retains its value til we overwrite it. its ok cuz memory only does a write on edge where we tell it to.
    //isItADigit is also sticky. It works out because we don't change states until isItADigit flip-flops.
 
    always_comb begin
        nextState = currentState; //stay like this if nothing changes. avoid a latch.
        
        case ({currentState, keyType}) //keyType is a pulse.
            {3'd0, 3'd1}: begin 
                //in state 0 and they typed a digit.
                nextState = 3'd1;
                
                
            end
            {3'd1, 3'd2}: begin
                //in state 1 and they typed an operator
                nextState = 3'd2;
                
            end
            {3'd2, 3'd1}: begin
                //in state 2 and they typed a digit: they typed the last digit. we'll show the result too.
                nextState = 3'd3; 
                
            end
            {3'd3, 3'd3}: begin
                //in state 3 and they pressed EQUALS
                nextState = 3'd4; //move to state 4
            end
            //now we stay in state 4 until clear key is pressed: if statement
            //will trigger and we'll go back to state 0.

            //all other cases: just stay in same state.
        endcase   
        if (keyType == 3'd4) begin //CLEAR KEY. I don't care what the state is, go back to first state.
            nextState = 3'd0; //back to waiting for first key press.
            whereToStore = 2'b00; //back to writing A slot.
        end

        //fix the latch on whereToStore: whereToStore is ALWAYS just based on state which is ALWAYS defined.
        case (nextState) //that way whereToStore is instantly up to date for Memory
            {3'd0}: begin //should NOT matter. no keys have been pressed yet.
                whereToStore = 2'b00; //to be safe
                memorySlotToDisplay = 2'b00; //displays 0
            end
            {3'd1}: begin
                whereToStore = 2'b00; //A
                memorySlotToDisplay = 2'b00; //display A while typing A
            end
            {3'd2}: begin
                whereToStore = 2'b10; //operator
                memorySlotToDisplay = 2'b00; //keep displaying A til they type B
            end
            {3'd3}: begin
                whereToStore = 2'b01; //B
                memorySlotToDisplay = 2'b01;
            end
            {3'd4}: begin
                whereToStore = 2'b11; //essentially just a command to tell Memory
                //to grab result from ALU and store it in result slot. It won't
                //care what digitIn is.
                memorySlotToDisplay = 2'b11; //display result.
                //once we type CLEAR we go to state 0 and start displaying A again
            end
            default: begin
                whereToStore = 2'b00; //impossible, but avoids latch
                memorySlotToDisplay = 2'b00;
            end 
        endcase

    end

    always_ff@(posedge CLK) begin
        currentState <= nextState; //actually store state in a flip flop
        //and avoid feedback loop
    end
    

endmodule
