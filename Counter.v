module Counter(clk,rst_n,out);

    input clk,rst_n;
    output reg [3:0] out;

    always @(posedge clk) begin
        if(~rst_n)
            out <= 0;
        else begin             
                if(out == 10)
                    out <= 0;
                else
                    out <= out + 1;
        end
    end
endmodule