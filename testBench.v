module SPISystem_tb();
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    reg MOSI,SS_n,rst_n,clk;
    wire MISO;

    SPISystem test(MOSI,SS_n,clk,rst_n,MISO);

//clock	
	initial begin
		clk = 0;
		forever
			#20 clk = ~clk;
	end

integer i;
    initial begin
        $readmemh("mem.dat", test.memory.mem);
        rst_n=0;
        #50;
        rst_n = 1;
        SS_n=1;
        #50;
        SS_n = 0;
        #40;
        for (i = 0; i<605; i=i+1) begin
            MOSI = $random;
            @(negedge clk);
        end
        MOSI=0;
        #1000;

        //directed test bench
        MOSI=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        for (i = 0; i<8; i=i+1) begin
            MOSI = $random;
            @(negedge clk);
        end

        MOSI=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        for (i = 0; i<8; i=i+1) begin
            MOSI = $random;
            @(negedge clk);
        end

        MOSI=1;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        for (i = 0; i<4; i=i+1) begin
            MOSI = 1;
            @(negedge clk);
        end

        MOSI=1;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        for (i = 0; i<8; i=i+1) begin
            MOSI = $random;
            @(negedge clk);
        end
        #160;
        $stop;
    end
endmodule
