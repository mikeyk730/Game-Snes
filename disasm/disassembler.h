#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

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

    void dotype(const Instruction& instr, unsigned char bank);

    void printComment(unsigned char low, unsigned char high);

    void load_data(char *fname);
    void load_symbols(char *fname);
    
    void add_label(int bank, int pc, const std::string& label);
    std::string get_label(const Instruction& instr, unsigned char bank, int pc);

    void fix_address(unsigned char& bank, unsigned int& pc);
    void do_smart();

public:    
    std::map<unsigned char, Instruction> m_instruction_lookup;
    std::map<int, std::string> m_label_lookup;

    unsigned char m_data[0x80000];

    DisassemblerProperties m_properties;

    bool m_hirom;

    unsigned char m_current_bank;
    unsigned int m_current_addr;
};

#endif
