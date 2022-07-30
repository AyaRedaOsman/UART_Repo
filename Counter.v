module Counter
#(parameter Counter_Width =3) 
(
    output  reg    o_overflow,
    input   wire    CLK,RST,
    input   wire    i_count_enable
);

    reg [Counter_Width-1:0]  counter=0;
    reg [Counter_Width-1:0]  counter_reg=0;

always@(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                counter<= { (Counter_Width) {1'b0} };
                o_overflow<=0;
            end
            
        else 
            begin
                if (i_count_enable)
                    counter<=counter_reg;
                        if (o_overflow)
                            counter<= { (Counter_Width) {1'b0} };
            end

    end

always@(*)

    begin
            {o_overflow , counter_reg }<=counter+1;
    end

endmodule