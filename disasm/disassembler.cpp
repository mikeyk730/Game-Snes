#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>
#include <cstdarg>

#include "proto.h"
#include "disassembler.h"
#include "request.h"

using namespace std;

namespace{
   const unsigned int BANK_SIZE = 0x08000;
}

inline int address(unsigned char i, unsigned char j)
{
    return j * 256 + i;
}

inline int bank_address(unsigned char i, unsigned char j, unsigned char k)
{
    return k * 256 * 256 + j * 256 + i;
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
    const unsigned char current,
    const unsigned char defaultb,
    const int off) : d(disasm), i(instr), is_accum_16(accum_16), is_index_16(index_16),
    current_bank(current), default_bank(defaultb), offset(off)
    {}

    const bool is_accum_16;
    const bool is_index_16;
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

struct InstructionOutput
{
    InstructionOutput()
    {
        address[0] = 0;
        additional_instruction[0] = 0;
    }

    void addInstructionBytes(unsigned char a)
    {
        instruction_bytes 
            << setw(2) << setfill('0') << uppercase << hex << (int)a << " ";
    }

    void addInstructionBytes(unsigned char a, unsigned char b)
    {
        instruction_bytes 
            << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
            << setw(2) << setfill('0') << uppercase << hex << (int)b << " ";
    }

    void addInstructionBytes(unsigned char a, unsigned char b, unsigned char c)
    {
        instruction_bytes 
            << setw(2) << setfill('0') << uppercase << hex << (int)a << " "
            << setw(2) << setfill('0') << uppercase << hex << (int)b << " "
            << setw(2) << setfill('0') << uppercase << hex << (int)c << " ";
    }

    string getInstructionBytes()
    {
        return instruction_bytes.str();
    }

    void setAddress(const char *format, ...){
        va_list args;
        va_start(args, format);
        vsprintf_s(address, format, args);
        va_end(args);
    }

    string getAddress() const
    {
        return address;
    }

    void setAdditionalInstruction(const char* format, ...)
    {
        va_list args;
        va_start(args, format);
        vsprintf_s(additional_instruction, format, args);
        va_end(args);
    }

    string getAdditionalInstruction() const
    {
        return additional_instruction;
    }

private:
    ostringstream instruction_bytes;
    char address[80];
    char additional_instruction[80];
};

namespace AddressMode
{
    void Implied(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    { }

    /* Accum  #$xx or #$xxxx */
    void Immediate(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        if (disasm_state->is_accum_16) {
            unsigned char j = context->read_next_byte(NULL);
            output->addInstructionBytes(j);

            output->setAddress("#$%.4X", address(i, j));
        }
        else{
            output->setAddress("#$%.2X", i);
        }
    }

    /* $xxxx */
    void Absolute(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j));

        if (msg.empty()) 
            output->setAddress("$%.4X", address(i, j));
        else 
            output->setAddress(msg.c_str());

