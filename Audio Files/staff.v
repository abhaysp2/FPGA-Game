module staff(
	input [7:0]scan_code1,
	input [7:0]scan_code2,
	input [7:0]scan_code3,
	input [7:0]scan_code4,
	output [15:0]sound1,
	output [15:0]sound2,
	output [15:0]sound3,
	output [15:0]sound4,
	output sound_off1,
	output sound_off2,
	output sound_off3,
	output sound_off4
);

//////SoundOff Key///////
	assign sound_off1=(scan_code1==8'h00)?0:1;
	assign sound_off2=(scan_code2==8'h00)?0:1;
	assign sound_off3=(scan_code3==8'h00)?0:1;
	assign sound_off4=(scan_code4==8'h00)?0:1;



/////////Channel-3 Trigger////////
	wire L3_5_tr=(scan_code3==8'h04)?0:0;//-5
	wire L3_7_tr=(scan_code3==8'h16)?0:0;//-7		
	wire M3_1_tr=(scan_code3==8'h07)?0:0;//1		
	wire L3_6_tr=(scan_code3==8'h52)?1:0;//-6		
	wire M3_2_tr=(scan_code3==8'h0a)?0:0;//2		
	wire M3_3_tr=(scan_code3==8'h0b)?0:0;//3		
	wire M3_4_tr=(scan_code3==8'h1a)?1:0;//4		
	wire M3_5_tr=(scan_code3==8'h0e)?0:0;//5		
	wire M3_6_tr=(scan_code3==8'h0f)?0:0;//6		
	wire M3_7_tr=(scan_code3==8'h33)?0:0;//7		
	wire H3_1_tr=(scan_code3==8'h34)?0:0;//+1		
	wire H3_2_tr=0;//+2
	wire H3_3_tr=0;//+3
	wire H3_4_tr=0;//+4
	wire H3_5_tr=0;//+5
	wire H3u4_tr=0;//((!get_gate) && (scan_code==8'h15))?1:0;//+#4
	wire H3u2_tr=0;//((!get_gate) && (scan_code==8'h1d))?1:0;//+#2
	wire H3u1_tr=(scan_code3==8'h1d)?0:0;//+#1
	wire M3u6_tr=(scan_code3==8'h1b)?0:0;//#6
	wire M3u5_tr=(scan_code3==8'h06)?0:0;//#5
	wire M3u4_tr=(scan_code3==8'h19)?0:0;//#4
	wire M3u2_tr=(scan_code3==8'h05)?0:0;//#2
	wire M3u1_tr=(scan_code3==8'h11)?0:0;//#1
	wire L3u6_tr=(scan_code3==8'h10)?0:0;//-#6
	wire L3u5_tr=(scan_code3==8'h36)?0:0;//-#5
	wire L3u4_tr=(scan_code3==8'h37)?0:0;//-#4

	assign sound3=(		//channel-3 frequency
		(L3u4_tr)?400  :(
		(L3_5_tr)?423  :(
		(L3u5_tr)?448  :(
		(L3_6_tr)?475  :(
		(L3u6_tr)?503  :(
		(L3_7_tr)?533  :(
		(M3_1_tr)?565  :(
		(M3u1_tr)?599  :(
		(M3_2_tr)?634  :(
		(M3u2_tr)?672  :(
		(M3_3_tr)?712  :(
		(M3_4_tr)?755  :(
		(M3u4_tr)?800  :(
		(M3_5_tr)?847  :(
		(M3u5_tr)?897  :(
		(M3_6_tr)?951  :(
		(M3u6_tr)?1007 :(
		(M3_7_tr)?1067 :(
		(H3_1_tr)?1131 :(
		(H3u1_tr)?1198 :1
		)))))))))))))))))))
	);


/////////Channel-2 Trigger////////
	wire L2_5_tr=(scan_code2==8'h04)?0:0;//-5
	wire L2_6_tr=(scan_code2==8'h16)?0:0;//-6		
	wire L2_7_tr=(scan_code2==8'h07)?0:0;//-7		
	wire M2_1_tr=(scan_code2==8'h52)?1:0;//1		
	wire M2_2_tr=(scan_code2==8'h0a)?0:0;//2		
	wire M2_3_tr=(scan_code2==8'h0b)?0:0;//3		
	wire M2_4_tr=(scan_code2==8'h1a)?1:0;//4		
	wire M2_5_tr=(scan_code2==8'h0e)?0:0;//5		
	wire M2_6_tr=(scan_code2==8'h0f)?0:0;//6		
	wire M2_7_tr=(scan_code2==8'h33)?0:0;//7		
	wire H2_1_tr=(scan_code2==8'h34)?0:0;//+1		
	wire H2_2_tr=0;//+2
	wire H2_3_tr=0;//+3
	wire H2_4_tr=0;//+4
	wire H2_5_tr=0;//+5
	wire H2u4_tr=0;//((!get_gate) && (scan_code==8'h15))?1:0;//+#4
	wire H2u2_tr=0;//((!get_gate) && (scan_code==8'h1d))?1:0;//+#2
	wire H2u1_tr=(scan_code2==8'h1d)?0:0;//+#1
	wire M2u6_tr=(scan_code2==8'h1b)?0:0;//#6
	wire M2u5_tr=(scan_code2==8'h06)?0:0;//#5
	wire M2u4_tr=(scan_code2==8'h19)?0:0;//#4
	wire M2u2_tr=(scan_code2==8'h05)?0:0;//#2
	wire M2u1_tr=(scan_code2==8'h11)?0:0;//#1
	wire L2u6_tr=(scan_code2==8'h10)?0:0;//-#6
	wire L2u5_tr=(scan_code2==8'h36)?0:0;//-#5
	wire L2u4_tr=(scan_code2==8'h37)?0:0;//-#4

	assign sound2=(     //channel-2 frequency
		(L2u4_tr)?400  :(
		(L2_5_tr)?423  :(
		(L2u5_tr)?448  :(
		(L2_6_tr)?475  :(
		(L2u6_tr)?503  :(
		(L2_7_tr)?533  :(
		(M2_1_tr)?565  :(
		(M2u1_tr)?599  :(
		(M2_2_tr)?634  :(
		(M2u2_tr)?672  :(
		(M2_3_tr)?712  :(
		(M2_4_tr)?755  :(
		(M2u4_tr)?800  :(
		(M2_5_tr)?847  :(
		(M2u5_tr)?897  :(
		(M2_6_tr)?951  :(
		(M2u6_tr)?1007 :(
		(M2_7_tr)?1067 :(
		(H2_1_tr)?1131 :(
		(H2u1_tr)?1198 :1
		)))))))))))))))))))
	);



/////////Channel-4 Trigger////////
	wire L4_5_tr=(scan_code4==8'h04)?0:0;//-5
	wire L4_6_tr=(scan_code4==8'h16)?0:0;//-6		
	wire L4_7_tr=(scan_code4==8'h07)?0:0;//-7		
	wire M4_1_tr=(scan_code4==8'h52)?1:0;//1		
	wire M4_2_tr=(scan_code4==8'h0a)?0:0;//2		
	wire M4_3_tr=(scan_code4==8'h0b)?0:0;//3		
	wire M4_4_tr=(scan_code4==8'h1a)?1:0;//4		
	wire M4_5_tr=(scan_code4==8'h0e)?0:0;//5		
	wire M4_6_tr=(scan_code4==8'h0f)?0:0;//6		
	wire M4_7_tr=(scan_code4==8'h33)?0:0;//7		
	wire H4_1_tr=(scan_code4==8'h34)?0:0;//+1		
	wire H4_2_tr=0;//+2
	wire H4_3_tr=0;//+3
	wire H4_4_tr=0;//+4
	wire H4_5_tr=0;//+5
	wire H4u4_tr=0;//((!get_gate) && (scan_code==8'h15))?1:0;//+#4
	wire H4u2_tr=0;//((!get_gate) && (scan_code==8'h1d))?1:0;//+#2
	wire H4u1_tr=(scan_code4==8'h1d)?0:0;//+#1
	wire M4u6_tr=(scan_code4==8'h1b)?0:0;//#6
	wire M4u5_tr=(scan_code4==8'h06)?0:0;//#5
	wire M4u4_tr=(scan_code4==8'h19)?0:0;//#4
	wire M4u2_tr=(scan_code4==8'h05)?0:0;//#2
	wire M4u1_tr=(scan_code4==8'h11)?0:0;//#1
	wire L4u6_tr=(scan_code4==8'h10)?0:0;//-#6
	wire L4u5_tr=(scan_code4==8'h36)?0:0;//-#5
	wire L4u4_tr=(scan_code4==8'h37)?0:0;//-#4

	assign sound4=(  //channel-4 frequency
		(L4u4_tr)?400  :(
		(L4_5_tr)?423  :(
		(L4u5_tr)?448  :(
		(L4_6_tr)?475  :(
		(L4u6_tr)?503  :(
		(L4_7_tr)?533  :(
		(M4_1_tr)?565  :(
		(M4u1_tr)?599  :(
		(M4_2_tr)?634  :(
		(M4u2_tr)?672  :(
		(M4_3_tr)?712  :(
		(M4_4_tr)?755  :(
		(M4u4_tr)?800  :(
		(M4_5_tr)?847  :(
		(M4u5_tr)?897  :(
		(M4_6_tr)?951  :(
		(M4u6_tr)?1007 :(
		(M4_7_tr)?1067 :(
		(H4_1_tr)?1131 :(
		(H4u1_tr)?1198 :1
		)))))))))))))))))))
	);
	
	/////////Channel-1 Trigger////////
	wire L_5_tr=0;
	wire L_6_tr=0;		
	wire L_7_tr=0;		
	wire M_1_tr=(scan_code1==8'h52)?1:0;//1		
	wire M_2_tr=0;		
	wire M_3_tr=0;		
	wire M_4_tr=(scan_code1==8'h1a)?1:0;//4		
	wire M_5_tr=0;
	wire M_6_tr=0;
	wire M_7_tr=0;
	wire H_1_tr=0;
	wire H_2_tr=0;
	wire H_3_tr=0;
	wire H_4_tr=0;
	wire H_5_tr=0;
	wire Hu4_tr=0;
	wire Hu2_tr=0;
	wire Hu1_tr=0;
	wire Mu6_tr=0;
	wire Mu5_tr=0;
	wire Mu4_tr=0;
	wire Mu2_tr=0;
	wire Mu1_tr=0;
	wire Lu6_tr=0;
	wire Lu5_tr=0;
	wire Lu4_tr=0;

	assign sound1=(    //channel-1 frequency
		(Lu4_tr)?400  :(
		(L_5_tr)?423  :(
		(Lu5_tr)?448  :(
		(L_6_tr)?475  :(
		(Lu6_tr)?503  :(
		(L_7_tr)?533  :(
		(M_1_tr)?565  :(
		(Mu1_tr)?599  :(
		(M_2_tr)?634  :(
		(Mu2_tr)?672  :(
		(M_3_tr)?712  :(
		(M_4_tr)?755  :(
		(Mu4_tr)?800  :(
		(M_5_tr)?847  :(
		(Mu5_tr)?897  :(
		(M_6_tr)?951  :(
		(Mu6_tr)?1007 :(
		(M_7_tr)?1067 :(
		(H_1_tr)?1131 :(
		(Hu1_tr)?1198 :1
		)))))))))))))))))))
	);

endmodule