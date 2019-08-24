//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              CLK,         // Whether current pixel belongs to ball  
														Reset, 			//   or background (computed in ball.sv)
														game_start,
														zuofu_win,
														patrick_win,
							  input [2:0] patrick_score, zuofu_score,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input [9:0] patrick_x, patrick_y, zuofu_x, zuofu_y, ball_ball_x, ball_ball_y,
                       output logic [4:0] is_right // VGA RGB output
                     );
						
	 logic p_on, 
			 z_on, 
			 ball_on, 
			 rg_on, 
			 lg_on;
	 logic [4:0] is_right_ball, is_right_zuofu, is_right_patrick;
	 
	 assign is_right_ball = ballon;
	 assign is_right_zuofu = zuofuon;
	 assign is_right_patrick = patrickon;
	 
	 //RIGHT GOAL
	 logic[9:0] rightGoal_x = 10'd570;  //top left corner
	 logic[9:0] rightGoal_y = 10'd275;	// same 
	 logic[9:0] rightGoal_size_x = 10'd70;
	 logic[9:0] rightGoal_size_y = 10'd165;
	 logic [9:0] rightGoalPix_x;
	 logic [9:0] rightGoalPix_y;
	 logic [4:0] RightGoalon;
	 logic [13:0] Rightaddress;
	 
	 assign rightGoalPix_x = DrawX - rightGoal_x;
	 assign rightGoalPix_y = DrawY - rightGoal_y;
	 
	 
	 //LEFT GOAL
	 logic[9:0] leftGoal_x = 10'd0;  //top left corner
	 logic[9:0] leftGoal_y = 10'd275;	// same 
	 logic[9:0] leftGoal_size_x = 10'd70;
	 logic[9:0] leftGoal_size_y = 10'd165;
	 logic [9:0] leftGoalPix_x;
	 logic [9:0] leftGoalPix_y;
	 logic [4:0] LeftGoalon;
	 logic [13:0] Leftaddress;

	 assign leftGoalPix_x = DrawX - leftGoal_x;
	 assign leftGoalPix_y = DrawY - leftGoal_y;
	 
	 //ZERO PATRICK
	 logic[9:0] zero_x = 10'd0;  //top left corner
	 logic[9:0] zero_y = 10'd30;	// same 
	 logic[9:0] zero_size_x = 10'd60;
	 logic[9:0] zero_size_y = 10'd60;
	 logic [9:0] zeroPix_x;
	 logic [9:0] zeroPix_y;
	 logic [4:0] zeroon;
	 logic [11:0] zeroaddress;

	 assign zeroPix_x = DrawX - zero_x;
	 assign zeroPix_y = DrawY - zero_y;
	 
	 //ONE PATRICK
	 logic[9:0] one_x = 10'd0;  //top left corner
	 logic[9:0] one_y = 10'd30;	// same 
	 logic[9:0] one_size_x = 10'd60;
	 logic[9:0] one_size_y = 10'd60;
	 logic [9:0] onePix_x;
	 logic [9:0] onePix_y;
	 logic [4:0] oneon;
	 logic [11:0] oneaddress;

	 assign onePix_x = DrawX - one_x;
	 assign onePix_y = DrawY - one_y;
	 
	 //TWO PATRICK
	 logic[9:0] two_x = 10'd0;  //top left corner
	 logic[9:0] two_y = 10'd30;	// same 
	 logic[9:0] two_size_x = 10'd60;
	 logic[9:0] two_size_y = 10'd60;
	 logic [9:0] twoPix_x;
	 logic [9:0] twoPix_y;
	 logic [4:0] twoon;
	 logic [11:0] twoaddress;

	 assign twoPix_x = DrawX - two_x;
	 assign twoPix_y = DrawY - two_y;
	 
	 //THREE PATRICK
	 logic[9:0] three_x = 10'd0;  //top left corner
	 logic[9:0] three_y = 10'd30;	// same 
	 logic[9:0] three_size_x = 10'd60;
	 logic[9:0] three_size_y = 10'd60;
	 logic [9:0] threePix_x;
	 logic [9:0] threePix_y;
	 logic [4:0] threeon;
	 logic [11:0] threeaddress;

	 assign threePix_x = DrawX - three_x;
	 assign threePix_y = DrawY - three_y;
	 
