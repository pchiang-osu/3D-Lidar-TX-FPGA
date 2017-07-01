`timescale 1ns/1ns

//parallel to serial module, bottom module
module spi(input sclk, //spi clock
	input spi_rst,  //spi reset
	input [23:0] data, //input parallel data
	output reg sync,  //sync with overall module
	output reg din);  //output serial data

reg [23:0] data_buffer;
reg [4:0] spi_counter;

	always @(posedge sclk, negedge spi_rst)
	begin
		if(~spi_rst)
		begin  //initializing
			spi_counter <= 5'd1;
			din <= 1'dz; 
			sync <= 1'd1;
			data_buffer <= data;
		end
		else begin
		if(spi_counter < 5'd24)	//spi counter, 24 bits every time
		begin  //serial transmitting
			sync <= 1'b0;
			din <= data_buffer[23];
			data_buffer <= data_buffer << 1;
			spi_counter <= spi_counter+1'b1;
			end
			else begin  //reset
				sync <= 1'b1;
				spi_counter <= 1'b0;
				data_buffer <= data;
			end
		end
	end
endmodule