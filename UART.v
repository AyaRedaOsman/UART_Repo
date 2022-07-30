module UART 
#(parameter DATA_WIDTH=8)
(
    output  wire                        TX_OUT,
    output  wire                        Busy,
    input   wire    [DATA_WIDTH-1:0]    P_DATA,
    input   wire                        PAR_TYP,
    input   wire                        PAR_EN,
    input   wire                        DATA_VALID,
    input   wire                        CLK,RST
);

    wire    load_enable,shift_enable,count_enable;
    wire    overflow,data_out,parity_bit;
    wire    [2:0]   sel;
control_unit Control_Unit 
                         (.o_load_enable(load_enable),
                          .o_shift_enable(shift_enable),
                          .Busy(Busy),
                          .o_count_enable(count_enable),
                          .o_mux_sel(sel),
                          .i_overflow(overflow),
                          .PAR_EN(PAR_EN),
                          .DATA_VALID(DATA_VALID),
                          .CLK(CLK),
                          .RST(RST)
                         );

parity_bit Parity_Bit 
                     (.o_parity_bit(parity_bit),
                      .PAR_TYP(PAR_TYP),
                      .P_DATA(P_DATA)
                     );

Mux Output_Mux 
              (.TX_OUT(TX_OUT),
               .P_DATA(data_out),
               .i_parity_bit(parity_bit),
               .i_sel(sel)
              );

Counter Counter 
               (.o_overflow(overflow),
                .i_count_enable(count_enable),
                .CLK(CLK),
                .RST(RST)
               );

Serializer Serializer 
                     (.o_data(data_out),
                      .P_DATA(P_DATA),
                      .i_load_enable(load_enable),
                      .i_shift_enable(shift_enable),
                      .CLK(CLK),
                      .RST(RST)
                     );


     
         

endmodule