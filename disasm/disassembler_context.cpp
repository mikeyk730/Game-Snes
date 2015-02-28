#include "disassembler_context.h"
#include "disassembler.h"
#include "utils.h"
#include "proto.h"

using namespace Address;

DisassemblerContext::DisassemblerContext(Disassembler* disasm,
    const InstructionMetadata& instr, unsigned int* pc, int* flag, bool* accum16, bool* index16, int* low, int* high, int bank, int offset)
    : d(*disasm), i(instr), m_pc(*pc), m_flag(*flag), m_accum_16(*accum16), m_index_16(*index16), m_low(*low), m_high(*high), m_bank(bank), m_offset(offset)
{ }

unsigned char DisassemblerContext::read_next_byte(int* pc)
{
    ++m_pc;
    if (pc) {
        *pc = m_pc;
    }
    return read_char(srcfile);
}

void DisassemblerContext::set_flag(int flag) { 
    m_flag |= flag; 
}

void DisassemblerContext::set_accum_16(bool is_16) {
    m_accum_16 = is_16; 
}

void DisassemblerContext::set_index_16(bool is_16) { 
    m_index_16 = is_16; 
}

void DisassemblerContext::set_range(int low, int high)
{
    m_low = low;
    m_high = high;
}

std::string DisassemblerContext::get_label(unsigned char bank, unsigned int pc)
{
    return d.get_label(i, bank, pc, m_offset, true, true);
}