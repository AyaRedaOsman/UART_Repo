module parity_bit
#(parameter Data_WIDTH=8)
(
    output  wire                        o_parity_bit,
    input   wire                        i_parity_type,
    input   wire    [Data_WIDTH-1:0]    P_DATA
);

assign o_parity_bit= (i_parity_type)? ^P_DATA : ~^P_DATA;

endmodule
