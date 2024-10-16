module RAM_tb ();
    reg [9:0] din;
    reg clk,rst_n,rx_valid;
    wire tx_valid;
    wire [7:0] dout;

    RAM test(din,clk,rst_n,rx_valid,dout,tx_valid);

    //clock	
	initial begin
		clk = 0;
		forever
			#20 clk = ~clk;
	end

    integer i;
    initial begin
        $readmemh("mem3.dat", test.mem);
        rx_valid = 1;
        rst_n = 1;
        #10;
        din = 'h0fe;
        #40;
        din = 'h1aa;
        #40;
        din = 'h2fe;
        #40;
        rx_valid = 0;
        din = 'h3fe;
        #40;
    for(i=0;i<10;i=i+1) begin
            din = $random;
            if (din[9:8] == 11)
                rx_valid = 0;
            else
                rx_valid = 1;
            @(negedge clk);
        end
        rst_n = 0;
        #100;
        $stop;
    end
endmodule
