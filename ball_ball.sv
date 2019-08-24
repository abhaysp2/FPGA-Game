module  ball_ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  Reset_New,
               input [9:0] DrawX, DrawY,      // Current pixel coordinates
					input [10:0] Count, 
					input [9:0] patrick_x, patrick_y, zuofu_x, zuofu_y, x_move,
					output grav_en, grav_reset, right_en, left_en, pure_grav,
							 zuofu_goal, patrick_goal, ball_sound_1, ball_sound_2, 
               output [9:0] Ball_X_Pos, Ball_Y_Pos             // Whether current pixel belongs to ball or background
              );

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd340;  // Center position on the Y axis 
    parameter [9:0] Ball_X_Min = 10'd3;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd439;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd4;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd2;      // Step size on the Y axis going down
    parameter [9:0] Ball_Size = 10'd33;        // Ball size

    logic [9:0] Ball_X_Motion, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;

    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || Reset_New)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
		  grav_reset = 1'b0;
		  grav_en = 1'b0;
		  right_en = 1'b0;
		  left_en = 1'b0;
		  pure_grav = 1'b0;
		  zuofu_goal = 1'b0;
		  patrick_goal = 1'b0;
		  ball_sound_1 = 1'b0;
		  ball_sound_2 = 1'b0;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin  
