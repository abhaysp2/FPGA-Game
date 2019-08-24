module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  Reset_New,
               input [9:0]   DrawX, DrawY, Ball_Y_Move, zuofu_x, zuofu_y,     // Current pixel coordinates
					input [7:0]  keycode,
					input up, left, right,
					output logic Grd_hit, 
               output [9:0] Ball_X_Pos, Ball_Y_Pos             // Whether current pixel belongs to ball or background
              );

    parameter [9:0] Ball_X_Center = 10'd72;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd370;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd70;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd568;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd440;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd15;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd70;        // Ball size

	 logic up1, up2;
	
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
		  Grd_hit = 1'b0;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin  
//////////////////////////////////////ON GROUND///////////////////////////////////
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
            if( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					begin
						Grd_hit = 1'b1;
						if((Ball_X_Pos <= (zuofu_x + 10'd70)) && ((Ball_X_Pos + Ball_Size) >= zuofu_x) //touches zuofu
						&& ((Ball_Y_Pos + Ball_Size) >= zuofu_y) && (Ball_Y_Pos <= (zuofu_y + 10'd70)))
							begin
								Ball_Y_Motion_in = 10'd0;
								if(Ball_X_Pos < (zuofu_x + 10'd35))
									if(Ball_X_Pos >= 10'd78)
										Ball_X_Motion_in = ~(Ball_Y_Step - 2) + 1;
									else
										Ball_X_Motion_in = 10'd0;
								else
									Ball_X_Motion_in = 10'd8;
							end
						else if((Ball_X_Pos + Ball_Size) >= Ball_X_Max)// right edge ground
							begin
								if(up) //up
									begin
										Ball_X_Motion_in= 10'b0;
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(up && left) //diagonal left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(left)  //left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= 10'b0;
									end
								else
									begin
										Ball_X_Motion_in = 10'b0;
										Ball_Y_Motion_in= 10'b0;
									end
							end
						else if((Ball_X_Pos) <= Ball_X_Min)// left edge ground
							begin
								if(up) //up
									begin
										Ball_X_Motion_in= 0;
										Ball_Y_Motion_in= (~(Ball_Y_Step + 4) + 1'b1);
									end
								else if(up && right) //diagonal left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= (~(Ball_Y_Step + 4) + 1'b1);
									end
								else if(right)  //left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= 0;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in= 0;
									end
							end
						else										
							begin
								if(up) //up
									begin
										Ball_X_Motion_in= 0;
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(up && right) //diagonal left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(right)  //left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= 0;
									end
								else if(up && left) //diagonal left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(left)  //left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= 0;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in = 0;
									end
							end
					end
//////////////////////////////////AIR////////////////////////////////////////////////						

				else
					begin
					Grd_hit = 1'b0;
					if((Ball_X_Pos <= (zuofu_x + 10'd70)) && ((Ball_X_Pos + Ball_Size) >= zuofu_x) 
						&& ((Ball_Y_Pos + Ball_Size) >= zuofu_y) && (Ball_Y_Pos <= (zuofu_y + 10'd70)))
							begin
								if(Ball_X_Pos < (zuofu_x + 10'd35))
									if(Ball_X_Pos >= 10'd78)
										Ball_X_Motion_in = ~(Ball_Y_Step - 2) + 1;
									else
										Ball_X_Motion_in = 10'd0;
								else
									Ball_X_Motion_in = 10'd8;
							end
					else if(((Ball_X_Pos + Ball_Size) >= Ball_X_Max))// right edge ground
							begin
								if(left)  //left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= Ball_Y_Move;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in= Ball_Y_Move;
									end
							end
					else if((Ball_X_Pos) <= Ball_X_Min)// left edge ground
							begin
								if(right)  //left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= Ball_Y_Move;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in= Ball_Y_Move;
									end
							end
					else
						begin
							if(right)  //right
									begin
										Ball_X_Motion_in = Ball_X_Step;
										Ball_Y_Motion_in = Ball_Y_Move;
									end
							else if(left)  //left
									begin
										Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in = Ball_Y_Move;
									end
							else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in = Ball_Y_Move;
									end
							end
					end
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
    end
endmodule
