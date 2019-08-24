module piano( input              CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             input AUDIO_CLK,
				 output logic [6:0]  HEX0,
											HEX1,
											HEX2,
											HEX3,
											HEX4,
											HEX5,
											HEX6,
											HEX7,
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
											 //Audio Signals
				 input				   AUD_ADCDAT,
				 inout				   AUD_ADCLRCK,
				 inout		   		AUD_BCLK,
				 output					AUD_DACDAT,
				 inout				   AUD_DACLRCK,
				 output					AUD_XCK,
				 //I2C for audio
				 output  				I2C_SCLK,
				 inout	  				I2C_SDAT,
				 input		  [17:0]	SW       
						  );
    
	 wire I2C_END;
	 wire AUD_CTRL_CLK;
	 logic [9:0] tile_speed_in;
	 assign tile_speed_in=10'd2;
	 logic Reset_h, Clk;
	 logic [15:0] intile,enable;
    logic [31:0] keycode;
    logic [9:0] DrawX,DrawY;
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
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
     
     final_soc nios_system(
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
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    VGA_controller vga_controller_instance(.*,.Reset(Reset_h));
    
	 //piano_keys piano_keys_instance(.*,.keycode(keycode[7:0]),.frame_clk(VGA_VS),.Reset(Reset_h));
    
	tile_maker tile_maker_instance0(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[0]),.Column(2'b00),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[0]));

	tile_maker tile_maker_instance1(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[1]),.Column(2'b01),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[1]));

	tile_maker tile_maker_instance2(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[2]),.Column(2'b10),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[2]));

	tile_maker tile_maker_instance3(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[3]),.Column(2'b11),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[3]));
 
	tile_maker tile_maker_instance4(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[4]),.Column(2'b00),.instance_number(1'b1),.keycode(keycode[7:0]),.enable(enable[4]));
 
	tile_maker tile_maker_instance5(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[5]),.Column(2'b01),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[5]));

	tile_maker tile_maker_instance6(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[6]),.Column(2'b10),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[6]));

	tile_maker tile_maker_instance7(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[7]),.Column(2'b11),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[7]));

	tile_maker tile_maker_instance8(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[8]),.Column(2'b00),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[8]));
 
	tile_maker tile_maker_instance9(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[9]),.Column(2'b01),.instance_number(1'b1),.keycode(keycode[7:0]),.enable(enable[9]));
 
	tile_maker tile_maker_instance10(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[10]),.Column(2'b10),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[10]));

	tile_maker tile_maker_instance11(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[11]),.Column(2'b11),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[11]));

	tile_maker tile_maker_instance12(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[12]),.Column(2'b00),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[12]));

	tile_maker tile_maker_instance13(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[13]),.Column(2'b01),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[13]));
 
	tile_maker tile_maker_instance14(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[14]),.Column(2'b10),.instance_number(1'b1),.keycode(keycode[7:0]),.enable(enable[14]));
 
	tile_maker tile_maker_instance15(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.intile(intile[15]),.Column(2'b11),.instance_number(1'b0),.keycode(keycode[7:0]),.enable(enable[15]));

	
	color_mapper color_instance(.*,.Clk(CLOCK_50));
    
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

	wire [7:0]sound_code1 = keycode[7:0] ;

	wire [7:0]sound_code2 = keycode[15:8] ;

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

    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_2 (keycode[11:8], HEX2);
    HexDriver hex_inst_3 (keycode[15:12], HEX3);
    HexDriver hex_inst_4 (keycode[19:16], HEX4);
    HexDriver hex_inst_5 (keycode[23:20], HEX5);
	 HexDriver hex_inst_6 (keycode[27:24], HEX6);
    HexDriver hex_inst_7 (keycode[31:28], HEX7);
endmodule
