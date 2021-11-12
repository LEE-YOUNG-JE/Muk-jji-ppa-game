module Vr_HW3_RSP (CLK, RST, AIN, BIN, AS, BS, STAT);
  /* I/O interface */
  input CLK, RST; //입력으로 CLK, RST를 받는다
  input [0:1] AIN, BIN; // 입력으로 AIN,BIN 가위바위보를 입력받는다
  input AS, BS; // 두 번 연속 냈는지 확인하는 AS,BS 입력받는다
  output [2:0] STAT; // 출력으로 지금 상태를 출력한다

  reg [2:0] S_reg, S_next; /* state memory and next state signals */ //지금 상태를 S_reg, 다음 상태를 S_next로 정의한다
  reg [0:1] a_prev, b_prev; /* previous a, b values */ //현재 들어온 AIN,BIN값을 a_prev,b_prev에 저장하기 위해 선언한다

  /* state declarations */
  parameter [2:0] S_INIT = 3'b000, //초기상태
                  S_AATK = 3'b001, //A가 공격권인 상태
                  S_BATK = 3'b010, //B가 공격권인 상태
                  S_AW = 3'b011, //A가 이긴상태
                  S_BW = 3'b100, //B가 이긴상태
                  S_DRAW = 3'b101; //A,B가 비긴상태
		  

  /* RSP */
  parameter [0:1] ROCK=2'b00, SCISSORS=2'b01, PAPER=2'b10, INVALID=2'b11;


  /* Implementation 1: main FSM */


always @(posedge CLK ) begin //CLK이 올라갈 때 마다 always 구문이 실행된다
S_reg <= S_next; // CLK이 실행될 때마다 S_next를 S_reg에 넣는다.
a_prev <= AIN; // 현재 AIN값을 a_prev에 저장하여 다음에 비교할 수 있게한다
b_prev <= BIN; // 현재 BIN값을 b_prev에 저장하여 다음에 비교할 수 있게한다
end

always @(posedge CLK) begin //CLK가 올라갈 때마다 always가 실행된다
if(RST ==1) begin //RST가 1일때
S_reg <= S_INIT; //S_reg에 S_INIT을 초기화한다
a_prev <= 2'b00; //a_prev에 2‘b00으로 초기화한다
b_prev <= 2'b00; //b_prev에 2‘b00으로 초기화한다
end
end


always @(*) begin //모든 상황에서 always가 실행된다
case(S_reg) //S_reg의 상태를 case로 나눠서 실행한다
S_INIT : //S_reg가 S_INIT일 때
	if(AIN == INVALID && BIN == INVALID) S_next = S_DRAW;
//AIN이 INVALID이고 BIN도 INVALID일 때 우선순위가 가장높고 그 때 S_DRAW를 저장
	else if(AIN == INVALID && BIN != INVALID) S_next = S_BW;
//AIN이 INVALID이고 BIN이 INVALID가 아니면 B가 이긴것이므로 S_BW를 저장
	else if(AIN != INVALID && BIN == INVALID) S_next = S_AW;
//AIN이 INVALID가 아니고 BIN이 INVALID이면 A가 이긴것이므로 S_AW를 저장
	else if(AS ==1 && BS==1 && AIN == a_prev && BIN == b_prev) S_next = S_DRAW;//AS,BS모두 1이고 AIN,BIN이 이전값과 같다면 3번연속 입력된것이므로 S_DRAW를 저장
	else if(AS==1 && AIN == a_prev) S_next = S_BW;//AS가 1이고 AIN이 이전값과 같다면 A가 3번연속 같은 것을 낸 것이므로 B가 이겨서 S_BW를 저장
	else if(BS==1 && BIN == b_prev) S_next = S_AW; //BS가 1이고 BIN이 이전값과 같다면 B가 3번연속 같은 것을 낸 것이므로 A가 이겨서 S_AW를 저장
	else if(AIN == ROCK && BIN == SCISSORS) S_next = S_AATK; //AIN이 주먹 BIN이 가위이면 A가 이겼으므로 다음상태는 S_AATK이 된다
	else if(AIN == ROCK && BIN == PAPER) S_next = S_BATK; //AIN이 주먹 BIN이 보자기이면 B가 이겼으므로 다음상태는 S_BATK이 된다
	else if(AIN == ROCK && BIN == ROCK) S_next = S_INIT; //AIN이 주먹 BIN이 주먹이면 비겼으므로 다음상태는 S_INIT이 된다
	else if(AIN == SCISSORS && BIN == ROCK) S_next = S_BATK; //AIN이 가위이고 BIN이 주먹이면 B가 이겼으므로 다음상태는 S_BATK이 된다
	else if(AIN == SCISSORS && BIN == SCISSORS) S_next = S_INIT; 
