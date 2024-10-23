module stream_mux_EC5E5_37FC7 (
	inp_data_i,
	inp_valid_i,
	inp_ready_o,
	inp_sel_i,
	oup_data_o,
	oup_valid_o,
	oup_ready_i
);
	parameter [31:0] DATA_T_AddrWidth = 0;
	parameter [31:0] DATA_T_DataWidth = 0;
	parameter [31:0] DATA_T_IdWidth = 0;
	parameter [31:0] DATA_T_UserWidth = 0;
	reg _sv2v_0;
	parameter integer N_INP = 0;
	parameter integer LOG_N_INP = $clog2(N_INP);
	input wire [(((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) >= 0 ? (N_INP * ((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 11)) - 1 : (N_INP * (1 - ((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10))) + ((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 9)):(((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) >= 0 ? 0 : (((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10)] inp_data_i;
	input wire [N_INP - 1:0] inp_valid_i;
	output reg [N_INP - 1:0] inp_ready_o;
	input wire [LOG_N_INP - 1:0] inp_sel_i;
	output wire [(((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10:0] oup_data_o;
	output wire oup_valid_o;
	input wire oup_ready_i;
	always @(*) begin
		if (_sv2v_0)
			;
		inp_ready_o = 1'sb0;
		inp_ready_o[inp_sel_i] = oup_ready_i;
	end
	assign oup_data_o = inp_data_i[(((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) >= 0 ? 0 : (((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) + (inp_sel_i * (((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) >= 0 ? (((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 11 : 1 - ((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10)))+:(((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10) >= 0 ? (((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 11 : 1 - ((((((DATA_T_AddrWidth + 7) + (DATA_T_DataWidth / 8)) + DATA_T_IdWidth) + 9) + DATA_T_UserWidth) + 10))];
	assign oup_valid_o = inp_valid_i[inp_sel_i];
	initial begin : p_assertions
		
	end
	initial _sv2v_0 = 0;
endmodule
