module Vr_HW3_Score (CLK, RST, STAT, ASC, BSC);
  /* I/O interface */
  input CLK, RST; //CLK,RST를 입력으로 받는다
  input [2:0] STAT; //2비트 입력인 현재 상태를 입력으로 받는다
  output [3:0] ASC, BSC; //4비트 ASC,BSC를 출력으로 내보낸다

  /* state declarations */
  parameter [2:0] S_INIT = 3'b000,
                  S_AATK = 3'b001,
                  S_BATK = 3'b010,
                  S_AW = 3'b011,
                  S_BW = 3'b100,
                  S_DRAW = 3'b101;

  integer ascore, bscore;
  /* Implementation 3: Score Calculator */

initial begin
ascore =0;
bscore = 0;
end

always @ (posedge CLK) begin //CLK이 올라갈 때만 always가 실행된다
if((RST ==0)&& (STAT ==S_AW)) ascore = ascore +1; //RST가 0이고 지금상태가 S_AW이면 ascore를 1증가한다
else if((RST ==0)&& (STAT ==S_BW)) bscore = bscore +1;
//RST가 0이고 지금상태가 S_BW이면 bscore를 1증가한다
if(ascore == 10) ascore = 0; //ascore가 10이면 0으로 다시 이동한다
else if(bscore ==10) bscore = 0; //bscore가 10이면 0으로 다시 이동한다

end
assign ASC = ascore; //ascore를 출력 ASC에 assign한다
assign BSC = bscore; //bscore를 출력 BSC에 assign한다
endmodule