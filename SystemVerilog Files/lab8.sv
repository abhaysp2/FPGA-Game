	
module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
				 input		  [2:0]  SW,
				 input AUDIO_CLK,
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
											
					input				   AUD_ADCDAT,
				 inout				   AUD_ADCLRCK,
				 inout		   		AUD_BCLK,
				 output					AUD_DACDAT,
				 inout				   AUD_DACLRCK,
				 output					AUD_XCK,
				 //I2C for audio
				 output  				I2C_SCLK,
				 inout	  				I2C_SDAT
                    );
						  
	 wire I2C_END;
	 wire AUD_CTRL_CLK;

    logic Reset_h, Clk, Reset_New;
	 logic ball_sound_1, ball_sound_2;
	 logic [2:0] zuofu_score, patrick_score;
	 logic zuofu_goal, patrick_goal, patrick_win, zuofu_win, patrick_grav, zuofu_grav;
	 logic contact, grav_en, grav_reset, left_en, right_en, pure_grav, game_start;
	 logic [10:0] Count, X_Count, pat_count;
    logic [31:0] keycode, keycode_game;
	 logic [9:0] drawx, drawy, Ball_X_Pos, Ball_Y_Pos, Ball_Y_Move, Zuofu_Y_Move,
					 Zuofu_X_Pos, Zuofu_Y_Pos, ball_ball_x, ball_ball_y, x_move;
	 logic isball, Hit, Grd_hit, Grd_hit2, start_on;
	 logic up, left, right, RIGHTZ, LEFTZ, UPZ, begin_game;
	 logic up_init, right_init, left_init, RIGHTZ_init, LEFTZ_init, UPZ_init;
	 logic [4:0] is_right; //MUST CHANGE WIDTH !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
	 logic w_on, a_on, d_on, up_on, right_on, left_on;
	 logic sound_on;
	 
	 assign start_on = (keycode[31:24] == 8'h2c | keycode[23:16] == 8'h2c |
					keycode[15: 8] == 8'h2c | keycode[ 7: 0] == 8'h2c);
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  
		  right <= d_on;
		  up <= w_on;
		  left <= a_on;
	
		  RIGHTZ <= right_on;
		  UPZ <= up_on;
		  LEFTZ <= left_on;
		  
    end
    always_comb
		begin
