`timescale 1 ns / 100 ps
module Vr_HW3_tb ();

  reg sig_clk, sig_rst; //sig_clk,sig_rst를 reg로 선언한다
  reg [0:1] sig_ain, sig_bin; //sig_ain,sig_bin을 2비트 reg로 선언한다
  wire [0:12] sig_ldisp, sig_rdisp, sig_sc_ldisp, sig_sc_rdisp; //13비트 wire을 선언한다

  parameter [0:1] ROCK=2'b00, SCISSORS=2'b01, PAPER=2'b10, INVALID=2'b11;


  /* main top-level file *///Vr_HW3를 uut로 instantiation하고 각 입력값에 위에 선언한 wire들을 넣는다
  Vr_HW3 uut (.CLK(sig_clk), .RST(sig_rst), .AIN(sig_ain), .BIN(sig_bin), .LDISP(sig_ldisp), .RDISP(sig_rdisp), .SC_LDISP(sig_sc_ldisp), .SC_RDISP(sig_sc_rdisp));

  /* display module *///VR_HW3_Disp를 u_disp로 instantiation하여 위에서 선언한 wire들을 알맞게 넣는다
  Vr_HW3_Disp u_disp (.CLK(sig_clk), .RST(sig_rst), .LDISP(sig_ldisp), .RDISP(sig_rdisp), .SC_LDISP(sig_sc_ldisp), .SC_RDISP(sig_sc_rdisp) );

  /* clock/reset generation */

  always begin //항상 실행되고 sig_clk는 10ns동안 1이고 10ns동안 0이다. 따라서 주기가 20ns인 CLK이다
    sig_clk = 1; #10;
    sig_clk = 0; #10;
  end

  always begin //처음15ns는 0으로하고 그 후에 1을 20ns유지하고 10000ns동안 0을 유지한다
    sig_rst = 0; #15;
    sig_rst = 1; #20;
    sig_rst = 0; #10000;
  end

  /* game playing scenarios */
  always begin 
    sig_ain = INVALID; sig_bin = INVALID; #35;//35ns동안 A,B에 INVALID를 넣는다
    sig_ain = ROCK; sig_bin = ROCK; #20;//20ns동안 A는 주먹 B는 주먹
    sig_ain = ROCK; sig_bin = SCISSORS; #20;//A는 주먹 B는 가위(A 공격권)
    sig_ain = PAPER; sig_bin = ROCK; #20;//A 보자기 B 주먹(A 공격권)
    sig_ain = PAPER; sig_bin = PAPER; #20;//A 보자기 B 보자기(A win)
    sig_ain = INVALID; sig_bin = INVALID; #20; //  A is expected to win the game here


    sig_ain = INVALID; sig_bin = ROCK; #20; // B is expected to win the game
    sig_ain = INVALID; sig_bin = INVALID; #20; 

    sig_ain = INVALID; sig_bin = INVALID; #20; // They are expected to draw
    sig_ain = INVALID; sig_bin = INVALID; #20;  //rule 2


    sig_ain = PAPER; sig_bin = SCISSORS; #20;
    sig_ain = ROCK; sig_bin = SCISSORS; #20;
    sig_ain = ROCK; sig_bin = PAPER; #20;
    sig_ain = ROCK; sig_bin = SCISSORS; #20; // B is expected to win the game
    sig_ain = INVALID; sig_bin = INVALID; #20;

    
    /* Implementation 6: complete the test bench to check more scenarios */

    sig_ain = ROCK; sig_bin = SCISSORS; #20;//rule3 > rule4을 검증한다
    sig_ain = ROCK; sig_bin = PAPER; #20;
    sig_ain = ROCK; sig_bin = INVALID; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20; //승부가 결정되고 나서 A가 주먹 3번연속냈고 B는 마지막에 INVALID를 냈는데 우선순위에 의하여 A가 이긴다


    sig_ain = ROCK; sig_bin = SCISSORS; #20;//rule5를 검증한다
    sig_ain = ROCK; sig_bin = SCISSORS; #20;
    sig_ain = ROCK; sig_bin = SCISSORS; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;//승부가 난 상태에서 서로 같은 것만 3번 내면 무승부가 된다

    sig_ain = ROCK; sig_bin = ROCK; #20;// rule1을 검증한다
    sig_ain = ROCK; sig_bin = ROCK; #20;
    sig_ain = ROCK; sig_bin = ROCK; #20;
    sig_ain = ROCK; sig_bin = PAPER; #20;
    sig_ain = ROCK; sig_bin = ROCK; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;//승부가 나지 않은 상태에서 A가 주먹을 계속내도 연속을 따지지 않고 승부가 결정되고 나서 같은 것을 내서 B가 이긴다

    sig_ain = ROCK; sig_bin = ROCK; #20;// rule1 attack change
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = SCISSORS; sig_bin = ROCK; #20;
    sig_ain = ROCK; sig_bin = SCISSORS; #20;
    sig_ain = ROCK; sig_bin = ROCK; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;//공격권이 A,B 번갈아가면서 바뀌어도 마지막에 공격권을 쥐고있는 상태에서 동시에 같은 것을 낸 A가 이긴다

    sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 4
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 5
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 6
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 7
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 8
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 9
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;

sig_ain = ROCK; sig_bin = SCISSORS; #20;// score 10
    sig_ain = PAPER; sig_bin = PAPER; #20;
    sig_ain = INVALID; sig_bin = INVALID; #20;//score가 10이 된 후에는 0으로 다시 간다
    
  end
  
endmodule