        context->m_high = j; 
        context->m_low = i;
    }

    /* $xxxxxx */
    void AbsoluteLong(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        string msg = disasm_state->get_label(k, address(i, j)); 
        if (msg.empty())
            output->setAddress("$%.6X", bank_address(i, j, k));
        else 
            output->setAddress(msg.c_str());
    }

    /* $xx */
    void DirectPage(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);
        if (msg.empty())
            output->setAddress("$%.2X", i);
        else 
            output->setAddress(msg.c_str());
    }

    /* ($xx),Y */
    void DPIndirectIndexedY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);
        if (msg.empty())
            output->setAddress("($%.2X),Y", i);
        else 
            output->setAddress("(%s),Y", msg.c_str());
    }

    /* [$xx],Y */
    void DPIndirectLongIndexedY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);  
        if (msg.empty())
            output->setAddress("[$%.2X],Y", i);
        else 
            output->setAddress("[%s],Y", msg.c_str());
    }

    /* ($xx,X) */
    void DPIndexedIndirectX(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i); 
        if (msg.empty())
            output->setAddress("($%.2X,X)", i);
        else 
            output->setAddress("(%s,X)", msg.c_str());
    }

    /* $xx,X */
    void DPIndexedX(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i); 
        if (msg.empty())
            output->setAddress("$%.2X,X", i);
        else
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxx,X */
    void AbsoluteIndexedX(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j)); 
        if (msg.empty())
            output->setAddress("$%.4X,X", address(i, j));
        else 
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxxxx,X */
    void AbsoluteLongIndexedX(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        string msg = disasm_state->get_label(k, address(i, j));
        if (msg.empty())
            output->setAddress("$%.6X,X", bank_address(i, j, k));
        else 
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxx,Y */
    void AbsoluteIndexedY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j)); 
        if (msg.empty())
            output->setAddress("$%.4X,Y", address(i, j));
        else 
            output->setAddress("%s,Y", msg.c_str());
    }

    /* ($xx) */
    void DPIndirect(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char  i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);
        if (msg.empty())
            output->setAddress("($%.2X)", i);
        else 
            output->setAddress("(%s)", msg.c_str());
    }

    /* [$xx] */
    void DPIndirectLong(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i); 
        if (msg.empty())
            output->setAddress("[$%.2X]", i);
        else 
            output->setAddress("[%s]", msg.c_str());
    }

    /* $xx,S */
    void StackRelative(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);
        if (msg.empty())
            output->setAddress("$%.x,S", i);
        else
            output->setAddress("%s,S", msg.c_str());
    }

    /* ($xx,S),Y */
    void SRIndirectIndexedY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i); 
        if (msg.empty())
            output->setAddress("($%.2X,S),Y", i);
        else
            output->setAddress("(%s,S),Y", msg.c_str());
    }

    /* relative */
    void ProgramCounterRelative(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        int pc;
        char r = context->read_next_byte(&pc);
        output->addInstructionBytes((unsigned char)r);

        string msg = disasm_state->get_label(disasm_state->current_bank, pc + r);
        if (msg.empty())
            output->setAddress("$%.4X", pc + r);
        else
            output->setAddress("%s", msg.c_str());
    }

    /* relative long */
    void ProgramCounterRelativeLong(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        int pc;
        unsigned char i = context->read_next_byte(&pc);
        unsigned char j = context->read_next_byte(&pc);
        output->addInstructionBytes(i, j);

        long ll = address(i, j); 
        if (ll > 32767) ll = -(65536 - ll);
        long xx = disasm_state->current_bank * 65536 + pc + ll;
        string msg = disasm_state->get_label((xx) / 0x10000, (xx) & 0xffff);
        if (msg.empty()) 
            output->setAddress("$%.6x", xx);
        else 
            output->setAddress("%s", msg.c_str());
    }

    /* PER/PEA $xxxx */
    void StackPCRelativeLong(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        output->setAddress("$%.4X", address(i, j));
    }

    /* [$xxxx] */
    void AbsoluteIndirectLong(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j));
        if (msg.empty())
            output->setAddress("[$%.4X]", address(i, j));
        else 
            output->setAddress("[%s]", msg.c_str());
    }

    /* ($xxxx) */
    void AbsoluteIndirect(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j)); 
        if (msg.empty())
            output->setAddress("($%.4X)", address(i, j));
        else 
            output->setAddress("(%s)", msg.c_str());
    }

    /* ($xxxx,X) */
    void AbsoluteIndexedIndirect(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = disasm_state->get_label(disasm_state->current_bank, address(i, j));
        if (msg.empty())
            output->setAddress("($%.4X,X)", address(i, j));
        else 
            output->setAddress("(%s,X)", msg.c_str());
    }

    /* $xx,Y */
    void DPIndexedY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        string msg = disasm_state->get_label(disasm_state->current_bank, i);
        if (msg.empty())
            output->setAddress("$%.2X,Y", i);
        else
            output->setAddress("%s,Y", msg.c_str());
    }

    /* #$xx */
    void StackDPIndirect(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        output->setAddress("#$%.2X", i);
    }

    /* REP */
    void ImmediateREP(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        output->setAddress("#$%.2X", i);
        
        if (i & 0x20) { context->set_accum_16(1); context->set_flag(0x20); }
        if (i & 0x10) { context->set_index_16(1); context->set_flag(0x10); }
    }

    /* SEP */
    void ImmediateSEP(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        output->setAddress("#$%.2X", i);

        if (i & 0x20) { context->set_accum_16(0); context->set_flag(0x02); }
        if (i & 0x10) { context->set_index_16(0); context->set_flag(0x01); }
    }

    /* Index  #$xx or #$xxxx */
    void ImmediateXY(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);
        
        if (disasm_state->is_index_16) {
            unsigned char j = context->read_next_byte(NULL);
            output->addInstructionBytes(j);

            output->setAddress("#$%.4X", address(i, j));
        }
        else
            output->setAddress("#$%.2X", i);
    }

    /* MVN/MVP */
    void BlockMove(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        output->setAddress("$%.2X,$%.2X", i, j);
    }

    /* $xxxx, .db :$xxxx */
    void LongPointer(DisasmState* disasm_state, StateContext* context, InstructionOutput* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        unsigned char oldk = k;
        if (k == 0xFF)
            k = disasm_state->default_bank;

        string msg = disasm_state->get_label(k, address(i, j));
        if (msg.empty()){
            output->setAddress("$%.6X", bank_address(i, j, k));
            if (i == 0 && j == 0 && k == 0){
                output->setAdditionalInstruction(".db $00");  //WLA cannot take bank of $000000
            }
            else{
                output->setAdditionalInstruction(".db :$%.6X", bank_address(i, j, k));
            }
        }
        else {
            if (oldk == 0xFF){
                output->setAddress(".%s", msg.c_str());
                output->setAdditionalInstruction(".db $%.2X", oldk);
            }
            else{
                output->setAddress(".%s", msg.c_str());
                output->setAdditionalInstruction(".db :%s", msg.c_str());
            }
        }
    }
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