//			right = (right_init && game_start);	//DISABLING MOVEMENT UNTIL GAME START
//			left = (left_init & game_start);
//			up = (up_init && game_start);
//			RIGHTZ = (RIGHTZ_init && game_start);
//			LEFTZ = (LEFTZ_init && game_start);
//			UPZ = (UPZ_init && game_start);
			
			gameover = 1'b0;
			patrick_win = 1'b0;
			zuofu_win = 1'b0;
			patrick_grav = 1'b0;
			zuofu_grav = 1'b0;
			begin_game = 1'b0;
			
			if(game_start == 1'b0)		//Keycode enabled or ot
				begin
					if(start_on)
					begin
						begin_game = 1'b1;
						keycode_game = keycode;
					end
					else
					begin
						keycode_game = 31'h00;
						begin_game = 1'b0;
					end
				end
		   else
				keycode_game = keycode;
				
			if(up_on == 1'b1) 
				zuofu_grav = 1'b1;
			if(w_on == 1'b1)
				patrick_grav = 1'b1;
				
			if(patrick_score == 2'b11)
				begin
					gameover = 1'b1;
					patrick_win = 1'b1;
				end
			else if(zuofu_score == 2'b11)
				begin
					gameover = 1'b1;
					zuofu_win = 1'b1;
				end
			else
				begin
					gameover = 1'b0;
					patrick_win = 1'b0;
					zuofu_win = 1'b0;
				end
		end
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc lab8_soc(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
	 // GAME CONTROLLER STATE MACHINE									///CHANGE .KEY
	 
	 game_controller godfather(.*, .CLK(Clk), .Reset(Reset_h), .KEY(begin_game), .gameover(gameover), .game_start(game_start),
										.patrick_score(patrick_score), .zuofu_score(zuofu_score));
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*, .Clk(VGA_CLK), .Reset(Reset_h), .DrawX(drawx), .DrawY(drawy));

    
    ball patrick_instance(.*, .Clk(Clk), .Reset(Reset_h), .Grd_hit(Grd_hit), .frame_clk(VGA_VS), .DrawX(drawx), .DrawY(drawy), .keycode(keycode), 
	 .Ball_X_Pos(Ball_X_Pos), .Ball_Y_Pos(Ball_Y_Pos), .Ball_Y_Move(Ball_Y_Move), .zuofu_x(Zuofu_X_Pos), .zuofu_y(Zuofu_Y_Pos));
	 
    zuofu zuofu_instance(.*, .Reset(Reset_h), .up(UPZ), .right(RIGHTZ), .left(LEFTZ), .frame_clk(VGA_VS), .DrawX(drawx), .DrawY(drawy),
				.Ball_X_Pos(Zuofu_X_Pos), .Ball_Y_Pos(Zuofu_Y_Pos), .keycode(keycode_game), .patrick_x(Ball_X_Pos), .patrick_y(Ball_Y_Pos));
				
	 ball_ball (.*, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawx), .DrawY(drawy), .Ball_X_Pos(ball_ball_x), .Ball_Y_Pos(ball_ball_y),
					.grav_en(grav_en), .Count(Count), .grav_reset(grav_reset), .patrick_x(Ball_X_Pos), .patrick_y(Ball_Y_Pos), .zuofu_x(Zuofu_X_Pos),
					.zuofu_y(Zuofu_Y_Pos), .x_move(x_move), .right_en(right_en), .left_en(left_en));
	 
    color_mapper color_instance(.*, .Reset(Reset_h), .CLK(Clk), .DrawX(drawx), .DrawY(drawy), .patrick_x(Ball_X_Pos), .patrick_y(Ball_Y_Pos),
											.zuofu_x(Zuofu_X_Pos), .zuofu_y(Zuofu_Y_Pos));
    
	 palette coloring (.*, .DrawX(drawx));																//change KEY
	 
	 grav_p patrick_gravity (.*, .CLK(Clk), .Reset(Reset_h), .Ball_Y_Move(Ball_Y_Move), .KEY(patrick_grav), .Grd_hit(Grd_hit));
	 grav_z zuofu_gravity (.*, .CLK(Clk), .Reset(Reset_h), .Zuofu_Y_Move(Zuofu_Y_Move), .SWITCH(zuofu_grav), .Grd_hit2(Grd_hit2));
	 grav_x ball_x_direction(.*, .CLK(Clk), .Reset(Reset_h), .Ball_X_Move(x_move)); 
	 
	 counter ball_grav(.*, .CLK(Clk), .CountEnable(grav_en), .RESET(grav_reset), .Count(Count));
	 
	 keycode_reader keysorter (.*, .keycode(keycode_game));
	 
///////////////////////////////////////////AUDIO STUFF///////////////////////////////////////////////////
	 
	  //I2C
I2C_AV_Config I2C_AV_Config_instance(	//	Host Side
								 .iCLK		( Clk),
								 .iRST_N		( Reset_h ),
								 .o_I2C_END	( I2C_END ),
								   //	I2C Side
								 .I2C_SCLK	( I2C_SCLK ),
								 .I2C_SDAT	( I2C_SDAT )	
								);

//Audio Sound
assign AUD_ADCLRCK=AUD_DACLRCK;
assign AUD_XCK= AUD_CTRL_CLK;

//  AUDIO PLL

VGA_Audio_PLL 	u1	(	
						 .areset ( ~I2C_END ),
						 .inclk0 ( AUDIO_CLK ),
						 .c1		( AUD_CTRL_CLK )	
						);
						
////////////Sound Select/////////////	
	
	wire [15:0]	sound1;
	wire [15:0]	sound2;
	wire [15:0]	sound3;
	wire [15:0]	sound4;
	wire 			sound_off1;
	wire 			sound_off2;
	wire 			sound_off3;
	wire 			sound_off4;
	
	wire [7:0]sound_code1 = keycode[7:0];
	
	wire [7:0]sound_code2 = keycode[15:8];

	wire [7:0]sound_code3 = keycode[23:16];

	wire [7:0]sound_code4 = keycode[31:24];
	
	
		 
    
						
	staff st1(
		
			 // Key code-in //
		
			 .scan_code1		( sound_code1 ),
			 .scan_code2		( sound_code2 ),
			 .scan_code3      ( sound_code3 ), 
			 .scan_code4		( sound_code4 ), 
		
			 //Sound Output to Audio Generater//
		
			 .sound1				( sound1 ),
			 .sound2				( sound2 ),
			 .sound3				( sound3 ),
			 .sound4				( sound4 ),
		
			 .sound_off1		( sound_off1 ),
			 .sound_off2		( sound_off2 ),
			 .sound_off3		( sound_off3 ), //OFF
			 .sound_off4		( sound_off4 )	 //OFF	
	        );
						
						
						// 2CH Audio Sound output -- Audio Generater //

	adio_codec ad1	(	
	        
					// AUDIO CODEC //
		
					.oAUD_BCK 	( AUD_BCLK ),
					.oAUD_DATA	( AUD_DACDAT ),
					.oAUD_LRCK	( AUD_DACLRCK ),																
					.iCLK_18_4	( AUD_CTRL_CLK ),
			
					// KEY //
		
					.iRST_N	  	( ~Reset_h ),							
					.iSrc_Select( 2'b00 ),

					// Sound Control //

					.key1_on		( sound_off1 ),//CH1 ON / OFF		
					.key2_on		( sound_off2 ),//CH2 ON / OFF
					.key3_on		( sound_off3 ),			    	// OFF
					.key4_on		( sound_off4 ), 					// OFF							
					.sound1		( sound1 ),					// CH1 Freq
					.sound2		( sound2 ),					// CH2 Freq
					.sound3		( sound3 ),					// OFF,CH3 Freq
					.sound4		( sound4 ),					// OFF,CH4 Freq							
					.instru		( SW[0] )  					// Instruction Select
					);
	 
	 
	 /////////////////////////////////////////////////////AUDIO END/////////////////////////////////////////////
	 
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
endmodule
