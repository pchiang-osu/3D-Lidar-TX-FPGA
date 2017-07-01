`timescale 1ns/1ns

//top spi module
module spi_test(input fpgaclock, //fpgaclock, 50MHz
	input rst, //overall reset
	output reg sclk, //output spi clock for the high voltage converter spi registers
	output reg sync, //output spi synchronize signal for the high voltage converter spi registers
	output reg din,  //output spi data for the high voltage converter spi registers
	output reg fclk, 
	output reg pulsepin1, //two pins for laser - one high, one swinging between high and low
	output reg pulsepin2);

reg [23:0] input_buffer;

wire [23:0] data_buffer = input_buffer;

reg [23:0] inidata_1 = 24'b001010010000000000000001; //spi register initializing

reg [23:0] inidata_2 = 24'b001110010000000000000001;

reg [23:0] inidata_3 = 24'b001000000000000000001111;

reg [23:0] inidata_4 = 24'b001100000000000000000000;

reg [23:0] data_1 = 24'b000000000110111000101110;

reg [23:0] data_2 = 24'b000000010110111000101110;

reg [23:0] data_3 = 24'b000000100110111000101110;

reg [23:0] data_4 = 24'b000100110110111000101110;

reg [15:0] counter;

wire clock;
wire clock2;
//wire laserclock;
wire din_wire;
wire sync_wire;

reg loop = 1'b1; //loop marks
reg flag = 1'b0;

reg init = 1'b1;

reg [7:0] hori_counter;

reg [11:0] verti_counter;

reg [3:0] serial_counter;

reg [23:0] pin1_A_xplus = 24'b000000000000110110111001;  //initial value of x+

reg [23:0] pin2_B_xminu = 24'b000000011100111000111100;  //initial value of x-

reg [23:0] pin3_C_yminu = 24'b000000100000110110111001;  //initial value of y-

reg [23:0] pin4_D_yplus = 24'b000100111100111000111100;  //initial value of y+

reg [23:0] step = 24'b000000000000010011010000; //step between each scanning points


	clockpll pll(.clkin(fpgaclock),
		.ncr(rst),
		.clk(clock),
		.clk2(clock2)/*,
		.laserclock(laserclock)*/);

	spi spi_I1(.sclk(clock2),
		.spi_rst(rst),
		.data(data_buffer),
		.sync(sync_wire),
		.din(din_wire));

	always@(posedge fpgaclock)
	begin
		fclk <= clock;
		sclk <= clock2;
		din <= din_wire;
		sync <= sync_wire;
	end


	always @(posedge clock2,negedge rst) begin
		if (~rst) begin
			// reset
			input_buffer <= inidata_1;
			counter <= 16'b0;
			pulsepin1 <= 1'b1;
		    pulsepin2 <= 1'b1;
		    

		end
		else begin    //initialize the registers
		

		if(counter == 16'd24) begin
			input_buffer <= inidata_2;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd49) begin
			input_buffer <= inidata_3;
			counter <= counter + 1'b1;
			
		end
		else if(counter == 16'd74) begin
			input_buffer <= inidata_4;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd99) begin
			input_buffer <= data_1;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd124) begin
			input_buffer <= data_2;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd149) begin
			input_buffer <= data_3;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd174) begin
			input_buffer <= data_4;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd198) begin
		init <= 1'b0;
		loop <= 1'b0;
		counter <= counter + 1'b1;
		end
		else if(counter == 16'd199) begin
			input_buffer <= pin1_A_xplus;
			pulsepin1 <= ~pulsepin1;
			pulsepin2 <= 1'b1;
			counter <= counter + 1'b1;
			
		end
		else if(counter == 16'd224) begin
			input_buffer <= pin2_B_xminu;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd249) begin
			input_buffer <= pin3_C_yminu;
			pulsepin1 <= ~pulsepin1;
			pulsepin2 <= 1'b1;
			counter <= counter + 1'b1;
		end
		else if(counter == 16'd274) begin
			input_buffer <= pin4_D_yplus;
			counter <= counter + 1'b1;
			//init <= 1'b0;
		end
		else if(counter == 16'd299) begin
			input_buffer <= pin1_A_xplus;
			counter <= 16'd200;
			pulsepin1 <= ~pulsepin1;
			pulsepin2 <= 1'b1;
		end
		else begin
			counter <= counter + 1'b1;
		end
		if(verti_counter == 16'd1681) loop <= 1'd1;
		if(verti_counter == 16'd0) loop <= 1'd0;
		end

		
	end

	always @(negedge sync_wire,negedge rst) begin
		if (~rst) begin
			// reset
			hori_counter <= 8'b0;
		    verti_counter <= 12'd0;
		    serial_counter <= 4'd0;
			pin1_A_xplus <= 24'b000000000000110110111001;

			pin2_B_xminu <= 24'b000000011100111000111100;

			pin3_C_yminu <= 24'b000000100000110110111001;

			pin4_D_yplus <= 24'b000100111100111000111100;

		end
		else if(init == 0)begin     //send the serial voltage swing
				if(loop == 1'd1) begin
					pin1_A_xplus <= 24'b000000000000110110111001;

			pin2_B_xminu <= 24'b000000011100111000111100;

			pin3_C_yminu <= 24'b000000100000110110111001;

			pin4_D_yplus <= 24'b000100111100111000111100;

			flag <= ~flag;

			if(verti_counter == 12'd1681)begin
				verti_counter<=12'd0;
				end


			
				end
				else begin
				serial_counter <= serial_counter + 1'b1;

				if(serial_counter == 4'd3) begin
					verti_counter <= verti_counter + 12'd1;

				end

				if(serial_counter == 4'd4) begin serial_counter <= 4'd1;
				

			
				if(flag == 1'b0) begin
					
					pin1_A_xplus <= pin1_A_xplus + step;
					pin2_B_xminu <= pin2_B_xminu - step;
					
					hori_counter <= hori_counter + 1'b1;
					

				end
				else begin
				
					pin1_A_xplus <= pin1_A_xplus - step;
					pin2_B_xminu <= pin2_B_xminu + step;

					hori_counter <= hori_counter + 1'b1;
					
				end
				if(hori_counter == 8'd40) begin
					flag <= ~flag;
					
					
					hori_counter <= 8'b0;
					pin1_A_xplus <= pin1_A_xplus;
					pin2_B_xminu <= pin2_B_xminu;
					pin3_C_yminu <= pin3_C_yminu + step;
					pin4_D_yplus <= pin4_D_yplus - step;
					

				
				end

				
				
			
end
			end
		end
	end
	endmodule
