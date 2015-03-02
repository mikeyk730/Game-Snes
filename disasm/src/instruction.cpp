#include <cstdarg>
#include <iomanip>
#include <iostream>
#include "instruction.h"
#include "utils.h"

using namespace std;

InstructionMetadata::InstructionMetadata() :
m_opcode(0),
m_instruction_handler(0)
{ }

InstructionMetadata::InstructionMetadata(unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler) :
m_opcode(opcode),
m_instruction_handler(address_mode_handler),
m_annotation_handler(annotation_handler)
{ }

string InstructionMetadata::annotation(bool is_accum_16, bool is_index_16) const {
    if (m_annotation_handler){
        return (*m_annotation_handler)(is_accum_16, is_index_16);
    }
    return string();
}

bool InstructionMetadata::isBranch() const 
{
    return 
        m_opcode == 0x90 ||
        m_opcode == 0xB0 ||
        m_opcode == 0xF0 ||
        m_opcode == 0x30 ||
        m_opcode == 0xD0 ||
        m_opcode == 0x10 ||
        m_opcode == 0x80 ||
        m_opcode == 0x50 ||
        m_opcode == 0x70;
}

bool InstructionMetadata::isJump() const
{
    return
        m_opcode == 0x4C ||
        m_opcode == 0x5C ||
        m_opcode == 0x6C ||
        m_opcode == 0x7C ||
        m_opcode == 0xDC;
}

bool InstructionMetadata::isReturn() const
{
    return
        m_opcode == 0x40 || //RTI
        m_opcode == 0x60 || //RTS
        m_opcode == 0x6B;   //RTL
}

Instruction::Instruction(const InstructionMetadata& metadata, shared_ptr<InstructionNameProvider> name_provider, bool accum_16, bool index_16, int comment_level)
: m_metadata(metadata),
m_name_provider(name_provider),
m_accum_16(accum_16),
m_index_16(index_16),
m_comment_level(comment_level)
{
    address[0] = 0;
    additional_instruction[0] = 0;
    if (metadata.is_snes_instruction()){
        addInstructionBytes(metadata.opcode());
    }
}

void Instruction::addInstructionBytes(unsigned char a)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " ";
}

void Instruction::addInstructionBytes(unsigned char a, unsigned char b)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)b << " ";
}

void Instruction::addInstructionBytes(unsigned char a, unsigned char b, unsigned char c)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)b << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)c << " ";
}

string Instruction::getInstructionBytes() const
{
    return instruction_bytes.str();
}

void Instruction::setAddress(const char *format, ...){
    va_list args;
    va_start(args, format);
    vsprintf_s(address, format, args);
    va_end(args);
}

string Instruction::getAddress() const
{
    return address;
}

string Instruction::annotatedName() const
{
    return m_name_provider->get_name(m_metadata.opcode()) + m_metadata.annotation(m_accum_16, m_index_16);
}

string Instruction::toString() const
{
    return annotatedName() + " " + getAddress();
}

void Instruction::setAdditionalInstruction(const char* format, ...)
{
    va_list args;
    va_start(args, format);
    vsprintf_s(additional_instruction, format, args);
    va_end(args);
}

string Instruction::getAdditionalInstruction() const
{
    return additional_instruction;
}

InstructionNameProvider::InstructionNameProvider(std::istream& input)
{
    string line;
    while (getline(input, line)){
        if (Input::is_comment(line)) continue;

        int hex_addr;
        string name;

        istringstream ss(line);
        if (!(ss >> hex >> hex_addr))
            continue;
        ss.get(); //consume space delimiter
        if (!getline(ss, name))
            continue;

        if (!m_names.insert(make_pair(hex_addr, name)).second)
            cerr << "failed to add name >" << name << "<" << endl;
    }
}

string InstructionNameProvider::get_name(int opcode) const
{
    auto it = m_names.find(opcode);
    if (it != m_names.end()){
        return it->second;
    }
    return "???";
}

