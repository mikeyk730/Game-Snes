#include <cstdarg>
#include <iomanip>
#include "instruction.h"

using namespace std;

InstructionMetadata::InstructionMetadata() :
m_name(""),
m_opcode(0),
m_instruction_handler(0)
{ }

InstructionMetadata::InstructionMetadata(const std::string& name, unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler) :
m_name(name),
m_opcode(opcode),
m_instruction_handler(address_mode_handler),
m_annotation_handler(annotation_handler)
{ }

std::string InstructionMetadata::annotated_name(bool is_accum_16, bool is_index_16) const {
    if (m_annotation_handler){
        return m_name + (*m_annotation_handler)(is_accum_16, is_index_16);
    }
    return m_name;
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

bool InstructionMetadata::isCodeBreak() const
{
    return (isReturn() || m_name == "JMP" || m_name == "BRA");
}

bool InstructionMetadata::isReturn() const
{
    return (m_name == "RTS" || m_name == "RTI" || m_name == "RTL");
}

Instruction::Instruction(const InstructionMetadata& metadata, bool accum_16, bool index_16, int comment_level)
: m_metadata(metadata),
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