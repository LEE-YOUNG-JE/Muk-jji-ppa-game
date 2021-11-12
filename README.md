# Muk-jji-ppa-game

# the overview of my design
묵찌빠를 verilog로 구현하여 실제로 게임을 진행시켜서 score를 기록하는 것이다. 
큰 틀은 CLK,RST,AIN,BIN을 입력으로 받고 CLK가 올라갈 때마다 AIN,BIN의 결과에 따라서 LDISP,RDISP에 상황을 출력하고 승부가 났으면 SC_DISP에 출력하는 것이다. 

좀 더 세부적으로 들어가보면 묵찌빠의 기존 룰과 추가적인 룰을 구현하기 위해서 Series를 확인하는 틀과 실제로 승부를 결정짓는 main RSP와 SCORE를 올려주는 틀과 마지막으로 현재 상황과 점수를 출력해주는 틀로 총 5가지로 구현하였다. 

추가적인 룰에서 공격권이 정해진 상태에서 세 번 연속 같은 것을 낸 경우에 상대방이 이기는 룰이 있는데 이것을 구현하기 위해서 STAT가 공격권이 주어진 상태인지 확인한 후, Series에서 같은 것이 두 번 연속 입력됐는지 확인하고 맞다면 main RSP에 1을 보내도록 구현하였다. 

그리고 나서 1을 받고 난 후, main RSP에서 AIN과 이전에 입력되었던 a_prev가 같다면 3번 연속 입력됐다는 뜻이므로 STAT를 바로 S_BW를 출력하도록 구현하였다. 

Series에서 3번연속인 것을 체크안하고 2번만 한 이유는 3번 확인하고 나서 1을 보내면 이미 main RSP에서는 AIN을 받고나서 승부가 결정된 상태가 되기 때문에 출력이 한 칸 밀리는 상황이 발생한다. 

따라서 Series에서 2번만 체크하고 main RSP에서 직접 3번 연속인지 바로 확인하여 출력하도록 하였다. 가위바위보를 하고 있는 상태에서 연속인지 판단하는 것은 유효하지 않으므로 STAT가 공격하고 있는 상태가 아니라면 AS,BS가 0을 assign하게 설계하였고 공격권이 있는 상태라면 Series와 main RSP를 AS,BS로 assign하는 방식으로 설계해서 가위바위보할 때는 연속을 고려하지 않도록 하였다.

그리고 모든 경우에 RST이 1일 때 초기화 되게 설계하였다. 마지막으로 score가 9를 초과한 경우에 0으로 가게 하였다. 



# 결과화면
![image](https://user-images.githubusercontent.com/76897007/141432893-1e3d355a-34e0-456d-9cc4-b45c58ed7ca9.png)
![image](https://user-images.githubusercontent.com/76897007/141432919-18106c8f-0687-480e-9700-dab3dbe1bc3d.png)
