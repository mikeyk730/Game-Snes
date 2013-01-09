#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <iostream>
#include <string>
#include <map>

#include "proto.h"
#include "request.h"

class Instruction;

struct Disassembler{
private:    
    void initialize_instruction_lookup();

public:
    Disassembler();
 
    void handleRequest(const Request& request, bool user_request = true);

    void dodcb();
    void dodisasm();
    void do_smart();

    void dotype(const Instruction& instr);
    void setProcessFlags();

    std::string getRAMComment(unsigned char low, unsigned char high);

    void load_data(char *fname);
    void load_comments(char* fname);
    void load_symbols(char *fname, bool ram = false);
    void load_symbols2(char *fname);
    void load_accum_bytes(char *fname, bool accum);

    bool is_comment(const std::string& line);    
    void add_label(int bank, int pc, const std::string& label, bool used=false);
    std::string get_label(const Instruction& instr, unsigned char bank, int pc);

    std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);
    std::string get_comment(unsigned char bank, unsigned int pc);
    void fix_address(unsigned char& bank, unsigned int& pc);
    std::string getInstructionName(const Instruction& instr);

    inline void hirom(bool hirom) { m_hirom = hirom; }
    inline bool hirom() const { return m_hirom; }

    inline void passes(int passes) { m_passes_to_make = passes; }
    bool finalPass() const { return (m_current_pass == m_passes_to_make); }
    bool printInstructionBytes() const { return (!m_request_prop.m_quiet && finalPass()); }

private:    
    std::map<unsigned char, Instruction> m_instruction_lookup;
    std::map<int, std::string> m_label_lookup;
    std::map<int, std::string> m_ram_lookup;
    std::map<int, std::string> m_used_label_lookup;
    std::map<int, std::string> m_comment_lookup;
    std::map<int, std::string> m_unresolved_symbol_lookup;

    std::map<int, int> m_accum_lookup;
    std::map<int, int> m_index_lookup;

    unsigned char m_data[0x80000];

    DisassemblerProperties m_request_prop;

    bool m_hirom;
    int m_current_pass;
    int m_passes_to_make;
    int m_flag; 

    unsigned char m_current_bank;
    unsigned int m_current_addr;

    int m_start;
    int m_end;
};

#endif
