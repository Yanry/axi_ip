module tb_axi_top;
	reg [31:0] mem_master [0:7];
	initial $readmemh("/home/yanry/axi_vivado/src/mem1.txt", mem_master);
	reg clk_i;
	reg rst_ni;
	parameter T = 10;
	initial begin
		clk_i = 0;
		forever #(T / 2) clk_i = ~clk_i;
	end
	initial begin
		rst_ni = 1'b0;
		#(30) rst_ni = 1'b1;
	end
	parameter [31:0] MemAddrWidth = 32'd5;
	parameter [31:0] AxiAddrWidth = 32'd5;
	parameter [31:0] DataWidth = 32'd32;
	parameter [31:0] MaxRequests = 32'd3;
	parameter [2:0] AxiProt = 3'b000;
	parameter [31:0] IdWidth = 1;
	parameter [31:0] UserWidth = 1;
	parameter [31:0] NumBanks = 1;
	parameter [31:0] BufDepth = 1;
	parameter [0:0] HideStrb = 1'b0;
	parameter [31:0] OutFifoDepth = 1;
	reg mem_req_i;
	wire mem_req_o;
	reg mem_we_i;
	wire mem_we_o;
	wire mem_err_i;
	wire mem_err_o;
	reg mem_rvalid_i;
	wire mem_rvalid_o;
	reg [MemAddrWidth - 1:0] mem_addr_i;
	wire [MemAddrWidth - 1:0] mem_addr_o;
	wire [MemAddrWidth - 1:0] mem_addr;
	reg [(DataWidth / NumBanks) - 1:0] mem_wdata_i;
	wire [(DataWidth / NumBanks) - 1:0] mem_wdata_o;
	wire [(DataWidth / NumBanks) - 1:0] mem_rdata_i;
	wire [(DataWidth / NumBanks) - 1:0] mem_rdata_o;
	wire [((DataWidth / NumBanks) / 8) - 1:0] mem_strb_i;
	wire [((DataWidth / NumBanks) / 8) - 1:0] mem_strb_o;
	assign mem_strb_i = {DataWidth / 8 {1}};
	assign mem_addr = 1;
	reg [2:0] cnt;
	always @(posedge clk_i)
		if (!rst_ni) begin
			mem_req_i <= 0;
			cnt <= 0;
		end
		else begin
			mem_req_i <= 1;
			mem_we_i <= 1;
			mem_addr_i <= (mem_addr * (DataWidth / 8)) * cnt;
			mem_wdata_i <= mem_master[mem_addr];
			mem_rvalid_i <= 1;
			if (cnt < 7)
				cnt <= cnt + 1;
			else
				cnt <= cnt;
		end
	axi_top #(
		.MemAddrWidth(MemAddrWidth),
		.AxiAddrWidth(AxiAddrWidth),
		.DataWidth(DataWidth)
	) i_axi_top(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.mem_req_i(mem_req_i),
		.mem_req_o(mem_req_o),
		.mem_addr_i(mem_addr_i),
		.mem_addr_o(mem_addr_o),
		.mem_we_i(mem_we_i),
		.mem_we_o(mem_we_o),
		.mem_wdata_i(mem_wdata_i),
		.mem_wdata_o(mem_wdata_o),
		.mem_rdata_i(mem_rdata_i),
		.mem_rsp_rdata_o(mem_rdata_o),
		.mem_be_i(mem_strb_i),
		.mem_strb_o(mem_strb_o),
		.mem_rvalid_i(mem_rvalid_i),
		.mem_rsp_valid_o(mem_rvalid_o),
		.mem_err_i(mem_err_i),
		.mem_rsp_error_o(mem_err_o)
	);
endmodule
