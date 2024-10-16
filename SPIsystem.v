module SPISystem(MOSI,SS_n,clk,rst_n,MISO);
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    input MOSI,SS_n,rst_n,clk;
    output MISO;

    wire [9:0] din_rx;
    wire rx_valid, tx_valid;
    wire [7:0] tx_data;

    RAM memory(din_rx,clk,rst_n,rx_valid,tx_data,tx_valid);
    SPIslave slave(MOSI,SS_n,tx_data,tx_valid,clk,rst_n,din_rx,rx_valid,MISO);
endmodule
