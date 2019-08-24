module  zuofu ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  Reset_New,
               input [9:0]   DrawX, DrawY, Zuofu_Y_Move,      // Current pixel coordinates
					input [9:0]  patrick_x, patrick_y,
					input [7:0]  keycode,
					input up, left, right,
					output logic Grd_hit2,
               output [9:0] Ball_X_Pos, Ball_Y_Pos             // Whether current pixel belongs to ball or background
              );

    parameter [9:0] Ball_X_Center = 10'd497;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd370;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd70;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd568;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd440;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd15;      // Step size on the Y axis
    parameter [9:0] Ball_Size_X = 10'd70;        // Ball size
	 parameter [9:0] Ball_Size_Y = 10'd70;

	 //up = 8'h52
	 //left = 8'h50
	 //right = 8'h4f

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
		  Grd_hit2 = 1'b0;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin  
//////////////////////////////////////ON GROUND///////////////////////////////////
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
            if( (Ball_Y_Pos + Ball_Size_Y) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					begin
						Grd_hit2 = 1'b1;
						if((Ball_X_Pos <= (patrick_x + 10'd70)) && ((Ball_X_Pos + Ball_Size_X) >= patrick_x) 
						&& ((Ball_Y_Pos + Ball_Size_Y) >= patrick_y) && (Ball_Y_Pos <= (patrick_y + 10'd70)))
							begin
								Ball_Y_Motion_in = 10'd0;
								if(Ball_X_Pos > (patrick_x + 10'd35))
									if(Ball_X_Pos + Ball_Size_X <= 10'd548)
										Ball_X_Motion_in = 10'd8;
									else
										Ball_X_Motion_in = 10'd0;
								else
									Ball_X_Motion_in = ~(Ball_Y_Step) + 1;
							end
						else if((Ball_X_Pos + Ball_Size_X) >= Ball_X_Max)// right edge ground
							begin
								if(up) //up
									begin
										Ball_X_Motion_in= 10'b0;
										Ball_Y_Motion_in= (~(Ball_Y_Step + 4) + 1'b1);
									end
								else if((up) && (left)) //diagonal left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= (~(Ball_Y_Step + 4) + 1'b1);
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
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(up && right) //diagonal left
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(right)  //right
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
								else if(up && right) //diagonal right
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= (~(Ball_Y_Step) + 1'b1);
									end
								else if(right)  //right
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
					Grd_hit2 = 1'b0;
					if((Ball_X_Pos <= (patrick_x + 10'd70)) && ((Ball_X_Pos + Ball_Size_X) >= patrick_x) 
						&& ((Ball_Y_Pos + Ball_Size_Y) >= patrick_y) && (Ball_Y_Pos <= (patrick_y + 10'd70)))
							begin
								Ball_Y_Motion_in = Zuofu_Y_Move;
								if(Ball_X_Pos > (patrick_x + 10'd35))
									if(Ball_X_Pos + Ball_Size_X <= 10'd548)
										Ball_X_Motion_in = 10'd8;
									else
										Ball_X_Motion_in = 10'd0;
								else
									Ball_X_Motion_in = ~(Ball_Y_Step) + 1;
							end
					else if(((Ball_X_Pos + Ball_Size_X) >= Ball_X_Max))// right edge 
							begin
								if(left)  //left
									begin
										Ball_X_Motion_in= (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in= Zuofu_Y_Move;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in= Zuofu_Y_Move;
									end
							end
					else if((Ball_X_Pos) <= Ball_X_Min)// left edge 
							begin
								if(right)  //right
									begin
										Ball_X_Motion_in= Ball_X_Step;
										Ball_Y_Motion_in= Zuofu_Y_Move;
									end
								else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in= Zuofu_Y_Move;
									end
							end
					else
						begin
							if(right)  //right
									begin
										Ball_X_Motion_in = Ball_X_Step;
										Ball_Y_Motion_in = Zuofu_Y_Move;
									end
							else if(left)  //left
									begin
										Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
										Ball_Y_Motion_in = Zuofu_Y_Move;
									end
							else
									begin
										Ball_X_Motion_in = 0;
										Ball_Y_Motion_in = Zuofu_Y_Move;
									end
							end
					end
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end

    end
endmodule
