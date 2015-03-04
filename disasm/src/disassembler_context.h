#include <string>

struct Disassembler;
struct DisassemblerState;
class InstructionMetadata;

struct DisassemblerContext
{
    //todo: combine data_bank and offset into struct
    DisassemblerContext(Disassembler* disasm, const InstructionMetadata& instr, DisassemblerState* state, int* flag, int data_bank, int offset);

    unsigned char read_next_byte(int* pc);

    void set_flag(int flag);

    void set_accum_16(bool is_16);
    void set_index_16(bool is_16);

    unsigned char data_bank() const { return m_data_bank; }
    int offset() const { return m_offset; }
    bool is_accum_16() const;
    bool is_index_16() const;
    
    std::string get_label(unsigned char data_bank, unsigned int pc);

private:
    int& m_flag; //todo: move to disasmstate?
    unsigned char m_data_bank;
    int m_offset;
    Disassembler& d;
    DisassemblerState& state;
    const InstructionMetadata& i;
};
