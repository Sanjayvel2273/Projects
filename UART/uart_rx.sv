`timescale 1ns/1ps
module uart_rx #(
    parameter CLKS_PER_BIT = 87
)(
    input logic clk,
    input logic rst,
    input logic rx,

    output logic [7:0] rx_data,
    output logic rx_done
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

    if(rst) begin
        state <= IDLE;
        rx_done <= 0;
    end
    else begin

        rx_done <= 0;

        case(state)

        IDLE: begin

            if(rx == 0) begin
                clk_count <= 0;
                state <= START_BIT;
            end
        end

        START_BIT: begin

            if(clk_count == (CLKS_PER_BIT/2)) begin

                if(rx == 0) begin
                    clk_count <= 0;
                    bit_index <= 0;
                    state <= DATA_BITS;
                end
                else
                    state <= IDLE;

            end
            else
                clk_count <= clk_count + 1;

        end

        DATA_BITS: begin

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin

                clk_count <= 0;
                data_reg[bit_index] <= rx;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                    state <= STOP_BIT;

            end

        end

        STOP_BIT: begin

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin

                rx_data <= data_reg;
                rx_done <= 1;
                clk_count <= 0;
                state <= CLEANUP;

            end

        end

        CLEANUP:
            state <= IDLE;

        endcase 

    end

end

endmodule
