`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
*/
module CS(Y, X, reset, clk);

input clk, reset; 
input [7:0] X;
output [9:0] Y;

reg [3:0] count;
reg [7:0] buff[8:0];
reg [9:0] Y;
reg [10:0] x_sum0;

wire [10:0] x_sum = x_sum0 - buff[8] + X;
wire [10:0] x_avg = x_sum/9;

wire [7:0] cmp0 = (buff[0] <= x_avg)? buff[0]:0;
wire [7:0] cmp1 = (buff[1] <= x_avg)? buff[1]:0;
wire [7:0] cmp2 = (buff[2] <= x_avg)? buff[2]:0;
wire [7:0] cmp3 = (buff[3] <= x_avg)? buff[3]:0;
wire [7:0] cmp4 = (buff[4] <= x_avg)? buff[4]:0;
wire [7:0] cmp5 = (buff[5] <= x_avg)? buff[5]:0;
wire [7:0] cmp6 = (buff[6] <= x_avg)? buff[6]:0;
wire [7:0] cmp7 = (buff[7] <= x_avg)? buff[7]:0;
wire [7:0] cmp8 = (X <= x_avg)? X:0;

wire [7:0] cmp01 = (cmp0 > cmp1)? cmp0:cmp1;
wire [7:0] cmp23 = (cmp2 > cmp3)? cmp2:cmp3;
wire [7:0] cmp45 = (cmp4 > cmp5)? cmp4:cmp5;
wire [7:0] cmp67 = (cmp6 > cmp7)? cmp6:cmp7;

wire [7:0] cmp03 = (cmp01 > cmp23)? cmp01:cmp23;
wire [7:0] cmp47 = (cmp45 > cmp67)? cmp45:cmp67;

wire [7:0] cmp07 = (cmp03 > cmp47)? cmp03:cmp47;
wire [7:0] cmp08 = (cmp07 > cmp8)? cmp07:cmp8;
wire [12:0] out = x_sum + cmp08 + (cmp08 << 3);

always@(posedge clk)
begin

	if(!reset)
	begin
	
		buff[8] <= buff[7];
		buff[7] <= buff[6];
		buff[6] <= buff[5];
		buff[5] <= buff[4];
		buff[4] <= buff[3];
		buff[3] <= buff[2];
		buff[2] <= buff[1];
		buff[1] <= buff[0];
		buff[0] <= X;
		
		Y <= (count == 4'd8)? out[12:3]:10'd0;
		count <= (count == 4'd8)? count:count + 4'd1;
		
		x_sum0 <= x_sum;
	
	end
	else
	begin
	
		count <= 4'd0;
		x_sum0 <= 11'd0;
		buff[0] <= 8'd0;
		buff[1] <= 8'd0;
		buff[2] <= 8'd0;
		buff[3] <= 8'd0;
		buff[4] <= 8'd0;
		buff[5] <= 8'd0;
		buff[6] <= 8'd0;
		buff[7] <= 8'd0;
		buff[8] <= 8'd0;
	
	end

end


endmodule
