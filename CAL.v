`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:09 12/01/2016 
// Design Name: 
// Module Name:    CAL 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CAL(
		input clk1,
		input BTN_SOUTH,	//reset
		input BTN_WEST,		//square root
		input BTN_EAST,		//multiplication
		input BTN_NORTH,	//addition
		input SW_0,
		input SW_1,
		input SW_2,
		input SW_3,
		output reg [7:0]LED
    );
	
parameter IDLE=0;
parameter INPUT=1;
parameter OUTPUT=2;

reg [1:0]current_state,next_state;
reg [1:0]operator,operator2;
reg [22:0]count;
reg flag1,flag2,flag3,flag4;
reg f1,f2,f3,f4;
reg [3:0]sum;
reg [7:0]sum2;
wire [7:0]in;
wire [7:0]ans;
wire clk;

assign in=LED;
sqrt s(
	.x_in(in), // input [7 : 0] x_in
	.x_out(ans), // output [7 : 0] x_out
	.clk(clk) // input clk
);

always @ (posedge clk1)
	count<=count+1'b1;
assign clk=count[22];

always@(posedge clk) begin
	if(BTN_SOUTH)
		current_state=IDLE;
	else 
		current_state=next_state;
end

always@(*) begin 
	case(current_state)
		IDLE:	next_state=INPUT;
		INPUT: begin
			if(!BTN_WEST&&!BTN_EAST&&!BTN_NORTH)
				next_state=INPUT;
			else
				next_state=OUTPUT;
		end
		OUTPUT: begin
			if(BTN_SOUTH)
				next_state=IDLE;
			else
				next_state=OUTPUT;
		end
		default:next_state=IDLE;
	endcase
end

always@(posedge clk) begin
	if(BTN_SOUTH)
		operator=0;
	else begin
		if(current_state==INPUT||current_state==OUTPUT) begin
			if(BTN_WEST) begin
					operator=1;
			end
			else if(BTN_NORTH) begin
					operator=2;
			end
			else if(BTN_EAST) begin
					operator=3;
			end
			else
				operator=operator;
		end
		else
			operator=operator;
	end
end

always@(posedge clk1) begin
	if(BTN_SOUTH) 
		operator2=0;
	else if(operator==1) begin
		if(!BTN_WEST)
			operator2=1;
		else
			operator2=0;
	end
	else if(operator==2) begin
		if(!BTN_NORTH)
			operator2=2;
		else
			operator2=0;
	end
	else if(operator==3) begin
		if(!BTN_EAST)
			operator2=3;
		else 
			operator2=0;
	end
	else
		operator2=operator2;
end

always@(posedge clk) begin
	if(BTN_SOUTH) begin
		f1=0;
	end
	else begin
		if(current_state==OUTPUT) begin
			if(!f1)
				f1=1;
			else if((8*SW_3+4*SW_2+2*SW_1+SW_0)!=sum)
				f1=0;			
			else
				f1=f1;
		end
		else begin
			f1=f1;
		end
	end
end

always@(posedge clk) begin
	if(BTN_SOUTH) begin
		f2=0;
	end
	else begin
		if(current_state==OUTPUT) begin
			if(f2)
				f2=0;
			else if(BTN_EAST||BTN_NORTH||BTN_WEST)
				f2=1;			
			else
				f2=f2;
		end
		else begin
			f2=f2;
		end
	end
end

always@(posedge clk) begin
	if(BTN_SOUTH) begin
		f3=0;
	end
	else begin
		if(current_state==OUTPUT) begin
			if(f3)
				f3=0;
			else if(f2)
				f3=1;			
			else
				f3=f3;
		end
		else begin
			f3=f3;
		end
	end
end

always@(posedge clk) begin
	if(BTN_SOUTH)
		sum=0;
	else begin
		if(current_state==OUTPUT) begin
			if(!f1)
				sum=(8*SW_3+4*SW_2+2*SW_1+SW_0);
			else
				sum=sum;
		end
	end
end

always@(posedge clk) begin
	if(BTN_SOUTH)
		sum2=0;
	else begin
		if(current_state==INPUT) begin
			sum2=LED;
		end
		else if(f2)
			sum2=LED;
		else
			sum2=sum2;
	end
end

always@(posedge clk) begin
	if(BTN_SOUTH)
			LED=0;
	else begin
		if(current_state==INPUT) begin
			LED=8*SW_3+4*SW_2+2*SW_1+SW_0;
		end
		else if(current_state==OUTPUT) begin
			case(operator2)
				1: begin
					if(!f1) begin
						LED=ans;
					end
					if(f3) begin
						LED=ans;
					end
					else
						LED=LED;
				end
				2:begin
					if(!f1) begin
						LED=sum2*(8*SW_3+4*SW_2+2*SW_1+SW_0);				
					end
					if(f3)
						LED=sum2*(8*SW_3+4*SW_2+2*SW_1+SW_0);
					else
						LED=LED;
				end
				3:begin
					if(!f1)
						LED=LED+(8*SW_3+4*SW_2+2*SW_1+SW_0)-sum;
					if(f3)
						LED=LED+(8*SW_3+4*SW_2+2*SW_1+SW_0);
					else
						LED=LED;
				end
				default:LED=LED;
			endcase
		end
		else
			LED=LED;
	end
end
endmodule
