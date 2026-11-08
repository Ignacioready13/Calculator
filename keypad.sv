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

    output logic [3:0] digitOut = 0, //stores up to value 15
    //0-9: digits
    //10: plus
    //11: minus
    //12: times
    //13: divide

    //14: CLEAR
    //15: DEAD

    output logic [2:0] keyType = 0
    //0: EMPTY/ dead
    //1: digit
    //2: operator
    //3: equals key
    //4: clear key (eventually)
    //these all get sent to the controller.


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

    //both digitOut and keyType pulse for one clock when set, then go back to 'dead' values
    //one gets sent to controller, one gets sent to memory

    always_ff@(posedge CLK) begin
        keyType <= 3'd0; //immediately set to 'dead' value.
        digitOut <= 4'd15; //dead value
        //last assignment wins. so if we need to overwrite these this frame, it'll allow that.

        if (clkCounter == 32767) begin
            //it'll wrap automatically next time. but lets increment the row.
            rowWeAreChecking <= rowWeAreChecking + 1;
            //if i updated rowSet itself here it wouldnt use the new rowWeAreChecking (because non-blocking)
            
            //The DEFAULTS are the dead values. Instantly overwritten for 1 clock 
            //if we haven't pressed anything for awhile, then quickly set back.
            
            //also each clock edge: update digitOut based on row and column.
            case ({rowWeAreChecking, columnGet, (noPressCounter>11)}) //rowWeAreChecking has not been updated yet (non-blocking). 
                //0 throught 9 digit presses

                //only register a NEW KEYPRESS if we haven't pressed any key for awhile
                {2'd0, 4'b1000, 1'b1}: begin //also check: only set digitOut IF WE HAVENT pressed for 12 row-checks.
                    digitOut <= 4'd1; //if concatenation of row and column reads '00', that means they pressed 1
                    keyType <= 1'b1;
                    
                end
                {2'd0, 4'b0100, 1'b1}: begin
                    digitOut <= 4'd2;
                    keyType <= 1'b1;
                    
                end
                {2'd0, 4'b0010, 1'b1}: begin
                    digitOut <= 4'd3;
                    keyType <= 1'b1;
                    
                end
                {2'd1, 4'b1000,1'b1}: begin
                    digitOut <= 4'd4;
                    keyType <= 1'b1;
                    
                end
                {2'd1, 4'b0100,1'b1}: begin
                    digitOut <= 4'd5;
                    keyType <= 1'b1;
                    
                end
                {2'd1, 4'b0010, 1'b1}: begin
                    digitOut <= 4'd6;
                    keyType <= 1'b1;
                    
                end
                {2'd2, 4'b1000,1'b1}: begin
                    digitOut <= 4'd7;
                    keyType <= 1'b1;
                    
                end
                {2'd2, 4'b0100, 1'b1}: begin
                    digitOut <= 4'd8;
                    keyType <= 1'b1;
                    
                end
                {2'd2, 4'b0010, 1'b1}: begin
                    digitOut <= 4'd9;
                    keyType <= 1'b1;
                    
                end
                {2'd3, 4'b0100, 1'b1}: begin
                    //zero key
                    digitOut <= 0;
                    keyType <= 1'b1;
                    
                end
                
                //OPERATORS: all are in col 3
                {2'd0, 4'b0001, 1'b1}: begin
                    digitOut <= 4'd10; //plus
                    keyType <= 3'd2;
                    
                end
                {2'd1, 4'b0001, 1'b1}: begin
                    digitOut <= 4'd11; //minus
                    keyType <= 3'd2;
                    
                end
                {2'd2, 4'b0001, 1'b1}: begin
                    digitOut <= 4'd12; //times
                    keyType <= 3'd2;
                    
                end
                {2'd3, 4'b0001, 1'b1}: begin
                    digitOut <= 4'd13; //divide
                    keyType <= 3'd2;
                end

                //equals key is the pound key
                {2'd3, 4'b0010, 1'b1}: begin
                    digitOut <= 4'd13; //doesn't matter.
                    keyType <= 3'd3;
                end

                //clear key is the star key
                {2'd3, 4'b1000, 1'b1}: begin
                    digitOut <= 4'd14; //Sent to MEMORY, forces it to clear
                    keyType <= 3'd4; //sent to CONTROLLER
                end
                
            endcase

            
            if (columnGet == 4'b0000) begin
                //if NO COLUMNS ARE ON we may increment the counter.
                //keep it at 15 if it's already full. so it doesnt wrap and disable typing again.
                if (noPressCounter != 4'd15) begin
                    noPressCounter <= noPressCounter + 1;
                end
                
                
            end else begin
                //if for any reason a column is high, regardless of what it did in the case statement,
                //we must reset the noPressCounter.
                noPressCounter <= 0;
            end
            
        end
        
        clkCounter <= clkCounter + 1;
    end

endmodule




