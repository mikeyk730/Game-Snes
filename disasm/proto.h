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

class InstructionMetadata{
    typedef void(*InstructionHandlerPtr)(DisassemblerContext*, Instruction*);
    typedef std::string(*AnnotationHandlerPtr)(bool, bool);
public:
    InstructionMetadata() :
        m_name(""), 
        m_opcode(0),
        m_instruction_handler(0), 
        m_bitmask(0)
    { }

    InstructionMetadata(const std::string& name, unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler = 0, int bitmask = 0) :
        m_name(name), 
        m_opcode(opcode),
        m_instruction_handler(address_mode_handler),
        m_annotation_handler(annotation_handler),
        m_bitmask(bitmask)
    { }

    inline std::string name() const { 
        return m_name; 
    }

    inline bool is_snes_instruction() const
    {
        return m_opcode < 0x100;
    }

    inline unsigned char opcode() const
    {
        return m_opcode;
    }

    inline std::string annotated_name(bool is_accum_16, bool is_index_16) const {
        if (m_annotation_handler){
            return m_name + (*m_annotation_handler)(is_accum_16, is_index_16);
        }
        return m_name ;
    }

    inline bool isBranch() const { return (m_bitmask & IS_BRANCH) != 0; }
    bool isCodeBreak() const{
        return (m_name == "RTS" || m_name == "RTI" || m_name == "RTL"
            || m_name == "JMP" || m_name == "BRA");
    }

    InstructionHandlerPtr handler() const { return m_instruction_handler; }
    AnnotationHandlerPtr annotationHandler() const { return m_annotation_handler; }
    
private:
    std::string m_name;
    int m_bitmask;
    unsigned int m_opcode;

    InstructionHandlerPtr m_instruction_handler;
    AnnotationHandlerPtr m_annotation_handler;
};






#endif
