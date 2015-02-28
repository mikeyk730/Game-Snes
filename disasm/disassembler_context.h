#include <string>

struct Disassembler;
class InstructionMetadata;

struct DisassemblerContext
{
    DisassemblerContext(Disassembler* disasm,
    const InstructionMetadata& instr, unsigned int* pc, int* flag, bool* accum16, bool* index16, int* low, int* high, int bank, int offset, FILE* rom_file);

    unsigned char read_next_byte(int* pc);

    void set_flag(int flag);

    void set_accum_16(bool is_16);
    void set_index_16(bool is_16);

    void set_range(int low, int high);

    unsigned char address_bank() const { return m_bank; }
    int offset() const { return m_offset; }
    bool is_index_16(){ return m_index_16; }
    bool is_accum_16(){ return m_accum_16; }

    std::string get_label(unsigned char bank, unsigned int pc);

private:
    unsigned int& m_pc;
    int& m_flag;
    bool& m_accum_16;
    bool& m_index_16;
    int& m_low;
    int& m_high;
    unsigned char m_bank;
    int m_offset;
    Disassembler& d;
    const InstructionMetadata& i;
    FILE* m_rom_file;
};
