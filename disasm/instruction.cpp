#include "instruction.h"
#include <cstdarg>
#include <iomanip>

using namespace std;

InstructionOutput::InstructionOutput()
{
    address[0] = 0;
    additional_instruction[0] = 0;
}

void InstructionOutput::addInstructionBytes(unsigned char a)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " ";
}

void InstructionOutput::addInstructionBytes(unsigned char a, unsigned char b)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)b << " ";
}

void InstructionOutput::addInstructionBytes(unsigned char a, unsigned char b, unsigned char c)
{
    instruction_bytes
        << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)b << " "
        << setw(2) << setfill('0') << uppercase << hex << (int)c << " ";
}

string InstructionOutput::getInstructionBytes()
{
    return instruction_bytes.str();
}

void InstructionOutput::setAddress(const char *format, ...){
    va_list args;
    va_start(args, format);
    vsprintf_s(address, format, args);
    va_end(args);
}

string InstructionOutput::getAddress() const
{
    return address;
}

void InstructionOutput::setAdditionalInstruction(const char* format, ...)
{
    va_list args;
    va_start(args, format);
    vsprintf_s(additional_instruction, format, args);
    va_end(args);
}

string InstructionOutput::getAdditionalInstruction() const
{
    return additional_instruction;
}