#include "instruction.h"
#include <cstdarg>
#include <iomanip>

using namespace std;

Instruction::Instruction(const InstructionMetadata& metadata, bool accum_16, bool index_16)
: m_metadata(metadata),
m_accum_16(accum_16),
m_index_16(index_16)
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

string Instruction::toString() const
{
    return m_metadata.annotated_name(m_accum_16, m_index_16) + " " + getAddress();
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