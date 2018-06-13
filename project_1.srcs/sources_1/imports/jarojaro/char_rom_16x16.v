// File: char_rom_16x16.v

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1ns / 1ps

module char_rom_16x16(
    input wire [7:0] char_xy,
    output reg [6:0] char_code
    );
        
    //16 characters allowed in each line
    reg [0:127] line0   = "    Mikolaj     ";
    reg [0:127] line1   = "  Jaroslawski   "; 
    reg [0:127] line2   = "Mikroelektronika";
    reg [0:127] line3   = "        1       ";
    reg [0:127] line4   = "        2       ";
    reg [0:127] line5   = "        3       ";
    reg [0:127] line6   = "        4       ";
    reg [0:127] line7   = "        5       ";
    reg [0:127] line8   = "        6       ";
    reg [0:127] line9   = "        7       ";
    reg [0:127] line10  = "        8       ";
    reg [0:127] line11  = "        9       ";
    reg [0:127] line12  = "       10       ";
    reg [0:127] line13  = "       11       ";
    reg [0:127] line14  = "       12       ";
    reg [0:127] line15  = "       13       ";
    
    always @*
        if (char_xy[3:0] == 0)      //zerowa linijka
            case (char_xy[7:4])
                0:  char_code = line0[0:7];
                1:  char_code = line0[8:15];
                2:  char_code = line0[16:23];
                3:  char_code = line0[24:31];
                4:  char_code = line0[32:39];
                5:  char_code = line0[40:47];
                6:  char_code = line0[48:55];
                7:  char_code = line0[56:63];
                8:  char_code = line0[64:71];
                9:  char_code = line0[72:79];
                10:  char_code = line0[80:87];
                11:  char_code = line0[88:95];
                12:  char_code = line0[96:103];
                13:  char_code = line0[104:111];
                14:  char_code = line0[112:119];
                15:  char_code = line0[120:127];   
                default:
                char_code =7'h45;
            endcase
        
        else if (char_xy[3:0] == 1) //pierwsza linijka
            case (char_xy[7:4])
                0:  char_code = line1[0:7];
                1:  char_code = line1[8:15];
                2:  char_code = line1[16:23];
                3:  char_code = line1[24:31];
                4:  char_code = line1[32:39];
                5:  char_code = line1[40:47];
                6:  char_code = line1[48:55];
                7:  char_code = line1[56:63];
                8:  char_code = line1[64:71];
                9:  char_code = line1[72:79];
                10:  char_code = line1[80:87];
                11:  char_code = line1[88:95];
                12:  char_code = line1[96:103];
                13:  char_code = line1[104:111];
                14:  char_code = line1[112:119];
                15:  char_code = line1[120:127];   
                default:
                char_code =7'h45; 
            endcase
                
        else if (char_xy[3:0] == 2) //druga linijka
            case (char_xy[7:4])
                0:  char_code = line2[0:7];
                1:  char_code = line2[8:15];
                2:  char_code = line2[16:23];
                3:  char_code = line2[24:31];
                4:  char_code = line2[32:39];
                5:  char_code = line2[40:47];
                6:  char_code = line2[48:55];
                7:  char_code = line2[56:63];
                8:  char_code = line2[64:71];
                9:  char_code = line2[72:79];
                10:  char_code = line2[80:87];
                11:  char_code = line2[88:95];
                12:  char_code = line2[96:103];
                13:  char_code = line2[104:111];
                14:  char_code = line2[112:119];
                15:  char_code = line2[120:127];
                default:
                char_code =7'h45;
            endcase
        
        else if (char_xy[3:0] == 3) //trzecia linijka
            case (char_xy[7:4])
                0:  char_code = line3[0:7];
                1:  char_code = line3[8:15];
                2:  char_code = line3[16:23];
                3:  char_code = line3[24:31];
                4:  char_code = line3[32:39];
                5:  char_code = line3[40:47];
                6:  char_code = line3[48:55];
                7:  char_code = line3[56:63];
                8:  char_code = line3[64:71];
                9:  char_code = line3[72:79];
                10:  char_code = line3[80:87];
                11:  char_code = line3[88:95];
                12:  char_code = line3[96:103];
                13:  char_code = line3[104:111];
                14:  char_code = line3[112:119];
                15:  char_code = line3[120:127]; 
                default:
                char_code =7'h45;
            endcase
        
        else if (char_xy[3:0] == 4) //czwarta linijka
            case (char_xy[7:4])
                0:  char_code = line4[0:7];
                1:  char_code = line4[8:15];
                2:  char_code = line4[16:23];
                3:  char_code = line4[24:31];
                4:  char_code = line4[32:39];
                5:  char_code = line4[40:47];
                6:  char_code = line4[48:55];
                7:  char_code = line4[56:63];
                8:  char_code = line4[64:71];
                9:  char_code = line4[72:79];
                10:  char_code = line4[80:87];
                11:  char_code = line4[88:95];
                12:  char_code = line4[96:103];
                13:  char_code = line4[104:111];
                14:  char_code = line4[112:119];
                15:  char_code = line4[120:127];  
                default:
                char_code =7'h45;
            endcase
        
        else if (char_xy[3:0] == 5) //piata linijka
            case (char_xy[7:4])
                0:  char_code = line5[0:7];
                1:  char_code = line5[8:15];
                2:  char_code = line5[16:23];
                3:  char_code = line5[24:31];
                4:  char_code = line5[32:39];
                5:  char_code = line5[40:47];
                6:  char_code = line5[48:55];
                7:  char_code = line5[56:63];
                8:  char_code = line5[64:71];
                9:  char_code = line5[72:79];
                10:  char_code = line5[80:87];
                11:  char_code = line5[88:95];
                12:  char_code = line5[96:103];
                13:  char_code = line5[104:111];
                14:  char_code = line5[112:119];
                15:  char_code = line5[120:127];
                default:
                char_code =7'h45; 
            endcase
        
        else if (char_xy[3:0] == 6) //szosta linijka
            case (char_xy[7:4])
                0:  char_code = line6[0:7];
                1:  char_code = line6[8:15];
                2:  char_code = line6[16:23];
                3:  char_code = line6[24:31];
                4:  char_code = line6[32:39];
                5:  char_code = line6[40:47];
                6:  char_code = line6[48:55];
                7:  char_code = line6[56:63];
                8:  char_code = line6[64:71];
                9:  char_code = line6[72:79];
                10:  char_code = line6[80:87];
                11:  char_code = line6[88:95];
                12:  char_code = line6[96:103];
                13:  char_code = line6[104:111];
                14:  char_code = line6[112:119];
                15:  char_code = line6[120:127];
                default:
                char_code =7'h45;   
            endcase
        
        else if (char_xy[3:0] == 7) //siodma linijka
            case (char_xy[7:4])
                0:  char_code = line7[0:7];
                1:  char_code = line7[8:15];
                2:  char_code = line7[16:23];
                3:  char_code = line7[24:31];
                4:  char_code = line7[32:39];
                5:  char_code = line7[40:47];
                6:  char_code = line7[48:55];
                7:  char_code = line7[56:63];
                8:  char_code = line7[64:71];
                9:  char_code = line7[72:79];
                10:  char_code = line7[80:87];
                11:  char_code = line7[88:95];
                12:  char_code = line7[96:103];
                13:  char_code = line7[104:111];
                14:  char_code = line7[112:119];
                15:  char_code = line7[120:127];
                default:
                char_code =7'h45;  
            endcase
        
        else if (char_xy[3:0] == 8) //osma linijka
            case (char_xy[7:4])
                0:  char_code = line8[0:7];
                1:  char_code = line8[8:15];
                2:  char_code = line8[16:23];
                3:  char_code = line8[24:31];
                4:  char_code = line8[32:39];
                5:  char_code = line8[40:47];
                6:  char_code = line8[48:55];
                7:  char_code = line8[56:63];
                8:  char_code = line8[64:71];
                9:  char_code = line8[72:79];
                10:  char_code = line8[80:87];
                11:  char_code = line8[88:95];
                12:  char_code = line8[96:103];
                13:  char_code = line8[104:111];
                14:  char_code = line8[112:119];
                15:  char_code = line8[120:127];
                default:
                char_code =7'h45;     
            endcase
        
        else if (char_xy[3:0] == 9) //dziewiata linijka
            case (char_xy[7:4])
                0:  char_code = line9[0:7];
                1:  char_code = line9[8:15];
                2:  char_code = line9[16:23];
                3:  char_code = line9[24:31];
                4:  char_code = line9[32:39];
                5:  char_code = line9[40:47];
                6:  char_code = line9[48:55];
                7:  char_code = line9[56:63];
                8:  char_code = line9[64:71];
                9:  char_code = line9[72:79];
                10:  char_code = line9[80:87];
                11:  char_code = line9[88:95];
                12:  char_code = line9[96:103];
                13:  char_code = line9[104:111];
                14:  char_code = line9[112:119];
                15:  char_code = line9[120:127];
                default:
                char_code =7'h45;
            endcase
        
        else if (char_xy[3:0] == 10) //dziesiata linijka
            case (char_xy[7:4])
                0:  char_code = line10[0:7];
                1:  char_code = line10[8:15];
                2:  char_code = line10[16:23];
                3:  char_code = line10[24:31];
                4:  char_code = line10[32:39];
                5:  char_code = line10[40:47];
                6:  char_code = line10[48:55];
                7:  char_code = line10[56:63];
                8:  char_code = line10[64:71];
                9:  char_code = line10[72:79];
                10:  char_code = line10[80:87];
                11:  char_code = line10[88:95];
                12:  char_code = line10[96:103];
                13:  char_code = line10[104:111];
                14:  char_code = line10[112:119];
                15:  char_code = line0[120:127];
                default:
                char_code =7'h45;  
            endcase
        
        else if (char_xy[3:0] == 11) //jedenasta linijka
            case (char_xy[7:4])
                0:  char_code = line11[0:7];
                1:  char_code = line11[8:15];
                2:  char_code = line11[16:23];
                3:  char_code = line11[24:31];
                4:  char_code = line11[32:39];
                5:  char_code = line11[40:47];
                6:  char_code = line11[48:55];
                7:  char_code = line11[56:63];
                8:  char_code = line11[64:71];
                9:  char_code = line11[72:79];
                10:  char_code = line11[80:87];
                11:  char_code = line11[88:95];
                12:  char_code = line11[96:103];
                13:  char_code = line11[104:111];
                14:  char_code = line11[112:119];
                15:  char_code = line0[120:127];
                default:
                char_code =7'h45;  
            endcase
        
        else if (char_xy[3:0] == 12) //dwunasta linijka
            case (char_xy[7:4])
                0:  char_code = line12[0:7];
                1:  char_code = line12[8:15];
                2:  char_code = line12[16:23];
                3:  char_code = line12[24:31];
                4:  char_code = line12[32:39];
                5:  char_code = line12[40:47];
                6:  char_code = line12[48:55];
                7:  char_code = line12[56:63];
                8:  char_code = line12[64:71];
                9:  char_code = line12[72:79];
                10:  char_code = line12[80:87];
                11:  char_code = line12[88:95];
                12:  char_code = line12[96:103];
                13:  char_code = line12[104:111];
                14:  char_code = line12[112:119];
                15:  char_code = line12[120:127];
                default:
                char_code =7'h45;  
            endcase
        
        else if (char_xy[3:0] == 13) //trzynasta linijka
            case (char_xy[7:4])
                0:  char_code = line13[0:7];
                1:  char_code = line13[8:15];
                2:  char_code = line13[16:23];
                3:  char_code = line13[24:31];
                4:  char_code = line13[32:39];
                5:  char_code = line13[40:47];
                6:  char_code = line13[48:55];
                7:  char_code = line13[56:63];
                8:  char_code = line13[64:71];
                9:  char_code = line13[72:79];
                10:  char_code = line13[80:87];
                11:  char_code = line13[88:95];
                12:  char_code = line13[96:103];
                13:  char_code = line13[104:111];
                14:  char_code = line13[112:119];
                15:  char_code = line13[120:127];
                default:
                char_code =7'h45; 
            endcase
        
        else if (char_xy[3:0] == 14) //czternasta linijka
            case (char_xy[7:4])
                0:  char_code = line14[0:7];
                1:  char_code = line14[8:15];
                2:  char_code = line14[16:23];
                3:  char_code = line14[24:31];
                4:  char_code = line14[32:39];
                5:  char_code = line14[40:47];
                6:  char_code = line14[48:55];
                7:  char_code = line14[56:63];
                8:  char_code = line14[64:71];
                9:  char_code = line14[72:79];
                10:  char_code = line14[80:87];
                11:  char_code = line14[88:95];
                12:  char_code = line14[96:103];
                13:  char_code = line14[104:111];
                14:  char_code = line14[112:119];
                15:  char_code = line14[120:127];
                default:
                char_code =7'h45; 
            endcase
        
        else if (char_xy[3:0] == 15) //pietnasta linijka
            case (char_xy[7:4])
                0:  char_code = line15[0:7];
                1:  char_code = line15[8:15];
                2:  char_code = line15[16:23];
                3:  char_code = line15[24:31];
                4:  char_code = line15[32:39];
                5:  char_code = line15[40:47];
                6:  char_code = line15[48:55];
                7:  char_code = line15[56:63];
                8:  char_code = line15[64:71];
                9:  char_code = line15[72:79];
                10:  char_code = line15[80:87];
                11:  char_code = line15[88:95];
                12:  char_code = line15[96:103];
                13:  char_code = line15[104:111];
                14:  char_code = line15[112:119];
                15:  char_code = line15[120:127];
                default:
                char_code =7'h45;  
            endcase
         else  
                char_code =7'h45;
    endmodule
