`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 16:32:51
// Design Name: 
// Module Name: identify_color
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


module identify_color(
input ready,
input clk,
input frequncy,
input [63:0] r_time,
input [63:0] g_time,
input [63:0] b_time,
output reg [9:0] red,
output reg [9:0] green,
output reg [9:0] blue,
output reg [1:0] filter_select
    );
  reg [63:0]counter=0;  
  reg [9:0] r_counter=0,g_counter=0,b_counter=0;
  reg reset=0;
  assign cout=counter;
 always@(posedge clk&& ready )
 begin
 if(!reset)
    counter = counter+1;
 else
 begin
    counter=0; 
 end   
 end   
    
 always@(posedge frequncy&& ready)
 begin
    if(counter==0)
    begin
         r_counter=0;
         g_counter=0;
         b_counter=0;
         reset=0;
    end
    if(counter<r_time)
    begin
        filter_select = 2'b00;
        r_counter = r_counter+1;
    end
    else if(counter>=r_time&&counter<r_time+g_time)
    begin
         filter_select = 2'b11;
         g_counter = g_counter+1;    
    end
    else if(counter>=r_time+g_time&&counter<r_time+g_time+b_time)
    begin
        filter_select = 2'b10;
        b_counter = b_counter+1;    
    end
    else if(counter>=r_time+g_time+b_time)
    begin
        red=r_counter-1;
        green=g_counter-1;
        blue=b_counter-1;
        reset=1;
    end
 end
 
    
endmodule
