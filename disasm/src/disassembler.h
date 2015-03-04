#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <iostream>
#include <memory>
#include <string>
#include <map>
#include "request.h"

class InstructionMetadata;
struct OutputHandler;
struct InstructionNameProvider;
struct AnnotationProvider;
struct ByteProperties;

struct DisassemblerState
{
    DisassemblerState();

    void hirom(bool hi) { m_hirom = hi; } //todo: move to ctor

    void increment_address();
    void set_address(unsigned char bank, unsigned int pc);
    unsigned int get_current_index() const;
    unsigned int get_current_address() const;

    unsigned int get_current_bank() const { return m_current_bank; }
    unsigned int get_current_pc() const { return m_current_addr; }

    bool is_accum_16bit() const { return m_accum_16; }
    void is_accum_16bit(bool is_16bit) { m_accum_16 = is_16bit; }

    bool is_index_16bit() const { return m_index_16; }
    void is_index_16bit(bool is_16bit) { m_index_16 = is_16bit; }

    bool is_bank_start() const { return m_current_addr == 0x8000; }

    bool m_hirom;
    unsigned char m_current_bank;
    unsigned int m_current_addr;
    bool m_accum_16;
    bool m_index_16;
    //unsigned char m_data_bank; //todo: move this here
};


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

    void load_data_bank(const char *filename);
    void load_data(const char *filename, bool is_ptr_data = false); //todo: separate
    void load_comments(const char *filename);
    void load_symbols(const char *filename, bool ram = false); //todo: separate
    void load_symbols2(const char *filename); //todo: rename
    void load_accum_bytes(char *fname, bool accum);//todo: rename
    void load_offsets(const char *filename); //load instructions whose targets need to be adjusted 
    void load_instruction_names(const char *filename);
    void set_output_format(const char* output_format);
    void set_annotation_format(const char* output_format);

    bool add_label(int bank, int pc, const std::string& label);
    void mark_label_used(int bank, int pc, const std::string& label);
    std::string get_instr_label(const InstructionMetadata& instr, unsigned char bank, int pc, int offset);
    std::string get_line_label(bool use_addr_label);

    int get_offset();
    std::string get_comment();
    int get_data_bank() const;

    void hirom(bool hirom);
    bool hirom() const { return m_hirom; }

    inline void quiet(bool q) { m_quiet = q; }
    inline bool quiet() const { return m_quiet; }

    inline void passes(int passes) { m_passes_to_make = passes; }
    bool finalPass() const { return (m_current_pass == m_passes_to_make); }
    bool printInstructionBytes() const { return (!m_range_properties.m_quiet && finalPass()); }

    int header_size() const { return m_header_size; }
    void header_size(int size) { m_header_size = size; }

    char read_next_byte();

private:
    std::string get_label_helper(unsigned int full_address, bool use_addr_label, bool mark_instruction_used, bool is_branch);
    void disassembleRange(const Request& request);
    void disassembleInstruction(const InstructionMetadata& instr, const std::string& label, const std::string& comment, int offset, int data_bank);
    std::shared_ptr<OutputHandler> output_handler() const
    {
        return finalPass() ? m_output_handler : m_noop_handler;
    }

    std::map<int, InstructionMetadata> m_instruction_lookup;
    std::map<int, std::string> m_ram_lookup;
    std::map<int, std::string> m_used_label_lookup;
    std::map<int, std::string> m_unresolved_symbol_lookup;
    
    // todo: make this a class
    ByteProperties *m_data; 

    DisassemblerProperties m_range_properties;

    bool m_quiet;
    int m_current_pass;
    int m_passes_to_make;
    int m_flag; //indicates whether accum/index have changed size during the current instruction

    DisassemblerState m_state;

    bool m_hirom;
    int m_start;
    int m_end;

    std::shared_ptr<OutputHandler> m_noop_handler;
    std::shared_ptr<OutputHandler> m_output_handler;
    std::shared_ptr<InstructionNameProvider> m_instruction_name_provider;
    std::shared_ptr<AnnotationProvider> m_annotation_provider;

    FILE* m_rom_file;
    int m_header_size;
};

#endif
