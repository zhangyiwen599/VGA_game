`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 15:44:24
// Design Name: 
// Module Name: white_balance
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


module white_balance(
 input clk,
 input frequncy,
 output reg[63:0]R_time,
 output reg[63:0]G_time,
 output reg[63:0]B_time,
 output ready,
 output reg [1:0] filter_select
    );
 reg [63:0]counter=0;
 reg [63:0]r_counter=0;
 reg [63:0]g_counter=0;
 reg [63:0]b_counter=0;
 
 always@(posedge clk && !ready)
 begin
    counter=counter+1;
 end
 
 always@(posedge frequncy&&!ready)
 begin
    if(r_counter<255)
    begin
        r_counter=r_counter+1;
        filter_select=2'b00;
    end
    else if(r_counter==255)
    begin
        r_counter=r_counter+1;
        R_time=counter;
    end
    
    if(r_counter>255&&g_counter<255)
    begin
        filter_select=2'b11;
        g_counter=g_counter+1;
    end    
    else if(g_counter==255)
    begin
        g_counter=g_counter+1;
        G_time=counter-R_time;
    end
    
    
    if(r_counter>255&&g_counter>255&&b_counter<255)
    begin       
        filter_select=2'b10;
        b_counter=b_counter+1;
    end    
    else if(b_counter==255)
    begin
        b_counter=b_counter+10;
        B_time=counter-R_time-G_time-1;
    end
 end
 
assign ready=(r_counter>255&&g_counter>255&&b_counter>255);
 
endmodule
