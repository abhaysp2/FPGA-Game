module  leftGoalRam
(
		input [13:0] read_address,
		input Clk,
		output logic [4:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [4:0] mem [0:11549];

initial
begin
	 $readmemh("sprites/LeftGoal.txt", mem);
	 //C:/Users/Abhay/Documents/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/rightGoal.txt
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
