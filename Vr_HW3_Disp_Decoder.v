module Vr_HW3_Disp_Decoder (AIN, BIN, STAT, ASC, BSC, LDISP, RDISP, SC_LDISP, SC_RDISP);
  /* I/O interface */
  input [0:1] AIN, BIN; //입력으로 AIN,BIN을 받는다
  input [2:0] STAT; //상태 STAT를 입력받는다
  input [3:0] ASC, BSC; //A,B의 점수를 입력으로 받는다
  output reg [0:12] LDISP, RDISP; // 현재상태를 출력으로 표시한다
  output reg [0:12] SC_LDISP, SC_RDISP; //현재 점수를 출력으로 표시한다

  /* state declarations */
  parameter [2:0] S_INIT = 3'b000,
                  S_AATK = 3'b001,
                  S_BATK = 3'b010,
                  S_AW = 3'b011,
                  S_BW = 3'b100,
                  S_DRAW = 3'b101;
  parameter [0:1] ROCK=2'b00, SCISSORS=2'b01, PAPER=2'b10, INVALID=2'b11;

  function [0:12] number_dec; //4비트 입력을 받아서 정해진 원칙대로 13비트로 변환해주는 함수 number_dec이고 반환값이 number_dec이다
    input [3:0] in_val;
    if(in_val==4'b0000) number_dec = 13'b1111110000000; // 0
    else if(in_val==4'b0001) number_dec = 13'b0110000000000; // 1
    else if(in_val==4'b0010) number_dec = 13'b1101101000000; // 2
    else if(in_val==4'b0011) number_dec = 13'b1111001000000; // 3
    else if(in_val==4'b0100) number_dec = 13'b0110011000000; // 4
    else if(in_val==4'b0101) number_dec = 13'b1011011000000; // 5
    else if(in_val==4'b0110) number_dec = 13'b1011111000000; // 6
    else if(in_val==4'b0111) number_dec = 13'b1110010000000; // 7
    else if(in_val==4'b1000) number_dec = 13'b1111111000000; // 8
    else if(in_val==4'b1001) number_dec = 13'b1111011000000; // 9
    else number_dec = 13'b0000000000000;
  endfunction

  function [0:12] sign_dec; // 2비트 입력을 받아서 주먹,가위,보자기,invalid를 13비트로 변환해주는 함수이고 반환값은 sign_dec이다
    input [0:1] in_val;
    if(in_val==2'b00) sign_dec = 13'b0011101000111; // rock 
    else if(in_val==2'b01) sign_dec = 13'b0011101101010; // scissors
    else if(in_val==2'b10) sign_dec = 13'b0111111010000; // paper
    else if(in_val==2'b11) sign_dec = 13'b0000000101101; // invalid
    else sign_dec = 13'b0000000000000; 
  endfunction

  function isRock; //2비트 입력을 받아서 주먹인지 아닌지 판별한다
    input [0:1] in_val;
    if (in_val == ROCK) isRock = 1'b1;
    else isRock = 1'b0;
  endfunction

  function isScissors; //2비트 입력을 받아서 가위인지 아닌지 판별한다
    input [0:1] in_val;
    if (in_val == SCISSORS) isScissors = 1'b1;
    else isScissors = 1'b0;
  endfunction

  function isPaper; //2비트 입력을 받아서 보자기인지 아닌지 판별한다
    input [0:1] in_val;
    if (in_val == PAPER) isPaper = 1'b1;
    else isPaper = 1'b0;
  endfunction

  function isInvalid; //2비트 입력을 받아서 invalid인지 아닌지 판별한다
    input [0:1] in_val;
    if (in_val == INVALID) isInvalid = 1'b1;
    else isInvalid = 1'b0;
  endfunction  

  /* Implementation 4: display decoder */
assign SC_LDISP = number_dec(ASC); //ASC를 입력으로 받아서 13비트로 변환 후 SC_LDISP에 assign한다
assign SC_RDISP = number_dec(BSC); //BSC를 입력으로 받아서 13비트로 변환 후 SC_RDISP에 assign한다

function  isSign; //2비트 입력을 받아서 상태가 초기상태이거나 공격상태이면 1을 반환한다
    input [2:0] in_val;
    if (in_val == S_INIT || in_val == S_AATK || in_val == S_BATK ) isSign = 1;
    else isSign =0;
  endfunction


function [0:12] isResult_A; //2비트 입력을 받아서 상태가 A가 이겼거나 B가 이겼거나 비겼으면 13비트로 변환해주는 함수이다.
    input [2:0] in_val;
    if (in_val == S_AW ) isResult_A = 13'b0000001000000;
    else if ( in_val == S_BW) isResult_A = 13'b0000000001001;
    else if ( in_val == S_DRAW) isResult_A = 13'b0000001000000;
  endfunction

function [0:12] isResult_B; //2비트 입력을 받아서 상태가 A가 이겼거나 B가 이겼거나 비겼으면 13비트로 변환해주는 함수이다.
    input [2:0] in_val;
    if (in_val == S_BW ) isResult_B = 13'b0000001000000;
    else if ( in_val == S_AW) isResult_B = 13'b0000000100100;
    else if ( in_val == S_DRAW) isResult_B = 13'b0000001000000;
  endfunction


assign LDISP = (isSign(STAT)==1) ? sign_dec(AIN) : isResult_A(STAT);
assign RDISP = (isSign(STAT)==1) ? sign_dec(BIN) : isResult_B(STAT);
// 현재상태가 승부가 결정된 상태가 아니라면 AIN입력을 그대로 출력하고 승부가 결정된 상태라면 현재 승부를 결과로 출력한다
endmodule