`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 08:21:38 PM
// Design Name: 
// Module Name: tb_axi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_axi_top();
  
  reg [31:0] mem_master [0:7];
  initial begin
    $readmemh("/home/yanry/axi_vivado/src/mem1.txt", mem_master);
  end
  
  logic clk_i, rst_ni;
  parameter T = 10;
  initial begin
    clk_i = 0;
    forever begin
        #(T/2) clk_i = ~clk_i;
    end
  end
  initial begin
    rst_ni = 1'b0;
    #30 rst_ni = 1'b1;
  end

  parameter int unsigned MemAddrWidth = 32'd5;
  parameter int unsigned AxiAddrWidth = 32'd5;
  parameter int unsigned DataWidth = 32'd32;
  parameter int unsigned MaxRequests = 32'd3;
  parameter axi_pkg::prot_t AxiProt = 3'b000;
  
  parameter type mem_addr_t = logic[MemAddrWidth-1:0];
  parameter type axi_addr_t = logic[AxiAddrWidth-1:0];
  parameter type data_t = logic[DataWidth-1:0];
  parameter type strb_t = logic[DataWidth/8-1:0];
  
  parameter int unsigned IdWidth    = 1;
  parameter int unsigned UserWidth  = 1;
  parameter int unsigned NumBanks   = 1;
  parameter int unsigned BufDepth   = 1;
  parameter bit          HideStrb   = 1'b0;
  parameter int unsigned OutFifoDepth = 1;
  
  localparam type mem_data_t = logic [DataWidth/NumBanks-1:0];
  localparam type mem_strb_t = logic [DataWidth/NumBanks/8-1:0];
  localparam type mem_id_t   = logic [IdWidth-1:0];
  localparam type mem_user_t = logic [UserWidth-1:0];
  
  logic mem_req_i, mem_req_o, mem_we_i, mem_we_o, mem_err_i, mem_err_o, mem_rvalid_i, mem_rvalid_o;
  mem_addr_t mem_addr_i, mem_addr_o, mem_addr;
  mem_data_t mem_wdata_i, mem_wdata_o, mem_rdata_i, mem_rdata_o;
  mem_strb_t mem_strb_i, mem_strb_o;
  
  assign mem_strb_i = {DataWidth/8{1}};
  assign mem_addr = 1;
  reg [2:0] cnt;
  
  always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        mem_req_i <= 0;
        cnt <= 0;
    end
    else begin
        mem_req_i <= 1;
        mem_we_i <= 1;
        mem_addr_i <= mem_addr * $bits(strb_t) * cnt;
        mem_wdata_i <= mem_master[mem_addr];
        mem_rvalid_i <= 1;
        if (cnt < 7) begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= cnt;
        end
        
    end
  end
  
  axi_top #(
    .MemAddrWidth ( MemAddrWidth ),
    .AxiAddrWidth ( AxiAddrWidth ),
    .DataWidth    ( DataWidth    )
  ) i_axi_top (
    .clk_i,
    .rst_ni,
    .mem_req_i,
    .mem_req_o,
    .mem_addr_i,
    .mem_addr_o,
    .mem_we_i,
    .mem_we_o,
    .mem_wdata_i,
    .mem_wdata_o,
    .mem_rdata_i,
    .mem_rsp_rdata_o ( mem_rdata_o ),
    .mem_be_i ( mem_strb_i ),
    .mem_strb_o,
    .mem_rvalid_i,
    .mem_rsp_valid_o ( mem_rvalid_o ),
    .mem_err_i,
    .mem_rsp_error_o ( mem_err_o )
  );
  
endmodule
