`timescale 1ns/1ns

module clockpll(input clkin,
	input ncr,
	output reg clk,
	output reg clk2/*,
	output reg laserclk*/);

	reg [15:0] count;
	reg [15:0] count2;
	//reg [31:0] count3;

	always @(posedge clkin, negedge ncr)
	begin
		if(~ncr)
		begin
			count<=16'd0;
			clk<=1'b0;
		end
		else begin
			if(count == 16'd4166)
			begin
				count <= 16'd0;
				clk <= ~clk;
			end
			else count <= count+1'b1;
		end
	end

	always @(posedge clkin, negedge ncr)
	begin
		if(~ncr)
		begin
			count2<=16'd0;
			clk2<=1'b0;
		end
		else begin
			if(count2 == 16'd255)
			begin
				count2 <= 16'd0;
				clk2 <= ~clk2;
			end
			else count2 <= count2+1'b1;
		end
	end

	/*always @(posedge clkin, negedge ncr)
	begin
		if(~ncr)
		begin
			count3<=32'd0;
			laserclk<=1'b0;
		end
		else begin
			if(count3 == 32'd2499999)
			begin
				count3 <= 32'd0;
				laserclk <= ~laserclk;
			end
			else count3 <= count3+1'b1;
		end
	end*/

	endmodule

