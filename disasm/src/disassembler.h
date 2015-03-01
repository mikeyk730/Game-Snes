#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <iostream>
#include <string>
#include <map>
#include "request.h"

class InstructionMetadata;
struct OutputHandler;

struct Disassembler{
private:    
    void initialize_instruction_lookup();

public:
    Disassembler(FILE* rom_file);
    ~Disassembler();
 
    void handleRequest(const Request& request);

    void doDcb(int bytes_per_line = 8);
    void doPtr(bool long_ptrs = false);
    void doDisasm();
    void doSmart();

    void setProcessFlags();

    void load_data(char *fname, bool is_ptr_data = false);
    void load_comments(char* fname);
    void load_symbols(char *fname, bool ram = false);
    void load_symbols2(char *fname);
    void load_accum_bytes(char *fname, bool accum);
    void load_offsets(char *fname);

    bool add_label(int bank, int pc, const std::string& label);
    void mark_label_used(int bank, int pc, const std::string& label);
    std::string get_instr_label(const InstructionMetadata& instr, unsigned char bank, int pc, int offset);
    std::string get_line_label(unsigned char bank, int pc, bool use_addr_label);

    int get_offset(unsigned char bank, unsigned int pc);
    std::string get_comment(unsigned char bank, unsigned int pc);
    int get_default_ptr_bank() const;

    inline void hirom(bool hirom) { m_hirom = hirom; }
    inline bool hirom() const { return m_hirom; }

    inline void quiet(bool q) { m_quiet = q; }
    inline bool quiet() const { return m_quiet; }

    inline void passes(int passes) { m_passes_to_make = passes; }
    bool finalPass() const { return (m_current_pass == m_passes_to_make); }
    bool printInstructionBytes() const { return (!m_range_properties.m_quiet && finalPass()); }

    char read_next_byte();

private:
    std::string get_label_helper(unsigned char bank, int pc, bool use_addr_label, bool mark_instruction_used, bool is_branch);
    void disassembleRange(const Request& request);
    void disassembleInstruction(const InstructionMetadata& instr, unsigned char default_bank, const std::string& label, const std::string& comment, int offset);
    OutputHandler* output_handler() const
    {
        return finalPass() ? m_output_handler : m_noop_handler;
    }

    unsigned int current_full_address() const;

    std::map<int, InstructionMetadata> m_instruction_lookup;
    std::map<int, std::string> m_label_lookup;
    std::map<int, std::string> m_ram_lookup;
    std::map<int, std::string> m_used_label_lookup;
    std::map<int, std::string> m_comment_lookup;
    std::map<int, std::string> m_unresolved_symbol_lookup;
    std::map<int, int> m_load_offsets;

    std::map<int, int> m_accum_lookup;
    std::map<int, int> m_index_lookup;
    std::map<int, int> m_ptr_bank_lookup;

    // m_data holds a char for every byte of the rom, indicating if that byte is data, code, ptr, etc
    unsigned char *m_data; 

    DisassemblerProperties m_range_properties;

    bool m_hirom;
    bool m_quiet;
    int m_current_pass;
    int m_passes_to_make;
    int m_flag; 

    unsigned char m_current_bank;
    unsigned int m_current_addr;
    bool m_accum_16;
    bool m_index_16;

    int m_start;
    int m_end;

    OutputHandler* m_noop_handler;
    OutputHandler* m_output_handler;
    FILE* m_rom_file;
};

#endif
