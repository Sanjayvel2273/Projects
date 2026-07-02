// Testbench  is here

module test();
  reg clk,rst;
  reg [7:0] data_in;
  reg wr_en;
  reg [3:0] wr_addr; 
  reg [3:0] rd_addr;
  reg rd_en;
  wire [7:0] data_out;
  
  ram8x8 dut  (.clk(clk),.rst(rst),.data_in(data_in),.wr_en(wr_en),.wr_addr(wr_addr),.rd_en(rd_en),.rd_addr(rd_addr),.data_out(data_out));
  
initial begin
  clk=0;
  rst=0;
  data_in=0;
  wr_en=0;
  wr_addr=0;
  rd_en=0;
  rd_addr=0;
end
  
always #5 clk = ~ clk;

initial begin
  
$dumpfile ("ram8x8.vcd");
$dumpvars (0,test); 
  
    rst = 1;
    #10 rst = 0;

    wr_en = 1;
    wr_addr = 3'b100;
    data_in = 8'd5;
    #10;

    wr_en = 1;
    wr_addr = 3'b101;
    data_in = 8'd10;
    #10;

    wr_en = 0;
    rd_en = 1;
    rd_addr = 3'b100;
    #10;

    wr_en = 0;
    rd_en = 1;
    rd_addr = 3'b101;
    #10;

    $finish;
end

endmodule
      

