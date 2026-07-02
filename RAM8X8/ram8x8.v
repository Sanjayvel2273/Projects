// Top module design here
module ram8x8(
  input clk, rst,
  input [7:0] data_in,
  input wr_en,
  input [3:0] wr_addr,
  input rd_en,
  input [3:0] rd_addr,
  output reg [7:0] data_out);
  
reg [7:0] mem [0:7];
integer i;
  
  
  always@(posedge clk or posedge rst)
    begin
      if (rst) begin
        for(i=0;i<7;i=i+1)
          mem[i]<=0;
        end
      else if(wr_en)
        mem [wr_addr] <= data_in;
      else if(rd_en)
        data_out <= mem [rd_addr];
    end
  
endmodule
