module SPIslave(MOSI,SS_n,tx_data,tx_valid,clk,rst_n,rx_data,rx_valid,MISO);
    parameter IDLE = 0;
    parameter CHK_MOD = 1;
    parameter WRITE = 2;
    parameter READ_ADDR = 3;
    parameter READ_DATA = 4;

    input MOSI,SS_n,tx_valid,clk,rst_n;
    input [7:0] tx_data;
    output reg [9:0] rx_data;
    output reg MISO;
    output rx_valid;


    (* fsm_encoding = "sequential" *) reg [2:0] ns,cs;
    reg [9:0] shiftReg;
    reg MOSIreg;
    wire [3:0] counterOut;
    wire switchState;
    wire [1:0] opmode;

    Counter count(clk,rst_n,counterOut);
    assign opmode = shiftReg[9:8];
    assign switchState = (counterOut == 0) ? 1 : 0;  //to check for opmode

    //cs logic
    integer i;
    always @(posedge clk) begin
        if(~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    //ns logic
    always @(cs, SS_n, MOSIreg, switchState) begin

            case (cs)
                IDLE: begin
                        if(SS_n)
                            ns <= IDLE;
                        else
                            ns <= CHK_MOD;
                    end

                CHK_MOD: begin
                        if(SS_n)
                            ns <= IDLE;
                        else if (~SS_n && switchState) begin
                            if(~MOSIreg) 
                                ns <= WRITE;
                            else begin
                                if(opmode == 'b10)
                                    ns <= READ_ADDR;
                                else if (opmode == 'b11)
                                    ns <= READ_DATA;
                            end
                        end
                        else
                            ns <= ns;

                    end

                WRITE: begin
                        if(SS_n)
                            ns <=IDLE;
                        else if(switchState || rx_valid == 1) //once write operation done return to CHK_MOD
                            ns <= CHK_MOD;
                        else
                            ns <= ns;
                    end

                READ_ADDR: begin
                        if(SS_n)
                            ns <=IDLE;
                        else if(switchState || rx_valid == 1)
                            ns <= CHK_MOD;
                        else
                            ns <= ns;
                    end

                READ_DATA: begin
                        if(SS_n)
                            ns <=IDLE;
                        else if(switchState)
                            ns <= CHK_MOD;
                        else
                            ns <= ns;
                    end

                default:    ns <= IDLE;
            endcase

    end


    //output logic
    assign rx_valid = (cs == WRITE || cs == READ_ADDR) ? 1 : 0;
    always @(posedge clk) begin
        
        if (switchState) begin        
            MOSIreg <= MOSI;
        end else begin
            shiftReg[0] <= MOSI;
            for(i=0;i<9;i=i+1)
                shiftReg[i+1] <= shiftReg[i];
            MISO <= shiftReg[9];
        end


        case (cs)
            //IDLE:
            CHK_MOD:
                rx_data <= rx_data;
            WRITE:
                rx_data <= shiftReg;
            READ_ADDR: 
                rx_data <= shiftReg;
            READ_DATA: begin
                if(tx_valid && counterOut == 2 && !switchState)
                    shiftReg[9:2]<= tx_data;
            end
            default:  ;
        endcase
    end


endmodule
