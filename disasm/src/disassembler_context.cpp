#include "disassembler_context.h"
#include "disassembler.h"
#include "utils.h"

using namespace Address;

DisassemblerContext::DisassemblerContext(Disassembler* disasm, const InstructionMetadata& instr, DisassemblerState* s, int* flag, int data_bank, int offset)
    : d(*disasm), state(*s), i(instr), m_flag(*flag), m_data_bank(data_bank), m_offset(offset)
{ }

unsigned char DisassemblerContext::read_next_byte(int* pc)
{
    char c = d.read_next_byte();
    if (pc) {
        *pc = state.get_current_pc();
    }
    return c;
}

void DisassemblerContext::set_flag(int flag) 
{ 
    m_flag |= flag; 
}


bool DisassemblerContext::is_index_16() const 
{
    return state.is_index_16bit(); 
}

void DisassemblerContext::set_accum_16(bool is_16)
{
    state.is_accum_16bit(is_16);
}

bool DisassemblerContext::is_accum_16() const 
{
    return state.is_accum_16bit(); 
}

void DisassemblerContext::set_index_16(bool is_16)
{ 
    state.is_index_16bit(is_16);
}

std::string DisassemblerContext::get_label(unsigned char data_bank, unsigned int pc)
{
    return d.get_instr_label(i, data_bank, pc, m_offset);
}
