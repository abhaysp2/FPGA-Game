module patrick_jump(input logic CLK, Reset, right_en, left_en,
                                output [9:0] Ball_X_Move);
                               
enum logic [2:0] {ZERO, RIGHT, LEFT} State, Next_state;
 

parameter [9:0] right_step = 10'd3;
parameter [9:0] left_step = ~(right_step) + 1'b1;

 
always_ff @ (posedge CLK)
    begin
        if (Reset)
        begin
            State <= ZERO; 
        end
        else
        begin
            State <= Next_state;
        end
    end
 
always_comb
    begin
        Next_state = State;
        unique case (State)
            ZERO:
                if(right_en)
                    Next_state = RIGHT;
                else if(left_en)
                    Next_state = LEFT;
					 else
						  Next_state = ZERO;
            RIGHT:
					 if(left_en)
                    Next_state = LEFT;
                else 
                    Next_state = RIGHT;
            LEFT:
                if(right_en)
                    Next_state = RIGHT;
                else
                    Next_state = LEFT;
            default: ;
        endcase
        case (State)
            ZERO:
                Ball_X_Move = 10'd0;
            LEFT:
                Ball_X_Move = left_step;
            RIGHT: 
					 Ball_X_Move = right_step;
            default: Ball_X_Move = 10'd0;
        endcase
    end
endmodule