namespace Annotation{
    string Word(bool is_accum_16, bool is_index_16){
        return ".W";
    }

    string AccumDependentWord(bool is_accum_16, bool is_index_16){
        if (is_accum_16)
            return ".W";
        return ".B";
    }

    string IndexDependentWord(bool is_accum_16, bool is_index_16){
        if (is_index_16)
            return ".W";
        return ".B";
    }

    string Long(bool is_accum_16, bool is_index_16){
        return ".L";
    }
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

            string label = get_label(Instruction("", &AddressMode::Implied, 0, LINE_LABEL), bank, pc, 0);
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
        string label = get_label(Instruction("", &AddressMode::Implied, 0, LINE_LABEL | output_flag), bank, pc, 0);

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
        string label = get_label(Instruction("", &AddressMode::Implied, 0, LINE_LABEL | output_flag), bank, pc, 0);
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

    unsigned char& bank = default_bank; // m_current_bank;
    unsigned int& pc = m_current_addr;
    bool& accum16 = m_request_prop.m_accum_16;
    bool& index16 = m_request_prop.m_index_16;

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

    DisasmState state(*((Disassembler*)this), instr, accum16, index16, bank, default_bank, offset);
    StateContext context(pc, m_flag, accum16, index16, low, high);
    InstructionOutput output;

    auto f = instr.m_address_mode_handler;
    f(&state, &context, &output);

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
        if (!m_request_prop.m_quiet){
            cout << setw(11) << output.getInstructionBytes();
        }
        
        cout << setw(25) << getInstructionName(instr, accum16, index16) + " " + output.getAddress()
            << " " << comment << endl;
    
        string additional_instruction = output.getAdditionalInstruction();
        if (!additional_instruction.empty()){
            cout << setw(34)  << "" << additional_instruction << endl;
        }
    }
}



