module keycode_reader(input [31:0] keycode,
							output logic w_on, a_on, d_on, up_on, right_on, left_on);
			
assign w_on = (keycode[31:24] == 8'h1A | keycode[23:16] == 8'h1A |
					keycode[15: 8] == 8'h1A | keycode[ 7: 0] == 8'h1A);
assign d_on = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 |
					keycode[15: 8] == 8'h07 | keycode[ 7: 0] == 8'h07);
assign a_on = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 |
					keycode[15: 8] == 8'h04 | keycode[ 7: 0] == 8'h04);
assign up_on = (keycode[31:24] == 8'h52 | keycode[23:16] == 8'h52 |
					keycode[15: 8] == 8'h52 | keycode[ 7: 0] == 8'h52);
assign right_on = (keycode[31:24] == 8'h4f | keycode[23:16] == 8'h4f |
					keycode[15: 8] == 8'h4f | keycode[ 7: 0] == 8'h4f);
assign left_on = (keycode[31:24] == 8'h50 | keycode[23:16] == 8'h50 |
					keycode[15: 8] == 8'h50 | keycode[ 7: 0] == 8'h50);
endmodule
