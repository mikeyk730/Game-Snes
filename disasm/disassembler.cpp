#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>
#include "disassembler.h"
#include "disassembler_context.h"
#include "request.h"
#include "instruction.h"
#include "instruction_handlers.h"
#include "annotation_handlers.h"
#include "output_handlers.h"
#include "utils.h"

using namespace std;
using namespace Address;

namespace{
   const int MAX_FILE_SIZE = 0x400000;
}

Disassembler::Disassembler(FILE* rom_file) :
m_hirom(false),
m_current_pass(1),
m_passes_to_make(1),
m_flag(0),
m_accum_16(false),
m_index_16(false),
m_output_handler(new DefaultOutput()),
m_rom_file(rom_file)
{ 
    initialize_instruction_lookup(); 
    m_data = new unsigned char[MAX_FILE_SIZE];
    memset(m_data, 0, MAX_FILE_SIZE);
}

Disassembler::~Disassembler()
{
    delete m_output_handler;
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

        m_accum_16 = request.m_properties.m_start_w_accum_16;
        m_index_16 = request.m_properties.m_start_w_index_16;
    }

    do{
        m_request_prop = request.m_properties;

        m_current_bank = m_request_prop.m_start_bank;
        m_current_addr = m_request_prop.m_start_addr;

        fseek(m_rom_file, 512, 0);
        if (m_hirom)
            fseek(m_rom_file, full_address(m_current_bank, m_current_addr), 1);
        else
            fseek(m_rom_file, m_current_bank * 32768 + m_current_addr - 0x8000, 1);

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

    unsigned int end_pc = m_request_prop.m_end_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;

    while ((!feof(m_rom_file)) && (full_address(bank, pc) < full_address(end_bank, end_pc))){

        unsigned char code = read_char(m_rom_file);
        InstructionMetadata instr = m_instruction_lookup[code];

        if (!feof(m_rom_file)){

            //adjust pc address
            fix_address(bank,pc);

            string label = get_line_label(bank, pc, true);
            
            if (finalPass() && pc == 0x8000){
                cout << ".BANK " << int(bank) << endl;
            }

            doType(instr, false, bank, label);

            if (m_request_prop.m_stop_at_rts &&
                (instr.name() == "RTS" || instr.name() == "RTI" || instr.name() == "RTL"))
                break;            
        }
        if (feof(m_rom_file)) cout << "; End of file." << endl;
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
        m_accum_16 = ((it->second) == 16);
        m_flag |= (m_accum_16) ? 0x20 : 0x02;
    }

    map<int, int>::iterator it2 = m_index_lookup.find(full_address(bank,pc));
    if (it2 != m_index_lookup.end()){
        m_index_16 = ((it2->second) == 16);    
        m_flag |= (m_index_16) ? 0x10 : 0x01;
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
        
        ss.get(); //skip a single space

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

        unsigned int index = get_index(bank, addr);
        unsigned int size = get_index(end_bank, end_addr) - index;

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

bool Disassembler::add_label(int bank, int pc, const string& label)
{
    int full_addr = full_address(bank,pc);
    if (!m_label_lookup.insert(make_pair(full_addr, label)).second){
        cerr << "failed to add symbol >" << label << "<" << endl;
        return false;
    }
    return true;
}

void Disassembler::mark_label_used(int bank, int pc, const string& label)
{
    int full_addr = full_address(bank, pc);
    m_used_label_lookup.insert(make_pair(full_addr, label));
}

string Disassembler::get_instr_label(const InstructionMetadata& instr, unsigned char bank, int pc, int offset)
{
    pc -= offset;
    bool is_branch = instr.isBranch();

    string label = get_label_helper(bank, pc, true, true, is_branch);

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

string Disassembler::get_line_label(unsigned char bank, int pc, bool use_addr_label)
{
    return get_label_helper(bank, pc, use_addr_label, false, false);
}

string Disassembler::get_label_helper(unsigned char bank, int pc, bool use_addr_label, bool mark_instruction_used, bool is_branch)
{
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
            if (mark_instruction_used)
                mark_label_used(bank, pc, label);
        }

        else if (((pc >= 0x8000 && use_addr_label) ||
            (pc < 0x8000 && is_branch) ) && bank < 0x7E){
                label = "ADDR_" + to_string(bank, 2) + /*"_" +*/ to_string(pc, 4);
                if (mark_instruction_used)
                    mark_label_used(bank, pc, label);
            }
        
        else if(pc < 0x8000){
            map<int, string>::iterator it2 = m_ram_lookup.find(key);
            if (it2 != m_ram_lookup.end())
                label = it2->second;
        }
    }
    
    if (label.size() > 0 && finalPass() && is_extern)
        m_unresolved_symbol_lookup.insert(make_pair(key, label));

    return label;
}

void Disassembler::doSmart()
{
    unsigned char bank = m_request_prop.m_start_bank;
    unsigned int pc = m_request_prop.m_start_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int end_pc = m_request_prop.m_end_addr;

    unsigned int end_address = full_address(end_bank, end_pc);
    for (int i = get_index(bank, pc); i >= 0 && i < MAX_FILE_SIZE &&
        full_address(bank, pc) < end_address;){

            Request request(m_request_prop);
            request.m_properties.m_start_bank = bank;
            request.m_properties.m_start_addr = pc;
            //cerr << "start " << hex << bank * 65536 + pc ;

            if (m_data[i] == 1){
                request.m_type = Request::Dcb;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while ((m_data[i] == 1) && (full_address(bank, pc) < end_address));
            }
            else if (m_data[i] == 2){
                request.m_type = Request::Ptr;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while ((m_data[i] == 2) && (full_address(bank, pc) < end_address));
            }
            else if (m_data[i] == 3){
                request.m_type = Request::PtrLong;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while ((m_data[i] == 3) && (full_address(bank, pc) < end_address));
            }
            else{
                request.m_type = Request::Asm;
                do{
                    ++i;
                    fix_address(bank,++pc);
                } while ((m_data[i] == 0) && (full_address(bank, pc) < end_address));
            }

            request.m_properties.m_end_bank = bank;
            request.m_properties.m_end_addr = pc;
            handleRequest(request, false);
        }
}

void Disassembler::doDcb(int bytes_per_line)
{
    unsigned char bank = m_request_prop.m_start_bank;
    unsigned int pc = m_request_prop.m_start_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int end_pc = m_request_prop.m_end_addr;

    while (full_address(bank, pc) < full_address(end_bank, end_pc)){
        vector<unsigned char> bytes;
        string comment;
        string label;
        bool end_of_chunk = false;

        for (int j = 0; j < bytes_per_line && full_address(bank, pc) < full_address(end_bank, end_pc); ++j){
            string current_label = get_line_label(bank, pc, false);
            if (!current_label.empty()){
                if (j == 0){
                    label = current_label;
                }
                else{
                    end_of_chunk = true;
                    break;
                }
            }

            string current_comment = get_comment(bank, pc);
            if (!current_comment.empty()) {
                if (comment.empty()){
                    comment = current_comment;
                }
                else{
                    comment += (" ; " + current_comment);
                }
            }

            if (finalPass() && pc == 0x8000){
                cout << ".BANK " << int(bank) << endl;
            }

            unsigned char c = read_char(m_rom_file);
            bytes.push_back(c);

            fix_address(bank, ++pc);
        }

        if (full_address(bank, pc) == full_address(end_bank, end_pc)){
            end_of_chunk = true;
        }
        m_output_handler->PrintData(bytes, label, comment, !m_request_prop.m_quiet, end_of_chunk);
    }
}

void Disassembler::doPtr(bool long_ptrs)
{
    unsigned char& bank = m_current_bank;
    unsigned int& pc = m_current_addr;
    unsigned char end_bank = m_request_prop.m_end_bank;
    unsigned int end_pc = m_request_prop.m_end_addr;

    cout << endl;
    for (int i = 0; full_address(bank, pc) < full_address(end_bank, end_pc); ++i){
        //adjust pc address
        fix_address(bank,pc);

        string label = get_line_label(bank, pc, false);

        if (finalPass() && pc == 0x8000){
            cout << ".BANK " << int(bank) << endl;
        }

        auto it = m_ptr_bank_lookup.find(get_index(bank, pc));
        unsigned char default_bank = (it != m_ptr_bank_lookup.end()) ? it->second : bank;

        if(long_ptrs)
            doType(m_instruction_lookup[0x101], true, default_bank, label);
        else
            doType(m_instruction_lookup[0x100], true, default_bank, label);
       
    }
    cout << endl;
}

void Disassembler::doType(const InstructionMetadata& instr, bool is_data, unsigned char default_bank, const string& label)
{
    setProcessFlags();

    int offset = 0;
    int full_addr = full_address(m_current_bank, m_current_addr);
    auto load_offset = m_load_offsets.find(full_addr);
    if (load_offset != m_load_offsets.end()){
        offset = load_offset->second;
    }

    string comment = get_comment(m_current_bank, m_current_addr);

    if (!is_data) ++m_current_addr;

    DisassemblerContext context((Disassembler*)this, instr, &m_current_addr, &m_flag, &m_accum_16,
        &m_index_16, default_bank, offset, m_rom_file);
    Instruction output(instr, m_accum_16, m_index_16, m_request_prop.m_comment_level);

    auto instruction_handler = instr.handler();
    instruction_handler(&context, &output);

    if (finalPass()){
        m_output_handler->PrintInstruction(output, label, comment, !m_request_prop.m_quiet, m_flag);
    }
}



void Disassembler::initialize_instruction_lookup()
{
    m_instruction_lookup.insert(make_pair(0x69, InstructionMetadata("ADC", 0x69, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x6D, InstructionMetadata("ADC", 0x6D, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6F, InstructionMetadata("ADC", 0x6F, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x65, InstructionMetadata("ADC", 0x65, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x71, InstructionMetadata("ADC", 0x71, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x77, InstructionMetadata("ADC", 0x77, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x61, InstructionMetadata("ADC", 0x61, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x75, InstructionMetadata("ADC", 0x75, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7D, InstructionMetadata("ADC", 0x7D, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x7F, InstructionMetadata("ADC", 0x7F, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x79, InstructionMetadata("ADC", 0x79, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x72, InstructionMetadata("ADC", 0x72, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x67, InstructionMetadata("ADC", 0x67, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x63, InstructionMetadata("ADC", 0x63, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x73, InstructionMetadata("ADC", 0x73, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x29, InstructionMetadata("AND", 0x29, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2D, InstructionMetadata("AND", 0x2D, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x2F, InstructionMetadata("AND", 0x2F, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x25, InstructionMetadata("AND", 0x25, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x31, InstructionMetadata("AND", 0x31, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x37, InstructionMetadata("AND", 0x37, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x21, InstructionMetadata("AND", 0x21, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x35, InstructionMetadata("AND", 0x35, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3D, InstructionMetadata("AND", 0x3D, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x3F, InstructionMetadata("AND", 0x3F, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x39, InstructionMetadata("AND", 0x39, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x32, InstructionMetadata("AND", 0x32, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x27, InstructionMetadata("AND", 0x27, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x23, InstructionMetadata("AND", 0x23, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x33, InstructionMetadata("AND", 0x33, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x0E, InstructionMetadata("ASL", 0x0E, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x06, InstructionMetadata("ASL", 0x06, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0A, InstructionMetadata("ASL", 0x0A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x16, InstructionMetadata("ASL", 0x16, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1E, InstructionMetadata("ASL", 0x1E, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x90, InstructionMetadata("BCC", 0x90, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0xB0, InstructionMetadata("BCS", 0xB0, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0xF0, InstructionMetadata("BEQ", 0xF0, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x30, InstructionMetadata("BMI", 0x30, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0xD0, InstructionMetadata("BNE", 0xD0, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x10, InstructionMetadata("BPL", 0x10, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x80, InstructionMetadata("BRA", 0x80, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x82, InstructionMetadata("BRL", 0x82, &InstructionHandler::ProgramCounterRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x50, InstructionMetadata("BVC", 0x50, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x70, InstructionMetadata("BVS", 0x70, &InstructionHandler::ProgramCounterRelative)));
    m_instruction_lookup.insert(make_pair(0x89, InstructionMetadata("BIT", 0x89, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x2C, InstructionMetadata("BIT", 0x2C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x24, InstructionMetadata("BIT", 0x24, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x34, InstructionMetadata("BIT", 0x34, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3C, InstructionMetadata("BIT", 0x3C, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x00, InstructionMetadata("BRK", 0x00, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x18, InstructionMetadata("CLC", 0x18, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xD8, InstructionMetadata("CLD", 0xD8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x58, InstructionMetadata("CLI", 0x58, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xB8, InstructionMetadata("CLV", 0xB8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC9, InstructionMetadata("CMP", 0xC9, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCD, InstructionMetadata("CMP", 0xCD, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xCF, InstructionMetadata("CMP", 0xCF, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xC5, InstructionMetadata("CMP", 0xC5, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xD1, InstructionMetadata("CMP", 0xD1, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xD7, InstructionMetadata("CMP", 0xD7, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xC1, InstructionMetadata("CMP", 0xC1, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xD5, InstructionMetadata("CMP", 0xD5, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDD, InstructionMetadata("CMP", 0xDD, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xDF, InstructionMetadata("CMP", 0xDF, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xD9, InstructionMetadata("CMP", 0xD9, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xD2, InstructionMetadata("CMP", 0xD2, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xC7, InstructionMetadata("CMP", 0xC7, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xC3, InstructionMetadata("CMP", 0xC3, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xD3, InstructionMetadata("CMP", 0xD3, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE0, InstructionMetadata("CPX", 0xE0, &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xEC, InstructionMetadata("CPX", 0xEC, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE4, InstructionMetadata("CPX", 0xE4, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xC0, InstructionMetadata("CPY", 0xC0, &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xCC, InstructionMetadata("CPY", 0xCC, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xC4, InstructionMetadata("CPY", 0xC4, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xCE, InstructionMetadata("DEC", 0xCE, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xC6, InstructionMetadata("DEC", 0xC6, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3A, InstructionMetadata("DEC", 0x3A, &InstructionHandler::Accumulator)));
    m_instruction_lookup.insert(make_pair(0xD6, InstructionMetadata("DEC", 0xD6, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xDE, InstructionMetadata("DEC", 0xDE, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xCA, InstructionMetadata("DEX", 0xCA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x88, InstructionMetadata("DEY", 0x88, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x49, InstructionMetadata("EOR", 0x49, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x4D, InstructionMetadata("EOR", 0x4D, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x4F, InstructionMetadata("EOR", 0x4F, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x45, InstructionMetadata("EOR", 0x45, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x51, InstructionMetadata("EOR", 0x51, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x57, InstructionMetadata("EOR", 0x57, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x41, InstructionMetadata("EOR", 0x41, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x55, InstructionMetadata("EOR", 0x55, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5D, InstructionMetadata("EOR", 0x5D, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x5F, InstructionMetadata("EOR", 0x5F, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x59, InstructionMetadata("EOR", 0x59, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x52, InstructionMetadata("EOR", 0x52, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x47, InstructionMetadata("EOR", 0x47, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x43, InstructionMetadata("EOR", 0x43, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x53, InstructionMetadata("EOR", 0x53, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xEE, InstructionMetadata("INC", 0xEE, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE6, InstructionMetadata("INC", 0xE6, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x1A, InstructionMetadata("INC", 0x1A, &InstructionHandler::Accumulator)));
    m_instruction_lookup.insert(make_pair(0xF6, InstructionMetadata("INC", 0xF6, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFE, InstructionMetadata("INC", 0xFE, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xE8, InstructionMetadata("INX", 0xE8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC8, InstructionMetadata("INY", 0xC8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5C, InstructionMetadata("JMP", 0x5C, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xDC, InstructionMetadata("JMP", 0xDC, &InstructionHandler::AbsoluteIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x4C, InstructionMetadata("JMP", 0x4C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6C, InstructionMetadata("JMP", 0x6C, &InstructionHandler::AbsoluteIndirect)));
    m_instruction_lookup.insert(make_pair(0x7C, InstructionMetadata("JMP", 0x7C, &InstructionHandler::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0x22, InstructionMetadata("JSL", 0x22, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x20, InstructionMetadata("JSR", 0x20, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xFC, InstructionMetadata("JSR", 0xFC, &InstructionHandler::AbsoluteIndexedIndirect)));
    m_instruction_lookup.insert(make_pair(0xA9, InstructionMetadata("LDA", 0xA9, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAD, InstructionMetadata("LDA", 0xAD, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xAF, InstructionMetadata("LDA", 0xAF, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xA5, InstructionMetadata("LDA", 0xA5, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB1, InstructionMetadata("LDA", 0xB1, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xB7, InstructionMetadata("LDA", 0xB7, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA1, InstructionMetadata("LDA", 0xA1, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xB5, InstructionMetadata("LDA", 0xB5, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBD, InstructionMetadata("LDA", 0xBD, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xBF, InstructionMetadata("LDA", 0xBF, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xB9, InstructionMetadata("LDA", 0xB9, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xB2, InstructionMetadata("LDA", 0xB2, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xA7, InstructionMetadata("LDA", 0xA7, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xA3, InstructionMetadata("LDA", 0xA3, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xB3, InstructionMetadata("LDA", 0xB3, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xA2, InstructionMetadata("LDX", 0xA2, &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAE, InstructionMetadata("LDX", 0xAE, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA6, InstructionMetadata("LDX", 0xA6, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB6, InstructionMetadata("LDX", 0xB6, &InstructionHandler::DPIndexedY)));
    m_instruction_lookup.insert(make_pair(0xBE, InstructionMetadata("LDX", 0xBE, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA0, InstructionMetadata("LDY", 0xA0, &InstructionHandler::ImmediateXY, &AnnotationHandler::IndexDependentWord)));
    m_instruction_lookup.insert(make_pair(0xAC, InstructionMetadata("LDY", 0xAC, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xA4, InstructionMetadata("LDY", 0xA4, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xB4, InstructionMetadata("LDY", 0xB4, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xBC, InstructionMetadata("LDY", 0xBC, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x4E, InstructionMetadata("LSR", 0x4E, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x46, InstructionMetadata("LSR", 0x46, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x4A, InstructionMetadata("LSR", 0x4A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x56, InstructionMetadata("LSR", 0x56, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x5E, InstructionMetadata("LSR", 0x5E, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xEA, InstructionMetadata("NOP", 0xEA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x09, InstructionMetadata("ORA", 0x09, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x0D, InstructionMetadata("ORA", 0x0D, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x0F, InstructionMetadata("ORA", 0x0F, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x05, InstructionMetadata("ORA", 0x05, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x11, InstructionMetadata("ORA", 0x11, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x17, InstructionMetadata("ORA", 0x17, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x01, InstructionMetadata("ORA", 0x01, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x15, InstructionMetadata("ORA", 0x15, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x1D, InstructionMetadata("ORA", 0x1D, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x1F, InstructionMetadata("ORA", 0x1F, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x19, InstructionMetadata("ORA", 0x19, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x12, InstructionMetadata("ORA", 0x12, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x07, InstructionMetadata("ORA", 0x07, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x03, InstructionMetadata("ORA", 0x03, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x13, InstructionMetadata("ORA", 0x13, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF4, InstructionMetadata("PEA", 0xF4, &InstructionHandler::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0xD4, InstructionMetadata("PEI", 0xD4, &InstructionHandler::StackDPIndirect)));
    m_instruction_lookup.insert(make_pair(0x62, InstructionMetadata("PER", 0x62, &InstructionHandler::StackPCRelativeLong)));
    m_instruction_lookup.insert(make_pair(0x48, InstructionMetadata("PHA", 0x48, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8B, InstructionMetadata("PHB", 0x8B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x0B, InstructionMetadata("PHD", 0x0B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x4B, InstructionMetadata("PHK", 0x4B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x08, InstructionMetadata("PHP", 0x08, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xDA, InstructionMetadata("PHX", 0xDA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5A, InstructionMetadata("PHY", 0x5A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x68, InstructionMetadata("PLA", 0x68, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xAB, InstructionMetadata("PLB", 0xAB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x2B, InstructionMetadata("PLD", 0x2B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x28, InstructionMetadata("PLP", 0x28, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xFA, InstructionMetadata("PLX", 0xFA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x7A, InstructionMetadata("PLY", 0x7A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xC2, InstructionMetadata("REP", 0xC2, &InstructionHandler::ImmediateREP)));
    m_instruction_lookup.insert(make_pair(0x2E, InstructionMetadata("ROL", 0x2E, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0x26, InstructionMetadata("ROL", 0x26, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x2A, InstructionMetadata("ROL", 0x2A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x36, InstructionMetadata("ROL", 0x36, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x3E, InstructionMetadata("ROL", 0x3E, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x6E, InstructionMetadata("ROR", 0x6E, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x66, InstructionMetadata("ROR", 0x66, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x6A, InstructionMetadata("ROR", 0x6A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x76, InstructionMetadata("ROR", 0x76, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x7E, InstructionMetadata("ROR", 0x7E, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x40, InstructionMetadata("RTI", 0x40, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x6B, InstructionMetadata("RTL", 0x6B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x60, InstructionMetadata("RTS", 0x60, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xE9, InstructionMetadata("SBC", 0xE9, &InstructionHandler::Immediate, &AnnotationHandler::AccumDependentWord)));
    m_instruction_lookup.insert(make_pair(0xED, InstructionMetadata("SBC", 0xED, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xEF, InstructionMetadata("SBC", 0xEF, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xE5, InstructionMetadata("SBC", 0xE5, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0xF1, InstructionMetadata("SBC", 0xF1, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xF7, InstructionMetadata("SBC", 0xF7, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0xE1, InstructionMetadata("SBC", 0xE1, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0xF5, InstructionMetadata("SBC", 0xF5, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0xFD, InstructionMetadata("SBC", 0xFD, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xFF, InstructionMetadata("SBC", 0xFF, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0xF9, InstructionMetadata("SBC", 0xF9, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xF2, InstructionMetadata("SBC", 0xF2, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0xE7, InstructionMetadata("SBC", 0xE7, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0xE3, InstructionMetadata("SBC", 0xE3, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0xF3, InstructionMetadata("SBC", 0xF3, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x38, InstructionMetadata("SEC", 0x38, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xF8, InstructionMetadata("SED", 0xF8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x78, InstructionMetadata("SEI", 0x78, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xE2, InstructionMetadata("SEP", 0xE2, &InstructionHandler::ImmediateSEP)));
    m_instruction_lookup.insert(make_pair(0x8D, InstructionMetadata("STA", 0x8D, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x8F, InstructionMetadata("STA", 0x8F, &InstructionHandler::AbsoluteLong, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x85, InstructionMetadata("STA", 0x85, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x91, InstructionMetadata("STA", 0x91, &InstructionHandler::DPIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0x97, InstructionMetadata("STA", 0x97, &InstructionHandler::DPIndirectLongIndexedY)));
    m_instruction_lookup.insert(make_pair(0x81, InstructionMetadata("STA", 0x81, &InstructionHandler::DPIndexedIndirectX)));
    m_instruction_lookup.insert(make_pair(0x95, InstructionMetadata("STA", 0x95, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9D, InstructionMetadata("STA", 0x9D, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x9F, InstructionMetadata("STA", 0x9F, &InstructionHandler::AbsoluteLongIndexedX, &AnnotationHandler::Long)));
    m_instruction_lookup.insert(make_pair(0x99, InstructionMetadata("STA", 0x99, &InstructionHandler::AbsoluteIndexedY, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x92, InstructionMetadata("STA", 0x92, &InstructionHandler::DPIndirect)));
    m_instruction_lookup.insert(make_pair(0x87, InstructionMetadata("STA", 0x87, &InstructionHandler::DPIndirectLong)));
    m_instruction_lookup.insert(make_pair(0x83, InstructionMetadata("STA", 0x83, &InstructionHandler::StackRelative)));
    m_instruction_lookup.insert(make_pair(0x93, InstructionMetadata("STA", 0x93, &InstructionHandler::SRIndirectIndexedY)));
    m_instruction_lookup.insert(make_pair(0xDB, InstructionMetadata("STP", 0xDB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8E, InstructionMetadata("STX", 0x8E, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x86, InstructionMetadata("STX", 0x86, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x96, InstructionMetadata("STX", 0x96, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x8C, InstructionMetadata("STY", 0x8C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x84, InstructionMetadata("STY", 0x84, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x94, InstructionMetadata("STY", 0x94, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9C, InstructionMetadata("STZ", 0x9C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x64, InstructionMetadata("STZ", 0x64, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x74, InstructionMetadata("STZ", 0x74, &InstructionHandler::DPIndexedX)));
    m_instruction_lookup.insert(make_pair(0x9E, InstructionMetadata("STZ", 0x9E, &InstructionHandler::AbsoluteIndexedX, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0xAA, InstructionMetadata("TAX", 0xAA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xA8, InstructionMetadata("TAY", 0xA8, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x5B, InstructionMetadata("TCD", 0x5B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x1B, InstructionMetadata("TCS", 0x1B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x7B, InstructionMetadata("TDC", 0x7B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x1C, InstructionMetadata("TRB", 0x1C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x14, InstructionMetadata("TRB", 0x14, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x0C, InstructionMetadata("TSB", 0x0C, &InstructionHandler::Absolute, &AnnotationHandler::Word)));
    m_instruction_lookup.insert(make_pair(0x04, InstructionMetadata("TSB", 0x04, &InstructionHandler::DirectPage)));
    m_instruction_lookup.insert(make_pair(0x3B, InstructionMetadata("TSC", 0x3B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xBA, InstructionMetadata("TSX", 0xBA, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x8A, InstructionMetadata("TXA", 0x8A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x9A, InstructionMetadata("TXS", 0x9A, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x9B, InstructionMetadata("TXY", 0x9B, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x98, InstructionMetadata("TYA", 0x98, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xBB, InstructionMetadata("TYX", 0xBB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xCB, InstructionMetadata("WAI", 0xCB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xEB, InstructionMetadata("XBA", 0xEB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0xFB, InstructionMetadata("XCE", 0xFB, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x02, InstructionMetadata("COP", 0x02, &InstructionHandler::Implied)));
    m_instruction_lookup.insert(make_pair(0x54, InstructionMetadata("MVN", 0x54, &InstructionHandler::BlockMove)));
    m_instruction_lookup.insert(make_pair(0x44, InstructionMetadata("MVP", 0x44, &InstructionHandler::BlockMove)));
    m_instruction_lookup.insert(make_pair(0x42, InstructionMetadata("???", 0x42, &InstructionHandler::Implied)));

    m_instruction_lookup.insert(make_pair(0x100, InstructionMetadata(".dw", 0x100, &InstructionHandler::Absolute)));
    m_instruction_lookup.insert(make_pair(0x101, InstructionMetadata(".dw", 0x101, &InstructionHandler::LongPointer)));
}