//AIN이 가위 BIN이 가위이면 비겼으므로 다음상태는 S_INIT이 된다
	else if(AIN == SCISSORS && BIN == PAPER) S_next = S_AATK;
//AIN이 가위 BIN이 보자기이면 A가 이겼으므로 다음상태는 S_AATK 된다
	else if(AIN == PAPER && BIN == ROCK) S_next = S_AATK;
//AIN이 보자기 BIN이 주먹이면 A가 이겼으므로 다음상태는 S_AATK 된다
	else if(AIN == PAPER && BIN == SCISSORS) S_next = S_BATK;
//AIN이 보자기 BIN이 가위이면 B가 이겼으므로 다음상태는 S_BATK 된다
	else if(AIN == PAPER && BIN == PAPER) S_next = S_INIT;
//AIN이 보자기 BIN이 보자기이면 비겼으므로 다음상태는 S_INIT 된다
S_AATK : S_reg가 S_AATK일 때
	if(AIN == INVALID && BIN == INVALID) S_next = S_DRAW;
//AIN이 INVALID BIN이 INVALID이면 비겼으므로 다음상태는 S_DRAW 된다
	else if(AIN == INVALID && BIN != INVALID) S_next = S_BW;
//AIN이 INVALID BIN이 INVALID아니면 B가 이겼으므로 다음상태는 S_BW 된다
	else if(AIN != INVALID && BIN == INVALID) S_next = S_AW;
//AIN이 INVALID아니고 BIN이 INVALID이면 A가 이겼으므로 다음상태는 S_AW 된다
	else if(AS ==1 && BS==1 && AIN == a_prev && BIN == b_prev) S_next 
= S_DRAW;//AS,BS가 1이고 AIN,BIN이 이전값과 같다면 비겼으므로 다음상태는 S_DRAW이다
	else if(AS==1 && AIN == a_prev) S_next = S_BW;
//AS가 1이고 AIN이 이전값과 같다면 B가 이겼으므로 다음상태는 S_BW이다
	else if(BS==1 && BIN == b_prev) S_next = S_AW;
//BS가 1이고 BIN이 이전값과 같다면 A가 이겼으므로 다음상태는 S_AW이다
	else if(AIN == ROCK && BIN == SCISSORS) S_next = S_AATK;
//AIN이 주먹이고 BIN이 가위이면 다음상태는 S_AATK이다
	else if(AIN == ROCK && BIN == PAPER) S_next = S_BATK;
//AIN이 주먹이고 BIN이 보자기이면 다음상태는 S_BATK이다
	else if(AIN == ROCK && BIN == ROCK) S_next = S_AW;
//AIN이 주먹이고 BIN이 주먹이면 묵찌빠를 이겼으므로 다음상태는 S_AW이다
	else if(AIN == SCISSORS && BIN == ROCK) S_next = S_BATK;
//AIN이 가위이고 BIN이 주먹이면 다음상태는 S_BATK이다
	else if(AIN == SCISSORS && BIN == SCISSORS) S_next = S_AW;
//AIN이 가위이고 BIN이 가위이면 묵찌빠를 이겼으므로 다음상태는 S_BW이다
	else if(AIN == SCISSORS && BIN == PAPER) S_next = S_AATK;
//AIN이 가위이고 BIN이 보자기이면 다음상태는 S_AATK이다
	else if(AIN == PAPER && BIN == ROCK) S_next = S_AATK;
