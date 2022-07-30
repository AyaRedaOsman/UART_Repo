module Serializer 
#(parameter Register_Width=8)

(
    output  wire                            o_data,            
    input   wire    [Register_Width-1:0]    P_DATA,
    input   wire                            CLK,
    input   wire                            RST,
    input   wire                            i_load_enable,
    input   wire                            i_shift_enable

);

    reg [Register_Width-1:0]    internal_buffer;
    reg [Register_Width-1:0]    data_shifted;


    always@(posedge i_load_enable )
        begin
            internal_buffer<=P_DATA;
        end


    always@(posedge CLK or negedge RST)
        begin
            if(!RST)
            
            internal_buffer<={ (Register_Width){1'b0} };

            else if (i_shift_enable)
            begin
                internal_buffer<=data_shifted;
            end        
        end

    always@(*)
        begin
            data_shifted<=internal_buffer<<1;
        end

    assign o_data=internal_buffer[Register_Width-1];       

    endmodule