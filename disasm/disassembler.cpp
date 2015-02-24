#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>

#include "proto.h"
#include "disassembler.h"
#include "request.h"

using namespace std;

namespace{
   const unsigned int BANK_SIZE = 0x08000;
}


struct StateContext
{
    StateContext(unsigned int& pc, int& flag, bool& accum16, bool& index16, int& low, int& high)
    : m_pc(pc), m_flag(flag), m_accum_16(accum16), m_index_16(index16), m_low(low), m_high(high)
    { }

    unsigned char read_next_byte(int* pc)
    {
        ++m_pc;
        if (pc) {
            *pc = m_pc;
        }
        return read_char(srcfile);
    }
    
    void set_flag(int flag) { m_flag |= flag; }
    void set_accum_16(bool is_16) { m_accum_16 = is_16; }
    void set_index_16(bool is_16) { m_index_16 = is_16; }

    unsigned int& m_pc;
    int& m_flag;
    bool& m_accum_16;
    bool& m_index_16;
    int& m_low;
    int& m_high;
};

struct DisasmState
{
    DisasmState(Disassembler& disasm,
    const Instruction& instr,
    bool accum_16,
    const bool index_16,
    const bool print_bytes,
    const unsigned char current,
    const unsigned char defaultb,
    const int off) : d(disasm), i(instr), is_accum_16(accum_16), is_index_16(index_16), print_instruction_bytes(print_bytes),
    current_bank(current), default_bank(defaultb), offset(off)
    {}

    const bool is_accum_16;
    const bool is_index_16;
    const bool print_instruction_bytes;
    const unsigned char current_bank;
    const unsigned char default_bank;
    const int offset;

    string get_label(int bank, int pc)
    {
        return d.get_label(i, bank, pc, offset);
    }

    Disassembler& d;
    const Instruction& i;
};


void foo0(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    if (disasm_state->print_instruction_bytes) printf("         ");
}

void foo1(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);


    if (disasm_state->print_instruction_bytes)
        printf("%.2X ", i);

    /* Accum  #$xx or #$xxxx */
    long ll = i;
    strcat(buff2, "#");
    if (disasm_state->is_accum_16) {
        unsigned char j = context->read_next_byte(NULL);
    
        ll = j * 256 + ll;
        if (disasm_state->print_instruction_bytes) printf("%.2X ", j);
    }
    if (!disasm_state->is_accum_16)
        sprintf(buff1, "$%.2X", ll);
    else
        sprintf(buff1, "$%.4X", ll);
    strcat(buff2, buff1);
    if (disasm_state->print_instruction_bytes) {
        printf("   ");
        if (disasm_state->is_accum_16 == 0) printf("   ");
    }
}

void foo2(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* $xxxx */  if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i);
    if (msg == "") sprintf(buff1, "$%.2X%.2X", j, i);
    else sprintf(buff1, "%s", msg.c_str());
    strcat(buff2, buff1);
    context->m_high = j; context->m_low = i;
}

void foo3(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);
    unsigned char k = context->read_next_byte(NULL);


    /* $xxxxxx */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X %.2X ", i, j, k);
    string msg = disasm_state->get_label(k, j * 256 + i); if (msg == "")
        sprintf(buff1, "$%.2X%.2X%.2X", k, j, i);
    else sprintf(buff1, "%s", msg.c_str());  strcat(buff2, buff1); 
}

void foo4(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* $xx */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "$%.2X", i);
    else sprintf(buff1, "%s", msg.c_str()); strcat(buff2, buff1);
}
void foo5(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];
    
    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* ($xx),Y */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "($%.2X),Y", i);
    else sprintf(buff1, "(%s),Y", msg.c_str());
    strcat(buff2, buff1); 
}

void foo6(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* [$xx],Y */
    string msg = disasm_state->get_label(disasm_state->current_bank, i);  if (msg == "")
        sprintf(buff1, "[$%.2X],Y", i);
    else sprintf(buff1, "[%s],Y", msg.c_str());
    strcat(buff2, buff1); 
}

void foo7(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* ($xx,X) */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "($%.2X,X)", i);
    else sprintf(buff1, "(%s,X)", msg.c_str());
    strcat(buff2, buff1);
}
void foo8(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* $xx,X */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "$%.2X,X", i);
    else sprintf(buff1, "%s,X", msg.c_str());
    strcat(buff2, buff1);
}

void foo9(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* $xxxx,X */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i); if (msg == "")
        sprintf(buff1, "$%.2X%.2X,X", j, i);
    else sprintf(buff1, "%s,X", msg.c_str());
    strcat(buff2, buff1); 
}

void foo10(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);
    unsigned char k = context->read_next_byte(NULL);


    /* $xxxxxx,X */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X %.2X ", i, j, k);
    string msg = disasm_state->get_label(k, j * 256 + i); if (msg == "")
        sprintf(buff1, "$%.2X%.2X%.2X,X", k, j, i);
    else sprintf(buff1, "%s,X", msg.c_str());
    strcat(buff2, buff1);
}

void foo11(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* $xxxx,Y */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i); if (msg == "")
        sprintf(buff1, "$%.2X%.2X,Y", j, i);
    else sprintf(buff1, "%s,Y", msg.c_str());
    strcat(buff2, buff1);
}

void foo12(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char  i = context->read_next_byte(NULL);

    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* ($xx) */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "($%.2X)", i); else sprintf(buff1, "(%s)", msg.c_str());
    strcat(buff2, buff1);
}

void foo13(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* [$xx] */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "[$%.2X]", i); else sprintf(buff1, "[%s]", msg.c_str());
    strcat(buff2, buff1);
}

void foo14(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);

    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* $xx,S */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "$%.x,S", i); else sprintf(buff1, "%s,S", msg.c_str());
    strcat(buff2, buff1);
}

void foo15(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 

    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* ($xx,S),Y */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "($%.2X,S),Y", i);
    else sprintf(buff1, "(%s,S),Y", msg.c_str());
    strcat(buff2, buff1);
}

void foo16(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    int pc;
    char r = context->read_next_byte(&pc);

    unsigned char h = r; if (disasm_state->print_instruction_bytes) printf("%.2X       ", h);
    /* relative */ 

    string msg = disasm_state->get_label(disasm_state->current_bank, pc + r); if (msg == "")
        sprintf(buff1, "$%.4X", pc + r); else sprintf(buff1, "%s", msg.c_str());
    strcat(buff2, buff1);
}
void foo17(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    int pc;
    unsigned char i = context->read_next_byte(&pc);
    unsigned char j = context->read_next_byte(&pc);

    /* relative long */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    long ll = j * 256 + i; if (ll > 32767) ll = -(65536 - ll);
    string msg = disasm_state->get_label((disasm_state->current_bank * 65536 + pc + ll) / 0x10000, (disasm_state->current_bank * 65536 + pc + ll) & 0xffff);
    if (msg == "") sprintf(buff1, "$%.6x", disasm_state->current_bank * 65536 + pc + ll);
    else sprintf(buff1, "%s", msg.c_str());
    strcat(buff2, buff1);
}

