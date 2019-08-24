module grav_p(input logic CLK, Reset, Hit, Grd_hit, KEY,
                                output [9:0] Ball_Y_Move);
                               
enum logic [3:0] {WAIT, DONE, UP, DOWN1, DOWN2, DOWN3} State, Next_state;
 
parameter [9:0] transform = 10'd7;
parameter [9:0] down_step_1 = 10'd1;
parameter [9:0] down_step_2 = 10'd1;
parameter [9:0] down_step_3 = 10'd1;
parameter [9:0] up_step = (~(transform) + 1);
 
always_ff @ (posedge CLK)
    begin
        if (Reset)
        begin
            State <= WAIT; 
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
            WAIT:
                if(Hit || KEY)
                    Next_state = UP;
                else
                    Next_state = WAIT;
            UP:
                Next_state = DOWN1;
            DOWN1:
                if(Grd_hit)
                    Next_state = WAIT;
                else
                    Next_state = DOWN2;
            DOWN2:
                if(Grd_hit)
                    Next_state = WAIT;
                else
                    Next_state = DOWN3;
            DOWN3:
                if(Grd_hit)
                    Next_state = WAIT;
                else
                    Next_state = DOWN3;
            default: ;
        endcase
        case (State)
            WAIT:
                Ball_Y_Move = 10'd0;
				UP:
					 Ball_Y_Move = up_step;
            DOWN1: 
                Ball_Y_Move = down_step_1;
            DOWN2:
                Ball_Y_Move = down_step_2;
            DOWN3:
                Ball_Y_Move = down_step_3;
            default: Ball_Y_Move = 10'd0;
        endcase
    end
endmodule

module grav_z(input logic CLK, Reset, Hit, Grd_hit2, SWITCH,
                                output [9:0] Zuofu_Y_Move);
                               
enum logic [3:0] {WAIT, DONE, UP1, DOWN1, DOWN2, DOWN3} State, Next_state;
 
logic [9:0] up_step;
parameter [9:0] down_step_1 = 10'd1;
parameter [9:0] down_step_2 = 10'd1;
parameter [9:0] down_step_3 = 10'd1;

assign up_step = ~(down_step_3) + 1'b1;
 
always_ff @ (posedge CLK)
    begin
        if (Reset)
        begin
            State <= WAIT; 
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
            WAIT:
                if(Hit || SWITCH)
                    Next_state = UP1;
                else
                    Next_state = WAIT;
            UP1:
                Next_state = DOWN1;
            DOWN1:
                if(Grd_hit2)
                    Next_state = WAIT;
                else
                    Next_state = DOWN2;
            DOWN2:
                if(Grd_hit2)
                    Next_state = WAIT;
                else
                    Next_state = DOWN3;
            DOWN3:
                if(Grd_hit2)
                    Next_state = WAIT;
                else
                    Next_state = DOWN3;
            default: ;
        endcase
        case (State)
            WAIT:
                Zuofu_Y_Move = 10'd0;
            UP1:
                Zuofu_Y_Move = up_step;
            DOWN1: 
                Zuofu_Y_Move = down_step_1;
            DOWN2:
                Zuofu_Y_Move = down_step_2;
            DOWN3:
                Zuofu_Y_Move = down_step_3;
            default: Zuofu_Y_Move = 10'd0;
        endcase
    end
endmodule

module grav_x(input logic CLK, Reset, Reset_New, right_en, left_en,
                                output [9:0] Ball_X_Move);
                               
enum logic [2:0] {ZERO, RIGHT, LEFT} State, Next_state;
 

parameter [9:0] right_step = 10'd4;
parameter [9:0] left_step = ~(right_step) + 1'b1;
 
always_ff @ (posedge CLK)
    begin
        if (Reset || Reset_New)
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