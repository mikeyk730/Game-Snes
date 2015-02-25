#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>

#include "proto.h"
#include "disassembler.h"
#include "request.h"
#include "utils.h"
#include "annotation_handlers.h"
#include "instruction_handlers.h"
#include "disassembler_context.h"
#include "instruction.h"

using namespace std;
using namespace Address;

namespace{
   const unsigned int BANK_SIZE = 0x08000;
   const int MAX_FILE_SIZE = 0x400000;
}

Disassembler::Disassembler() :
m_hirom(false),
m_current_pass(1),
m_passes_to_make(1),
m_flag(0)
{ 
    initialize_instruction_lookup(); 
    m_data = new unsigned char[MAX_FILE_SIZE];
    memset(m_data, 0, MAX_FILE_SIZE);
}

Disassembler::~Disassembler()
{
    delete [] m_data;
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
    sprintf_s(s2, "%.4X", pc);
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

    addr = addr16_from_addr24(full);
    bank = bank_from_addr24(full);

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
        InstructionMetadata instr = m_instruction_lookup[code];

        if (!feof(srcfile)){

            //adjust pc address
            fix_address(bank,pc);

            string label = get_label(InstructionMetadata("", &InstructionHandler::Implied, 0, LINE_LABEL), bank, pc, 0);
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

        unsigned int addr = addr16_from_addr24(fulladdr);
        unsigned char bank = bank_from_addr24(fulladdr);

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

string Disassembler::get_label(const InstructionMetadata& instr, unsigned char bank, int pc, int offset)
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
    for (int i = bank * BANK_SIZE + pc - 0x08000; i >= 0 && i < MAX_FILE_SIZE &&
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
        string label = get_label(InstructionMetadata("", &InstructionHandler::Implied, 0, LINE_LABEL | output_flag), bank, pc, 0);

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
        string label = get_label(InstructionMetadata("", &InstructionHandler::Implied, 0, LINE_LABEL | output_flag), bank, pc, 0);
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


void Disassembler::doType(const InstructionMetadata& instr, bool is_data, unsigned char default_bank)
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

    DisassemblerContext context(*((Disassembler*)this), instr, pc, m_flag, accum16, index16, low, high, bank, default_bank, offset);
    Instruction output(instr);

    auto f = instr.handler();
    f(&context, &output);

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

    //print instruction and comment
    if (finalPass()){
        if (!m_request_prop.m_quiet){
            cout << setw(11) << output.getInstructionBytes();
        }
        
        cout << setw(25) << output.toString(accum16, index16) << " " << comment << endl;
    
        string additional_instruction = output.getAdditionalInstruction();
        if (!additional_instruction.empty()){
            cout << setw(34)  << "" << additional_instruction << endl;
        }

        if (output.metadata().isCodeBreak()){
            cout << endl;
        }
    }
}



void Disassembler::initialize_instruction_lookup()
{
    m_instruction_lookup.insert(make_pair(0x69, InstructionMetadata("ADC", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x6D, InstructionMetadata("ADC", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6F, InstructionMetadata("ADC", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x65, InstructionMetadata("ADC", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x71, InstructionMetadata("ADC", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x77, InstructionMetadata("ADC", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x61, InstructionMetadata("ADC", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x75, InstructionMetadata("ADC", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7D, InstructionMetadata("ADC", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x7F, InstructionMetadata("ADC", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x79, InstructionMetadata("ADC", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x72, InstructionMetadata("ADC", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x67, InstructionMetadata("ADC", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x63, InstructionMetadata("ADC", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x73, InstructionMetadata("ADC", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x29, InstructionMetadata("AND", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2D, InstructionMetadata("AND", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x2F, InstructionMetadata("AND", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x25, InstructionMetadata("AND", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x31, InstructionMetadata("AND", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x37, InstructionMetadata("AND", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x21, InstructionMetadata("AND", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x35, InstructionMetadata("AND", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3D, InstructionMetadata("AND", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x3F, InstructionMetadata("AND", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x39, InstructionMetadata("AND", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x32, InstructionMetadata("AND", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x27, InstructionMetadata("AND", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x23, InstructionMetadata("AND", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x33, InstructionMetadata("AND", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x0E, InstructionMetadata("ASL", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x06, InstructionMetadata("ASL", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0A, InstructionMetadata("ASL", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x16, InstructionMetadata("ASL", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1E, InstructionMetadata("ASL", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x90, InstructionMetadata("BCC", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xB0, InstructionMetadata("BCS", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xF0, InstructionMetadata("BEQ", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x30, InstructionMetadata("BMI", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0xD0, InstructionMetadata("BNE", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x10, InstructionMetadata("BPL", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x80, InstructionMetadata("BRA", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x82, InstructionMetadata("BRL", &InstructionHandler::ProgramCounterRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x50, InstructionMetadata("BVC", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x70, InstructionMetadata("BVS", &InstructionHandler::ProgramCounterRelative, 0, IS_BRANCH)));
    m_instruction_lookup.insert(make_pair(0x89, InstructionMetadata("BIT", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2C, InstructionMetadata("BIT", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x24, InstructionMetadata("BIT", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x34, InstructionMetadata("BIT", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3C, InstructionMetadata("BIT", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x00, InstructionMetadata("BRK", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x18, InstructionMetadata("CLC", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xD8, InstructionMetadata("CLD", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x58, InstructionMetadata("CLI", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xB8, InstructionMetadata("CLV", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC9, InstructionMetadata("CMP", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCD, InstructionMetadata("CMP", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xCF, InstructionMetadata("CMP", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xC5, InstructionMetadata("CMP", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xD1, InstructionMetadata("CMP", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xD7, InstructionMetadata("CMP", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xC1, InstructionMetadata("CMP", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xD5, InstructionMetadata("CMP", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDD, InstructionMetadata("CMP", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xDF, InstructionMetadata("CMP", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xD9, InstructionMetadata("CMP", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xD2, InstructionMetadata("CMP", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xC7, InstructionMetadata("CMP", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xC3, InstructionMetadata("CMP", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xD3, InstructionMetadata("CMP", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE0, InstructionMetadata("CPX", &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xEC, InstructionMetadata("CPX", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE4, InstructionMetadata("CPX", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xC0, InstructionMetadata("CPY", &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCC, InstructionMetadata("CPY", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xC4, InstructionMetadata("CPY", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xCE, InstructionMetadata("DEC", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xC6, InstructionMetadata("DEC", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3A, InstructionMetadata("DEC", &InstructionHandler::Accumulator)));
    m_instruction_lookup.insert(make_pair(0xD6, InstructionMetadata("DEC", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDE, InstructionMetadata("DEC", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xCA, InstructionMetadata("DEX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x88, InstructionMetadata("DEY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x49, InstructionMetadata("EOR", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x4D, InstructionMetadata("EOR", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x4F, InstructionMetadata("EOR", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x45, InstructionMetadata("EOR", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x51, InstructionMetadata("EOR", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x57, InstructionMetadata("EOR", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x41, InstructionMetadata("EOR", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x55, InstructionMetadata("EOR", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5D, InstructionMetadata("EOR", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x5F, InstructionMetadata("EOR", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x59, InstructionMetadata("EOR", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x52, InstructionMetadata("EOR", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x47, InstructionMetadata("EOR", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x43, InstructionMetadata("EOR", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x53, InstructionMetadata("EOR", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xEE, InstructionMetadata("INC", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE6, InstructionMetadata("INC", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x1A, InstructionMetadata("INC", &InstructionHandler::Accumulator)));
    m_instruction_lookup.insert(make_pair(0xF6, InstructionMetadata("INC", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFE, InstructionMetadata("INC", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE8, InstructionMetadata("INX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC8, InstructionMetadata("INY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5C, InstructionMetadata("JMP", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xDC, InstructionMetadata("JMP", &InstructionHandler::AbsoluteIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x4C, InstructionMetadata("JMP", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6C, InstructionMetadata("JMP", &InstructionHandler::AbsoluteIndirect)));
    m_instruction_lookup.insert(make_pair(0x7C, InstructionMetadata("JMP", &InstructionHandler::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0x22, InstructionMetadata("JSL", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x20, InstructionMetadata("JSR", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xFC, InstructionMetadata("JSR", &InstructionHandler::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0xA9, InstructionMetadata("LDA", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAD, InstructionMetadata("LDA", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xAF, InstructionMetadata("LDA", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xA5, InstructionMetadata("LDA", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB1, InstructionMetadata("LDA", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xB7, InstructionMetadata("LDA", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA1, InstructionMetadata("LDA", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xB5, InstructionMetadata("LDA", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBD, InstructionMetadata("LDA", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xBF, InstructionMetadata("LDA", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xB9, InstructionMetadata("LDA", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xB2, InstructionMetadata("LDA", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xA7, InstructionMetadata("LDA", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xA3, InstructionMetadata("LDA", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xB3, InstructionMetadata("LDA", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA2, InstructionMetadata("LDX", &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAE, InstructionMetadata("LDX", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA6, InstructionMetadata("LDX", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB6, InstructionMetadata("LDX", &InstructionHandler::DPIndexedY)));
    m_instruction_lookup.insert(make_pair(0xBE, InstructionMetadata("LDX", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA0, InstructionMetadata("LDY", &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAC, InstructionMetadata("LDY", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA4, InstructionMetadata("LDY", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB4, InstructionMetadata("LDY", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBC, InstructionMetadata("LDY", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x4E, InstructionMetadata("LSR", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x46, InstructionMetadata("LSR", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x4A, InstructionMetadata("LSR", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x56, InstructionMetadata("LSR", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5E, InstructionMetadata("LSR", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xEA, InstructionMetadata("NOP", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x09, InstructionMetadata("ORA", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x0D, InstructionMetadata("ORA", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x0F, InstructionMetadata("ORA", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x05, InstructionMetadata("ORA", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x11, InstructionMetadata("ORA", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x17, InstructionMetadata("ORA", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x01, InstructionMetadata("ORA", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x15, InstructionMetadata("ORA", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1D, InstructionMetadata("ORA", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x1F, InstructionMetadata("ORA", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x19, InstructionMetadata("ORA", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x12, InstructionMetadata("ORA", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x07, InstructionMetadata("ORA", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x03, InstructionMetadata("ORA", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x13, InstructionMetadata("ORA", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF4, InstructionMetadata("PEA", &InstructionHandler::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0xD4, InstructionMetadata("PEI", &InstructionHandler::StackDPIndirect)));
    m_instruction_lookup.insert(make_pair(0x62, InstructionMetadata("PER", &InstructionHandler::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x48, InstructionMetadata("PHA", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8B, InstructionMetadata("PHB", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x0B, InstructionMetadata("PHD", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x4B, InstructionMetadata("PHK", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x08, InstructionMetadata("PHP", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xDA, InstructionMetadata("PHX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5A, InstructionMetadata("PHY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x68, InstructionMetadata("PLA", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xAB, InstructionMetadata("PLB", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x2B, InstructionMetadata("PLD", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x28, InstructionMetadata("PLP", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xFA, InstructionMetadata("PLX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x7A, InstructionMetadata("PLY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC2, InstructionMetadata("REP", &InstructionHandler::ImmediateREP)));
    m_instruction_lookup.insert(make_pair(0x2E, InstructionMetadata("ROL", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x26, InstructionMetadata("ROL", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x2A, InstructionMetadata("ROL", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x36, InstructionMetadata("ROL", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3E, InstructionMetadata("ROL", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6E, InstructionMetadata("ROR", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x66, InstructionMetadata("ROR", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x6A, InstructionMetadata("ROR", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x76, InstructionMetadata("ROR", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7E, InstructionMetadata("ROR", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x40, InstructionMetadata("RTI", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x6B, InstructionMetadata("RTL", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x60, InstructionMetadata("RTS", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xE9, InstructionMetadata("SBC", &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xED, InstructionMetadata("SBC", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xEF, InstructionMetadata("SBC", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xE5, InstructionMetadata("SBC", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xF1, InstructionMetadata("SBC", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF7, InstructionMetadata("SBC", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE1, InstructionMetadata("SBC", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xF5, InstructionMetadata("SBC", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFD, InstructionMetadata("SBC", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xFF, InstructionMetadata("SBC", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xF9, InstructionMetadata("SBC", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xF2, InstructionMetadata("SBC", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xE7, InstructionMetadata("SBC", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xE3, InstructionMetadata("SBC", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xF3, InstructionMetadata("SBC", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x38, InstructionMetadata("SEC", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xF8, InstructionMetadata("SED", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x78, InstructionMetadata("SEI", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xE2, InstructionMetadata("SEP", &InstructionHandler::ImmediateSEP)));
    m_instruction_lookup.insert(make_pair(0x8D, InstructionMetadata("STA", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x8F, InstructionMetadata("STA", &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x85, InstructionMetadata("STA", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x91, InstructionMetadata("STA", &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x97, InstructionMetadata("STA", &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x81, InstructionMetadata("STA", &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x95, InstructionMetadata("STA", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9D, InstructionMetadata("STA", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x9F, InstructionMetadata("STA", &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x99, InstructionMetadata("STA", &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x92, InstructionMetadata("STA", &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x87, InstructionMetadata("STA", &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x83, InstructionMetadata("STA", &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x93, InstructionMetadata("STA", &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xDB, InstructionMetadata("STP", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8E, InstructionMetadata("STX", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x86, InstructionMetadata("STX", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x96, InstructionMetadata("STX", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x8C, InstructionMetadata("STY", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x84, InstructionMetadata("STY", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x94, InstructionMetadata("STY", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9C, InstructionMetadata("STZ", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x64, InstructionMetadata("STZ", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x74, InstructionMetadata("STZ", &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9E, InstructionMetadata("STZ", &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xAA, InstructionMetadata("TAX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xA8, InstructionMetadata("TAY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5B, InstructionMetadata("TCD", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x1B, InstructionMetadata("TCS", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x7B, InstructionMetadata("TDC", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x1C, InstructionMetadata("TRB", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x14, InstructionMetadata("TRB", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0C, InstructionMetadata("TSB", &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x04, InstructionMetadata("TSB", &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3B, InstructionMetadata("TSC", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xBA, InstructionMetadata("TSX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8A, InstructionMetadata("TXA", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x9A, InstructionMetadata("TXS", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x9B, InstructionMetadata("TXY", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x98, InstructionMetadata("TYA", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xBB, InstructionMetadata("TYX", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xCB, InstructionMetadata("WAI", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xEB, InstructionMetadata("XBA", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xFB, InstructionMetadata("XCE", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x02, InstructionMetadata("COP", &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x54, InstructionMetadata("MVN", &InstructionHandler::BlockMove)));
    m_instruction_lookup.insert(make_pair(0x44, InstructionMetadata("MVP", &InstructionHandler::BlockMove)));
    m_instruction_lookup.insert(make_pair(0x42, InstructionMetadata("???", &InstructionHandler::Implied)));

    m_instruction_lookup.insert(make_pair(0x100, InstructionMetadata(".dw", &InstructionHandler::Absolute)));
    m_instruction_lookup.insert(make_pair(0x101, InstructionMetadata(".dw", &InstructionHandler::LongPointer)));
}