void foo18(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL); 


    /* PER/PEA $xxxx */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    sprintf(buff1, "$%.2X%.2X", j, i);
    strcat(buff2, buff1);    
}

void foo19(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* [$xxxx] */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i); if (msg == "")
        sprintf(buff1, "[$%.2X%.2X]", j, i);
    else sprintf(buff1, "[%s]", msg.c_str());
    strcat(buff2, buff1);
}

void foo20(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* ($xxxx) */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i); if (msg == "")
        sprintf(buff1, "($%.2X%.2X)", j, i); else sprintf(buff1, "(%s)", msg.c_str());
    strcat(buff2, buff1);
}

void foo21(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* ($xxxx,X) */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    string msg = disasm_state->get_label(disasm_state->current_bank, j * 256 + i); if (msg == "")
        sprintf(buff1, "($%.2X%.2X,X)", j, i);
    else sprintf(buff1, "(%s,X)", msg.c_str());
    strcat(buff2, buff1);
}

void foo22(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 


    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* $xx,Y */
    string msg = disasm_state->get_label(disasm_state->current_bank, i); if (msg == "")
        sprintf(buff1, "$%.2X,Y", i); else sprintf(buff1, "%s,Y", msg.c_str());
    strcat(buff2, buff1);
}

void foo23(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);


    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* #$xx */
    sprintf(buff1, "#$%.2X", i);
    strcat(buff2, buff1);
}

void foo24(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* REP */    sprintf(buff1, "#$%.2X", i); strcat(buff2, buff1);
    if (i & 0x20) { context->set_accum_16(1); context->set_flag(0x20); }
    if (i & 0x10) { context->set_index_16(1); context->set_flag(0x10); }
}

void foo25(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL); 
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X       ", i);
    /* SEP */    sprintf(buff1, "#$%.2X", i); strcat(buff2, buff1);
    if (i & 0x20) { context->set_accum_16(0); context->set_flag(0x02); }
    if (i & 0x10) { context->set_index_16(0); context->set_flag(0x01); }
}

void foo26(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
 
    
    if (disasm_state->print_instruction_bytes) printf("%.2X ", i);
    /* Index  #$xx or #$xxxx */
    long ll = i; strcat(buff2, "#");
    if (disasm_state->is_index_16) {
        unsigned char j = context->read_next_byte(NULL); 
    

        ll = j * 256 + ll;
        if (disasm_state->print_instruction_bytes) printf("%.2X ", j);
    }
    if (!disasm_state->is_index_16)
        sprintf(buff1, "$%.2X", ll); 
    else 
        sprintf(buff1, "$%.4X", ll);
    strcat(buff2, buff1);
    if (disasm_state->print_instruction_bytes) {
        printf("   ");
        if (disasm_state->is_index_16 == 0) printf("   ");
    }
}

void foo27(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);


    /* MVN / MVP */ if (disasm_state->print_instruction_bytes) printf("%.2X %.2X    ", i, j);
    sprintf(buff1, "$%.2X,$%.2X", i, j); strcat(buff2, buff1);
}

void foo30(FILE * rom, char * buff2, char * buff3, DisasmState* disasm_state, StateContext* context)
{
    char buff1[80];

    unsigned char i = context->read_next_byte(NULL);
    unsigned char j = context->read_next_byte(NULL);
    unsigned char k = context->read_next_byte(NULL);


    /* $xxxx, .db :$xxxx */
    if (disasm_state->print_instruction_bytes)
        printf("%.2X %.2X %.2X ", i, j, k);
    unsigned char oldk = k;
    if (k == 0xFF) k = disasm_state->default_bank;
    string msg = disasm_state->get_label(k, j * 256 + i);
    if (msg == ""){
        if (i == 0 && j == 0 & k == 0){
            sprintf(buff1, "$%.2X%.2X%.2X", k, j, i);
            sprintf(buff3, ".db $%.2X", k);
        }
        else{
            sprintf(buff1, "$%.2X%.2X%.2X", k, j, i);
            sprintf(buff3, ".db :$%.2X%.2X%.2X", k, j, i);
        }
    }
    else {
        if (oldk == 0xFF){
            sprintf(buff1, ".%s", msg.c_str());
            sprintf(buff3, ".db $%.2X", oldk);
        }
        else{
            sprintf(buff1, ".%s", msg.c_str());
            sprintf(buff3, ".db :%s", msg.c_str());
        }
    }
    strcat(buff2, buff1);
}

Disassembler::Disassembler() :
m_hirom(false),
m_current_pass(1),
m_passes_to_make(1),
m_flag(0)
{ 
    initialize_instruction_lookup(); 
    m_data = new unsigned char[0x400000];
    memset(m_data,0,0x400000);
}

Disassembler::~Disassembler()
{
    delete [] m_data;
}

string bar1(bool is_accum_16, bool is_index_16){
    if (is_accum_16)
        return ".W";
    return ".B";
}

string bar4(bool is_accum_16, bool is_index_16){
    if (is_index_16)
        return ".W";
    return ".B";
}

string bar2(bool is_accum_16, bool is_index_16){
    return ".W";
}

string bar3(bool is_accum_16, bool is_index_16){
    return ".L";
}


std::string Disassembler::getInstructionName(const Instruction& instr, bool is_accum_16, bool is_index_16){
    return instr.annotated_name(is_accum_16, is_index_16);
}

std::string Disassembler::get_comment(unsigned char bank, unsigned int pc)
{
    map<int,string>::iterator it = m_comment_lookup.find(full_address(bank,pc));
    if (it != m_comment_lookup.end())
        return it->second;
    return "";
}

void Disassembler::fix_address(unsigned char& bank, unsigned int& pc)
{
    char s2[10];
    sprintf(s2, "%.4X", pc);
    if (strlen(s2) == 5){
        bank++; 
        if (m_hirom)
            pc -= 0x10000;
        else
            pc -= 0x8000;
    }
}

istream& Disassembler::get_address(istream& in, unsigned char& bank, unsigned int& addr)
{
    unsigned int full;
    if(!(in >> hex >> full))
        return in;

    addr = (full & 0x0FFFF);
    bank = ((full >> 16) & 0x0FF);

    if (addr < 0x8000)
        addr += 0x8000;

    //cerr << hex << int(bank) << " " << addr << endl;
    return in;
}

