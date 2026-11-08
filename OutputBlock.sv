`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 01:37:00 PM
// Design Name: 
// Module Name: OutputBlock
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


module OutputBlock#(
    parameter int WIDTH = 11	// So we can change the width easily
)(
    input logic [WIDTH-1:0] numberIn,
    input logic [0:0] CLK,
    output logic [3:0] D0_AN,
    output logic [7:0] D0_SEG
    
);

    logic [14:0] clkCounter = 0; //15 bits can store a bit more than 32,000.
    logic [3:0] digitPosition = 4'b1110; //4 digits. 1-4 means that respective digit is on.

    logic [3:0] digits [3:0]; //4 digits each containing 4 bits of 1-9 info
    //my convention: read left to right. so array[0] is LEFTMOST digit. or highest place.
    
    //10 bit array holds 0-9
    //Each index holds A-G, plus the period, which is 8

    bit [9:0] [7:0] digitMap = '{
        //GFEDCBA backwards order.
        9: 8'b10010000,
        8: 8'b10000000,
        7: 8'b11111000,
        6: 8'b10000010,
        5: 8'b10010010,
        4: 8'b10011001,
        3: 8'b10110000,
        2: 8'b10100100,
        1: 8'b11111001,
        0: 8'b11000000
    };
    always_comb begin
        //take the numberIn, which is binary, and convert to digits.
        digits[0] = (numberIn / 1000) % 10; //we want thousands place. 
        digits[1] = (numberIn / 100) % 10;  //div by 100 shifts decimal place 
        //left, truncates other stuff. mod 10 to get whats right next to decimal place
        digits[2] = (numberIn / 10) % 10;
        digits[3] = (numberIn) % 10; //divided by 1 so whatever
        //righmost is smallest

    end
    
    always_ff@(posedge CLK) begin
        if (clkCounter < 5000) begin
            //ALL DIGITS ARE OFF mode
            D0_AN <= 4'b1111; //active low: just turn them all off.
        end
        else begin
            //DRAWING A DIGIT
            
            
            //if we wanna draw digit 9, assign D0_SEG to 9th entry in map
            

            D0_AN <= digitPosition; //turn on the digit we want to display
            //active low

            case (digitPosition)
                    4'b1110: begin 
                        
                        D0_SEG <= digitMap[digits[3]]; //we wanna draw rightmost digit... go find what it is...get the mapping
                    end
                    4'b1101: begin 
                       
                        D0_SEG <= digitMap[digits[2]];
                    end
                    4'b1011: begin 
                       
                        D0_SEG <= digitMap[digits[1]];
                    end
                    4'b0111: begin 
                       
                        D0_SEG <= digitMap[digits[0]]; //leftmost digit, most significant.
                    end
                   
                endcase
            

            if (clkCounter == 32000) begin
                //happens once per drawing state. 
                //got to increment digitPosition to 0001 to 0010 etc (one hot)
                digitPosition <= {digitPosition[2:0], digitPosition[3]}; //its {rightmost 3 bits}+{leftmost}

                clkCounter <= 0; //needs manual rollover otherwise itd keep counting til 127
            end
            
            
        end
        if (clkCounter != 32000) begin
            clkCounter <= clkCounter + 1;
        end
        

        
    end


endmodule




