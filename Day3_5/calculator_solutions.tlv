\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      
      @0
         $reset = *reset;
      @1
         $valid = $reset ? 1'b0 : >>1$valid + 1'b1;
         $reset_or_valid = $valid || $reset;
         $val1[31:0] = >>2$out;
         $val2[31:0] = $rand2[3:0];
      ?$reset_or_valid
         @1   
            $sum[31:0] = $val1+ $val2;
            $diff[31:0] = $val1 - $val2;
            $quo[31:0] = $val1 / $val2;
            $prod[31:0] = $val1 * $val2;
         @2
            $out[31:0] = $reset ? 32'b0
                       : $op[2:0] == 3'd0 ? $sum
                       : $op[2:0] == 3'd1 ? $diff
                       : $op[2:0] == 3'd2 ? $prod
                       : $op[2:0] == 3'd3 ? $quo
                                          : $mem;
                      
            $mem [31:0] = $reset ? 'b0
                        : $op[2:0] == 3'd5 ? >>2$out
                                           : $mem[31:0];
                                        
   m4+cal_viz(@3) // Arg: Pipeline stage represented by viz, should be atleast equal to last stage of CALCULATOR logic.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
