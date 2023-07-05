module ds18b20_dri(
    //module clock
    input              clk        ,         // ʱ���źţ�50MHz��
    input              rst_n      ,         // ��λ�ź�

    //user interface    
    inout              dq         ,         // DS18B20��DQ��������
    output reg [19:0]  temp_data  ,         // ת����õ����¶�ֵ
    output reg         sign                 // ����λ
);

//parameter define
localparam  ROM_SKIP_CMD = 8'hcc;           // ���� ROM ����
localparam  CONVERT_CMD  = 8'h44;           // �¶�ת������
localparam  READ_TEMP    = 8'hbe;           // �� DS1820 �¶��ݴ�������
//state define
localparam  init         = 3'd1 ;           // ��ʼ��״̬
localparam  rom_skip     = 3'd2 ;           // ��������ROM����
localparam  wr_byte      = 3'd3 ;           // д�ֽ�״̬
localparam  temp_convert = 3'd4 ;           // �����¶�ת������
localparam  delay        = 3'd5 ;           // ��ʱ�ȴ��¶�ת������
localparam  rd_temp      = 3'd6 ;           // ���ض��¶�����
localparam  rd_byte      = 3'd7 ;           // ���ֽ�״̬

//reg define
reg     [ 5:0]         cnt         ;        // ��Ƶ������
reg                    clk_1us     ;        // 1MHzʱ��
reg     [19:0]         cnt_1us     ;        // ΢�����
reg     [ 2:0]         cur_state   ;        // ��ǰ״̬
reg     [ 2:0]         next_state  ;        // ��һ״̬
reg     [ 3:0]         flow_cnt    ;        // ��ת����
reg     [ 3:0]         wr_cnt      ;        // д����
reg     [ 4:0]         rd_cnt      ;        // ������
reg     [ 7:0]         wr_data     ;        // д��DS18B20������
reg     [ 4:0]         bit_width   ;        // ��ȡ�����ݵ�λ��
reg     [15:0]         rd_data     ;        // �ɼ���������
reg     [15:0]         org_data    ;        // ��ȡ����ԭʼ�¶�����
reg     [10:0]         data1       ;        // ��ԭ���¶Ƚ��з��Ŵ���
reg     [ 3:0]         cmd_cnt     ;        // �����������
reg                    init_done   ;        // ��ʼ������ź�
reg                    st_done     ;        // ����ź�
reg                    cnt_1us_en  ;        // ʹ�ܼ�ʱ
reg                    dq_out      ;        // DS18B20��dq���

//wire define
wire    [19:0]         data2       ;        // �Դ����Ľ���ת������

//*****************************************************
//**                    main code
//*****************************************************

assign dq = dq_out;

