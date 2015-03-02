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

InstructionMetadata::InstructionMetadata(const string& internal_name, unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler) :
m_internal_name(internal_name),
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
    string name = m_name_provider ? m_name_provider->get_name(m_metadata.opcode()) 
        : m_metadata.internal_name();
    return name + m_metadata.annotation(m_accum_16, m_index_16);
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
