module  palette
(
		input [4:0] is_right,
		input [9:0] DrawX,
		output logic [7:0] VGA_R, VGA_G, VGA_B
);

	logic [7:0] Red, Green, Blue;
// Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue; 
    
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_right == 5'b00001)
        begin
            Red = 8'hFF;
            Green = 8'hFD;
            Blue = 8'hFD;
        end
		  
		  else if (is_right == 5'b00010)
		  begin
				Red = 8'h7F;
            Green = 8'h7F;
            Blue = 8'h7F;
		  end
		  
		  else if (is_right == 5'b00011)
		  begin
				Red = 8'hDE;
            Green = 8'hDE;
            Blue = 8'hDE;
		  end
		  
		  else if (is_right == 5'b00100)
		  begin
				Red = 8'hFF;
            Green = 8'hFB;
            Blue = 8'hFB;
		  end
		  
		  else if (is_right == 5'b00101)
		  begin
				Red = 8'h87;
            Green = 8'hA8;
            Blue = 8'hD0;
		  end
		  
		  else if (is_right == 5'b00110)
		  begin
				Red = 8'h0B;
            Green = 8'h07;
            Blue = 8'h03;
		  end
		  
		  else if (is_right == 5'b00111)
		  begin
				Red = 8'h66;
            Green = 8'h66;
            Blue = 8'h66;
		  end
		  
		  else if (is_right == 5'b01000)
		  begin
				Red = 8'h60;
            Green = 8'h40;
            Blue = 8'h40;
		  end
		  
		  else if (is_right == 5'b01001)
		  begin
				Red = 8'h40;
            Green = 8'h00;
            Blue = 8'h00;
		  end
		  
		  else if (is_right == 5'b01010)
		  begin
				Red = 8'hA9;
            Green = 8'h89;
            Blue = 8'h73;
		  end
		  
		  else if (is_right == 5'b01011)
		  begin
				Red = 8'h47;
            Green = 8'h33;
            Blue = 8'h25;
		  end
		  
		  else if (is_right == 5'b01100)
		  begin
				Red = 8'h66;
            Green = 8'h53;
            Blue = 8'h46;
		  end
		  
		  else if (is_right == 5'b01101)
		  begin
				Red = 8'h7D;
            Green = 8'h61;
            Blue = 8'h4D;
		  end
		  
		  else if (is_right == 5'b01110)
		  begin
				Red = 8'h15;
            Green = 8'h11;
            Blue = 8'h0E;
		  end
		  
		  else if (is_right == 5'b01111)
		  begin
				Red = 8'hCD;
            Green = 8'hA7;
            Blue = 8'h8A;
		  end
		  
		  else if (is_right == 5'b10000)
		  begin
				Red = 8'hD5;
            Green = 8'hB1;
            Blue = 8'h91;
		  end
		  
		  else if (is_right == 5'b10001)
		  begin
				Red = 8'hCA;
            Green = 8'h88;
            Blue = 8'h84;
		  end
		  
		  else if (is_right == 5'b10010)
		  begin
				Red = 8'hEA;
            Green = 8'hCB;
            Blue = 8'hBB;
		  end
		  
		  else if (is_right == 5'b10011)
		  begin
				Red = 8'h45;
            Green = 8'h45;
            Blue = 8'h45;
		  end
		  
		  else if (is_right == 5'b10100)
		  begin
				Red = 8'hF6;
            Green = 8'hD0;
            Blue = 8'hBE;
		  end
		  
		  else if (is_right == 5'b10101)
		  begin
				Red = 8'hC2;
            Green = 8'h87;
            Blue = 8'h5F;
		  end
		  
		  else if (is_right == 5'b10110)
		  begin
				Red = 8'hD3;
            Green = 8'h9A;
            Blue = 8'h7E;
		  end
		  
		  else if (is_right == 5'b10111)
		  begin
				Red = 8'hE0;
            Green = 8'hA8;
            Blue = 8'h91;
		  end
		  
		  else if (is_right == 5'b11000)
		  begin
				Red = 8'h0F;
            Green = 8'h4C;
            Blue = 8'hE9;
		  end
		  
		  else if (is_right == 5'b11001)
		  begin
				Red = 8'hF4;
            Green = 8'h90;
            Blue = 8'h2E;
		  end
		  
		  //
        else if (is_right == 5'b11010)
        begin
            // Background with nice color gradient
            Red = 8'h20; 
            Green = 8'h7C;
            Blue = 8'h00;
        end
		  
		  else
        begin
            // Background with nice color gradient
            Red = 8'h67; 
            Green = 8'hD8;
            Blue = 8'hFF - {1'b0, DrawX[9:3]};
        end
		  
end
endmodule 