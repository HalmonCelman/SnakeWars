module char_rom_16x16
(
    input  logic clk,
    input  logic [7:0] char_xy,
    output logic [6:0] char_code
);
    logic [6:0] data;

    // body
    always_ff @(posedge clk)
        char_code <= data;

    always_comb
        case (char_xy)
            8'h00: data = "O";
            8'h01: data = "n";
            8'h02: data = "e";
            8'h03: data = " ";
            8'h04: data = "R";
            8'h05: data = "i";
            8'h06: data = "n";
            8'h07: data = "g";
            8'h08: data = " ";
            8'h09: data = "t";
            8'h0a: data = "o";
            8'h0b: data = " ";
            8'h0c: data = "r";
            8'h0d: data = "u";
            8'h0e: data = "l";
            8'h0f: data = "e";

            8'h10: data = "t";
            8'h11: data = "h";
            8'h12: data = "e";
            8'h13: data = "m";
            8'h14: data = " ";
            8'h15: data = "a";
            8'h16: data = "l";
            8'h17: data = "l";
            8'h18: data = ",";
            8'h19: data = " ";
            8'h1a: data = " ";
            8'h1b: data = " ";
            8'h1c: data = " ";
            8'h1d: data = " ";
            8'h1e: data = " ";
            8'h1f: data = " ";

            8'h20: data = "O";
            8'h21: data = "n";
            8'h22: data = "e";
            8'h23: data = " ";
            8'h24: data = "R";
            8'h25: data = "i";
            8'h26: data = "n";
            8'h27: data = "g";
            8'h28: data = " ";
            8'h29: data = "t";
            8'h2a: data = "o";
            8'h2b: data = " ";
            8'h2c: data = "f";
            8'h2d: data = "i";
            8'h2e: data = "n";
            8'h2f: data = "d";

            8'h30: data = "t";
            8'h31: data = "h";
            8'h32: data = "e";
            8'h33: data = "m";
            8'h34: data = ",";
            8'h35: data = " ";
            8'h36: data = "O";
            8'h37: data = "n";
            8'h38: data = "e";
            8'h39: data = " ";
            8'h3a: data = "R";
            8'h3b: data = "i";
            8'h3c: data = "n";
            8'h3d: data = "g";
            8'h3e: data = " ";
            8'h3f: data = " ";
        
            8'h40: data = "t";
            8'h41: data = "o";
            8'h42: data = " ";
            8'h43: data = "b";
            8'h44: data = "r";
            8'h45: data = "i";
            8'h46: data = "n";
            8'h47: data = "g";
            8'h48: data = " ";
            8'h49: data = "t";
            8'h4a: data = "h";
            8'h4b: data = "e";
            8'h4c: data = "m";
            8'h4d: data = " ";
            8'h4e: data = " ";
            8'h4f: data = " ";

            8'h50: data = "a";
            8'h51: data = "l";
            8'h52: data = "l";
            8'h53: data = " ";
            8'h54: data = "a";
            8'h55: data = "n";
            8'h56: data = "d";
            8'h57: data = " ";
            8'h58: data = "i";
            8'h59: data = "n";
            8'h5a: data = " ";
            8'h5b: data = "t";
            8'h5c: data = "h";
            8'h5d: data = "e";
            8'h5e: data = " ";
            8'h5f: data = " ";

            8'h60: data = "d";
            8'h61: data = "a";
            8'h62: data = "r";
            8'h63: data = "k";
            8'h64: data = "n";
            8'h65: data = "e";
            8'h66: data = "s";
            8'h67: data = "s";
            8'h68: data = " ";
            8'h69: data = " ";
            8'h6a: data = " ";
            8'h6b: data = " ";
            8'h6c: data = " ";
            8'h6d: data = " ";
            8'h6e: data = " ";
            8'h6f: data = " ";

            8'h70: data = "b";
            8'h71: data = "i";
            8'h72: data = "n";
            8'h73: data = "d";
            8'h74: data = " ";
            8'h75: data = "t";
            8'h76: data = "h";
            8'h77: data = "e";
            8'h78: data = "m";
            8'h79: data = ".";
            8'h7a: data = " ";
            8'h7b: data = " ";
            8'h7c: data = " ";
            8'h7d: data = " ";
            8'h7e: data = " ";
            8'h7f: data = " ";

            8'h80: data = "-";
            8'h81: data = "-";
            8'h82: data = "-";
            8'h83: data = "-";
            8'h84: data = "-";
            8'h85: data = "-";
            8'h86: data = "-";
            8'h87: data = "-";
            8'h88: data = "-";
            8'h89: data = "-";
            8'h8a: data = "-";
            8'h8b: data = "-";
            8'h8c: data = "-";
            8'h8d: data = "-";
            8'h8e: data = "-";
            8'h8f: data = "-";

            8'h90: data = "V";
            8'h91: data = "o";
            8'h92: data = "i";
            8'h93: data = "c";
            8'h94: data = "e";
            8'h95: data = "l";
            8'h96: data = "e";
            8'h97: data = "s";
            8'h98: data = "s";
            8'h99: data = " ";
            8'h9a: data = "i";
            8'h9b: data = "t";
            8'h9c: data = " ";
            8'h9d: data = " ";
            8'h9e: data = " ";
            8'h9f: data = " ";

            8'ha0: data = "c";
            8'ha1: data = "r";
            8'ha2: data = "i";
            8'ha3: data = "e";
            8'ha4: data = "s";
            8'ha5: data = ",";
            8'ha6: data = " ";
            8'ha7: data = "W";
            8'ha8: data = "i";
            8'ha9: data = "n";
            8'haa: data = "g";
            8'hab: data = "l";
            8'hac: data = "e";
            8'had: data = "s";
            8'hae: data = "s";
            8'haf: data = " ";

            8'hb0: data = "f";
            8'hb1: data = "l";
            8'hb2: data = "u";
            8'hb3: data = "t";
            8'hb4: data = "t";
            8'hb5: data = "e";
            8'hb6: data = "r";
            8'hb7: data = "s";
            8'hb8: data = ",";
            8'hb9: data = " ";
            8'hba: data = " ";
            8'hbb: data = " ";
            8'hbc: data = " ";
            8'hbd: data = " ";
            8'hbe: data = " ";
            8'hbf: data = " ";

            8'hc0: data = "T";
            8'hc1: data = "o";
            8'hc2: data = "o";
            8'hc3: data = "t";
            8'hc4: data = "h";
            8'hc5: data = "l";
            8'hc6: data = "e";
            8'hc7: data = "s";
            8'hc8: data = "s";
            8'hc9: data = " ";
            8'hca: data = "b";
            8'hcb: data = "i";
            8'hcc: data = "t";
            8'hcd: data = "e";
            8'hce: data = "s";
            8'hcf: data = ",";

            8'hd0: data = "M";
            8'hd1: data = "o";
            8'hd2: data = "u";
            8'hd3: data = "t";
            8'hd4: data = "h";
            8'hd5: data = "l";
            8'hd6: data = "e";
            8'hd7: data = "s";
            8'hd8: data = "s";
            8'hd9: data = " ";
            8'hda: data = " ";
            8'hdb: data = " ";
            8'hdc: data = " ";
            8'hdd: data = " ";
            8'hde: data = " ";
            8'hdf: data = " ";

            8'he0: data = "m";
            8'he1: data = "u";
            8'he2: data = "t";
            8'he3: data = "t";
            8'he4: data = "e";
            8'he5: data = "r";
            8'he6: data = "s";
            8'he7: data = ".";
            8'he8: data = " ";
            8'he9: data = " ";
            8'hea: data = " ";
            8'heb: data = " ";
            8'hec: data = " ";
            8'hed: data = " ";
            8'hee: data = " ";
            8'hef: data = " ";

            8'hf0: data = "~";
            8'hf1: data = "G";
            8'hf2: data = "o";
            8'hf3: data = "l";
            8'hf4: data = "l";
            8'hf5: data = "u";
            8'hf6: data = "m";
            8'hf7: data = " ";
            8'hf8: data = " ";
            8'hf9: data = " ";
            8'hfa: data = " ";
            8'hfb: data = " ";
            8'hfc: data = " ";
            8'hfd: data = " ";
            8'hfe: data = " ";
            8'hff: data = " ";

            
        endcase

endmodule