void Disassembler::handleRequest(const Request& request, bool user_request)
{
    if (user_request) {
        m_passes_to_make = request.m_properties.m_passes;

        m_start = full_address(request.m_properties.m_start_bank,
            request.m_properties.m_start_addr);

        m_end = full_address(request.m_properties.m_end_bank,
            request.m_properties.m_end_addr);
    }

    do{
        m_request_prop = request.m_properties;

        m_current_bank = m_request_prop.m_start_bank;
        m_current_addr = m_request_prop.m_start_addr;

        fseek(srcfile, 512, 0);
        if (m_hirom)
            fseek(srcfile, m_current_bank * 65536 + m_current_addr, 1);
        else
            fseek(srcfile, m_current_bank * 32768 + m_current_addr - 0x8000, 1);

        if (request.m_type == Request::Dcb)
            doDcb();
        else if (request.m_type == Request::Ptr)
            doPtr();
        else if (request.m_type == Request::PtrLong)
            doPtr(true);
        else if (request.m_type == Request::Asm)
            doDisasm();
        else{
            cout << "; ============ PASS " << m_current_pass << " ===============" << endl;
            if (finalPass()){
                cout << ".INCLUDE \"snes.cfg\"" << endl;
            }
            doSmart();
            m_current_pass++;
            if (m_current_pass > m_passes_to_make)               
                break;
        }
    } while(request.m_type == Request::Smart);
    
    if (user_request){
        if (!m_unresolved_symbol_lookup.empty() && !quiet()){
            cout << "Unresolved symbols: " << endl; 
            for (map<int,string>::iterator it = m_unresolved_symbol_lookup.begin(), 
                end_it = m_unresolved_symbol_lookup.end(); it != end_it; ++it){
                    cout << to_string(it->first, 6) << " " << it->second << endl;
                }
                m_unresolved_symbol_lookup.clear();
        }

        m_current_pass = 1;
    }

}


void Disassembler::doDisasm()
{
    unsigned int& pc = m_current_addr;
    unsigned char& bank = m_current_bank;

    unsigned int pc_end = m_request_prop.m_end_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;

    while( (!feof(srcfile)) && (bank * 65536 + pc < end_bank * 65536 + pc_end) ){

        unsigned char code = read_char(srcfile);
        Instruction instr = m_instruction_lookup[code];

        if (!feof(srcfile)){

            //adjust pc address
            fix_address(bank,pc);

            string label = get_label(Instruction("", &foo0, 0, LINE_LABEL), bank, pc, 0);
            if (label != "") label += ":";
            
            if (finalPass()){
                if (pc == 0x8000) cout << ".BANK " << int(bank) << endl;
                cout << left << setw(20) << label;
                if (!m_request_prop.m_quiet) cout << to_string(code, 2) << " ";
            }

            doType(instr, false, bank);

            if (m_request_prop.m_stop_at_rts &&
                (instr.name() == "RTS" || instr.name() == "RTI" || instr.name() == "RTL"))
                break;            
        }
        if (feof(srcfile)) cout << "; End of file." << endl;
    }
}

void Disassembler::load_accum_bytes(char *fname, bool accum)
{
    fstream in(fname);
    string line;
    while (getline(in, line)){
        if (is_comment(line)) continue;
        istringstream line_stream(line);

        string type;
        int fulladdr, bytes;
        if(!(line_stream >> hex >> fulladdr >> type >> dec >> bytes)) continue;
        
        if(type == "A" || type == "AI" || type == "IA")
            m_accum_lookup.insert(make_pair(fulladdr, bytes));
        if(type == "I" || type == "AI" || type == "IA")
            m_index_lookup.insert(make_pair(fulladdr, bytes));
    }
}

void Disassembler::setProcessFlags()
{    
    m_flag = 0;

    unsigned char bank = m_current_bank;
    unsigned int pc = m_current_addr;

    map<int, int>::iterator it = m_accum_lookup.find(full_address(bank,pc));
    if (it != m_accum_lookup.end()){
        m_request_prop.m_accum_16 = ((it->second) == 16);
        m_flag |= (m_request_prop.m_accum_16) ? 0x20 : 0x02;
    }

    map<int, int>::iterator it2 = m_index_lookup.find(full_address(bank,pc));
    if (it2 != m_index_lookup.end()){
        m_request_prop.m_index_16 = ((it2->second) == 16);    
        m_flag |= (m_request_prop.m_index_16) ? 0x10 : 0x01;
    }

}

bool Disassembler::is_comment(const string& line)
{
    return (line.length() < 1 || line[0] == ';');
}

void Disassembler::load_comments(char* fname)
{
    cerr << "; Reading comments" << endl;
    ifstream in(fname);
    string line;
    while(getline(in, line)){
        if (is_comment(line)) continue;

        istringstream ss(line);
        int hex_addr;
        if (!(ss >> hex >> hex_addr)) continue;
        
        string comment;
        if(!getline(ss, comment)) continue;

        if(!m_comment_lookup.insert(make_pair(hex_addr, comment)).second)
            cerr << "failed to add comment >" << comment << "<" << endl;
    }
    cerr << "; Reading comments... done." << endl;
}

void Disassembler::load_offsets(char* fname)
{
    fstream in(fname);
    string line;
    while (getline(in, line)){
        if (is_comment(line)) continue;

        string label;

        istringstream ss(line);
        int hex_addr;
        if (!(ss >> hex >> hex_addr)) continue;

        int offset = 1;
        if (!(ss >> dec >> offset)){
            cout << "couldn't read offset size in: " << line << endl;
            exit(-1);
        }

        auto result = m_load_offsets.insert(make_pair(hex_addr, offset));
        if (!result.second){
            cerr << "failed to add load offset >" << line << "<" << endl;
        }
    }
}


void Disassembler::load_symbols(char *fname, bool ram)
{
    cerr << "; Reading symbols" << endl;
    fstream in(fname);
    string line;
    while (getline(in, line)){
        if (is_comment(line)) continue;

        int fulladdr;
        string label;
        istringstream line_stream(line);
        if(!(line_stream >> hex >> fulladdr))
            continue;

        unsigned int addr = (fulladdr & 0x0FFFF);   
        unsigned char bank = ((fulladdr >> 16) & 0x0FF);

        if (addr < 0x8000 && bank != 0x7F) bank = 0x7e;

        if(!(line_stream >> label)){
            if (ram) label = "RAM_" + to_string(addr, 4);
            else label = "CODE_" + to_string(bank, 2) + to_string(addr, 4);
        }

        add_label(bank, addr, label);
    }
    cerr << "; Reading symbols... done." << endl;
}

