#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <iostream>
#include <string>
#include <map>

#include "proto.h"
#include "request.h"

class InstructionMetadata;
struct OutputHandler;

struct Disassembler{
private:    
    void initialize_instruction_lookup();

public:
    Disassembler();
    ~Disassembler();
 
    void handleRequest(const Request& request, bool user_request = true);

    void doDcb(int bytes_per_line = 8);
    void doPtr(bool long_ptrs = false);
    void doDisasm();
    void doSmart();

    void doType(const InstructionMetadata& instr, bool is_data, unsigned char default_bank, const std::string& label);
    void setProcessFlags();

    std::string getRAMComment(unsigned int addr);

    void load_data(char *fname, bool is_ptr_data = false);
    void load_comments(char* fname);
    void load_symbols(char *fname, bool ram = false);
    void load_symbols2(char *fname);
    void load_accum_bytes(char *fname, bool accum);
    void load_offsets(char *fname);

    bool is_comment(const std::string& line);    
    bool add_label(int bank, int pc, const std::string& label);
    void mark_label_used(int bank, int pc, const std::string& label);
    std::string get_label(const InstructionMetadata& instr, unsigned char bank, int pc, int offset, bool use_addr_label, bool mark_instruction_used);

    std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);
    std::string get_comment(unsigned char bank, unsigned int pc);
    void fix_address(unsigned char& bank, unsigned int& pc);

    inline void hirom(bool hirom) { m_hirom = hirom; }
    inline bool hirom() const { return m_hirom; }

    inline void quiet(bool q) { m_quiet = q; }
    inline bool quiet() const { return m_quiet; }

    inline void passes(int passes) { m_passes_to_make = passes; }
    bool finalPass() const { return (m_current_pass == m_passes_to_make); }
    bool printInstructionBytes() const { return (!m_request_prop.m_quiet && finalPass()); }

private:    
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

    DisassemblerProperties m_request_prop;

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

    OutputHandler* m_output_handler;
};

#endif
