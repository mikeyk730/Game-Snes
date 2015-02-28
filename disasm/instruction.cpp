#include <cstdarg>
#include <iomanip>
#include "instruction.h"

using namespace std;

InstructionMetadata::InstructionMetadata() :
m_name(""),
m_opcode(0),
m_instruction_handler(0),
m_bitmask(0)
{ }

InstructionMetadata::InstructionMetadata(const std::string& name, unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler, int bitmask) :
m_name(name),
m_opcode(opcode),
m_instruction_handler(address_mode_handler),
m_annotation_handler(annotation_handler),
m_bitmask(bitmask)
{ }

std::string InstructionMetadata::annotated_name(bool is_accum_16, bool is_index_16) const {
    if (m_annotation_handler){
        return m_name + (*m_annotation_handler)(is_accum_16, is_index_16);
    }
    return m_name;
}

bool InstructionMetadata::isBranch() const 
{
    return (m_bitmask & IS_BRANCH) != 0;
}

bool InstructionMetadata::isCodeBreak() const
{
    return (m_name == "RTS" || m_name == "RTI" || m_name == "RTL"
        || m_name == "JMP" || m_name == "BRA");
}

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