//AIN이 보자기이고 BIN이 주먹이면 다음상태는 S_AATK이다
	else if(AIN == PAPER && BIN == SCISSORS) S_next = S_BATK;
//AIN이 보자기이고 BIN이 가위이면 다음상태는 S_BATK이다
	else if(AIN == PAPER && BIN == PAPER) S_next = S_AW;
//AIN이 보자기이고 BIN이 보자기이면 묵찌빠를 이겼으므로 다음상태는 S_AW이다
	
S_BATK : //S_reg가 B공격권일 때
	if(AIN == INVALID && BIN == INVALID) S_next = S_DRAW;
//AIN이 INVALID BIN이 INVALID이면 비겼으므로 다음상태는 S_DRAW 된다
	else if(AIN == INVALID && BIN != INVALID) S_next = S_BW;
//AIN이 INVALID BIN이 INVALID가 아니면 B가 이겼으므로 다음상태는 S_BW 된다
	else if(AIN != INVALID && BIN == INVALID) S_next = S_AW;
//AIN이 INVALID아니고 BIN이 INVALID이면 A가 이겼으므로 다음상태는 S_AW 된다
	else if(AS ==1 && BS==1 && AIN == a_prev && BIN == b_prev) S_next = S_DRAW;//AS,BS가 1이고 AIN,BIN이 모두 이전값과 같다면 3번 연속이므로 다음상태는 S_DRAW이다
	else if(AS==1 && AIN == a_prev) S_next = S_BW; //AS가 1이고 AIN이 이전값과 같다면 B가 이긴것이므로 다음상태는 S_BW이다
	else if(BS==1 && BIN == b_prev) S_next = S_AW; //BS가 1이고 BIN이 이전값과 같다면 A가 이긴것이므로 다음상태는 S_AW이다
	else if(AIN == ROCK && BIN == SCISSORS) S_next = S_AATK; 
//AIN이 주먹이고 BIN이 가위이면 다음상태는 S_AATK이다
	else if(AIN == ROCK && BIN == PAPER) S_next = S_BATK;
//AIN이 주먹이고 BIN이 보자기이면 다음상태는 S_BATK이다
	else if(AIN == ROCK && BIN == ROCK) S_next = S_BW;
//AIN이 주먹이고 BIN이 주먹이면 B가 묵찌빠 이겼으므로 다음상태는 S_BW이다
	else if(AIN == SCISSORS && BIN == ROCK) S_next = S_BATK;
//AIN이 가위이고 BIN이 주먹이면 다음상태는 S_BATK이다
	else if(AIN == SCISSORS && BIN == SCISSORS) S_next = S_BW;
//AIN이 가위이고 BIN이 가위이면 B가 묵찌빠 이겼으므로 다음상태는 S_BW이다
	else if(AIN == SCISSORS && BIN == PAPER) S_next = S_AATK;
//AIN이 가위이고 BIN이 보자기이면 다음상태는 S_AATK이다

	else if(AIN == PAPER && BIN == ROCK) S_next = S_AATK;
//AIN이 보자기이고 BIN이 주먹이면 다음상태는 S_AATK이다
	else if(AIN == PAPER && BIN == SCISSORS) S_next = S_BATK;
//AIN이 보자기이고 BIN이 가위이면 다음상태는 S_BATK이다
	else if(AIN == PAPER && BIN == PAPER) S_next = S_BW;
//AIN이 보자기이고 BIN이 보자기이면 B가 묵찌빠 이겼으므로 다음상태는 S_BW이다
	
S_AW : S_next = S_INIT; //지금상태가 S_AW이면 다음상태는 무조건 S_INIT
S_BW : S_next = S_INIT; //지금상태가 S_BW이면 다음상태는 무조건 S_INIT
S_DRAW : S_next = S_INIT; //지금상태가 S_DRAW이면 다음상태는 무조건 S_INIT
default : S_next = S_INIT; //지금상태가 위에 있는 상태중에 어느 것도 해당 안 되면 이면 다음상태는 무조건 S_INIT

endcase
end

assign STAT = S_reg; //현재 상태 S_reg를 출력 STAT로 내보낸다
endmodule