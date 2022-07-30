module Mux
    #(parameter Selection=3  )

(
    output  reg                         TX_OUT,
    input   wire                        P_DATA,
    input   wire                        i_parity_bit,
    input   wire    [Selection-1:0]     i_sel
);

    localparam  [2:0]   IDLE = 3'b000,
                        START=3'b001,
                        DATA=3'b010,
                        PARITY=3'b011,
                        STOP=3'b100;

    always@(*)
        begin
            case(i_sel)

                IDLE : TX_OUT<=1'b1;

                START : TX_OUT<=1'b0;
                
                DATA : TX_OUT<=P_DATA;
                
                PARITY : TX_OUT<=i_parity_bit;
                
                STOP : TX_OUT<=1'b1;

                default : TX_OUT<=1'b1;
            endcase
        
        end

endmodule