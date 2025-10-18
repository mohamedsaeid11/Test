////////////////////////////////////////////////////////////////
//
// author name : Mohamed Khaled
// date        : 12 May 2024
// description :  Self-checking Testbench for shifter module
//
///////////////////////////////////////////////////////////////

module shift_unit_tb;
    parameter width = 16 ;
    //stimulus signals
    bit clk; 
    bit reset;
    logic [width-1:0] A;
    logic [width-1:0] B; 
    logic [1:0] ALU_FUN;
    logic shift_enable;

    logic [width-1:0] shift_out, shift_out_ref;
    logic shift_flag, shift_flag_ref;

    integer correct_count = 0;
    integer error_count = 0;  
    // Instantiation DUT
    shift_unit #(.width(width)) DUT (
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN),
        .shift_enable(shift_enable),
        .clk(clk),
        .reset(reset),
        .shift_out(shift_out),
        .shift_flag(shift_flag)
    );
    //clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //Randomizating Stimulus 100 times
    initial begin
        $display ("=============== Start Testing ===============");
        $display ("Check reset");
        reset = 0;
        ref_model();
        check_result();

        $display ("Randomization stimulus");
        repeat (100) begin
            @(negedge clk);
            reset = 1;
            A = $random();
            B = $random();
            ALU_FUN = $random();
            shift_enable = $random();
            ref_model();
            check_result();

        end
        $display ("================ End of Testing ===================");

        $display ("==================== Summary ======================");
        $display ("Correct Results: %0d, Errors: %0d", correct_count, error_count);
        $stop;
    end

    // Reference Model
    task ref_model;
       if (!reset) begin
            shift_out_ref = 'd0;
            shift_flag_ref = 1'b0;
        end
        else if (shift_enable) begin
            shift_flag_ref = 1'b1;
            if (ALU_FUN == 2'b00)  
                shift_out_ref = {1'b0, A[width-1:1]} ;
            else if (ALU_FUN == 2'b01) 
                shift_out_ref = {A[width-2:0], 1'b0};
            else if (ALU_FUN == 2'b10) 
                shift_out_ref = {1'b0, B[width-1:1]} ;
            else if (ALU_FUN == 2'b11) 
                shift_out_ref = {B[width-2:0], 1'b0};
            else begin // No Shift
                shift_out_ref = 0;
                shift_flag_ref = 0;
            end
        end
        else begin
            shift_out_ref = 'd0;
            shift_flag_ref = 1'b0;
        end
    endtask

    // Check Task
    task void check_result;
        @(negedge clk);
        if (shift_out !== shift_out_ref || shift_flag !== shift_flag_ref) begin
            $display ("Test fail : A = 0b%0b, B = 0b%0b, ALU_FUN = 0b%0b, Shift_Enable = 0b%0b, shift_flag = 0b%0b, shift_out = 0b%0b, Expected_Shift_flag = 0b%0b, Expected_shift_out = 0b%0b",
                        A, B, ALU_FUN, shift_enable, shift_flag, shift_out, shift_flag_ref, shift_out_ref);
            error_count++;
        end
        else begin
            $display ("Test pass : A = 0b%0b, B = 0b%0b, ALU_FUN = 0b%0b, Shift_Enable = 0b%0b, shift_flag = 0b%0b, shift_out = 0b%0b",
                        A, B, ALU_FUN, shift_enable, shift_flag, shift_out);
            correct_count++;
        end
    endtask
endmodule