////////////////////////////////////////////////////////////////////////
	 //ZERO ZUOFU
	 logic[9:0] zero_x2 = 10'd579;  //top left corner
	 logic[9:0] zero_y2 = 10'd30;	// same
	 logic [9:0] zeroPix_x2;
	 logic [9:0] zeroPix_y2;
	 logic [4:0] zeroon2;
	 logic [11:0] zeroaddress2;

	 assign zeroPix_x2 = DrawX - zero_x2;
	 assign zeroPix_y2 = DrawY - zero_y2;
	 
	 //ONE ZUOFU
	 logic[9:0] one_x2 = 10'd579;  //top left corner
	 logic[9:0] one_y2 = 10'd30;	// same 
	 logic [9:0] onePix_x2;
	 logic [9:0] onePix_y2;
	 logic [4:0] oneon2;
	 logic [11:0] oneaddress2;

	 assign onePix_x2 = DrawX - one_x2;
	 assign onePix_y2 = DrawY - one_y2;
	 
	 //TWO ZUOFU
	 logic[9:0] two_x2 = 10'd579;  //top left corner
	 logic[9:0] two_y2 = 10'd30;	// same 
	 logic [9:0] twoPix_x2;
	 logic [9:0] twoPix_y2;
	 logic [4:0] twoon2;
	 logic [11:0] twoaddress2;

	 assign twoPix_x2 = DrawX - two_x2;
	 assign twoPix_y2 = DrawY - two_y2;
	 
	 //THREE ZUOFU
	 logic[9:0] three_x2 = 10'd579;  //top left corner
	 logic[9:0] three_y2= 10'd30;	// same 
	 logic [9:0] threePix_x2;
	 logic [9:0] threePix_y2;
	 logic [4:0] threeon2;
	 logic [11:0] threeaddress2;

	 assign threePix_x2 = DrawX - three_x2;
	 assign threePix_y2 = DrawY - three_y2;
////////////////////////////////////////////////////////////////////////
	 //Banner
	 logic[9:0] headsoccer_x = 10'd169;  //top left corner
	 logic[9:0] headsoccer_y = 10'd15;	// same 
	 logic[9:0] headsoccer_size_x = 10'd300;
	 logic[9:0] headsoccer_size_y = 10'd60;
	 logic [9:0] headsoccerPix_x;
	 logic [9:0] headsoccerPix_y;
	 logic [4:0] headsocceron;
	 logic [14:0] headsocceraddress;

	 assign headsoccerPix_x = DrawX - headsoccer_x;
	 assign headsoccerPix_y = DrawY - headsoccer_y;


	 //START
	 logic[9:0] start_x = 10'd169;  //top left corner
	 logic[9:0] start_y = 10'd179;	// same 
	 logic[9:0] start_size_x = 10'd300;
	 logic[9:0] start_size_y = 10'd60;
	 logic [9:0] startPix_x;
	 logic [9:0] startPix_y;
	 logic [4:0] starton;
	 logic [14:0] startaddress;

	 assign startPix_x = DrawX - start_x;
	 assign startPix_y = DrawY - start_y;
	 
	 //PATRICK WIN 
	 logic[9:0] patrickwin_x = 10'd169;  //top left corner
	 logic[9:0] patrickwin_y = 10'd179;	// same 
	 logic[9:0] patrickwin_size_x = 10'd300;
	 logic[9:0] patrickwin_size_y = 10'd60;
	 logic [9:0] patrickwinPix_x;
	 logic [9:0] patrickwinPix_y;
	 logic [4:0] patrickwinon;
	 logic [14:0] patrickwinaddress;

	 assign patrickwinPix_x = DrawX - patrickwin_x;
	 assign patrickwinPix_y = DrawY - patrickwin_y;
	 
	 //ZUOFU WIN
	 logic[9:0] zuofuwin_x = 10'd169;  //top left corner
	 logic[9:0] zuofuwin_y = 10'd179;	// same 
	 logic[9:0] zuofuwin_size_x = 10'd300;
	 logic[9:0] zuofuwin_size_y = 10'd60;
	 logic [9:0] zuofuwinPix_x;
	 logic [9:0] zuofuwinPix_y;
	 logic [4:0] zuofuwinon;
	 logic [14:0] zuofuwinaddress;

	 assign zuofuwinPix_x = DrawX - zuofuwin_x;
	 assign zuofuwinPix_y = DrawY - zuofuwin_y;
	 
	 //Zuofu
//	 logic[9:0] zuofu_x = 10'd480;  //top left corner
//	 logic[9:0] zuofu_y = 10'd352;	// same 
	 logic[9:0] zuofu_size_x = 10'd70;
	 logic[9:0] zuofu_size_y = 10'd70;
	 logic [9:0] zuofuPix_x;
	 logic [9:0] zuofuPix_y;
	 logic [4:0] zuofuon;
	 logic [12:0] zuofuaddress;

	 assign zuofuPix_x = DrawX - zuofu_x;
	 assign zuofuPix_y = DrawY - zuofu_y;
	 
	 //Patrick
	 logic[9:0] patrick_size_x = 10'd70;
	 logic[9:0] patrick_size_y = 10'd70;
	 logic [9:0] patrickPix_x;
	 logic [9:0] patrickPix_y;
	 logic [4:0] patrickon;
	 logic [12:0] patrickaddress;

	 assign patrickPix_x = DrawX - patrick_x;
	 assign patrickPix_y = DrawY - patrick_y;
	 
	 
	 
	 //Ball
