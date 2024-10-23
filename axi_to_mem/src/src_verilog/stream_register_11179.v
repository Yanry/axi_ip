module stream_register_11179 (
	clk_i,
	rst_ni,
	clr_i,
	testmode_i,
	valid_i,
	ready_o,
	data_i,
	valid_o,
	ready_i,
	data_o
);
	input wire clk_i;
	input wire rst_ni;
	input wire clr_i;
	input wire testmode_i;
	input wire valid_i;
	output wire ready_o;
	input wire [7:0] data_i;
	output reg valid_o;
	input wire ready_i;
	output reg [7:0] data_o;
	wire reg_ena;
	assign ready_o = ready_i | ~valid_o;
	assign reg_ena = valid_i & ready_o;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			valid_o <= 1'b0;
		else if (clr_i)
			valid_o <= 1'b0;
		else if (ready_o)
			valid_o <= valid_i;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			data_o <= 8'b00000000;
		else if (clr_i)
			data_o <= 8'b00000000;
		else if (reg_ena)
			data_o <= data_i;
endmodule
