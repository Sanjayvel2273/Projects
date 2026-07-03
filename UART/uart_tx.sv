`timescale 1ns/1ps
module uart_tx #(
    parameter CLKS_PER_BIT = 87
)(
    input  logic       clk,
    input  logic       rst,
    input  logic       tx_start,
    input  logic [7:0] tx_data,

    output logic       tx,
    output logic       tx_busy,
    output logic       tx_done
);

typedef enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT,
    CLEANUP
} state_t;

state_t state;

logic [7:0] data_reg;
logic [2:0] bit_index;
logic [$clog2(CLKS_PER_BIT):0] clk_count;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 0;
        tx_done <= 0;
        clk_count <= 0;
        bit_index <= 0;
    end
    else begin

        tx_done <= 0;

        case(state)

        IDLE: begin
            tx <= 1'b1;
            tx_busy <= 0;
            clk_count <= 0;

            if(tx_start) begin
                data_reg <= tx_data;
                tx_busy <= 1;
                state <= START_BIT;
            end
        end

        START_BIT: begin
            tx <= 0;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                bit_index <= 0;
                state <= DATA_BITS;
            end
        end

        DATA_BITS: begin

            tx <= data_reg[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                    state <= STOP_BIT;
            end
        end

        STOP_BIT: begin

            tx <= 1;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                tx_done <= 1;
                tx_busy <= 0;
                state <= CLEANUP;
            end
        end

        CLEANUP:
            state <= IDLE;

        endcase
    end
end

endmodule
