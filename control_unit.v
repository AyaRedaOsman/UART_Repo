module control_unit 
(
    output  reg    [2:0]   o_mux_sel,
    output  reg            o_load_enable,
    output  reg            o_shift_enable,
    output  reg            Busy,
    output  reg            o_count_enable,
    input   wire            i_overflow,
    input   wire            PAR_EN,
    input   wire            DATA_VALID,
    input   wire            CLK,RST

);

    reg [2:0]   current_state;
    reg [2:0]   next_state;

    localparam  [2:0]   IDLE    = 3'b001,
                        LOAD    = 3'b010,
                        START   = 3'b011,
                        DATA    = 3'b100,
                        PARITY  = 3'b101,
                        STOP    = 3'b110;

always@(posedge CLK or negedge RST)
    begin
        if(!RST)
            current_state<=IDLE;
        else
            current_state<=next_state;
    end


always@(*)
    begin
        case (current_state)

        IDLE: 
            begin
                if (DATA_VALID)
                    next_state<=LOAD;
                else 
                    next_state<=IDLE;
            end
        
        LOAD:
            begin
                next_state<=START;
            end

        START:
            begin
                next_state<=DATA;
            end

        DATA:
            begin
                if (i_overflow)
                    next_state<=(PAR_EN)?PARITY : STOP;
                else
                    next_state<=DATA;
            end         

        PARITY:
            begin
                next_state<=STOP;
            end

        STOP:
            begin
                next_state<=IDLE;
            end

        default: next_state<= IDLE;
        endcase
    end

always@(*)
    begin
        case (current_state)

        IDLE: 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b0;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;
            
            end

        LOAD: 
            begin
                o_load_enable<=1'b1;
                Busy<=1'b0;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;

            end

        START: 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b001;
                o_count_enable<=1'b0;

            end

        DATA: 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b1;
                o_shift_enable<=1'b1;
                o_mux_sel<=3'b010;
                o_count_enable<=1'b1;

            end

        PARITY: 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b011;
                o_count_enable<=1'b0;
            end
        STOP: 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b100;
                o_count_enable<=1'b0;

            end
        default : 
            begin
                o_load_enable<=1'b0;
                Busy<=1'b0;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;
            end
        endcase
    end
endmodule