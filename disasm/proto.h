#ifndef PROTO_H
#define PROTO_H

#include <string>
#include <iostream>
#include <map>

#define HELP "disasm.exe ROM_FILENAME\n"
extern FILE *srcfile;

struct DisassemblerContext;
struct DisasmState;
struct Instruction;

unsigned int hex(const char *s);
std::string spaces(int number);
std::string to_string(int i, int length, bool in_hex=true);
std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);

const int IS_BRANCH = 0x01;
const int NO_ADDR_LABEL = 0x02;
const int LINE_LABEL = 0x04;

class InstructionMetadata{
    typedef void(*InstructionHandlerPtr)(DisassemblerContext*, Instruction*);
    typedef std::string(*AnnotationHandlerPtr)(bool, bool);
public:
    InstructionMetadata() :
        m_name(""), 
        m_instruction_handler(0), 
        m_bitmask(0)
    {}

    InstructionMetadata(const std::string& name, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler = 0, int bitmask = 0) :
        m_name(name), 
        m_instruction_handler(address_mode_handler),
        m_annotation_handler(annotation_handler),
        m_bitmask(bitmask)
    { }

    inline std::string name() const { 
        return m_name; 
    }

    inline std::string annotated_name(bool is_accum_16, bool is_index_16) const {
        if (m_annotation_handler){
            return m_name + (*m_annotation_handler)(is_accum_16, is_index_16);
        }
        return m_name ;
    }

    inline bool isBranch() const { return (m_bitmask & IS_BRANCH) != 0; }
    inline bool neverUseAddrLabel() const { return (m_bitmask & NO_ADDR_LABEL) != 0; }
    inline bool isLineLabel() const { return (m_bitmask & LINE_LABEL) != 0; }
    bool isCodeBreak() const{
        return (m_name == "RTS" || m_name == "RTI" || m_name == "RTL"
            || m_name == "JMP" || m_name == "BRA");
    }

    InstructionHandlerPtr handler() const { return m_instruction_handler; }
    AnnotationHandlerPtr annotationHandler() const { return m_annotation_handler; }
    
private:
    std::string m_name;
    int m_bitmask;

    InstructionHandlerPtr m_instruction_handler;
    AnnotationHandlerPtr m_annotation_handler;
};






#endif