void Disassembler::load_symbols2(char *fname)
{
    cerr << "using method 2" << endl;
    cerr << "; Reading symbols" << endl;
    fstream in(fname);
    int fulladdr;
    while (in >> hex >> fulladdr){
        string label = "CODE_" + to_string(fulladdr, 6);
        if(!m_label_lookup.insert(make_pair(fulladdr, label)).second)
            cerr << "failed to add symbol2 >" << label << "<" << endl;
    }
    cerr << "; Reading symbols... done." << endl;
}

void Disassembler::load_data(char *fname, bool is_ptr_data)
{
    fstream in(fname);
    string line;
    while (getline(in, line)){
        if (is_comment(line)) continue;

        string label;
        istringstream line_stream(line);

        unsigned char bank, end_bank;
        unsigned int addr, end_addr;        
        if(!get_address(line_stream, bank, addr))
            continue;
        
        if(!get_address(line_stream, end_bank, end_addr)){
            end_addr = addr + 1;
            end_bank = bank;            
        }

        unsigned int index = (bank * BANK_SIZE + addr - 0x08000);
        unsigned int size = (end_bank * BANK_SIZE + end_addr - 0x08000) - index;

        if(size > 0x80000){
            cerr << "Error in data: " << line << endl;
            cerr << hex << size << " data bytes" << endl;
            exit(-1);
        }        

        if (m_data[index] != 0){
            cerr << "Address " << to_string(bank,2) << to_string(addr,4) 
                << " already flagged as data.  Type: " << int(m_data[index]) << endl;
            continue;
        }

        int flag_byte = 1;
        if (is_ptr_data){
            int ptr_bank;
            if (!(line_stream >> flag_byte >> hex >> ptr_bank)){
                cout << "couldn't read pointer size in: " << line << endl;
                exit(-1);
            }
            for (int i = 0; i < size; i += flag_byte){
                m_ptr_bank_lookup.insert(make_pair(index+i, ptr_bank));
            }
        }

        memset(&m_data[index], flag_byte, size);

        //no label, create one
        if(!(line_stream >> label)){
            string prefix = "DATA_";
            if (flag_byte == 2) prefix = "Ptrs";
            else if (flag_byte == 3) prefix = "PtrsLong";
            label = prefix + to_string(bank,2) + to_string(addr,4);
        }

        add_label(bank, addr, label);
    }
}

bool Disassembler::add_label(int bank, int pc, const string& label, bool used)
{
    int full_addr = full_address(bank,pc);
    if (used)
        m_used_label_lookup.insert(make_pair(full_addr, label));
    else{
        if(!m_label_lookup.insert(make_pair(full_addr, label)).second){
            cerr << "failed to add symbol >" << label << "<" << endl;
            return false;
        }
    }
    return true;
}

string Disassembler::get_label(const Instruction& instr, unsigned char bank, int pc, int offset)
{
    pc -= offset;
    if (pc < 0x8000 && bank != 0x7f) bank = 0x7e;
    int key = full_address(bank,pc);

    // does the symbol lie outside of the range we are disassembling?
    bool is_extern = (key < m_start || key > m_end);
    if(is_extern && !m_request_prop.m_use_extern_symbols)
        return "";

    string label;
    if (m_current_pass == 2){
        map<int, string>::iterator it = m_used_label_lookup.find(key);
        if (it != m_used_label_lookup.end())
            label = it->second;
    }
    else{
        map<int, string>::iterator it = m_label_lookup.find(key);
        if (it != m_label_lookup.end()){
            label = it->second;
            add_label(bank, pc, label, true);
        }

        else if( ( (pc >= 0x8000 && !instr.neverUseAddrLabel()) ||
            (pc < 0x8000 && instr.isBranch()) ) && bank < 0x7E){
                label = "ADDR_" + to_string(bank, 2) + /*"_" +*/ to_string(pc, 4);
                if (!instr.isLineLabel()) add_label(bank, pc, label, true);
            }
        
        else if(pc < 0x8000){
            map<int, string>::iterator it2 = m_ram_lookup.find(key);
            if (it2 != m_ram_lookup.end())
                label = it2->second;
        }
            
    }
    
    if (label.size() > 0 && finalPass() && is_extern)
        m_unresolved_symbol_lookup.insert(make_pair(key, label));

    if (offset != 0){
        stringstream ss;
        ss << label;
        if (offset > 0){
            ss << "+";
        }
        ss << offset;
        label = ss.str();
    }

    return label;
}

void Disassembler::doSmart()
{
    unsigned char bank = m_request_prop.m_start_bank;
    unsigned int pc = m_request_prop.m_start_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int pc_end = m_request_prop.m_end_addr;

    unsigned int end_address = end_bank * 65536 + pc_end;
    for(int i = bank * BANK_SIZE + pc - 0x08000;
        bank * 65536 + pc < end_address;){

            Request request(m_request_prop);
            request.m_properties.m_start_bank = bank;
            request.m_properties.m_start_addr = pc;
            //cerr << "start " << hex << bank * 65536 + pc ;

            if (m_data[i] == 1){
                request.m_type = Request::Dcb;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while((m_data[i] == 1) && (bank * 65536 + pc < end_address));
            }
            else if (m_data[i] == 2){
                request.m_type = Request::Ptr;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while((m_data[i] == 2) && (bank * 65536 + pc < end_address));
            }
            else if (m_data[i] == 3){
                request.m_type = Request::PtrLong;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while((m_data[i] == 3) && (bank * 65536 + pc < end_address));
            }
            else{
                request.m_type = Request::Asm;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while((m_data[i] == 0) && (bank * 65536 + pc < end_address));
            }

            request.m_properties.m_end_bank = bank;
            request.m_properties.m_end_addr = pc;
            //cerr << " end " << hex << bank * 65536 + pc << endl;
            handleRequest(request, false);
            if (finalPass()) cout << endl;
        }
}

