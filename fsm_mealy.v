`timescale 1ns / 1ps

//책 예제
module fsm_mealy(
    input clk,
    input rst,
    input din_bit,
    output dout_bit
    );

    reg [2:0] state_reg, next_state;

    parameter start = 3'b000, rd0_once = 3'b001, rd1_once = 3'b010;
    parameter rd0_twice = 3'b011, rd1_twice = 3'b100;

    always @(state_reg or din_bit) begin
        case (state_reg)
            start: if (din_bit == 0) begin
                next_state = rd0_once;
            end else if (din_bit == 1) begin
                next_state = rd1_once;
            end else begin
                next_state = start;
            end
            rd0_once: if (din_bit == 0) begin
                next_state = rd0_twice;
            end else if (din_bit == 1) begin
                next_state = rd1_once;
            end else begin
                next_state = start;
            end
            rd0_twice: if (din_bit == 0) begin
                next_state = rd0_twice;
            end else if (din_bit == 1) begin
                next_state = rd1_once;
            end else begin
                next_state = start;
            end
            rd1_once: if (din_bit == 0) begin
                next_state = rd0_once;
            end else if (din_bit == 1) begin
                next_state = rd1_twice;
            end else begin
                next_state = start;
            end
            rd1_twice: if (din_bit == 0) begin
                next_state = rd0_once;
            end else if (din_bit == 1) begin
                next_state = rd1_twice;
            end else begin
                next_state = start;
            end
            default: next_state = start;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst == 1) begin
            state_reg <= start;
        end else begin
            state_reg <= next_state;
        end
    end

    assign dout_bit = (((state_reg == rd0_twice) && (din_bit == 0) || 
                        (state_reg == rd1_twice) && (din_bit == 1))) ? 1: 0;

endmodule
