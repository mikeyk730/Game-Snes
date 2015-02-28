#include <string>
#include "disassembler.h"
#include "utils.h"

using std::string;
using Address::to_string;

namespace
{
    string spaces(int number)
    {
        return ("\n" + string(number, ' '));
    }
}

std::string Disassembler::getRAMComment(unsigned int addr)
{
    string comment;
    int comment_level = m_request_prop.m_comment_level;

    if (comment_level)
    {
        switch (addr)
        {
            /*
        case 0x1DF9: case 0x1DFA: case 0x1DFB: case 0x1DFC: 
            comment = "/ Play sound effect";
            break;*/
        case 0x2100: comment = "Screen Display Register";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";a0000bbbb a: 0=screen on, 1=screen off  b = brightness";
            } break;
        case 0x2101: comment = "OAM Size and Data Area Designation";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaabbccc a = Size  b = Name Selection  c = Base Selection";
            } break;
        case 0x2102: comment = "Address for Accessing OAM"; break;
        case 0x2104: comment = "OAM Data Write"; break;
        case 0x2105: comment = "BG Mode and Tile Size Setting";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcdefff abcd = BG tile size (4321), 0 = 8x8, 1 = 16x16";
            comment += spaces(10);  comment += ";e = BG 3 High Priority  f = BG Mode";
            } break;
        case 0x2106: comment = "Mosaic Size and BG Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = Mosaic Size  b = Mosaic BG Enable";
            } break;
        case 0x2107: comment = "BG 1 Address and Size";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaaaabb a = Screen Base Address (Upper 6-bit)  b = Screen Size";
            } break;
        case 0x2108: { comment += "; BG 2 Address and Size";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaaaabb a = Screen Base Address (Upper 6-bit).  b = Screen Size";
            } break;
        case 0x2109: comment = "BG 3 Address and Size";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaaaabb a = Screen Base Address (Upper 6-bit)  b = Screen Size";
            } break;
        case 0x210A: comment = "BG 4 Address and Size";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaaaabb a = Screen Base Address (Upper 6-bit)  b = Screen Size";
            } break;
        case 0x210b: comment = "BG 1 & 2 Tile Data Designation";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = BG 2 Tile Base Address  b = BG 1 Tile Base Address";
            } break;
        case 0x210c: comment = "BG 3 & 4 Tile Data Designation";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = BG 4 Tile Base Address  b = BG 3 Tile Base Address";
            } break;
        case 0x210d: comment = "BG 1 Horizontal Scroll Offset"; break;
        case 0x210e: comment = "BG 1 Vertical Scroll Offset"; break;
        case 0x210f: comment = "BG 2 Horizontal Scroll Offset"; break;
        case 0x2110: comment = "BG 2 Vertical Scroll Offset"; break;
        case 0x2111: comment = "BG 3 Horizontal Scroll Offset"; break;
        case 0x2112: comment = "BG 3 Vertical Scroll Offset"; break;
        case 0x2113: comment = "BG 4 Horizontal Scroll Offset"; break;
        case 0x2114: comment = "BG 4 Vertical Scroll Offset"; break;
        case 0x2115: comment = "VRAM Address Increment Value"; break;
        case 0x2116: comment = "Address for VRAM Read/Write (Low Byte)"; break;
        case 0x2117: comment = "Address for VRAM Read/Write (High Byte)"; break;
        case 0x2118: comment = "Data for VRAM Write (Low Byte)"; break;
        case 0x2119: comment = "Data for VRAM Write (High Byte)"; break;
        case 0x211a: comment = "Initial Setting for Mode 7";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aa0000bc a = Screen Over  b = Vertical Flip  c = Horizontal Flip";
            } break;
        case 0x211b: comment = "Mode 7 Matrix Parameter A"; break;
        case 0x211c: comment = "Mode 7 Matrix Parameter B"; break;
        case 0x211d: comment = "Mode 7 Matrix Parameter C"; break;
        case 0x211e: comment = "Mode 7 Matrix Parameter D"; break;
        case 0x211f: comment = "Mode 7 Center Position X"; break;
        case 0x2120: comment = "Mode 7 Center Position Y"; break;
        case 0x2121: comment = "Address for CG-RAM Write"; break;
        case 0x2122: comment = "Data for CG-RAM Write"; break;
        case 0x2123: comment = "BG 1 and 2 Window Mask Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = BG 2 Window Settings  b = BG 1 Window Settings";
            } break;
        case 0x2124: comment = "BG 3 and 4 Window Mask Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = BG 4 Window Settings  b = BG 3 Window Settings";
            } break;
        case 0x2125: comment = "OBJ and Color Window Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aaaabbbb a = Color Window Settings  b = OBJ Window Settings";
            } break;
        case 0x2126: comment = "Window 1 Left Position Designation"; break;
        case 0x2127: comment = "Window 1 Right Position Designation"; break;
        case 0x2128: comment = "Window 2 Left Postion Designation"; break;
        case 0x2129: comment = "Window 2 Right Postion Designation"; break;
        case 0x212a: comment = "BG 1, 2, 3 and 4 Window Logic Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aabbccdd a = BG 4  b = BG 3  c = BG 2  d = BG 1";
            } break;
        case 0x212b: comment = "Color and OBJ Window Logic Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";0000aabb a = Color Window  b = OBJ Window";
            } break;
        case 0x212c: comment = "Background and Object Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";000abcde a = Object  b = BG 4  c = BG 3  d = BG 2  e = BG 1";
            } break;
        case 0x212d: comment = "Sub Screen Designation";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";000abcde a = Object  b = BG 4  c = BG 3  d = BG 2  e = BG 1";
            } break;
        case 0x212e: comment = "Window Mask Designation for Main Screen";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";000abcde a = Object  b = BG 4  c = BG 3  d = BG 2  e = BG 1";
            } break;
        case 0x212f: comment = "Window Mask Designation for Sub Screen";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";000abcde a = Object  b = BG 4  c = BG 3  d = BG 2  e = BG 1";
            } break;
        case 0x2130: comment = "Initial Settings for Color Addition";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";aabb00cd a = Main Color Window On/Off b = Sub Color Window On/Off";
            comment += spaces(10); comment += ";c = Fixed Color Add/Subtract Enable  d = Direct Select";
            } break;
        case 0x2131: comment = "Add/Subtract Select and Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcdefgh  a = 0 = Addition, 1 = Subtraction  b = 1/2 Enable";
            comment += spaces(10);
            comment += ";cdefgh = Enables  c = Back, d = Object, efgh = BG 4, 3, 2, 1";
            } break;
        case 0x2132: comment = "Fixed Color Data";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcddddd a = Blue  b = Green  c = Red  dddd = Color Data";
            } break;
        case 0x2133: comment = "Screen Initial Settings";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";ab00cdef a = External Sync  b = ExtBG Mode  c = Pseudo 512 Mode";
            comment += spaces(10); comment += ";d = Vertical Size  e = Object-V Select  f = Interlace";
            } break;
        case 0x2134: comment = "Multiplication Result (Low Byte)"; break;
        case 0x2135: comment = "Multiplication Result (Mid Byte)"; break;
        case 0x2136: comment = "Multiplication Result (High Byte)"; break;
        case 0x2137: comment = "Software Latch for H/V Counter"; break;
        case 0x2138: comment = "Read Data from OAM (Low-High)"; break;
        case 0x2139: comment = "Read Data from VRAM (Low)"; break;
        case 0x213a: comment = "Read Data from VRAM (High)"; break;
        case 0x213b: comment = "Read Data from CG-RAM (Low-High)"; break;
        case 0x213c: comment = "H-Counter Data"; break;
        case 0x213d: comment = "V-Counter Data"; } break;
        case 0x213e: case 0x213f: comment = "PPU Status Flag"; break;
        case 0x2140: case 0x2141: case 0x2142: case 0x2143: comment = "APU I/O Port"; break;
        case 0x4200: comment = "NMI, V/H Count, and Joypad Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";a0bc000d a = NMI  b = V-Count  c = H-Count  d = Joypad";
            } break;
        case 0x4201: comment = "Programmable I/O Port Output"; break;
        case 0x4202: comment = "Multiplicand A"; break;
        case 0x4203: comment = "Multplier B"; break;
        case 0x4204: comment = "Dividend (Low Byte)"; break;
        case 0x4205: comment = "Dividend (High-Byte)"; break;
        case 0x4206: comment = "Divisor B"; break;
        case 0x4207: comment = "H-Count Timer (Upper 8 Bits)"; break;
        case 0x4208: comment = "H-Count Timer MSB (Bit 0)"; break;
        case 0x4209: comment = "V-Count Timer (Upper 8 Bits)"; break;
        case 0x420a: comment = "V-Count Timer MSB (Bit 0)"; break;
        case 0x420b: comment = "Regular DMA Channel Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcdefgh  a = Channel 7 .. h = Channel 0: 0 = Enable  1 = Disable";
            } break;
        case 0x420c: comment = "H-DMA Channel Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcdefgh  a = Channel 7 .. h = Channel 0: 0 = Enable  1 = Disable";
            } break;
        case 0x420d: comment = "Cycle Speed Designation";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";0000000a a: 0 = 2.68 MHz, 1 = 3.58 MHz"; } break;
        case 0x4210: comment = "NMI Enable";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";a0000000 a: 0 = Disabled, 1 = Enabled"; } break;
        case 0x4211: comment = "IRQ Flag By H/V Count Timer";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";a0000000 a: 0 = H/V Timer Disabled, 1 = H/V Timer is Time Up";
            } break;
        case 0x4212: comment = "H/V Blank Flags and Joypad Status";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";ab00000c a = V Blank  b = H Blank  c = Joypad Ready to Be Read";
            } break;
        case 0x4213: comment = "Programmable I/O Port Input"; break;
        case 0x4214: comment = "Quotient of Divide Result (Low Byte)"; break;
        case 0x4215: comment = "Quotient of Divide Result (High Byte)"; break;
        case 0x4216: comment = "Product/Remainder Result (Low Byte)"; break;
        case 0x4217: comment = "Product/Remainder Result (High Byte)"; break;
        case 0x4218: case 0x421a: case 0x421c: case 0x421e: comment = "Joypad " + to_string((addr-0x4217)/2+1, 1, false) + "Data (Low Byte)";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcd0000 a = Button A  b = X  c = L  d = R"; } break;
        case 0x4219: case 0x421b: case 0x421d: case 0x421f: comment = "Joypad " + to_string((addr-0x4218)/2+1, 1, false) + "Data (High Byte)";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";abcdefgh a = B b = Y c = Select d = Start efgh = Up/Dn/Lt/Rt";
            } break;
        case 0x4300: case 0x4310: case 0x4320: case 0x4330: case 0x4340:
        case 0x4350: case 0x4360: case 0x4370: comment = "Parameters for DMA Transfer";
            if (comment_level > 1) { comment += spaces(10);
            comment += ";ab0cdeee a = Direction  b = Type  c = Inc/Dec  d = Auto/Fixed";
            comment += spaces(10); comment += ";e = Word Size Select";
            } break;
        case 0x4301: case 0x4311: case 0x4321: case 0x4331: case 0x4341:
        case 0x4351: case 0x4361: case 0x4371: comment = "B Address"; break;
        case 0x4302: case 0x4312: case 0x4322: case 0x4332: case 0x4342:
        case 0x4352: case 0x4362: case 0x4372: comment = "A Address (Low Byte)"; break;
        case 0x4303: case 0x4313: case 0x4323: case 0x4333: case 0x4343:
        case 0x4353: case 0x4363: case 0x4373: comment = "A Address (High Byte)"; break;
        case 0x4304: case 0x4314: case 0x4324: case 0x4334: case 0x4344:
        case 0x4354: case 0x4364: case 0x4374: comment = "A Address Bank"; break;
        case 0x4305: case 0x4315: case 0x4325: case 0x4335: case 0x4345:
        case 0x4355: case 0x4365: case 0x4375: comment = "Number Bytes to Transfer (Low Byte) (DMA)"; break;
        case 0x4306: case 0x4316: case 0x4326: case 0x4336: case 0x4346:
        case 0x4356: case 0x4366: case 0x4376: comment = "Number Bytes to Transfer (High Byte) (DMA)"; break;
        case 0x4307: case 0x4317: case 0x4327: case 0x4337: case 0x4347:
        case 0x4357: case 0x4367: case 0x4377: comment = "Data Bank (H-DMA)"; break;
        case 0x4308: case 0x4318: case 0x4328: case 0x4338: case 0x4348:
        case 0x4358: case 0x4368: case 0x4378: comment = "A2 Table Address (Low Byte)"; break;
        case 0x4309: case 0x4319: case 0x4329: case 0x4339: case 0x4349:
        case 0x4359: case 0x4369: case 0x4379: comment = "A2 Table Address (High Byte)"; break;
        case 0x430a: case 0x431a: case 0x432a: case 0x433a: case 0x434a:
        case 0x435a: case 0x436a: case 0x437a: comment = "Number of Lines to Transfer (H-DMA)"; break;

        }
    }
    if (comment != "") return ("; " + comment);
    return comment;
}

