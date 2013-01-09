#ifndef PROTO_H
#define PROTO_H

#include "disasm.h"
#include <string>
#include <map>

class Instruction;

void dotype(const Instruction& instr, unsigned char bank);
unsigned int hex(const char *s);
void comment(unsigned char low, unsigned char high);
void spaces(int number);
void loaddata(char *fname);
void loadsymbols(char *fname);
std::string get_label(const Instruction& instr, unsigned char bank, int pc);
char read_char(FILE * stream);
std::string to_string(int i, int length, bool in_hex=true);
int full_address(int bank, int pc);

const int ALWAYS_USE_LABEL = 0x01;
const int NO_ADDR_LABEL = 0x02;

class Instruction{
public:
    Instruction() :
        m_name(""), 
        m_address_mode(-1), 
        m_bitmask(0)
    {}

    Instruction(const std::string& name, unsigned char address_mode, int bitmask=0) :
        m_name(name), 
        m_address_mode(address_mode), 
        m_bitmask(bitmask)
    { }

    inline std::string name() const { 
        if (m_address_mode == 1 && accum == 1) return (m_name + ".W");
        return m_name; 
    }
    inline unsigned char addressMode() const { return m_address_mode; }
    inline bool alwaysUseLabel() const { return (m_bitmask & ALWAYS_USE_LABEL); }
    inline bool neverUseLabel() const { return (m_address_mode == 1); }
    inline bool neverUseAddrLabel() const { return (m_bitmask & NO_ADDR_LABEL); }

private:
    std::string m_name;
    unsigned char m_address_mode;
    int m_bitmask;
};

struct Request{
  Request() : 
    m_accum_16(false),
    m_index_16(false),
    m_dcb(false),
    m_stop_at_rts(false),
    m_nmi(false),
    m_reset(false),
    m_irq(false),
    m_start_addr(0),
    m_start_bank(0), 
    m_end_addr(0),
    m_end_bank(0)
  {}  

  bool m_accum_16;
  bool m_index_16;
  bool m_dcb;
  bool m_stop_at_rts;
  
  bool m_nmi;
  bool m_reset;
  bool m_irq;

  unsigned int m_start_addr;
  unsigned char m_start_bank; 
  unsigned int m_end_addr;
  unsigned char m_end_bank;
};

struct Disassembler{
    Disassembler();   
    void handleRequest(const Request& request);
    void dodcb(int bank, int pc, int end_bank, int pc_end);

    int m_comment_level;
    bool m_hirom;
    bool m_quiet;

    std::map<unsigned char, Instruction> m_instruction_lookup;

private:
    void initialize_instruction_lookup();
    
};


#endif