InstructionNameProvider::InstructionNameProvider()
{
    m_names.insert(make_pair(0x00, "BRK"));
    m_names.insert(make_pair(0x01, "ORA"));
    m_names.insert(make_pair(0x02, "COP"));
    m_names.insert(make_pair(0x03, "ORA"));
    m_names.insert(make_pair(0x04, "TSB"));
    m_names.insert(make_pair(0x05, "ORA"));
    m_names.insert(make_pair(0x06, "ASL"));
    m_names.insert(make_pair(0x07, "ORA"));
    m_names.insert(make_pair(0x08, "PHP"));
    m_names.insert(make_pair(0x09, "ORA"));
    m_names.insert(make_pair(0x0A, "ASL"));
    m_names.insert(make_pair(0x0B, "PHD"));
    m_names.insert(make_pair(0x0C, "TSB"));
    m_names.insert(make_pair(0x0D, "ORA"));
    m_names.insert(make_pair(0x0E, "ASL"));
    m_names.insert(make_pair(0x0F, "ORA"));
    m_names.insert(make_pair(0x10, "BPL"));
    m_names.insert(make_pair(0x11, "ORA"));
    m_names.insert(make_pair(0x12, "ORA"));
    m_names.insert(make_pair(0x13, "ORA"));
    m_names.insert(make_pair(0x14, "TRB"));
    m_names.insert(make_pair(0x15, "ORA"));
    m_names.insert(make_pair(0x16, "ASL"));
    m_names.insert(make_pair(0x17, "ORA"));
    m_names.insert(make_pair(0x18, "CLC"));
    m_names.insert(make_pair(0x19, "ORA"));
    m_names.insert(make_pair(0x1A, "INC"));
    m_names.insert(make_pair(0x1B, "TCS"));
    m_names.insert(make_pair(0x1C, "TRB"));
    m_names.insert(make_pair(0x1D, "ORA"));
    m_names.insert(make_pair(0x1E, "ASL"));
    m_names.insert(make_pair(0x1F, "ORA"));
    m_names.insert(make_pair(0x20, "JSR"));
    m_names.insert(make_pair(0x21, "AND"));
    m_names.insert(make_pair(0x22, "JSL"));
    m_names.insert(make_pair(0x23, "AND"));
    m_names.insert(make_pair(0x24, "BIT"));
    m_names.insert(make_pair(0x25, "AND"));
    m_names.insert(make_pair(0x26, "ROL"));
    m_names.insert(make_pair(0x27, "AND"));
    m_names.insert(make_pair(0x28, "PLP"));
    m_names.insert(make_pair(0x29, "AND"));
    m_names.insert(make_pair(0x2A, "ROL"));
    m_names.insert(make_pair(0x2B, "PLD"));
    m_names.insert(make_pair(0x2C, "BIT"));
    m_names.insert(make_pair(0x2D, "AND"));
    m_names.insert(make_pair(0x2E, "ROL"));
    m_names.insert(make_pair(0x2F, "AND"));
    m_names.insert(make_pair(0x30, "BMI"));
    m_names.insert(make_pair(0x31, "AND"));
    m_names.insert(make_pair(0x32, "AND"));
    m_names.insert(make_pair(0x33, "AND"));
    m_names.insert(make_pair(0x34, "BIT"));
    m_names.insert(make_pair(0x35, "AND"));
    m_names.insert(make_pair(0x36, "ROL"));
    m_names.insert(make_pair(0x37, "AND"));
    m_names.insert(make_pair(0x38, "SEC"));
    m_names.insert(make_pair(0x39, "AND"));
    m_names.insert(make_pair(0x3A, "DEC"));
    m_names.insert(make_pair(0x3B, "TSC"));
    m_names.insert(make_pair(0x3C, "BIT"));
    m_names.insert(make_pair(0x3D, "AND"));
    m_names.insert(make_pair(0x3E, "ROL"));
    m_names.insert(make_pair(0x3F, "AND"));
    m_names.insert(make_pair(0x40, "RTI"));
    m_names.insert(make_pair(0x41, "EOR"));
    m_names.insert(make_pair(0x43, "EOR"));
    m_names.insert(make_pair(0x44, "MVP"));
    m_names.insert(make_pair(0x45, "EOR"));
    m_names.insert(make_pair(0x46, "LSR"));
    m_names.insert(make_pair(0x47, "EOR"));
    m_names.insert(make_pair(0x48, "PHA"));
    m_names.insert(make_pair(0x49, "EOR"));
    m_names.insert(make_pair(0x4A, "LSR"));
    m_names.insert(make_pair(0x4B, "PHK"));
    m_names.insert(make_pair(0x4C, "JMP"));
    m_names.insert(make_pair(0x4D, "EOR"));
    m_names.insert(make_pair(0x4E, "LSR"));
    m_names.insert(make_pair(0x4F, "EOR"));
    m_names.insert(make_pair(0x50, "BVC"));
    m_names.insert(make_pair(0x51, "EOR"));
    m_names.insert(make_pair(0x52, "EOR"));
    m_names.insert(make_pair(0x53, "EOR"));
    m_names.insert(make_pair(0x54, "MVN"));
    m_names.insert(make_pair(0x55, "EOR"));
    m_names.insert(make_pair(0x56, "LSR"));
    m_names.insert(make_pair(0x57, "EOR"));
    m_names.insert(make_pair(0x58, "CLI"));
    m_names.insert(make_pair(0x59, "EOR"));
    m_names.insert(make_pair(0x5A, "PHY"));
    m_names.insert(make_pair(0x5B, "TCD"));
    m_names.insert(make_pair(0x5C, "JMP"));
    m_names.insert(make_pair(0x5D, "EOR"));
    m_names.insert(make_pair(0x5E, "LSR"));
    m_names.insert(make_pair(0x5F, "EOR"));
    m_names.insert(make_pair(0x60, "RTS"));
    m_names.insert(make_pair(0x61, "ADC"));
    m_names.insert(make_pair(0x62, "PER"));
    m_names.insert(make_pair(0x63, "ADC"));
    m_names.insert(make_pair(0x64, "STZ"));
    m_names.insert(make_pair(0x65, "ADC"));
    m_names.insert(make_pair(0x66, "ROR"));
    m_names.insert(make_pair(0x67, "ADC"));
    m_names.insert(make_pair(0x68, "PLA"));
    m_names.insert(make_pair(0x69, "ADC"));
    m_names.insert(make_pair(0x6A, "ROR"));
    m_names.insert(make_pair(0x6B, "RTL"));
    m_names.insert(make_pair(0x6C, "JMP"));
    m_names.insert(make_pair(0x6D, "ADC"));
    m_names.insert(make_pair(0x6E, "ROR"));
    m_names.insert(make_pair(0x6F, "ADC"));
    m_names.insert(make_pair(0x70, "BVS"));
    m_names.insert(make_pair(0x71, "ADC"));
    m_names.insert(make_pair(0x72, "ADC"));
    m_names.insert(make_pair(0x73, "ADC"));
    m_names.insert(make_pair(0x74, "STZ"));
    m_names.insert(make_pair(0x75, "ADC"));
    m_names.insert(make_pair(0x76, "ROR"));
    m_names.insert(make_pair(0x77, "ADC"));
    m_names.insert(make_pair(0x78, "SEI"));
    m_names.insert(make_pair(0x79, "ADC"));
    m_names.insert(make_pair(0x7A, "PLY"));
    m_names.insert(make_pair(0x7B, "TDC"));
    m_names.insert(make_pair(0x7C, "JMP"));
    m_names.insert(make_pair(0x7D, "ADC"));
    m_names.insert(make_pair(0x7E, "ROR"));
    m_names.insert(make_pair(0x7F, "ADC"));
    m_names.insert(make_pair(0x80, "BRA"));
    m_names.insert(make_pair(0x81, "STA"));
    m_names.insert(make_pair(0x82, "BRL"));
    m_names.insert(make_pair(0x83, "STA"));
    m_names.insert(make_pair(0x84, "STY"));
    m_names.insert(make_pair(0x85, "STA"));
    m_names.insert(make_pair(0x86, "STX"));
    m_names.insert(make_pair(0x87, "STA"));
    m_names.insert(make_pair(0x88, "DEY"));
    m_names.insert(make_pair(0x89, "BIT"));
    m_names.insert(make_pair(0x8A, "TXA"));
    m_names.insert(make_pair(0x8B, "PHB"));
    m_names.insert(make_pair(0x8C, "STY"));
    m_names.insert(make_pair(0x8D, "STA"));
    m_names.insert(make_pair(0x8E, "STX"));
    m_names.insert(make_pair(0x8F, "STA"));
    m_names.insert(make_pair(0x90, "BCC"));
    m_names.insert(make_pair(0x91, "STA"));
    m_names.insert(make_pair(0x92, "STA"));
    m_names.insert(make_pair(0x93, "STA"));
    m_names.insert(make_pair(0x94, "STY"));
    m_names.insert(make_pair(0x95, "STA"));
    m_names.insert(make_pair(0x96, "STX"));
    m_names.insert(make_pair(0x97, "STA"));
    m_names.insert(make_pair(0x98, "TYA"));
    m_names.insert(make_pair(0x99, "STA"));
    m_names.insert(make_pair(0x9A, "TXS"));
    m_names.insert(make_pair(0x9B, "TXY"));
    m_names.insert(make_pair(0x9C, "STZ"));
    m_names.insert(make_pair(0x9D, "STA"));
    m_names.insert(make_pair(0x9E, "STZ"));
    m_names.insert(make_pair(0x9F, "STA"));
    m_names.insert(make_pair(0xA0, "LDY"));
    m_names.insert(make_pair(0xA1, "LDA"));
    m_names.insert(make_pair(0xA2, "LDX"));
    m_names.insert(make_pair(0xA3, "LDA"));
    m_names.insert(make_pair(0xA4, "LDY"));
    m_names.insert(make_pair(0xA5, "LDA"));
    m_names.insert(make_pair(0xA6, "LDX"));
    m_names.insert(make_pair(0xA7, "LDA"));
    m_names.insert(make_pair(0xA8, "TAY"));
    m_names.insert(make_pair(0xA9, "LDA"));
    m_names.insert(make_pair(0xAA, "TAX"));
    m_names.insert(make_pair(0xAB, "PLB"));
    m_names.insert(make_pair(0xAC, "LDY"));
    m_names.insert(make_pair(0xAD, "LDA"));
    m_names.insert(make_pair(0xAE, "LDX"));
    m_names.insert(make_pair(0xAF, "LDA"));
    m_names.insert(make_pair(0xB0, "BCS"));
    m_names.insert(make_pair(0xB1, "LDA"));
    m_names.insert(make_pair(0xB2, "LDA"));
    m_names.insert(make_pair(0xB3, "LDA"));
    m_names.insert(make_pair(0xB4, "LDY"));
    m_names.insert(make_pair(0xB5, "LDA"));
    m_names.insert(make_pair(0xB6, "LDX"));
    m_names.insert(make_pair(0xB7, "LDA"));
    m_names.insert(make_pair(0xB8, "CLV"));
    m_names.insert(make_pair(0xB9, "LDA"));
    m_names.insert(make_pair(0xBA, "TSX"));
    m_names.insert(make_pair(0xBB, "TYX"));
    m_names.insert(make_pair(0xBC, "LDY"));
    m_names.insert(make_pair(0xBD, "LDA"));
    m_names.insert(make_pair(0xBE, "LDX"));
    m_names.insert(make_pair(0xBF, "LDA"));
    m_names.insert(make_pair(0xC0, "CPY"));
    m_names.insert(make_pair(0xC1, "CMP"));
    m_names.insert(make_pair(0xC2, "REP"));
    m_names.insert(make_pair(0xC3, "CMP"));
    m_names.insert(make_pair(0xC4, "CPY"));
    m_names.insert(make_pair(0xC5, "CMP"));
    m_names.insert(make_pair(0xC6, "DEC"));
    m_names.insert(make_pair(0xC7, "CMP"));
    m_names.insert(make_pair(0xC8, "INY"));
    m_names.insert(make_pair(0xC9, "CMP"));
    m_names.insert(make_pair(0xCA, "DEX"));
    m_names.insert(make_pair(0xCB, "WAI"));
    m_names.insert(make_pair(0xCC, "CPY"));
    m_names.insert(make_pair(0xCD, "CMP"));
    m_names.insert(make_pair(0xCE, "DEC"));
    m_names.insert(make_pair(0xCF, "CMP"));
    m_names.insert(make_pair(0xD0, "BNE"));
    m_names.insert(make_pair(0xD1, "CMP"));
    m_names.insert(make_pair(0xD2, "CMP"));
    m_names.insert(make_pair(0xD3, "CMP"));
    m_names.insert(make_pair(0xD4, "PEI"));
    m_names.insert(make_pair(0xD5, "CMP"));
    m_names.insert(make_pair(0xD6, "DEC"));
    m_names.insert(make_pair(0xD7, "CMP"));
    m_names.insert(make_pair(0xD8, "CLD"));
    m_names.insert(make_pair(0xD9, "CMP"));
    m_names.insert(make_pair(0xDA, "PHX"));
    m_names.insert(make_pair(0xDB, "STP"));
    m_names.insert(make_pair(0xDC, "JMP"));
    m_names.insert(make_pair(0xDD, "CMP"));
    m_names.insert(make_pair(0xDE, "DEC"));
    m_names.insert(make_pair(0xDF, "CMP"));
    m_names.insert(make_pair(0xE0, "CPX"));
    m_names.insert(make_pair(0xE1, "SBC"));
    m_names.insert(make_pair(0xE2, "SEP"));
    m_names.insert(make_pair(0xE3, "SBC"));
    m_names.insert(make_pair(0xE4, "CPX"));
    m_names.insert(make_pair(0xE5, "SBC"));
    m_names.insert(make_pair(0xE6, "INC"));
    m_names.insert(make_pair(0xE7, "SBC"));
    m_names.insert(make_pair(0xE8, "INX"));
    m_names.insert(make_pair(0xE9, "SBC"));
    m_names.insert(make_pair(0xEA, "NOP"));
    m_names.insert(make_pair(0xEB, "XBA"));
    m_names.insert(make_pair(0xEC, "CPX"));
    m_names.insert(make_pair(0xED, "SBC"));
    m_names.insert(make_pair(0xEE, "INC"));
    m_names.insert(make_pair(0xEF, "SBC"));
    m_names.insert(make_pair(0xF0, "BEQ"));
    m_names.insert(make_pair(0xF1, "SBC"));
    m_names.insert(make_pair(0xF2, "SBC"));
    m_names.insert(make_pair(0xF3, "SBC"));
    m_names.insert(make_pair(0xF4, "PEA"));
    m_names.insert(make_pair(0xF5, "SBC"));
    m_names.insert(make_pair(0xF6, "INC"));
    m_names.insert(make_pair(0xF7, "SBC"));
    m_names.insert(make_pair(0xF8, "SED"));
    m_names.insert(make_pair(0xF9, "SBC"));
    m_names.insert(make_pair(0xFA, "PLX"));
    m_names.insert(make_pair(0xFB, "XCE"));
    m_names.insert(make_pair(0xFC, "JSR"));
    m_names.insert(make_pair(0xFD, "SBC"));
    m_names.insert(make_pair(0xFE, "INC"));
    m_names.insert(make_pair(0xFF, "SBC"));
    m_names.insert(make_pair(0x100, ".dw"));
    m_names.insert(make_pair(0x101, ".dw"));
}