void Disassembler::doDcb(int bytes_per_line)
{
    unsigned char bank = m_request_prop.m_start_bank;
    unsigned int pc = m_request_prop.m_start_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int pc_end = m_request_prop.m_end_addr;
    string comment;
    for(int i=0; bank * 65536 + pc < end_bank * 65536 + pc_end; ++i){
        int output_flag = (m_request_prop.m_print_data_addr) ? 0 : NO_ADDR_LABEL;
        string label = get_label(Instruction("", &foo0, 0, LINE_LABEL | output_flag), bank, pc, 0);

        if (label != "") label += ":";

        if (finalPass()){

            if (pc == 0x8000) 
                cout << endl << ".BANK " << int(bank) << endl;

            if (i%bytes_per_line != 0 && label != "") {
                cout << endl << endl;
                i=0;
            }
            if (i%bytes_per_line == 0){
                cout << setw(19) << left << label << " ";
                if (!m_request_prop.m_quiet) cout << string(14, ' ');
                cout << ".db ";
                comment.clear();
            }
            else cout << ",";
        }

        string comment_buffer = get_comment(bank, pc);
        if (!comment_buffer.empty()) comment += (";" + comment_buffer + " ");

        //adjust address if necessary
        pc++;
        fix_address(bank,pc);

        //read and print byte
        unsigned char c = read_char(srcfile);

        if (finalPass()) printf("$%.2X", c);
        if ((i+1)%bytes_per_line == 0 || !(bank * 65536 + pc < end_bank * 65536 + pc_end)){
            if (finalPass()){
                if(!comment.empty())
                    cout << "     " << comment;
                cout << endl;
            }
        }
    }
}

void Disassembler::doPtr(bool long_ptrs)
{
    /*if (long_ptrs){
        doDcb(3);
        return;
    }*/

    unsigned char& bank = m_current_bank;
    unsigned int& pc = m_current_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int pc_end = m_request_prop.m_end_addr;

    for(int i=0; bank * 65536 + pc < end_bank * 65536 + pc_end; ++i){
        //adjust pc address
        fix_address(bank,pc);

        int output_flag = (m_request_prop.m_print_data_addr) ? 0 : NO_ADDR_LABEL;
        string label = get_label(Instruction("", &foo0, 0, LINE_LABEL | output_flag), bank, pc, 0);
        if (label != "") label += ":";

        if (finalPass()){
            if (pc == 0x8000) cout << ".BANK " << int(bank) << endl;
            cout << left << setw(20) << label;
            if (!m_request_prop.m_quiet) cout << "   ";
        }

        unsigned char default_bank = bank;
        unsigned int index = (bank * BANK_SIZE + pc - 0x08000);
        auto it = m_ptr_bank_lookup.find(index);
        if (it != m_ptr_bank_lookup.end()){
            default_bank = it->second;
        }

        if(long_ptrs)
            doType(m_instruction_lookup[0x101], true, default_bank);
        else
            doType(m_instruction_lookup[0x100], true, default_bank);
       
    }
}


void Disassembler::doType(const Instruction& instr, bool is_data, unsigned char default_bank)
{
    int high = 0, low = 0;

    char buff2[80];
    char buff3[80];
    buff3[0] = 0;

    unsigned char& bank = default_bank; // m_current_bank;
    unsigned int& pc = m_current_addr;
    bool& accum16 = m_request_prop.m_accum_16;
    bool& index16 = m_request_prop.m_index_16;

    unsigned char i, j, k, oldk;
    long ll;
    unsigned char h;
    char r;
    string msg;

    setProcessFlags();
    string comment = get_comment(bank, pc);

    int offset = 0;
    int full_addr = (bank << 16) + pc;
    auto load_offset = m_load_offsets.find(full_addr);
    if (load_offset != m_load_offsets.end()){
        offset = load_offset->second;
    }

    if (!is_data) ++pc;
    sprintf(buff2, "%s ", getInstructionName(instr, accum16, index16).c_str());

    DisasmState state(*((Disassembler*)this), instr, accum16, index16, printInstructionBytes(), bank, default_bank, offset);
    StateContext context(pc, m_flag, accum16, index16, low, high);

    auto f = instr.m_address_mode_handler;
    f(srcfile, buff2, buff3, &state, &context);

    //get comment
    if (comment != "")
        comment = ";" + comment + " ";
    if (m_flag != 0){
        comment += "; ";
        if (m_flag & 0x10) comment += "Index (16 bit) ";
        if (m_flag & 0x20) comment += "Accum (16 bit) ";
        if (m_flag & 0x01) comment += "Index (8 bit) ";
        if (m_flag & 0x02) comment += "Accum (8 bit) ";
    }

    if (high)
        comment += getRAMComment(low, high);
    if (instr.isCodeBreak())      
        comment += /*"; Return\n";*/ "\n";


    //print instruction and comment
    if (finalPass()){
        if (!m_request_prop.m_quiet) cout << "  ";    
        cout << setw(25) << left << buff2 << " " << comment << endl;
        if (buff3[0] != 0){
            cout << setw(34)  << "" << buff3 << endl;
        }
    }
}



