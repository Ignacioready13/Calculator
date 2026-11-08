`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 01:49:12 PM
// Design Name: 
// Module Name: keypad
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



module keypad#(
    parameter int WIDTH = 11	// So we can change the width easily
)(

    input logic [0:0] CLK,
    output logic [3:0] rowSet, //one-hot.
    input logic [3:0] columnGet,

    output logic [3:0] digitOut = 0,

    output logic [0:0] is_it_a_digit_being_typed = 0


);
  
    logic [14:0] clkCounter = 0; //15 bits can store 32,767
    logic [3:0] noPressCounter = 0;//stores up to 15
    //once it reaches 4 we know one frame has passed with no presses anywhere. wait 2 more extra, get to 12
    
    //row logic: one-hot counter we manually increment + conversion to plain number
    logic [1:0] rowWeAreChecking = 0; //rows 0-3. just an int. 0 1 2 3
    //rowSet is output
   

    always_comb begin

        //keep rowSet always updated, always one-hot equivalent of rowWeAreChecking
   
       
        rowSet = 4'b0000; //reset it all.
        rowSet[rowWeAreChecking] = 1; //turn one row HIGH

        

    end

    
    //from the board: columnIn always updated.
    //each clock: increment (next loop's) rowWeAreChecking
    //alwaysComb makes sure rowSet instantly converts that to a clean int. no delay.
    //this clock though, use rowWeAreChecking and latest columnGet to decide digitOut which goes right to output

    //if no column is high for whatever row we are on: digitOut remains untouched.
    //if you hold down key: digitOut keeps getting set to correct button.

    //we need some sort of debounce to: hold onto last key press and keep it there til new press
    //we can't always have an activeColumn. if they press nothing we can't keep updating.

    //to prevent digit repeating:
    //get a number press, store it.
    //immediately set digitOut to 15. We only get 1 clock high with a real number.
    //to make sure we don't immediately set it back:
    //count frames with absolutely NO HIGH COLUMNS.
    //only count a new press once we're certain all the keys used to be off for awhile

    //end goal: set digitOut for ONE CLOCK then immediately set it to 15 until a NEW KEY is actually pressed.

    always_ff@(posedge CLK) begin
        if (clkCounter == 32767) begin
            //it'll wrap automatically next time. but lets increment the row.
            rowWeAreChecking <= rowWeAreChecking + 1;
            //if i updated rowSet itself here it wouldnt use the new rowWeAreChecking (because non-blocking)
            
            //also each clock edge: update digitOut based on row and column.
            casez ({rowWeAreChecking, columnGet, (noPressCounter>11)}) //rowWeAreChecking has not been updated yet (non-blocking). 
            //casez lets me use wildcards. need that for the last case where no columns pressed.
                //0 throught 9 digit presses
                {2'd0, 4'b1000, 1'b1}: begin //also check: only set digitOut IF WE HAVENT pressed for 12 row-checks.
                    noPressCounter <= 0;
                    digitOut <= 4'd1; //if concatenation of row and column reads '00', that means they pressed 1
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd0, 4'b0100, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd2;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd0, 4'b0010, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd3;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd1, 4'b1000,1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd4;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd1, 4'b0100,1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd5;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd1, 4'b0010, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd6;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd2, 4'b1000,1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd7;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd2, 4'b0100, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd8;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd2, 4'b0010, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd9;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                {2'd3, 4'b0100, 1'b1}: begin
                    //zero key
                    noPressCounter <= 0;
                    digitOut <= 0;
                    is_it_a_digit_being_typed <= 1'b1;
                end
                
                //OPERATORS: all are in col 3
                {2'd0, 4'b0001, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd10; //plus
                    is_it_a_digit_being_typed <= 1'b0;
                end
                {2'd1, 4'b0001, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd11; //minus
                    is_it_a_digit_being_typed <= 1'b0;
                end
                {2'd2, 4'b0001, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd12; //times
                    is_it_a_digit_being_typed <= 1'b0;
                end
                {2'd3, 4'b0001, 1'b1}: begin
                    noPressCounter <= 0;
                    digitOut <= 4'd13; //divide
                    is_it_a_digit_being_typed <= 1'b0;
                end

                {2'd?, 4'b0000}: begin //anytime we have no columns on
                    digitOut <= 4'd15; //blank it out immediately.
                    noPressCounter <= noPressCounter + 1;
                end
            endcase
            
        end
        clkCounter <= clkCounter + 1;
    end

endmodule




