module RAM(din,clk,rst_n,rx_valid,dout,tx_valid);
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    input [9:0] din;
    input clk,rst_n,rx_valid;
    output reg [7:0] dout;
    output tx_valid;

    reg [7:0] mem [MEM_DEPTH-1:0];
    reg [7:0] write_address,read_address;
    wire [1:0] opmode;

    assign opmode = din[9:8];
    assign tx_valid = ~rx_valid;

    always @(posedge clk) begin
        if(~rst_n)
            dout <= 0;
        else begin
            case (opmode)
                0:
                    write_address <= din[7:0];
                1: 
                    mem[write_address] <= din[7:0];
                2:
                    read_address <= din[7:0];
                3: begin
                    if(tx_valid)
                        dout <= mem[read_address];
                end
                default: 
                    dout <= 0;
            endcase
        end
    end
endmodule
