module game_controller(input logic CLK, Reset, patrick_goal, zuofu_goal, KEY, gameover,
                                output Reset_New, game_start,
										  output [2:0]patrick_score, zuofu_score);
                               
enum logic [2:0] {START, INGAME, ENDGAME, INGAME_NEW} State, Next_state;

logic Reset_Score;

always_ff @ (posedge CLK)
    begin
        if (Reset)
			  begin
					State <= START; 
					patrick_score <= 2'b00;
					zuofu_score <= 2'b00;
			  end
		  else if (Reset_Score)
			  begin
					patrick_score <= 2'b00;
					zuofu_score <= 2'b00;
					State <= Next_state;
			  end
        else
        begin
            State <= Next_state;
				if(patrick_goal)
					begin
						patrick_score <= patrick_score + 1'b1;
						zuofu_score <= zuofu_score;
					end
				else if(zuofu_goal)
					begin
						patrick_score <= patrick_score;
						zuofu_score = zuofu_score + 1'b1;
					end
				else
					begin
						patrick_score = patrick_score;
						zuofu_score = zuofu_score;
					end
        end
    end
 
always_comb
    begin
		  Reset_New = 1'b0;
        Next_state = State;
		  game_start = 1'b0;
		  Reset_Score = 1'b0;
        unique case (State)
            START:
                if(KEY)
                    Next_state = INGAME;
					 else
						  Next_state = START;
            INGAME:
					 if(gameover)
                    Next_state = ENDGAME;
                else 
                   Next_state = INGAME;
            ENDGAME:
					 if(KEY)
						 Next_state = INGAME_NEW;
					 else
                   Next_state = ENDGAME;
				INGAME_NEW:
						 Next_state = INGAME;
            default: ;
        endcase
        case (State)
            START: 
				begin
					 game_start = 1'b0;
				end
            INGAME:
				begin
					 game_start = 1'b1;
				    if(patrick_goal)
							Reset_New = 1'b1;					
					 else if(zuofu_goal)
							Reset_New = 1'b1;
					 else
							Reset_New = 1'b0;
				end
            ENDGAME: 
				begin
					game_start = 1'b0;
				end
				INGAME_NEW:
				begin
					Reset_New = 1'b1;
					Reset_Score = 1'b1;
				end
        endcase
    end
endmodule