//��Ƶ����1MHz��ʱ���ź�
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt     <= 6'b0;
        clk_1us <= 1'b0;
    end
    else if(cnt < 6'd49) begin
        cnt     <= cnt + 1'b1;
        clk_1us <= clk_1us;
    end
    else begin
        cnt     <= 6'b0;
        clk_1us <= ~clk_1us;
    end
end

//΢���ʱ
always @ (posedge clk_1us or negedge rst_n) begin
    if (!rst_n)
        cnt_1us <= 20'b0;
    else if (cnt_1us_en)
        cnt_1us <= cnt_1us + 1'b1;
    else
        cnt_1us <= 20'b0;
end

//״̬��ת
always @ (posedge clk_1us or negedge rst_n) begin
    if(!rst_n)
        cur_state <= init;
    else 
        cur_state <= next_state;
end

//����߼�״̬�ж�ת������
always @( * ) begin
    case(cur_state)
        init: begin                             // ��ʼ��״̬
            if (init_done)
                next_state = rom_skip;
            else
                next_state = init;
        end
        rom_skip: begin                         // ��������ROM����
            if(st_done)
                next_state = wr_byte;
            else
                next_state = rom_skip;
        end
        wr_byte: begin                          // ��������
            if(st_done)
                case(cmd_cnt)                   // ����������ţ��ж��¸�״̬
                    4'b1: next_state = temp_convert;
                    4'd2: next_state = delay;
                    4'd3: next_state = rd_temp;
                    4'd4: next_state = rd_byte;
                    default: 
                          next_state = temp_convert;
                endcase
            else
                next_state = wr_byte;
        end
        temp_convert: begin                     // �����¶�ת������
            if(st_done)
                next_state = wr_byte;
            else
                next_state = temp_convert;
        end
        delay: begin                            // ��ʱ�ȴ��¶�ת������
            if(st_done)
                next_state = init;
            else
                next_state = delay;
        end
        rd_temp: begin                          // ���ض��¶�����
            if(st_done)
                next_state = wr_byte;
            else
                next_state = rd_temp;
        end
        rd_byte: begin                          // ���������ϵ�����
            if(st_done)
                next_state = init;
            else
                next_state = rd_byte;
        end
        default: next_state = init;
    endcase
end

//������������Ϊ��ʼ������������ROM������������¶�ת��ָ�
//�ٳ�ʼ�����ٷ�������ROM����ָ����Ͷ�����ָ�
always @ (posedge clk_1us or negedge rst_n) begin
    if(!rst_n) begin
        flow_cnt     <=  4'b0;
        init_done    <=  1'b0;
        cnt_1us_en   <=  1'b1;
        dq_out       <=  1'bZ;
        st_done      <=  1'b0;
        rd_data      <= 16'b0;
        rd_cnt       <=  5'd0;
        wr_cnt       <=  4'd0;
        cmd_cnt      <=  3'd0;
    end
    else begin
        st_done <= 1'b0;
        case (next_state)
            init:begin                              //��ʼ��
                init_done <= 1'b0;
                case(flow_cnt)
                    4'd0:
                        flow_cnt <= flow_cnt + 1'b1;
                        4'd1: begin                 //����500us��λ����
                        cnt_1us_en <= 1'b1;         
                        if(cnt_1us < 20'd500)
                            dq_out <= 1'b0;         
                        else begin
                            cnt_1us_en <= 1'b0;
                            dq_out <= 1'bz;
                            flow_cnt <= flow_cnt + 1'b1;
                        end
                    end
                    4'd2:begin                      //�ͷ����ߣ��ȴ�30us
                        cnt_1us_en <= 1'b1;
                        if(cnt_1us < 20'd30)
                            dq_out <= 1'bz;
                        else
                            flow_cnt <= flow_cnt + 1'b1;
                    end
                    4'd3: begin                     //�����Ӧ�ź�
                        if(!dq)
                            flow_cnt <= flow_cnt + 1'b1;
                        else
                            flow_cnt <= flow_cnt;
                    end
                    4'd4: begin                     //�ȴ���ʼ������
                        if(cnt_1us == 20'd500) begin
                            cnt_1us_en <= 1'b0;
                            init_done  <= 1'b1;     //��ʼ�����
                            flow_cnt   <= 4'd0;
                        end
                        else
                            flow_cnt <= flow_cnt;
                    end
                    default: flow_cnt <= 4'd0;
                endcase
            end
            rom_skip: begin                         //��������ROM����ָ��
                wr_data  <= ROM_SKIP_CMD;
                flow_cnt <= 4'd0;
                st_done  <= 1'b1;
            end
            wr_byte: begin                          //д�ֽ�״̬������ָ�
                if(wr_cnt <= 4'd7) begin
                    case (flow_cnt)
                        4'd0: begin
                            dq_out <= 1'b0;         //���������ߣ���ʼд����
                            cnt_1us_en <= 1'b1;     //������ʱ��
                            flow_cnt <= flow_cnt + 1'b1;
                        end
                        4'd1: begin                 //����������1us
                            flow_cnt <= flow_cnt + 1'b1;
                        end
                        4'd2: begin
                            if(cnt_1us < 20'd60)    //��������
                                dq_out <= wr_data[wr_cnt];
                            else if(cnt_1us < 20'd63)   
                                dq_out <= 1'bz;     //�ͷ����ߣ����ͼ����
                            else
                                flow_cnt <= flow_cnt + 1'b1;
                        end
                        4'd3: begin                 //����1λ�������
                            flow_cnt <= 0;
                            cnt_1us_en <= 1'b0;
                            wr_cnt <= wr_cnt + 1'b1;//д��������1
                        end
                        default : flow_cnt <= 0;
                    endcase
                end
                else begin                          //����ָ�1Byte������
                    st_done <= 1'b1;
                    wr_cnt <= 4'b0;
                    cmd_cnt <= (cmd_cnt == 3'd4) ?  //��ǵ�ǰ���͵�ָ�����
                               3'd1 : (cmd_cnt+ 1'b1);
                end
            end
            temp_convert: begin                     //�����¶�ת������
                wr_data <= CONVERT_CMD;
                st_done <= 1'b1;
            end
            delay: begin                            //��ʱ500ms�ȴ��¶�ת������
                cnt_1us_en <= 1'b1;
                if(cnt_1us == 20'd500000) begin
                    st_done <= 1'b1;
                    cnt_1us_en <= 1'b0;
                end 
            end 
            rd_temp: begin                          //���ض��¶�����
                wr_data <= READ_TEMP;
                bit_width <= 5'd16;                 //ָ�������ݸ���
                st_done <= 1'b1;
            end
            rd_byte: begin                          //����16λ�¶�����
                if(rd_cnt < bit_width) begin
                    case(flow_cnt)
                        4'd0: begin
                            cnt_1us_en <= 1'b1;
                            dq_out <= 1'b0;         //���������ߣ���ʼ������
                            flow_cnt <= flow_cnt + 1'b1;
                        end
                        4'd1: begin
                            dq_out <= 1'bz;         //�ͷ����߲���15us�ڽ�������
                            if(cnt_1us == 20'd14) begin
                                rd_data <= {dq,rd_data[15:1]};
                                flow_cnt <= flow_cnt + 1'b1 ;
                            end
                        end
                        4'd2: begin
                            if (cnt_1us <= 20'd64)  //��1λ���ݽ���
                                dq_out <= 1'bz;
                            else begin
                                flow_cnt <= 4'd0;   
                                rd_cnt <= rd_cnt + 1'b1;//����������1
                                cnt_1us_en <= 1'b0;
                            end
                        end
                        default : flow_cnt <= 4'd0;
                    endcase
                end
                else begin
                    st_done <= 1'b1;
                    org_data  <= rd_data;
                    rd_cnt <= 5'b0;
                end
            end
            default: ;
        endcase
    end 
end

//�жϷ���λ
always @(posedge clk_1us or negedge rst_n) begin
    if(!rst_n) begin
        sign  <=  1'b0;
        data1 <= 11'b0;
    end
    else if(org_data[15] == 1'b0) begin
        sign  <= 1'b0;
        data1 <= org_data[10:0];
    end
    else if(org_data[15] == 1'b1) begin
        sign  <= 1'b1;
        data1 <= ~org_data[10:0] + 1'b1;
    end
end

//�Բɼ������¶Ƚ���ת��
assign data2 = (data1 * 11'd625)/ 7'd100;

//�¶����
always @(posedge clk_1us or negedge rst_n) begin
    if(!rst_n)
        temp_data <= 20'b0;
    else
        temp_data <= data2;
end

endmodule