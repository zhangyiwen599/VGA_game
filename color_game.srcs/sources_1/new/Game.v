`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/08 17:33:44
// Design Name: 
// Module Name: Game
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
`include "E:/shuziluoji/color_game/color_game.srcs/sources_1/new/VGA_display.v"

module Top_module_of_game(
        input mclk,    
		input pause,
		input to_left,
		input to_right,
		//input [3:0] bar_move_speed,
        output HSync,         
        output [2:1] OutBlue,
        output [2:0] OutGreen, 
        output [2:0] OutRed,         
        output VSync
   );
reg pe;
reg [3:0] bar_move_speed;
always@(*)
begin
    bar_move_speed=4;
end

always@(*)
begin
    if(!lose)
        pe=pause;
    else
        pe=1;
end

VGA_display VGA_Disp(
	.clk(mclk),
	.pause(pe),
	.to_left(to_left),
	.to_right(to_right),
	.bar_move_speed(bar_move_speed),
	.hs(HSync),
	.Blue(OutBlue),
	.Green(OutGreen),
	.Red(OutRed),
	.vs(VSync),
	.lose(lose)
	);
endmodule
