#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <iostream>
#include <string>
#include <map>
#include "proto.h"

struct Request;
class Instruction;

struct Disassembler{
private:    
    void initialize_instruction_lookup();

public:
    Disassembler();
 
    void handleRequest(const Request& request);

    void dodcb();
    void dodisasm();
    void do_smart();

    void dotype(const Instruction& instr);
    void setProcessFlags();

    void printComment(unsigned char low, unsigned char high);

    void load_data(char *fname);
    void load_symbols(char *fname);
    void load_symbols2(char *fname);
    void load_accum_bytes(char *fname, bool accum);

    bool is_comment(const std::string& line);    
    void add_label(int bank, int pc, const std::string& label, bool used=false);
    std::string get_label(const Instruction& instr, unsigned char bank, int pc);

    std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);
    void fix_address(unsigned char& bank, unsigned int& pc);
    std::string getInstructionName(const Instruction& instr);

public:    
    std::map<unsigned char, Instruction> m_instruction_lookup;
    std::map<int, std::string> m_label_lookup;
    std::map<int, std::string> m_used_label_lookup;

    std::map<int, int> m_accum_lookup;
    std::map<int, int> m_index_lookup;

    unsigned char m_data[0x80000];

    DisassemblerProperties m_properties;

    bool m_hirom;
    int m_pass;
    int m_flag;

    unsigned char m_current_bank;
    unsigned int m_current_addr;
};

#endif
