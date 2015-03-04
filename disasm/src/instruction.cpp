#include <cstdarg>
#include <iomanip>
#include <iostream>
#include "disassembler.h"
#include "instruction.h"
#include "annotation_handlers.h"
#include "utils.h"

using namespace std;

InstructionMetadata::InstructionMetadata() :
m_opcode(0),
m_instruction_handler(0)
{ }

InstructionMetadata::InstructionMetadata(const string& internal_name, unsigned int opcode, InstructionHandlerPtr address_mode_handler) :
m_internal_name(internal_name),
m_opcode(opcode),
m_instruction_handler(address_mode_handler)
{ }

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
        m_opcode == 0x82 ||
        m_opcode == 0x50 ||
        m_opcode == 0x70;
}

bool InstructionMetadata::isCall() const
{
    return       
        m_opcode == 0x4C ||
        m_opcode == 0x5C ||
        m_opcode == 0x6C ||
        m_opcode == 0x7C ||
        m_opcode == 0xDC ||
        m_opcode == 0x80;
}

bool InstructionMetadata::isJump() const
{
    return
        m_opcode == 0x20 ||
        m_opcode == 0x22 ||
        m_opcode == 0xFC;
}

bool InstructionMetadata::isReturn() const
{
    return
        m_opcode == 0x40 || //RTI
        m_opcode == 0x60 || //RTS
        m_opcode == 0x6B;   //RTL
}

Instruction::Instruction(const InstructionMetadata& metadata, shared_ptr<InstructionNameProvider> name_provider, shared_ptr<AnnotationProvider> annotation_provider, const DisassemblerState& state, int comment_level)
: m_metadata(metadata),
m_name_provider(name_provider), 
m_annotation_provider(annotation_provider),
m_is_address_symbolic(false),
m_comment_level(comment_level),
m_initial_accum_16(state.is_accum_16bit()), 
m_initial_index_16(state.is_index_16bit())
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

void Instruction::setSymbolicAddress(const char *format, ...)
{
    m_is_address_symbolic = true;

    va_list args;
    va_start(args, format);
    vsprintf_s(address, format, args);
    va_end(args);
}

void Instruction::setDirectAddress(const char *format, ...)
{
    m_is_address_symbolic = false;

    va_list args;
    va_start(args, format);
    vsprintf_s(address, format, args);
    va_end(args);
}

string Instruction::getAddress() const
{
    return address;
}

string Instruction::flag_comment(int flags) const
{
    string comment;
    if (m_comment_level > 1 && flags != 0){
        if (flags & 0x10) comment += "Index (16 bit) ";
        if (flags & 0x20) comment += "Accum (16 bit) ";
        if (flags & 0x01) comment += "Index (8 bit) ";
        if (flags & 0x02) comment += "Accum (8 bit) ";
    }
    return comment;
}

string Instruction::annotatedName() const
{
    string name = m_name_provider ? m_name_provider->get_name(m_metadata.opcode()) 
        : m_metadata.internal_name();
    string annotation = m_annotation_provider->get_annotation(m_metadata.opcode(), m_initial_accum_16, m_initial_index_16, isAddressSymbolic());
    return name + annotation;
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