void Disassembler::initialize_instruction_lookup()
{
    m_instruction_lookup.insert(make_pair(0x69, Instruction("ADC", &foo1, &bar1)));
    m_instruction_lookup.insert(make_pair(0x6D, Instruction("ADC", &foo2, &bar2)));
    m_instruction_lookup.insert(make_pair(0x6F, Instruction("ADC", &foo3, &bar3)));
    m_instruction_lookup.insert(make_pair(0x65, Instruction("ADC", &foo4)));
    m_instruction_lookup.insert(make_pair(0x71, Instruction("ADC", &foo5)));
    m_instruction_lookup.insert(make_pair(0x77, Instruction("ADC", &foo6)));
    m_instruction_lookup.insert(make_pair(0x61, Instruction("ADC", &foo7)));
    m_instruction_lookup.insert(make_pair(0x75, Instruction("ADC", &foo8)));
    m_instruction_lookup.insert(make_pair(0x7D, Instruction("ADC", &foo9, &bar2)));
    m_instruction_lookup.insert(make_pair(0x7F, Instruction("ADC", &foo10, &bar3)));
    m_instruction_lookup.insert(make_pair(0x79, Instruction("ADC", &foo11, &bar2)));
    m_instruction_lookup.insert(make_pair(0x72, Instruction("ADC", &foo12)));
    m_instruction_lookup.insert(make_pair(0x67, Instruction("ADC", &foo13)));
    m_instruction_lookup.insert(make_pair(0x63, Instruction("ADC", &foo14)));
    m_instruction_lookup.insert(make_pair(0x73, Instruction("ADC", &foo15)));
    m_instruction_lookup.insert(make_pair(0x29, Instruction("AND", &foo1, &bar1)));
    m_instruction_lookup.insert(make_pair(0x2D, Instruction("AND", &foo2, &bar2)));
    m_instruction_lookup.insert(make_pair(0x2F, Instruction("AND", &foo3, &bar3)));
    m_instruction_lookup.insert(make_pair(0x25, Instruction("AND", &foo4)));
    m_instruction_lookup.insert(make_pair(0x31, Instruction("AND", &foo5)));
    m_instruction_lookup.insert(make_pair(0x37, Instruction("AND", &foo6)));
    m_instruction_lookup.insert(make_pair(0x21, Instruction("AND", &foo7)));
    m_instruction_lookup.insert(make_pair(0x35, Instruction("AND", &foo8)));
    m_instruction_lookup.insert(make_pair(0x3D, Instruction("AND", &foo9, &bar2)));
    m_instruction_lookup.insert(make_pair(0x3F, Instruction("AND", &foo10, &bar3)));
    m_instruction_lookup.insert(make_pair(0x39, Instruction("AND", &foo11, &bar2)));
    m_instruction_lookup.insert(make_pair(0x32, Instruction("AND", &foo12)));
    m_instruction_lookup.insert(make_pair(0x27, Instruction("AND", &foo13)));
    m_instruction_lookup.insert(make_pair(0x23, Instruction("AND", &foo14)));
    m_instruction_lookup.insert(make_pair(0x33, Instruction("AND", &foo15)));
    m_instruction_lookup.insert(make_pair(0x0E, Instruction("ASL", &foo2, &bar2)));
    m_instruction_lookup.insert(make_pair(0x06, Instruction("ASL", &foo4)));
    m_instruction_lookup.insert(make_pair(0x0A, Instruction("ASL", &foo0)));
    m_instruction_lookup.insert(make_pair(0x16, Instruction("ASL", &foo8)));
    m_instruction_lookup.insert(make_pair(0x1E, Instruction("ASL", &foo9, &bar2)));
    m_instruction_lookup.insert(make_pair(0x90, Instruction("BCC", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xB0, Instruction("BCS", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xF0, Instruction("BEQ", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x30, Instruction("BMI", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xD0, Instruction("BNE", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x10, Instruction("BPL", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x80, Instruction("BRA", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x82, Instruction("BRL", &foo17)));
    m_instruction_lookup.insert(make_pair(0x50, Instruction("BVC", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x70, Instruction("BVS", &foo16, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x89, Instruction("BIT", &foo1, &bar1)));
    m_instruction_lookup.insert(make_pair(0x2C, Instruction("BIT", &foo2, &bar2)));
    m_instruction_lookup.insert(make_pair(0x24, Instruction("BIT", &foo4)));
    m_instruction_lookup.insert(make_pair(0x34, Instruction("BIT", &foo8)));
    m_instruction_lookup.insert(make_pair(0x3C, Instruction("BIT", &foo9, &bar2)));
    m_instruction_lookup.insert(make_pair(0x00, Instruction("BRK", &foo0)));
    m_instruction_lookup.insert(make_pair(0x18, Instruction("CLC", &foo0)));
    m_instruction_lookup.insert(make_pair(0xD8, Instruction("CLD", &foo0)));
    m_instruction_lookup.insert(make_pair(0x58, Instruction("CLI", &foo0)));
    m_instruction_lookup.insert(make_pair(0xB8, Instruction("CLV", &foo0)));
    m_instruction_lookup.insert(make_pair(0xC9, Instruction("CMP", &foo1, &bar1)));
    m_instruction_lookup.insert(make_pair(0xCD, Instruction("CMP", &foo2, &bar2)));
    m_instruction_lookup.insert(make_pair(0xCF, Instruction("CMP", &foo3, &bar3)));
    m_instruction_lookup.insert(make_pair(0xC5, Instruction("CMP", &foo4)));
    m_instruction_lookup.insert(make_pair(0xD1, Instruction("CMP", &foo5)));
    m_instruction_lookup.insert(make_pair(0xD7, Instruction("CMP", &foo6)));
    m_instruction_lookup.insert(make_pair(0xC1, Instruction("CMP", &foo7)));
    m_instruction_lookup.insert(make_pair(0xD5, Instruction("CMP", &foo8)));
  m_instruction_lookup.insert(make_pair(0xDD, Instruction("CMP", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xDF, Instruction("CMP", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0xD9, Instruction("CMP", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0xD2, Instruction("CMP", &foo12)));
  m_instruction_lookup.insert(make_pair(0xC7, Instruction("CMP", &foo13)));
  m_instruction_lookup.insert(make_pair(0xC3, Instruction("CMP", &foo14)));
  m_instruction_lookup.insert(make_pair(0xD3, Instruction("CMP", &foo15)));
  m_instruction_lookup.insert(make_pair(0xE0, Instruction("CPX", &foo26, &bar4)));
  m_instruction_lookup.insert(make_pair(0xEC, Instruction("CPX", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xE4, Instruction("CPX", &foo4)));
  m_instruction_lookup.insert(make_pair(0xC0, Instruction("CPY", &foo26, &bar4)));
  m_instruction_lookup.insert(make_pair(0xCC, Instruction("CPY", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xC4, Instruction("CPY", &foo4)));
  m_instruction_lookup.insert(make_pair(0xCE, Instruction("DEC", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xC6, Instruction("DEC", &foo4)));
  m_instruction_lookup.insert(make_pair(0x3A, Instruction("DEC A", &foo0)));
  m_instruction_lookup.insert(make_pair(0xD6, Instruction("DEC", &foo8)));
  m_instruction_lookup.insert(make_pair(0xDE, Instruction("DEC", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xCA, Instruction("DEX", &foo0)));
  m_instruction_lookup.insert(make_pair(0x88, Instruction("DEY", &foo0)));
  m_instruction_lookup.insert(make_pair(0x49, Instruction("EOR", &foo1, &bar1)));
  m_instruction_lookup.insert(make_pair(0x4D, Instruction("EOR", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x4F, Instruction("EOR", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0x45, Instruction("EOR", &foo4)));
  m_instruction_lookup.insert(make_pair(0x51, Instruction("EOR", &foo5)));
  m_instruction_lookup.insert(make_pair(0x57, Instruction("EOR", &foo6)));
  m_instruction_lookup.insert(make_pair(0x41, Instruction("EOR", &foo7)));
  m_instruction_lookup.insert(make_pair(0x55, Instruction("EOR", &foo8)));
  m_instruction_lookup.insert(make_pair(0x5D, Instruction("EOR", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x5F, Instruction("EOR", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0x59, Instruction("EOR", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0x52, Instruction("EOR", &foo12)));
  m_instruction_lookup.insert(make_pair(0x47, Instruction("EOR", &foo13)));
  m_instruction_lookup.insert(make_pair(0x43, Instruction("EOR", &foo14)));
  m_instruction_lookup.insert(make_pair(0x53, Instruction("EOR", &foo15)));
  m_instruction_lookup.insert(make_pair(0xEE, Instruction("INC", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xE6, Instruction("INC", &foo4)));
  m_instruction_lookup.insert(make_pair(0x1A, Instruction("INC A", &foo0)));
  m_instruction_lookup.insert(make_pair(0xF6, Instruction("INC", &foo8)));
  m_instruction_lookup.insert(make_pair(0xFE, Instruction("INC", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xE8, Instruction("INX", &foo0)));
  m_instruction_lookup.insert(make_pair(0xC8, Instruction("INY", &foo0)));
  m_instruction_lookup.insert(make_pair(0x5C, Instruction("JMP", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0xDC, Instruction("JMP", &foo19)));
  m_instruction_lookup.insert(make_pair(0x4C, Instruction("JMP", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x6C, Instruction("JMP", &foo20)));
  m_instruction_lookup.insert(make_pair(0x7C, Instruction("JMP", &foo21)));
  m_instruction_lookup.insert(make_pair(0x22, Instruction("JSL", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0x20, Instruction("JSR", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xFC, Instruction("JSR", &foo21)));
  m_instruction_lookup.insert(make_pair(0xA9, Instruction("LDA", &foo1, &bar1)));
  m_instruction_lookup.insert(make_pair(0xAD, Instruction("LDA", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xAF, Instruction("LDA", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0xA5, Instruction("LDA", &foo4)));
  m_instruction_lookup.insert(make_pair(0xB1, Instruction("LDA", &foo5)));
  m_instruction_lookup.insert(make_pair(0xB7, Instruction("LDA", &foo6)));
  m_instruction_lookup.insert(make_pair(0xA1, Instruction("LDA", &foo7)));
  m_instruction_lookup.insert(make_pair(0xB5, Instruction("LDA", &foo8)));
  m_instruction_lookup.insert(make_pair(0xBD, Instruction("LDA", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xBF, Instruction("LDA", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0xB9, Instruction("LDA", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0xB2, Instruction("LDA", &foo12)));
  m_instruction_lookup.insert(make_pair(0xA7, Instruction("LDA", &foo13)));
  m_instruction_lookup.insert(make_pair(0xA3, Instruction("LDA", &foo14)));
  m_instruction_lookup.insert(make_pair(0xB3, Instruction("LDA", &foo15)));
  m_instruction_lookup.insert(make_pair(0xA2, Instruction("LDX", &foo26, &bar4)));
  m_instruction_lookup.insert(make_pair(0xAE, Instruction("LDX", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xA6, Instruction("LDX", &foo4)));
  m_instruction_lookup.insert(make_pair(0xB6, Instruction("LDX", &foo22)));
  m_instruction_lookup.insert(make_pair(0xBE, Instruction("LDX", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0xA0, Instruction("LDY", &foo26, &bar4)));
  m_instruction_lookup.insert(make_pair(0xAC, Instruction("LDY", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xA4, Instruction("LDY", &foo4)));
  m_instruction_lookup.insert(make_pair(0xB4, Instruction("LDY", &foo8)));
  m_instruction_lookup.insert(make_pair(0xBC, Instruction("LDY", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x4E, Instruction("LSR", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x46, Instruction("LSR", &foo4)));
  m_instruction_lookup.insert(make_pair(0x4A, Instruction("LSR", &foo0)));
  m_instruction_lookup.insert(make_pair(0x56, Instruction("LSR", &foo8)));
  m_instruction_lookup.insert(make_pair(0x5E, Instruction("LSR", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xEA, Instruction("NOP", &foo0)));
  m_instruction_lookup.insert(make_pair(0x09, Instruction("ORA", &foo1, &bar1)));
  m_instruction_lookup.insert(make_pair(0x0D, Instruction("ORA", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x0F, Instruction("ORA", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0x05, Instruction("ORA", &foo4)));
  m_instruction_lookup.insert(make_pair(0x11, Instruction("ORA", &foo5)));
  m_instruction_lookup.insert(make_pair(0x17, Instruction("ORA", &foo6)));
  m_instruction_lookup.insert(make_pair(0x01, Instruction("ORA", &foo7)));
  m_instruction_lookup.insert(make_pair(0x15, Instruction("ORA", &foo8)));
  m_instruction_lookup.insert(make_pair(0x1D, Instruction("ORA", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x1F, Instruction("ORA", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0x19, Instruction("ORA", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0x12, Instruction("ORA", &foo12)));
  m_instruction_lookup.insert(make_pair(0x07, Instruction("ORA", &foo13)));
  m_instruction_lookup.insert(make_pair(0x03, Instruction("ORA", &foo14)));
  m_instruction_lookup.insert(make_pair(0x13, Instruction("ORA", &foo15)));
  m_instruction_lookup.insert(make_pair(0xF4, Instruction("PEA", &foo18)));
  m_instruction_lookup.insert(make_pair(0xD4, Instruction("PEI", &foo23)));
  m_instruction_lookup.insert(make_pair(0x62, Instruction("PER", &foo18)));
  m_instruction_lookup.insert(make_pair(0x48, Instruction("PHA", &foo0)));
  m_instruction_lookup.insert(make_pair(0x8B, Instruction("PHB", &foo0)));
  m_instruction_lookup.insert(make_pair(0x0B, Instruction("PHD", &foo0)));
  m_instruction_lookup.insert(make_pair(0x4B, Instruction("PHK", &foo0)));
  m_instruction_lookup.insert(make_pair(0x08, Instruction("PHP", &foo0)));
  m_instruction_lookup.insert(make_pair(0xDA, Instruction("PHX", &foo0)));
  m_instruction_lookup.insert(make_pair(0x5A, Instruction("PHY", &foo0)));
  m_instruction_lookup.insert(make_pair(0x68, Instruction("PLA", &foo0)));
  m_instruction_lookup.insert(make_pair(0xAB, Instruction("PLB", &foo0)));
  m_instruction_lookup.insert(make_pair(0x2B, Instruction("PLD", &foo0)));
  m_instruction_lookup.insert(make_pair(0x28, Instruction("PLP", &foo0)));
  m_instruction_lookup.insert(make_pair(0xFA, Instruction("PLX", &foo0)));
  m_instruction_lookup.insert(make_pair(0x7A, Instruction("PLY", &foo0)));
  m_instruction_lookup.insert(make_pair(0xC2, Instruction("REP", &foo24)));
  m_instruction_lookup.insert(make_pair(0x2E, Instruction("ROL", &foo1, &bar1)));
  m_instruction_lookup.insert(make_pair(0x26, Instruction("ROL", &foo4)));
  m_instruction_lookup.insert(make_pair(0x2A, Instruction("ROL", &foo0)));
  m_instruction_lookup.insert(make_pair(0x36, Instruction("ROL", &foo8)));
  m_instruction_lookup.insert(make_pair(0x3E, Instruction("ROL", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x6E, Instruction("ROR", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x66, Instruction("ROR", &foo4)));
  m_instruction_lookup.insert(make_pair(0x6A, Instruction("ROR", &foo0)));
  m_instruction_lookup.insert(make_pair(0x76, Instruction("ROR", &foo8)));
  m_instruction_lookup.insert(make_pair(0x7E, Instruction("ROR", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x40, Instruction("RTI", &foo0)));
  m_instruction_lookup.insert(make_pair(0x6B, Instruction("RTL", &foo0)));
  m_instruction_lookup.insert(make_pair(0x60, Instruction("RTS", &foo0)));
  m_instruction_lookup.insert(make_pair(0xE9, Instruction("SBC", &foo1, &bar1)));
  m_instruction_lookup.insert(make_pair(0xED, Instruction("SBC", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0xEF, Instruction("SBC", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0xE5, Instruction("SBC", &foo4)));
  m_instruction_lookup.insert(make_pair(0xF1, Instruction("SBC", &foo5)));
  m_instruction_lookup.insert(make_pair(0xF7, Instruction("SBC", &foo6)));
  m_instruction_lookup.insert(make_pair(0xE1, Instruction("SBC", &foo7)));
  m_instruction_lookup.insert(make_pair(0xF5, Instruction("SBC", &foo8)));
  m_instruction_lookup.insert(make_pair(0xFD, Instruction("SBC", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xFF, Instruction("SBC", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0xF9, Instruction("SBC", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0xF2, Instruction("SBC", &foo12)));
  m_instruction_lookup.insert(make_pair(0xE7, Instruction("SBC", &foo13)));
  m_instruction_lookup.insert(make_pair(0xE3, Instruction("SBC", &foo14)));
  m_instruction_lookup.insert(make_pair(0xF3, Instruction("SBC", &foo15)));
  m_instruction_lookup.insert(make_pair(0x38, Instruction("SEC", &foo0)));
  m_instruction_lookup.insert(make_pair(0xF8, Instruction("SED", &foo0)));
  m_instruction_lookup.insert(make_pair(0x78, Instruction("SEI", &foo0)));
  m_instruction_lookup.insert(make_pair(0xE2, Instruction("SEP", &foo25)));
  m_instruction_lookup.insert(make_pair(0x8D, Instruction("STA", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x8F, Instruction("STA", &foo3, &bar3)));
  m_instruction_lookup.insert(make_pair(0x85, Instruction("STA", &foo4)));
  m_instruction_lookup.insert(make_pair(0x91, Instruction("STA", &foo5)));
  m_instruction_lookup.insert(make_pair(0x97, Instruction("STA", &foo6)));
  m_instruction_lookup.insert(make_pair(0x81, Instruction("STA", &foo7)));
  m_instruction_lookup.insert(make_pair(0x95, Instruction("STA", &foo8)));
  m_instruction_lookup.insert(make_pair(0x9D, Instruction("STA", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0x9F, Instruction("STA", &foo10, &bar3)));
  m_instruction_lookup.insert(make_pair(0x99, Instruction("STA", &foo11, &bar2)));
  m_instruction_lookup.insert(make_pair(0x92, Instruction("STA", &foo12)));
  m_instruction_lookup.insert(make_pair(0x87, Instruction("STA", &foo13)));
  m_instruction_lookup.insert(make_pair(0x83, Instruction("STA", &foo14)));
  m_instruction_lookup.insert(make_pair(0x93, Instruction("STA", &foo15)));
  m_instruction_lookup.insert(make_pair(0xDB, Instruction("STP", &foo0)));
  m_instruction_lookup.insert(make_pair(0x8E, Instruction("STX", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x86, Instruction("STX", &foo4)));
  m_instruction_lookup.insert(make_pair(0x96, Instruction("STX", &foo8)));
  m_instruction_lookup.insert(make_pair(0x8C, Instruction("STY", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x84, Instruction("STY", &foo4)));
  m_instruction_lookup.insert(make_pair(0x94, Instruction("STY", &foo8)));
  m_instruction_lookup.insert(make_pair(0x9C, Instruction("STZ", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x64, Instruction("STZ", &foo4)));
  m_instruction_lookup.insert(make_pair(0x74, Instruction("STZ", &foo8)));
  m_instruction_lookup.insert(make_pair(0x9E, Instruction("STZ", &foo9, &bar2)));
  m_instruction_lookup.insert(make_pair(0xAA, Instruction("TAX", &foo0)));
  m_instruction_lookup.insert(make_pair(0xA8, Instruction("TAY", &foo0)));
  m_instruction_lookup.insert(make_pair(0x5B, Instruction("TCD", &foo0)));
  m_instruction_lookup.insert(make_pair(0x1B, Instruction("TCS", &foo0)));
  m_instruction_lookup.insert(make_pair(0x7B, Instruction("TDC", &foo0)));
  m_instruction_lookup.insert(make_pair(0x1C, Instruction("TRB", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x14, Instruction("TRB", &foo4)));
  m_instruction_lookup.insert(make_pair(0x0C, Instruction("TSB", &foo2, &bar2)));
  m_instruction_lookup.insert(make_pair(0x04, Instruction("TSB", &foo4)));
  m_instruction_lookup.insert(make_pair(0x3B, Instruction("TSC", &foo0)));
  m_instruction_lookup.insert(make_pair(0xBA, Instruction("TSX", &foo0)));
  m_instruction_lookup.insert(make_pair(0x8A, Instruction("TXA", &foo0)));
  m_instruction_lookup.insert(make_pair(0x9A, Instruction("TXS", &foo0)));
  m_instruction_lookup.insert(make_pair(0x9B, Instruction("TXY", &foo0)));
  m_instruction_lookup.insert(make_pair(0x98, Instruction("TYA", &foo0)));
  m_instruction_lookup.insert(make_pair(0xBB, Instruction("TYX", &foo0)));
  m_instruction_lookup.insert(make_pair(0xCB, Instruction("WAI", &foo0)));
  m_instruction_lookup.insert(make_pair(0xEB, Instruction("XBA", &foo0)));
  m_instruction_lookup.insert(make_pair(0xFB, Instruction("XCE", &foo0)));
  m_instruction_lookup.insert(make_pair(0x02, Instruction("COP", &foo0)));
  m_instruction_lookup.insert(make_pair(0x54, Instruction("MVN", &foo27)));
  m_instruction_lookup.insert(make_pair(0x44, Instruction("MVP", &foo27)));

  m_instruction_lookup.insert(make_pair(0x100, Instruction(".dw", &foo2)));
  m_instruction_lookup.insert(make_pair(0x101, Instruction(".dw", &foo30)));
}