void Disassembler::initialize_instruction_lookup()
{
    m_instruction_lookup.insert(make_pair(0x69, Instruction("ADC", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x6D, Instruction("ADC", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x6F, Instruction("ADC", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x65, Instruction("ADC", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x71, Instruction("ADC", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x77, Instruction("ADC", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x61, Instruction("ADC", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x75, Instruction("ADC", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7D, Instruction("ADC", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x7F, Instruction("ADC", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x79, Instruction("ADC", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x72, Instruction("ADC", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x67, Instruction("ADC", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x63, Instruction("ADC", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x73, Instruction("ADC", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x29, Instruction("AND", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2D, Instruction("AND", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x2F, Instruction("AND", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x25, Instruction("AND", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x31, Instruction("AND", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x37, Instruction("AND", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x21, Instruction("AND", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x35, Instruction("AND", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3D, Instruction("AND", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x3F, Instruction("AND", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x39, Instruction("AND", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x32, Instruction("AND", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x27, Instruction("AND", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x23, Instruction("AND", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x33, Instruction("AND", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x0E, Instruction("ASL", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x06, Instruction("ASL", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0A, Instruction("ASL", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x16, Instruction("ASL", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1E, Instruction("ASL", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x90, Instruction("BCC", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xB0, Instruction("BCS", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xF0, Instruction("BEQ", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x30, Instruction("BMI", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xD0, Instruction("BNE", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x10, Instruction("BPL", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x80, Instruction("BRA", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x82, Instruction("BRL", &AddressMode::ProgramCounterRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x50, Instruction("BVC", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x70, Instruction("BVS", &AddressMode::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x89, Instruction("BIT", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2C, Instruction("BIT", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x24, Instruction("BIT", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x34, Instruction("BIT", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3C, Instruction("BIT", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x00, Instruction("BRK", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x18, Instruction("CLC", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xD8, Instruction("CLD", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x58, Instruction("CLI", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xB8, Instruction("CLV", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xC9, Instruction("CMP", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCD, Instruction("CMP", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xCF, Instruction("CMP", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xC5, Instruction("CMP", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xD1, Instruction("CMP", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xD7, Instruction("CMP", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xC1, Instruction("CMP", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xD5, Instruction("CMP", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDD, Instruction("CMP", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xDF, Instruction("CMP", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xD9, Instruction("CMP", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xD2, Instruction("CMP", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xC7, Instruction("CMP", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xC3, Instruction("CMP", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xD3, Instruction("CMP", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE0, Instruction("CPX", &AddressMode::ImmediateXY, &Annotation::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xEC, Instruction("CPX", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xE4, Instruction("CPX", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xC0, Instruction("CPY", &AddressMode::ImmediateXY, &Annotation::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCC, Instruction("CPY", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xC4, Instruction("CPY", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xCE, Instruction("DEC", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xC6, Instruction("DEC", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3A, Instruction("DEC A", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xD6, Instruction("DEC", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDE, Instruction("DEC", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xCA, Instruction("DEX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x88, Instruction("DEY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x49, Instruction("EOR", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x4D, Instruction("EOR", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x4F, Instruction("EOR", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x45, Instruction("EOR", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x51, Instruction("EOR", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x57, Instruction("EOR", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x41, Instruction("EOR", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x55, Instruction("EOR", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5D, Instruction("EOR", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x5F, Instruction("EOR", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x59, Instruction("EOR", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x52, Instruction("EOR", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x47, Instruction("EOR", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x43, Instruction("EOR", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x53, Instruction("EOR", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xEE, Instruction("INC", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xE6, Instruction("INC", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x1A, Instruction("INC A", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xF6, Instruction("INC", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFE, Instruction("INC", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xE8, Instruction("INX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xC8, Instruction("INY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x5C, Instruction("JMP", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xDC, Instruction("JMP", &AddressMode::AbsoluteIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x4C, Instruction("JMP", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x6C, Instruction("JMP", &AddressMode::AbsoluteIndirect)));
    m_instruction_lookup.insert(make_pair(0x7C, Instruction("JMP", &AddressMode::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0x22, Instruction("JSL", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x20, Instruction("JSR", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xFC, Instruction("JSR", &AddressMode::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0xA9, Instruction("LDA", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAD, Instruction("LDA", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xAF, Instruction("LDA", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xA5, Instruction("LDA", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB1, Instruction("LDA", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xB7, Instruction("LDA", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA1, Instruction("LDA", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xB5, Instruction("LDA", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBD, Instruction("LDA", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xBF, Instruction("LDA", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xB9, Instruction("LDA", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xB2, Instruction("LDA", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xA7, Instruction("LDA", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xA3, Instruction("LDA", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xB3, Instruction("LDA", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA2, Instruction("LDX", &AddressMode::ImmediateXY, &Annotation::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAE, Instruction("LDX", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xA6, Instruction("LDX", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB6, Instruction("LDX", &AddressMode::DPIndexedY)));
    m_instruction_lookup.insert(make_pair(0xBE, Instruction("LDX", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xA0, Instruction("LDY", &AddressMode::ImmediateXY, &Annotation::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAC, Instruction("LDY", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xA4, Instruction("LDY", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB4, Instruction("LDY", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBC, Instruction("LDY", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x4E, Instruction("LSR", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x46, Instruction("LSR", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x4A, Instruction("LSR", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x56, Instruction("LSR", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5E, Instruction("LSR", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xEA, Instruction("NOP", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x09, Instruction("ORA", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x0D, Instruction("ORA", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x0F, Instruction("ORA", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x05, Instruction("ORA", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x11, Instruction("ORA", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x17, Instruction("ORA", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x01, Instruction("ORA", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x15, Instruction("ORA", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1D, Instruction("ORA", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x1F, Instruction("ORA", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x19, Instruction("ORA", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x12, Instruction("ORA", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x07, Instruction("ORA", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x03, Instruction("ORA", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x13, Instruction("ORA", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF4, Instruction("PEA", &AddressMode::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0xD4, Instruction("PEI", &AddressMode::StackDPIndirect)));
    m_instruction_lookup.insert(make_pair(0x62, Instruction("PER", &AddressMode::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x48, Instruction("PHA", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x8B, Instruction("PHB", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x0B, Instruction("PHD", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x4B, Instruction("PHK", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x08, Instruction("PHP", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xDA, Instruction("PHX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x5A, Instruction("PHY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x68, Instruction("PLA", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xAB, Instruction("PLB", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x2B, Instruction("PLD", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x28, Instruction("PLP", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xFA, Instruction("PLX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x7A, Instruction("PLY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xC2, Instruction("REP", &AddressMode::ImmediateREP)));
    m_instruction_lookup.insert(make_pair(0x2E, Instruction("ROL", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x26, Instruction("ROL", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x2A, Instruction("ROL", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x36, Instruction("ROL", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3E, Instruction("ROL", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x6E, Instruction("ROR", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x66, Instruction("ROR", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x6A, Instruction("ROR", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x76, Instruction("ROR", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7E, Instruction("ROR", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x40, Instruction("RTI", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x6B, Instruction("RTL", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x60, Instruction("RTS", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xE9, Instruction("SBC", &AddressMode::Immediate, &Annotation::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xED, Instruction("SBC", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xEF, Instruction("SBC", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xE5, Instruction("SBC", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xF1, Instruction("SBC", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF7, Instruction("SBC", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE1, Instruction("SBC", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xF5, Instruction("SBC", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFD, Instruction("SBC", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xFF, Instruction("SBC", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0xF9, Instruction("SBC", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xF2, Instruction("SBC", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xE7, Instruction("SBC", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xE3, Instruction("SBC", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xF3, Instruction("SBC", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x38, Instruction("SEC", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xF8, Instruction("SED", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x78, Instruction("SEI", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xE2, Instruction("SEP", &AddressMode::ImmediateSEP)));
    m_instruction_lookup.insert(make_pair(0x8D, Instruction("STA", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x8F, Instruction("STA", &AddressMode::AbsoluteLong, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x85, Instruction("STA", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x91, Instruction("STA", &AddressMode::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x97, Instruction("STA", &AddressMode::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x81, Instruction("STA", &AddressMode::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x95, Instruction("STA", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9D, Instruction("STA", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x9F, Instruction("STA", &AddressMode::AbsoluteLongIndexedX, &Annotation::Long)));
    m_instruction_lookup.insert(make_pair(0x99, Instruction("STA", &AddressMode::AbsoluteIndexedY, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x92, Instruction("STA", &AddressMode::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x87, Instruction("STA", &AddressMode::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x83, Instruction("STA", &AddressMode::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x93, Instruction("STA", &AddressMode::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xDB, Instruction("STP", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x8E, Instruction("STX", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x86, Instruction("STX", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x96, Instruction("STX", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x8C, Instruction("STY", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x84, Instruction("STY", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x94, Instruction("STY", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9C, Instruction("STZ", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x64, Instruction("STZ", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x74, Instruction("STZ", &AddressMode::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9E, Instruction("STZ", &AddressMode::AbsoluteIndexedX, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0xAA, Instruction("TAX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xA8, Instruction("TAY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x5B, Instruction("TCD", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x1B, Instruction("TCS", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x7B, Instruction("TDC", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x1C, Instruction("TRB", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x14, Instruction("TRB", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0C, Instruction("TSB", &AddressMode::Absolute, &Annotation::Word)));
    m_instruction_lookup.insert(make_pair(0x04, Instruction("TSB", &AddressMode::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3B, Instruction("TSC", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xBA, Instruction("TSX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x8A, Instruction("TXA", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x9A, Instruction("TXS", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x9B, Instruction("TXY", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x98, Instruction("TYA", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xBB, Instruction("TYX", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xCB, Instruction("WAI", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xEB, Instruction("XBA", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0xFB, Instruction("XCE", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x02, Instruction("COP", &AddressMode::Implied)));
    m_instruction_lookup.insert(make_pair(0x54, Instruction("MVN", &AddressMode::BlockMove)));
    m_instruction_lookup.insert(make_pair(0x44, Instruction("MVP", &AddressMode::BlockMove)));

    m_instruction_lookup.insert(make_pair(0x100, Instruction(".dw", &AddressMode::Absolute)));
    m_instruction_lookup.insert(make_pair(0x101, Instruction(".dw", &AddressMode::LongPointer)));
}