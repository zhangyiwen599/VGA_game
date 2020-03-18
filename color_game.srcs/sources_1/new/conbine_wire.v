`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 17:53:21
// Design Name: 
// Module Name: conbine_wire
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// conbine the wires
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conbine_wire(
input ready,
input [1:0]filter_select_balance,
input [1:0]filter_select_identify,
output  reg [1:0] filter_select_out
    );
    always@(*)
    begin
        if(!ready)
        begin
            filter_select_out = filter_select_balance;       
        end
        else
        begin
         filter_select_out = filter_select_identify;       
        end
    end
    
    
endmodule
