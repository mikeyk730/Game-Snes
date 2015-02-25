#include "instruction.h"
#include <cstdarg>
#include <iomanip>

using namespace std;

Instruction::Instruction(const InstructionMetadata& metadata)
: m_metadata(metadata)
{
    address[0] = 0;
    additional_instruction[0] = 0;
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

string Instruction::getInstructionBytes()
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

string Instruction::toString(bool is_accum_16, bool is_index_16) const
{
    return m_metadata.annotated_name(is_accum_16, is_index_16) + " " + getAddress();
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