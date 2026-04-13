`timescale 1ns / 1ps

module fsm_led(
    input clk,
    input rst,
    input [2:0] sw,
    output reg [2:0] led
    );

    parameter STATE_A = 3'b000, STATE_B = 3'b001, STATE_C = 3'b010, STATE_D = 3'b011, STATE_E = 3'b100;

    //순차논리가 항상 설계의 중심임.
    //state register
    reg [2:0] current_state, next_state; //이거 놓치지마세연
    always @(posedge clk, posedge rst) begin //순차논리, assign ㄱㄴ
        if (rst) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    //nonblocking
    //next state Combinational Logic
    always @(*) begin //원래는 입력과 state 감시
        case (current_state)
            STATE_A : begin
                if (sw == 3'b001) begin
                    next_state = STATE_B; //조합논리니까 바로 바뀜. 지연x
                end else if (sw == 3'b010) begin
                    next_state = STATE_C;
                end else begin
                    next_state = current_state; //==STATE_A
                end
            end
            STATE_B : begin
                if (sw == 3'b010) begin
                    next_state = STATE_C;
                end else begin
                    next_state = current_state; 
                end
            end
            STATE_C : begin
                if (sw == 3'b100) begin
                    next_state = STATE_D;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_D : begin
                if (sw == 3'b111) begin
                    next_state = STATE_E;
                end else if (sw == 3'b000) begin
                    next_state = STATE_A;
                end else if (sw == 3'b001) begin
                    next_state = STATE_B;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_E : begin
                if (sw == 3'b000) begin
                    next_state = STATE_A;
                end else begin
                    next_state = current_state;
                end
            end
            default: next_state = current_state;
        endcase
    end

    // output Combinational Logic
    //assign led = (current_state == STATE_A) ? 3'b001 :
    //(current_state == STATE_B) ? 3'b010 : 3'b100;

    always @(*) begin
        case (current_state)
            STATE_A: led = 3'b000;
            STATE_B: led = 3'b001;
            STATE_C: led = 3'b010;
            STATE_D: led = 3'b100;
            STATE_E: led = 3'b111;
            default: led = 3'b000;
        endcase
    end

endmodule