////////////////////////////////////// CONTACT PATRICK ///////////////////////////////////
				
				if((Ball_X_Pos <= (patrick_x + 10'd70)) && ((Ball_X_Pos + Ball_Size) >= patrick_x) 
						&& ((Ball_Y_Pos + Ball_Size) >= patrick_y) && (Ball_Y_Pos <= (patrick_y + 10'd70))) //touches patrick
					begin
						ball_sound_1 = 1'b1;
						grav_en = 1'b0;
						grav_reset = 1'b0;
						//STUCK BETWEEN ZUOFU AND PATRICK
						if((Ball_X_Pos <= (zuofu_x + 10'd70)) && ((Ball_X_Pos + Ball_Size) >= zuofu_x) 
						&& ((Ball_Y_Pos + Ball_Size) >= zuofu_y) && (Ball_Y_Pos <= (zuofu_y + 10'd70))) //touches zuofu
							begin
								Ball_Y_Motion_in = ~(Ball_Y_Step + 6) + 1;
								Ball_X_Motion_in = 10'd0;
								grav_reset = 1'b1;
								ball_sound_1 = 1'b0;
								ball_sound_2 = 1'b1;
							end
						//BOTTOM SIDE OF PATRICK
						else if(Ball_Y_Pos >= (patrick_y + 10'd68))
							begin
							pure_grav = 1'b1;
								//BOTTOM LEFT
								if(Ball_X_Pos <= (patrick_x + 10'd35))
									begin   
									Ball_X_Motion_in= (~(Ball_X_Step) + 1);
									left_en = 1'b1;
									if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )
										begin
											Ball_Y_Motion_in = 10'd0;
											Ball_X_Motion_in= Ball_X_Step - 10'd18;
											grav_reset = 1'b1;
										end
									else
										Ball_Y_Motion_in = Ball_Y_Step;
									end
								//BOTTOM RIGHT
								else 
									begin   
									Ball_X_Motion_in= Ball_X_Step;
									right_en = 1'b1;
									if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )
										begin
											Ball_Y_Motion_in = 10'd0;
											Ball_X_Motion_in= Ball_X_Step + 10'd15;
											grav_reset = 1'b1;
										end
									else
										Ball_Y_Motion_in = Ball_Y_Step;
									end
							end
						//TOP SIDE OF PATRICK
						else if(((Ball_Y_Pos + Ball_Size) <= (patrick_y + 10'd21 )) || ((Ball_X_Pos > (patrick_x + 10'd15)) 
								 && (Ball_X_Pos + Ball_Size < patrick_x + 10'd60) && (Ball_Y_Pos + Ball_Size < (patrick_y + 10'd60))))
							begin
								grav_reset = 1'b1;
								//TOP RIGHT
								if(Ball_X_Pos >= (patrick_x + 10'd38))
									begin    
									Ball_X_Motion_in= Ball_X_Step;								
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;	
									right_en = 1'b1;
									end
								//TOP LEFT
								else if(Ball_X_Pos <= (patrick_x + 10'd5))
									begin  
									Ball_X_Motion_in= (~(Ball_X_Step) + 1);
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
									left_en = 1'b1;
									end
								//TOP TOP
								else
									begin    
									Ball_X_Motion_in= 10'd0;								
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
									end
							end
						//RIGHT SIDE OF PATRICK
						else if(Ball_X_Pos >= (patrick_x + 10'd35))
							begin
								Ball_X_Motion_in = Ball_X_Step;
								right_en = 1'b1;
								if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
									begin
										Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
										Ball_X_Motion_in= x_move;
										grav_reset = 1'b1;
									end
								else
									begin
										if(Count < 10'b000011011)					// 15
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0100110) //38
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0101111) //47
									Ball_Y_Motion_in = ~(Ball_Y_Step - 1) + 1;
								else if(Count < 10'b0110011) //51
									Ball_Y_Motion_in = 10'd0;
								else if(Count < 10'b0111100) //60
									Ball_Y_Motion_in = Ball_Y_Step - 1;
								else if(Count < 10'b01001100) //76
									Ball_Y_Motion_in = Ball_Y_Step;
								else if(Count < 10'b01011001) //89
									Ball_Y_Motion_in = Ball_Y_Step + 1;
								else
									Ball_Y_Motion_in = Ball_Y_Step + 1;
									end
							end
						//LEFT SIDE OF PATRICK
						else if(Ball_X_Pos < (patrick_x + 10'd35))
							begin
								Ball_X_Motion_in = (~(Ball_X_Step) + 1);
								left_en = 1'b1;
								if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
									begin
										Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
										Ball_X_Motion_in= x_move;
										grav_reset = 1'b1;
									end
								else
									begin
										if(Count < 10'b000011011)					// 15
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0100110) //38
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0101111) //47
									Ball_Y_Motion_in = ~(Ball_Y_Step - 1) + 1;
								else if(Count < 10'b0110011) //51
									Ball_Y_Motion_in = 10'd0;
								else if(Count < 10'b0111100) //60
									Ball_Y_Motion_in = Ball_Y_Step - 1;
								else if(Count < 10'b01001100) //76
									Ball_Y_Motion_in = Ball_Y_Step;
								else if(Count < 10'b01011001) //89
									Ball_Y_Motion_in = Ball_Y_Step + 1;
								else
									Ball_Y_Motion_in = Ball_Y_Step + 1;
									end
							end
					end
////////////////////////////////////// CONTACT ZUOFU ///////////////////////////////////
				else if((Ball_X_Pos <= (zuofu_x + 10'd70)) && ((Ball_X_Pos + Ball_Size) >= zuofu_x) 
						&& ((Ball_Y_Pos + Ball_Size) >= zuofu_y) && (Ball_Y_Pos <= (zuofu_y + 10'd70))) //touches zuofu
					begin
						grav_en = 1'b0;
						grav_reset = 1'b0;
						ball_sound_1 = 1'b1;
						//BOTTOM SIDE OF ZUOFU
						if(Ball_Y_Pos >= (zuofu_y + 10'd68))
							begin
							pure_grav = 1'b1;
								//BOTTOM LEFT
								if(Ball_X_Pos <= (zuofu_x + 10'd36))
									begin   
									Ball_X_Motion_in= (~(Ball_X_Step) + 1);
									left_en = 1'b1;
									if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )
										begin
											Ball_Y_Motion_in = 10'd0;
											Ball_X_Motion_in= Ball_X_Step - 10'd18;
											grav_reset = 1'b1;
										end
									else
										Ball_Y_Motion_in = Ball_Y_Step;
									end
								//BOTTOM RIGHT
								else 
									begin   
									Ball_X_Motion_in= Ball_X_Step;
									right_en = 1'b1;
									if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )
										begin
											Ball_Y_Motion_in = 10'd0;
											Ball_X_Motion_in= Ball_X_Step + 10'd15;
											grav_reset = 1'b1;
										end
									else
										Ball_Y_Motion_in = Ball_Y_Step;
									end
							end
						//TOP SIDE OF ZUOFU
						else if(((Ball_Y_Pos + Ball_Size) <= (zuofu_y + 10'd19)) || ((Ball_X_Pos > (zuofu_x + 10'd15)) 
								 && (Ball_X_Pos + Ball_Size < zuofu_x + 10'd60) && (Ball_Y_Pos + Ball_Size < (zuofu_y + 10'd60))))
							begin
								grav_reset = 1'b1;
								//TOP LEFT
								if(Ball_X_Pos <= (zuofu_x + 10'd10))
									begin  
									Ball_X_Motion_in= (~(Ball_X_Step) + 1);
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
									left_en = 1'b1;
									end
								//TOP RIGHT
								else if(Ball_X_Pos >= (zuofu_x + 10'd49))
									begin    
									Ball_X_Motion_in= Ball_X_Step;								
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;	
									right_en = 1'b1;
									end
								//TOP TOP
								else
									begin    
									Ball_X_Motion_in= 10'd0;								
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
									end
							end
						//RIGHT SIDE OF ZUOFU
						else if(Ball_X_Pos >= (zuofu_x + 10'd35))
							begin
								Ball_X_Motion_in = Ball_X_Step;
								right_en = 1'b1;
								if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
									begin
										Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
										Ball_X_Motion_in= x_move;
										grav_reset = 1'b1;
									end
								else
									begin
										if(Count < 10'b000011011)					// 15
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0100110) //38
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0101111) //47
									Ball_Y_Motion_in = ~(Ball_Y_Step - 1) + 1;
								else if(Count < 10'b0110011) //51
									Ball_Y_Motion_in = 10'd0;
								else if(Count < 10'b0111100) //60
									Ball_Y_Motion_in = Ball_Y_Step - 1;
								else if(Count < 10'b01001100) //76
									Ball_Y_Motion_in = Ball_Y_Step;
								else if(Count < 10'b01011001) //89
									Ball_Y_Motion_in = Ball_Y_Step + 1;
								else
									Ball_Y_Motion_in = Ball_Y_Step + 1;
									end
							end
						//LEFT SIDE OF ZUOFU
						else if(Ball_X_Pos < (zuofu_x + 10'd35))
							begin
								Ball_X_Motion_in = (~(Ball_X_Step) + 1);
								left_en = 1'b1;
								if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
									begin
										Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
										Ball_X_Motion_in= x_move;
										grav_reset = 1'b1;
									end
								else
									begin
										if(Count < 10'b000011011)					// 15
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0100110) //38
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0101111) //47
									Ball_Y_Motion_in = ~(Ball_Y_Step - 1) + 1;
								else if(Count < 10'b0110011) //51
									Ball_Y_Motion_in = 10'd0;
								else if(Count < 10'b0111100) //60
									Ball_Y_Motion_in = Ball_Y_Step - 1;
								else if(Count < 10'b01001100) //76
									Ball_Y_Motion_in = Ball_Y_Step;
								else if(Count < 10'b01011001) //89
									Ball_Y_Motion_in = Ball_Y_Step + 1;
								else
									Ball_Y_Motion_in = Ball_Y_Step + 1;
									end
							end
					end
					

/////////////////////////////////// NO CONTACT ////////////////////////////////////////////

				else
					begin
					if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
							begin
								Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
								Ball_X_Motion_in= x_move;
								grav_reset = 1'b1;
							end
					else if (Ball_Y_Pos <= (Ball_Y_Min + Ball_Size))  // Ball is at the top edge, BOUNCE!
							begin
								Ball_Y_Motion_in = Ball_Y_Step;
								Ball_X_Motion_in= x_move;
							end

					else if((Ball_X_Pos + Ball_Size) >= Ball_X_Max) // right side bounce to the left
						begin
								Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
								Ball_Y_Motion_in = Ball_Y_Step;
								left_en = 1'b1;
						end
					else if((Ball_X_Pos) <= (Ball_X_Min)) // left side bounce to the right
							begin
								Ball_X_Motion_in = Ball_X_Step;
								Ball_Y_Motion_in = Ball_Y_Step;
								right_en = 1'b1;
							end
					else if((Ball_X_Pos <= 10'd70) && (Ball_X_Pos >= 10'd68) && (Ball_Y_Pos >= 10'd248) && //left goal bounce right
							 ((Ball_Y_Pos + Ball_Size) <= 10'd305))
							begin
								Ball_Y_Motion_in = Ball_Y_Step;
								Ball_X_Motion_in = Ball_X_Step;
								right_en = 1'b1;
							end
					else if((Ball_X_Pos + Ball_Size <= 10'd570) && (Ball_X_Pos + Ball_Size >= 10'd568) && (Ball_Y_Pos >= 10'd248) && //right goal bounce left
							 ((Ball_Y_Pos + Ball_Size) <= 10'd300))
							 begin
								Ball_Y_Motion_in = Ball_Y_Step;
								Ball_X_Motion_in = ~(Ball_X_Step) + 1;
								left_en = 1'b1;
							end
					else if((Ball_X_Pos <= 10'd69) && (Ball_X_Pos >= 10'd0)  && // BOUNCE TOP OF GOAL
							 (Ball_Y_Pos <= 10'd274) && ((Ball_Y_Pos + Ball_Size) >= 10'd275)) 
							begin
								Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								Ball_X_Motion_in = x_move;
								grav_reset = 1'b1;
							end
					else if((Ball_X_Pos <= 10'd639) && (Ball_X_Pos >= 10'd569) && // BOUNCE TOP OF GOAL
							 (Ball_Y_Pos <= 10'd274) && ((Ball_Y_Pos + Ball_Size) >= 10'd275))
							 begin
								Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								Ball_X_Motion_in = x_move;
								grav_reset = 1'b1;
							end
					else if((Ball_X_Pos + 10'd5) <= 10'd70 && (Ball_Y_Pos >= 10'd276)) 	//SCORE FOR ZUOFU
							begin
								zuofu_goal = 1'b1;
							end
					else if((Ball_X_Pos + 10'd29 >= 10'd570) && (Ball_Y_Pos >= 10'd276)) //SCORE FOR PATRICK
							begin
								patrick_goal = 1'b1;
							end
					else
							begin
								Ball_X_Motion_in = x_move;
								grav_reset = 1'b0;
								grav_en = 1'b1;
								if(Count < 10'b000011011)					// 15
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0100110) //38
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1;
								else if(Count < 10'b0101111) //47
									Ball_Y_Motion_in = ~(Ball_Y_Step - 1) + 1;
								else if(Count < 10'b0110011) //51
									Ball_Y_Motion_in = 10'd0;
								else if(Count < 10'b0111100) //60
									Ball_Y_Motion_in = Ball_Y_Step - 1;
								else if(Count < 10'b01001100) //76
									Ball_Y_Motion_in = Ball_Y_Step;
								else if(Count < 10'b01011001) //89
									Ball_Y_Motion_in = Ball_Y_Step + 1;
								else
									Ball_Y_Motion_in = Ball_Y_Step + 1;
							end
					end	
					
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				
			end
    end
endmodule