//	 logic[9:0] ball_x = 10'd320;  //top left corner
//	 logic[9:0] ball_y = 10'd240;	// same 
	 logic[9:0] ball_size_x = 10'd33;
	 logic[9:0] ball_size_y = 10'd33;
	 logic [9:0] ballPix_x;
	 logic [9:0] ballPix_y;
	 logic [4:0] ballon;
	 logic [10:0] balladdress;

	 assign ballPix_x = DrawX - ball_ball_x;
	 assign ballPix_y = DrawY - ball_ball_y;
	 
	 ////////////////////////////////////////////////////////////////////
	 
	 always_comb
	 begin
		p_on = 1'b0;
		z_on = 1'b0;
		rg_on = 1'b0;
		lg_on = 1'b0;
		ball_on = 1'b0;
		
	 //RIGHT GOAL
		if(DrawX >= rightGoal_x && DrawX < rightGoal_x + rightGoal_size_x && 
			DrawY >= rightGoal_y && DrawY < rightGoal_y + rightGoal_size_y)
			begin
				is_right = RightGoalon;
				rg_on = 1'b1;
			end
	//LEFT GOAL
		else if(DrawX >= leftGoal_x && DrawX < leftGoal_x + leftGoal_size_x && 
				  DrawY >= leftGoal_y && DrawY < leftGoal_y + leftGoal_size_y)
			begin
				is_right = LeftGoalon;
				lg_on = 1'b1;
			end
	//ZUOFU
		else if(DrawX >= zuofu_x && DrawX < zuofu_x + zuofu_size_x && 
				  DrawY >= zuofu_y && DrawY < zuofu_y + zuofu_size_y && DrawY < 10'd440)
			begin
				z_on = 1'b1;
				if(DrawX >= ball_ball_x && DrawX < ball_ball_x + ball_size_x && 
					DrawY >= ball_ball_y && DrawY < ball_ball_y + ball_size_y && DrawY < 10'd440)
					begin
						if(is_right_zuofu == 5'b00000)
							is_right = ballon;
						else
							is_right = zuofuon;
					end
				else
					begin
						is_right = zuofuon;
					end
					
			end
	//PATRICK
		else if(DrawX >= patrick_x && DrawX < patrick_x + patrick_size_x && 
				  DrawY >= patrick_y && DrawY < patrick_y + patrick_size_y && DrawY < 10'd440)
			begin
				p_on = 1'b1;
				if(DrawX >= ball_ball_x && DrawX < ball_ball_x + ball_size_x && 
					DrawY >= ball_ball_y && DrawY < ball_ball_y + ball_size_y && DrawY < 10'd440)
					begin
						if(is_right_patrick == 5'b00000)
							is_right = ballon;
						else
							is_right = patrickon;
					end
				else
					begin
						is_right = patrickon;
					end
			end
	//BALL
		else if(DrawX >= ball_ball_x && DrawX < ball_ball_x + ball_size_x && 
				  DrawY >= ball_ball_y && DrawY < ball_ball_y + ball_size_y && DrawY < 10'd440)
			begin
				is_right = ballon;
				ball_on = 1'b1;
			end
	//PATRICK WIN
		else if(DrawX >= patrickwin_x && DrawX < patrickwin_x + patrickwin_size_x && 
				  DrawY >= patrickwin_y && DrawY < patrickwin_y + patrickwin_y && DrawY < 10'd240 && (patrick_win))
			begin
				is_right = patrickwinon;	
			end
	//ZUOFU WIN
		else if(DrawX >= zuofuwin_x && DrawX < zuofuwin_x + zuofuwin_size_x && 
				  DrawY >= zuofuwin_y && DrawY < zuofuwin_y + zuofuwin_y && DrawY < 10'd240 && (zuofu_win))
			begin
				is_right = zuofuwinon;	
			end
	//START
		else if(DrawX >= start_x && DrawX < start_x + start_size_x && 
					  DrawY >= start_y && DrawY < start_y + start_size_y && DrawY < 10'd440 && (~game_start))
			begin
				is_right = starton;	
			end
	//BANNER
		else if(DrawX >= headsoccer_x && DrawX < headsoccer_x + headsoccer_size_x && 
					  DrawY >= headsoccer_y && DrawY < headsoccer_y + headsoccer_size_y && DrawY < 10'd440)
			begin
				is_right = headsocceron;	
			end
	//NUMBERS PATRICK
		else if(DrawX >= zero_x && DrawX < zero_x + one_size_x && 
				  DrawY >= zero_y && DrawY < zero_y + one_size_y && DrawY < 10'd440)
			begin
				case(patrick_score)
					2'b00: is_right = zeroon;
					2'b01: is_right = oneon;
					2'b10: is_right = twoon;
					2'b11: is_right = threeon;
					default: is_right = zeroon;
				endcase
			end
	//NUMBERS ZUOFU
		else if(DrawX >= zero_x2 && DrawX < zero_x2 + one_size_x && 
				  DrawY >= zero_y2 && DrawY < zero_y2 + one_size_y && DrawY < 10'd440)
			begin
				case(zuofu_score)
					2'b00: is_right = zeroon2;
					2'b01: is_right = oneon2;
					2'b10: is_right = twoon2;
					2'b11: is_right = threeon2;
					default: is_right = zeroon2;
				endcase
			end
	//GROUND
		else if(DrawY >= 10'd440)
			begin
				is_right = 5'b11010;
			end
	//BACKGROUND
		else
			is_right = 5'b00000;
	 end
	 
	 rightGoalRam rightGoalRam_1(.read_address(Rightaddress), .Clk(CLK), .data_Out(RightGoalon));
	 assign Rightaddress = rightGoalPix_x + (rightGoalPix_y * rightGoal_size_x);
	 
	 leftGoalRam leftGoalRam_1(.read_address(Leftaddress), .Clk(CLK), .data_Out(LeftGoalon));
	 assign Leftaddress = leftGoalPix_x + (leftGoalPix_y * leftGoal_size_x);
	 
	 zuofuRam zuofuRam_1(.read_address(zuofuaddress), .Clk(CLK), .data_Out(zuofuon));
	 assign zuofuaddress = zuofuPix_x + (zuofuPix_y * zuofu_size_x);
	 
	 patrickRam patrickRam_1(.read_address(patrickaddress), .Clk(CLK), .data_Out(patrickon));
	 assign patrickaddress = patrickPix_x + (patrickPix_y * patrick_size_x);
	 
	 ballRam ballRam_1(.read_address(balladdress), .Clk(CLK), .data_Out(ballon));
	 assign balladdress = ballPix_x + (ballPix_y * ball_size_x);
	 
	 zeroRam zeroRam_1(.read_address(zeroaddress), .Clk(CLK), .data_Out(zeroon));
	 assign zeroaddress = zeroPix_x + (zeroPix_y * zero_size_x);
	 
	 oneRam oneRam_1(.read_address(oneaddress), .Clk(CLK), .data_Out(oneon));
	 assign oneaddress = onePix_x + (onePix_y * one_size_x);
	 
	 twoRam twoRam_1(.read_address(twoaddress), .Clk(CLK), .data_Out(twoon));
	 assign twoaddress = twoPix_x + (twoPix_y * two_size_x);
	 
	 threeRam threeRam_1(.read_address(threeaddress), .Clk(CLK), .data_Out(threeon));
	 assign threeaddress = threePix_x + (threePix_y * three_size_x);
	 
	 zeroRam zeroRam_2(.read_address(zeroaddress2), .Clk(CLK), .data_Out(zeroon2));
	 assign zeroaddress2 = zeroPix_x2 + (zeroPix_y2 * zero_size_x);
	 
	 oneRam oneRam_2(.read_address(oneaddress2), .Clk(CLK), .data_Out(oneon2));
	 assign oneaddress2 = onePix_x2 + (onePix_y2 * one_size_x);
	 
	 twoRam twoRam_2(.read_address(twoaddress2), .Clk(CLK), .data_Out(twoon2));
	 assign twoaddress2 = twoPix_x2 + (twoPix_y2 * two_size_x);
	 
	 threeRam threeRam_2(.read_address(threeaddress2), .Clk(CLK), .data_Out(threeon2));
	 assign threeaddress2 = threePix_x2 + (threePix_y2 * three_size_x);
	 
	 startRam startRam_1(.read_address(startaddress), .Clk(CLK), .data_Out(starton));
	 assign startaddress = startPix_x + (startPix_y * start_size_x);
	 
	 patrickwinRam patrickwinRam_1(.read_address(patrickwinaddress), .Clk(CLK), .data_Out(patrickwinon));
	 assign patrickwinaddress = patrickwinPix_x + (patrickwinPix_y * patrickwin_size_x);
	 
	 zuofuwinRam zuofuwinRam_1(.read_address(zuofuwinaddress), .Clk(CLK), .data_Out(zuofuwinon));
	 assign zuofuwinaddress = zuofuwinPix_x + (zuofuwinPix_y * zuofuwin_size_x);
	 
	 headsoccerRam headsoccerRam_1(.read_address(headsocceraddress), .Clk(CLK), .data_Out(headsocceron));
	 assign headsocceraddress = headsoccerPix_x + (headsoccerPix_y * headsoccer_size_x);
    
endmodule
