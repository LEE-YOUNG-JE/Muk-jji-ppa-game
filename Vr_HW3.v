module Vr_HW3 (CLK, RST, AIN, BIN, LDISP, RDISP, SC_LDISP, SC_RDISP);
  /* I/O interface */
  input CLK, RST;//CLK와 RST를 입력으로 받는다
  input [0:1] AIN, BIN;//AIN과 BIN을 입력으로 받는다
  output [0:12] LDISP, RDISP; //13비트 LDISP,RDISP를 출력으로 내보낸다
  output [0:12] SC_LDISP, SC_RDISP;//13비트 SC_LDISP,SCRDISP를 출력으로 내보낸다

  /* Implementation 5: top-level module */
  /* see page 10 for its structure */
  /* instantiate one main FSM, two series detectors, one score calculator,
     and one display decoder; and properly connect them with each other */
wire AS, BS, AS_out, BS_out; //각 모듈 instantiation을 연결하기 위해 wire를 선언하였고 AS,BS는 RSP가 입력받는 부분, AS_out,BS_out은 RSP가 출력하는 부분이다
wire [2:0] out_STAT; // RSP의 상태를 출력하기 위해 wire out_STAT를 선언하였다
wire [3:0] out_ASC, out_BSC; // ASC,BSC의 4비트 score를 DISP와 연결하기 위해 wire로 선언하였다

assign AS = (out_STAT== 3'b000) ? 1'b0 : AS_out;//현재상태가 초기상태이면 가위바위보하는 상태이므로 AS는 0을 assign해서 AS 연결을 끊고, 나머지 상태라면 연속인 것을 확인해야 하므로 AS_out과 assign한다
assign BS = (out_STAT== 3'b000) ? 1'b0 : BS_out;//현재상태가 초기상태이면 가위바위보하는 상태이므로 BS는 0을 assign해서 BS 연결을 끊고, 나머지 상태라면 연속인 것을 확인해야 하므로 BS_out과 assign한다
Vr_HW3_RSP Main_FSM(CLK, RST, AIN, BIN, AS, BS, out_STAT); //RSP를 Main_FSM으로 instantiation했다
Vr_HW3_Series A(CLK, in_RST_A, AIN, AS_out); // Vr_HW3_Series를 A로 instantiation하였다
Vr_HW3_Series B(CLK, in_RST_B, BIN, BS_out); // Vr_HW3_Series를 B로 instantiation하였다
Vr_HW3_Score Calculation(CLK, RST, out_STAT, out_ASC, out_BSC); //Vr_HW3_Score를 Calculation으로 instantiation하였다.
Vr_HW3_Disp_Decoder Display(AIN, BIN, out_STAT, out_ASC, out_BSC, LDISP, RDISP, SC_LDISP, SC_RDISP); //Vr_HW#_Disp_Decoder를 Display로 instantiation하였다.
endmodule
