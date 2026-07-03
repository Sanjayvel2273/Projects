`timescale 1ns/1ps

module uart_tb;

parameter CLKS_PER_BIT = 10;

logic clk;
logic rst;

logic tx_start;
logic [7:0] tx_data;

logic tx;
logic tx_busy;
logic tx_done;

logic [7:0] rx_data;
logic rx_done;

always #5 clk = ~clk;

uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) TX (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);

uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) RX (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

initial begin

    clk = 0;
    rst = 1;
    tx_start = 0;

    #50;
    rst = 0;

    @(posedge clk);
    tx_data = 8'hA5;
    tx_start = 1;

    @(posedge clk);
    tx_start = 0;

    wait(rx_done);

    if(rx_data == 8'hA5)
        $display("PASS Received = %h", rx_data);
    else
        $display("FAIL Received = %h", rx_data);

    #100;
    $finish;

end

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
end

endmodule
