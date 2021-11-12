module Vr_HW3_Series (CLK, RST, V, S);
  /* I/O interface */
  input CLK, RST; //CLK,RST를 입력으로 받는다
  input [0:1] V; //2비트 입력인 가위,바위,보,invalid를 V로 받는다
  output S; //연속인지 판단하고 출력 S로 내보낸다

  /* parameterizable length threshold */
  parameter integer len = 1; //이전 값과 현재값만 비교하고 바로 내보낼 것이므로 len의 길이는 1로 선언하였다

  integer cnt;
  reg [0:1] prev_v; 


  /* Implementation 2: Series detector */
initial
cnt = 0; //처음에 cnt는 0으로 정의한다
 
always @(posedge CLK) begin //CLK가 올라갈 때만 always가 실행된다
if((cnt == len)) cnt = 0; //cnt가 len과 같다면 연속이 판단돼서 출력이 됐으므로 0으로 다시 초기화 한다

if((V==prev_v && V!=2'b11)) begin //지금들어온 값 V가 이전 값 prev_v와 같고 지금값이 invalid가 아니라면 cnt를 1씩 더한다
cnt <= cnt+1;
prev_v <= V; // 그리고 현재값을 prev_v에 저장한다
end
else prev_v = V; // 위의 조건이 실행되지 않더라도 이전값에 저장한다
end

always @(posedge RST) begin // RST가 올라갈 때마다 실행된다
if((RST ==1)) cnt = 0; // RST가 1이면 cnt를 0으로 초기화한다
end


assign S = (cnt==len) ? 1 : 0;  //cnt가 len와 같다면 연속이므로 1으로 출력으로 내보내고 아니면 0을 내보낸다
endmodule