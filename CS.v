`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
*/
module CS(Y, X, reset, clk);

input clk, reset; 
input [7:0] X;
output reg [9:0] Y;
reg [3:0]count;
reg [7:0]buffer[8:0];

wire [10:0]avg;
wire [7:0]smaller0, smaller1, smaller2, smaller3, smaller4, smaller5, smaller6, smaller7, smaller8, 
          com01, com23, com45, com67, 
          com03, com47,
          com07, com8;        
integer i;

assign avg = (buffer[0] + buffer[1] + buffer[2] + buffer[3] + buffer[4] + buffer[5] + buffer[6] + buffer[7] + buffer[8])/9; 

assign smaller0 = (buffer[0] <= avg)?buffer[0]:8'd0;
assign smaller1 = (buffer[1] <= avg)?buffer[1]:8'd0;
assign smaller2 = (buffer[2] <= avg)?buffer[2]:8'd0;
assign smaller3 = (buffer[3] <= avg)?buffer[3]:8'd0;
assign smaller4 = (buffer[4] <= avg)?buffer[4]:8'd0;
assign smaller5 = (buffer[5] <= avg)?buffer[5]:8'd0;
assign smaller6 = (buffer[6] <= avg)?buffer[6]:8'd0;
assign smaller7 = (buffer[7] <= avg)?buffer[7]:8'd0;
assign smaller8 = (buffer[8] <= avg)?buffer[8]:8'd0;

assign com01 = (smaller0 > smaller1)?smaller0:smaller1;
assign com23 = (smaller2 > smaller3)?smaller2:smaller3;
assign com45 = (smaller4 > smaller5)?smaller4:smaller5;
assign com67 = (smaller6 > smaller7)?smaller6:smaller7;

assign com03 = (com01 > com23)?com01:com23;
assign com47 = (com45 > com67)?com45:com67;

assign com07 = (com03 > com47)?com03:com47;

assign com8 = (com07 > smaller8)?com07:smaller8;

// find < avg from buffer and find the maximum 
always@(posedge clk)
begin
  if(reset)
    begin
      for(i = 0; i < 9; i = i + 1)
        buffer[i] <= 8'd0;    
  end  
  else
    begin
      for(i = 0; i < 8; i = i + 1)
          buffer[i+1] <= buffer[i]; 
      buffer[0] <= X;
  end
end
always@(negedge clk)
begin
  if(reset)
    begin
      count <= 4'd0; 
      Y <= 10'd0; 
  end  
  else
    begin
      if(count != 4'd8)
        begin     
          Y <= 10'd0;  
          count <= count + 4'd1;  
      end
      else
        begin
          count <= count;
          //if(buffer[0] == avg || buffer[1] == avg || buffer[2] == avg || buffer[3] == avg || buffer[4] == avg || buffer[5] == avg || buffer[6] == avg || buffer[7] == avg || buffer[8] == avg)
            //Y <= (((buffer[0] + buffer[1]) + (buffer[2] + buffer[3])) + ((buffer[4] + buffer[5]) + (buffer[6] + buffer[7])) + (buffer[8] + (avg * 9))) >> 3;
          //else
            //begin
                Y <= (buffer[0] + buffer[1] + buffer[2] + buffer[3] + buffer[4] + buffer[5] + buffer[6] + buffer[7] + buffer[8] + (com8 * 9)) >> 3;
          //end
      end
  end
end
endmodule