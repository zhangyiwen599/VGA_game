`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/08 16:59:56
// Design Name: 
// Module Name: VGA_display
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

`define RIGHT 1'b1
`define LEFT  1'b0
`define UP    1'b0
`define DOWN  1'b1

module VGA_display(
    input clk,
    input pause,
	 input to_left,
	 input to_right,
	 input [3:0] bar_move_speed,
    output reg hs,
    output reg vs,
    output reg [2:0] Red,
    output reg [2:0] Green,
    output reg [1:0] Blue,
	 output reg lose
    );
	
	//parameter definition
	parameter PAL = 640;		//Pixels/Active Line (pixels)
	parameter LAF = 480;		//Lines/Active Frame (lines)
	parameter PLD = 800;	    //Pixel/Line Divider
	parameter LFD = 521;		//Line/Frame Divider
	parameter HPW = 96;			//Horizontal synchro Pulse Width (pixels)
	parameter HFP = 16;			//Horizontal synchro Front Porch (pixels)
	parameter VPW = 2;			//Verical synchro Pulse Width (lines)
	parameter VFP = 10;			//Verical synchro Front Porch (lines)
	
	parameter UP_BOUND = 10;
    parameter DOWN_BOUND = 480;  
    parameter LEFT_BOUND = 20;  
    parameter RIGHT_BOUND = 630;
    
    parameter BLOCK_DOWN_first = 70;
    parameter BLOCK_DOWN_second = 35;
    parameter BLOCK_WIDTH = 125;
	
	// Radius of the ball
	parameter ball_r = 10;
	
	
	reg pau=1;
	
	/*register definition*/
	reg [9:0] Hcnt;      // horizontal counter  if = PLD-1 -> Hcnt <= 0
	reg [9:0] Vcnt;      // verical counter  if = LFD-1 -> Vcnt <= 0
	reg clk_25M = 0;     //25MHz frequency
	reg clk_50M = 0;     //50MHz frequency
	
	reg h_speed = `RIGHT;
	reg v_speed = `UP; 
	
	// The position of the downside bar
	reg [9:0] up_pos = 400;
	reg [9:0] down_pos = 430;
	reg [9:0] left_pos = 230;
	reg [9:0] right_pos = 430;  
		
	// The circle heart position of the ball
	reg [9:0] ball_x_pos = 330;
	reg [9:0] ball_y_pos = 390;
	
	
	//The blocks
	reg [9:0] blocks=10'b1111111111;
	
	always@(posedge pause)
	begin
	   pau=~pau;
	end
	
	//generate a half frequency clock of 50MHz
	always@(posedge(clk))
	begin
		clk_50M <= ~clk_50M;
	end
	
	//generate a half frequency clock of 25MHz
	always@(posedge(clk_50M))
     begin
         clk_25M <= ~clk_25M;
     end
	
	/*generate the hs && vs timing*/
	always@(posedge(clk_25M)) 
	begin
		/*conditions of reseting Hcnter && Vcnter*/
		if( Hcnt == PLD-1 ) //have reached the edge of one line
		begin
			Hcnt <= 0; //reset the horizontal counter
			if( Vcnt == LFD-1 ) //only when horizontal pointer reach the edge can the vertical counter ++
				Vcnt <=0;
			else
				Vcnt <= Vcnt + 1;
		end
		else
			Hcnt <= Hcnt + 1;
		
		/*generate hs timing*/
		if( Hcnt == PAL - 1 + HFP)
			hs <= 1'b0;
		else if( Hcnt == PAL - 1 + HFP + HPW )
			hs <= 1'b1;
		
		/*generate vs timing*/		
		if( Vcnt == LAF - 1 + VFP ) 
			vs <= 1'b0;
		else if( Vcnt == LAF - 1 + VFP + VPW )
			vs <= 1'b1;					
	end
	
	
	//Display the downside bar and the ball
	always @ (posedge clk_25M)   
	begin  
		// Display the downside bar
		if (Vcnt>=up_pos && Vcnt<=down_pos  
				&& Hcnt>=left_pos && Hcnt<=right_pos) 
		begin  
			Red <= Hcnt[3:1];  
			Green <= Hcnt[6:4];  
			Blue <= Hcnt[8:7]; 
		end  
		
		// Display the ball
		else if ( (Hcnt - ball_x_pos)*(Hcnt - ball_x_pos) + (Vcnt - ball_y_pos)*(Vcnt - ball_y_pos) <= (ball_r * ball_r))  
		begin  
			Red <= Hcnt[3:1];  
			Green <= Hcnt[6:4];  
			Blue <= Hcnt[8:7];  
		end  
		else if(Vcnt<=BLOCK_DOWN_first&&Vcnt>BLOCK_DOWN_second)
		begin
		      if(Hcnt<BLOCK_WIDTH&&blocks[0])
		      begin
		          Red <= 111;  
                  Green <= 000;  
                  Blue <= 000; 
		      end
		      else if(Hcnt<BLOCK_WIDTH&&!blocks[0])
                             begin
                                Red <= 0;  
                                Green <= 0;  
                               Blue <= 0; 
                            end
		       if(Hcnt<BLOCK_WIDTH*2&&blocks[1]&&Hcnt>BLOCK_WIDTH)
                begin
                     Red <= 000;  
                     Green <= 111;  
                     Blue <= 000; 
               end
		      else if(Hcnt<BLOCK_WIDTH*2&&!blocks[1]&&Hcnt>BLOCK_WIDTH)
                              begin
                                 Red <= 0;  
                                 Green <= 0;  
                                Blue <= 0; 
                             end
               if(Hcnt<BLOCK_WIDTH*3&&blocks[2]&&Hcnt>BLOCK_WIDTH*2)
               begin
                   Red <= 000;  
                   Green <= 000;  
                    Blue <= 111; 
               end
		      else if(Hcnt<BLOCK_WIDTH*3&&!blocks[2]&&Hcnt>BLOCK_WIDTH*2)
                              begin
                                 Red <= 0;  
                                 Green <= 0;  
                                Blue <= 0; 
                             end
               if(Hcnt<BLOCK_WIDTH*4&&blocks[3]&&Hcnt>BLOCK_WIDTH*3)
               begin
                    Red <= 000;  
                    Green <= 111;  
                    Blue <= 111; 
              end
		      else if(Hcnt<BLOCK_WIDTH*4&&!blocks[3]&&Hcnt>BLOCK_WIDTH*3)
                             begin
                                Red <= 0;  
                                Green <= 0;  
                               Blue <= 0; 
                            end
              if(blocks[4]&&Hcnt>BLOCK_WIDTH*4)
              begin
                   Red <= 111;  
                   Green <= 111;  
                   Blue <= 111; 
              end
		      else if(!blocks[4]&&Hcnt>BLOCK_WIDTH*4)
               begin
                  Red <= 0;  
                  Green <= 0;  
                 Blue <= 0; 
              end
		end
		else if(Vcnt<=BLOCK_DOWN_second)
                begin
                      if(Hcnt<BLOCK_WIDTH&&blocks[5])
                      begin
                          Red <= 111;  
                          Green <= 111;  
                          Blue <= 000; 
                      end
		      else if(Hcnt<BLOCK_WIDTH&&!blocks[5])
                      begin
                        Red <= 0;  
                        Green <= 0;  
                        Blue <= 0; 
                      end
                       if(Hcnt<BLOCK_WIDTH*2&&blocks[6]&&Hcnt>BLOCK_WIDTH)
                        begin
                             Red <= 010;  
                             Green <= 101;  
                             Blue <= 010; 
                       end
		      else if(Hcnt<BLOCK_WIDTH*2&&!blocks[6]&&Hcnt>BLOCK_WIDTH)
                          begin
                          Red <= 0;  
                          Green <= 0;  
                          Blue <= 0; 
                        end
                       if(Hcnt<BLOCK_WIDTH*3&&blocks[7]&&Hcnt>BLOCK_WIDTH*2)
                       begin
                           Red <= 100;  
                           Green <= 011;  
                            Blue <= 111; 
                       end
		      else if(Hcnt<BLOCK_WIDTH*3&&!blocks[7]&&Hcnt>BLOCK_WIDTH*2)
                        begin
                            Red <= 0;  
                            Green <= 0;  
                            Blue <=0; 
                         end
                       if(Hcnt<BLOCK_WIDTH*4&&blocks[8]&&Hcnt>BLOCK_WIDTH*3)
                       begin
                            Red <= 010;  
                            Green <= 101;  
                            Blue <= 111; 
                      end
		      else if(Hcnt<BLOCK_WIDTH*4&&!blocks[8]&&Hcnt>BLOCK_WIDTH*3)
                        begin
                              Red <= 0;  
                             Green <= 0;  
                             Blue <= 0; 
                      end
                      if(blocks[9]&&Hcnt>BLOCK_WIDTH*4)
                      begin
                           Red <= 011;  
                           Green <= 011;  
                           Blue <= 011; 
                      end
		      else if(!blocks[9]&&Hcnt>BLOCK_WIDTH*4)
                         begin
                             Red <= 0;  
                              Green <= 0;  
                              Blue <= 0; 
                        end
                end
		
		else 
		begin  
			Red <= 3'b000;  
			Green <= 3'b000;  
			Blue <= 2'b00;  
		end		 
		
		
	end
	
	reg flag;
	//flush the image every zhen = =||
    always @ (posedge vs)  
   begin  		
		// movement of the bar
		if(lose)
		begin 
			ball_x_pos = 330;
			ball_y_pos = 390;
			up_pos = 400;
            down_pos = 430;
            left_pos = 230;
            right_pos = 430; 
			flag=1;
		end
		else if(!pau)
		begin
		  flag=0;
     	  if (to_left && left_pos >= LEFT_BOUND) 
			begin  
				left_pos <= left_pos - bar_move_speed;  
				right_pos <= right_pos - bar_move_speed;  
	      end  
	      else if(to_right && right_pos <= RIGHT_BOUND)
			begin  		
				left_pos <= left_pos + bar_move_speed; 
				right_pos <= right_pos + bar_move_speed;  
    	  end  
		
			//movement of the ball
			if (v_speed == `UP) // go up 
				ball_y_pos <= ball_y_pos - bar_move_speed;  
        	else //go down
				ball_y_pos <= ball_y_pos + bar_move_speed;  
			if (h_speed == `RIGHT) // go right 
				ball_x_pos <= ball_x_pos + bar_move_speed;  
        	else //go down
				ball_x_pos <= ball_x_pos - bar_move_speed; 

		end 	
   	end 
	
	//change directions when reach the edge or crush the bar
	always @ (negedge vs)  
    begin
        if(flag)
        begin
           lose<=0;
           blocks=10'b1111111111; 
        end
		if (ball_y_pos <= UP_BOUND)   // Here, all the jugement should use >= or <= instead of ==
		begin	
			v_speed <= `DOWN;              // Because when the offset is more than 1, the axis may step over the line
			lose <= 0;
		end
		else if(ball_y_pos <= BLOCK_DOWN_first&&ball_y_pos > BLOCK_DOWN_second)
		begin
		      if(ball_x_pos<BLOCK_WIDTH&&blocks[0])
		      begin
		          v_speed<=`DOWN;
		          blocks[0]<=0;
		      end
		      else if(ball_x_pos<BLOCK_WIDTH*2&&blocks[1]&&ball_x_pos>BLOCK_WIDTH)
                begin
                     v_speed<=`DOWN;
                     blocks[1]<=0;
                end
             else if(ball_x_pos<BLOCK_WIDTH*3&&blocks[2]&&ball_x_pos>BLOCK_WIDTH*2)
               begin
                      v_speed<=`DOWN;
                       blocks[2]<=0;
               end
               else if(ball_x_pos<BLOCK_WIDTH*4&&blocks[3]&&ball_x_pos>BLOCK_WIDTH*3)
                begin
                      v_speed<=`DOWN;
                      blocks[3]<=0;
                end
              else if(blocks[4]&&ball_x_pos>4*BLOCK_WIDTH)
               begin
                     v_speed<=`DOWN;
                     blocks[4]<=0;
              end
		end
		else if(ball_y_pos <= BLOCK_DOWN_second)
                begin
                      if(ball_x_pos<BLOCK_WIDTH&&blocks[5])
                      begin
                          v_speed<=`DOWN;
                          blocks[5]<=0;
                      end
                      else if(ball_x_pos<BLOCK_WIDTH*2&&blocks[6]&&ball_x_pos>BLOCK_WIDTH)
                        begin
                             v_speed<=`DOWN;
                             blocks[6]<=0;
                        end
                      else if(ball_x_pos<BLOCK_WIDTH*3&&blocks[7]&&ball_x_pos>BLOCK_WIDTH*2)
                       begin
                              v_speed<=`DOWN;
                               blocks[7]<=0;
                       end
                       else if(ball_x_pos<BLOCK_WIDTH*4&&blocks[8]&&ball_x_pos>BLOCK_WIDTH*3)
                        begin
                              v_speed<=`DOWN;
                              blocks[8]<=0;
                        end
                      else if(blocks[9]&&ball_x_pos>4*BLOCK_WIDTH)
                       begin
                             v_speed<=`DOWN;
                             blocks[9]<=0;
                      end
                end
		else if (ball_y_pos >= (up_pos - ball_r) && ball_x_pos <= right_pos && ball_x_pos >= left_pos)  
            v_speed <= `UP;  
		else if (ball_y_pos >= down_pos && ball_y_pos < (DOWN_BOUND - ball_r))
		begin
			//Do what you want when lose
			lose <= 1;
		end
		else if(blocks==0)
		  lose<=0;
		else if (ball_y_pos >= (DOWN_BOUND - ball_r + 1))
			v_speed <= 0; 
      else  
         v_speed <= v_speed;  
              
      if (ball_x_pos <= LEFT_BOUND)  
         h_speed <= `RIGHT;  
      else if (ball_x_pos >= RIGHT_BOUND)  
         h_speed <= `LEFT;  
      else  
         h_speed <= h_speed;  
  end 
  

endmodule
