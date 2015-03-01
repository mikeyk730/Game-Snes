#include "disassembler_context.h"
#include "disassembler.h"
#include "utils.h"

using namespace Address;

DisassemblerContext::DisassemblerContext(Disassembler* disasm,
    const InstructionMetadata& instr, unsigned int* pc, int* flag, bool* accum16, bool* index16, int bank, int offset, FILE* rom_file)
    : d(*disasm), i(instr), m_pc(*pc), m_flag(*flag), m_accum_16(*accum16), m_index_16(*index16), m_bank(bank), m_offset(offset), m_rom_file(rom_file)
{ }

unsigned char DisassemblerContext::read_next_byte(int* pc)
{
    ++m_pc;
    if (pc) {
        *pc = m_pc;
    }
    return read_char(m_rom_file);
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

std::string DisassemblerContext::get_label(unsigned char bank, unsigned int pc)
{
    return d.get_instr_label(i, bank, pc, m_offset);
}
