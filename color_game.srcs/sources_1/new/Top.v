`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 10:02:02
// Design Name: 
// Module Name: Top
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
`include "E:/shuziluoji/color_game/color_game.srcs/sources_1/new/Game.v"
`include "E:/shuziluoji/color_game/color_game.srcs/sources_1/new/Top_module.v"
module Top(
    input clk,
    input color_frequncy,
    input pause,
    output [1:0] filter_select,
    output [1:0] frequncy_rate,
    output led,
    output HSync,         
    output [2:1] OutBlue,
    output [2:0] OutGreen, 
    output [2:0] OutRed,         
    output VSync
    );
    wire [1:0]rate;
    wire [9:0]r,g,b;
    wire to_left,to_right;
    Top_module_of_color color_sensor(
    .clk(clk),
    .frequncy(color_frequncy),
    .filter_select(filter_select),
    .frequncy_rate(frequncy_rate),
    .led(led),
    .r(r),
    .g(g),
    .b(b)
        );
        
     assign to_left= r>200&&g>200&&b>200;   
     assign to_right=r<20&&g<20&&b<20;   
     assign frequncy_rate=2'b11;
     Top_module_of_game game(
               .mclk(clk),    
                .pause(pause),
               .to_left(to_left),
               .to_right(to_right),
                .HSync(HSync),         
                .OutBlue(OutBlue),
                .OutGreen(OutGreen), 
                .OutRed(OutRed),         
                .VSync(VSync)
           );  
        
        
    
    
endmodule
