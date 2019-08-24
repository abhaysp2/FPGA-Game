module counter (input logic CLK,
					 input logic CountEnable,
					 input logic pure_grav,
					 input logic RESET,
					 output logic [10:0] Count);
					 
logic [10:0] counter = 10'b0000000000;

always_ff @ (posedge CLK)
begin
	if(RESET)
		Count <= 10'b0000000000;
	if(CountEnable)
		Count <= counter;
end

always_comb
begin
	if(Count == 10'b1111111111)
		counter = 10'b0000000000;
	else if (pure_grav)
		counter = 10'b0101010100;
	else
		counter = Count + 1;
		
end
endmodule

