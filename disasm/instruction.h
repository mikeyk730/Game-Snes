#include <string>
#include <sstream>
#include "proto.h"

const int IS_BRANCH = 0x01;

class InstructionMetadata{
    typedef void(*InstructionHandlerPtr)(DisassemblerContext*, Instruction*);
    typedef std::string(*AnnotationHandlerPtr)(bool, bool);
public:
    InstructionMetadata();
    InstructionMetadata(const std::string& name, unsigned int opcode, InstructionHandlerPtr address_mode_handler, AnnotationHandlerPtr annotation_handler = 0, int bitmask = 0);

    std::string name() const {
        return m_name;
    }

    bool is_snes_instruction() const
    {
        return m_opcode < 0x100;
    }

    unsigned char opcode() const
    {
        return m_opcode;
    }

    std::string annotated_name(bool is_accum_16, bool is_index_16) const;
    bool isBranch() const;
    bool isCodeBreak() const;

    InstructionHandlerPtr handler() const { return m_instruction_handler; }
    AnnotationHandlerPtr annotationHandler() const { return m_annotation_handler; }

private:
    std::string m_name;
    int m_bitmask;
    unsigned int m_opcode;

    InstructionHandlerPtr m_instruction_handler;
    AnnotationHandlerPtr m_annotation_handler;
};

struct Instruction
{
    Instruction(const InstructionMetadata& metadata, bool accum_16, bool index_16);
    
    void addInstructionBytes(unsigned char a);
    void addInstructionBytes(unsigned char a, unsigned char b);
    void addInstructionBytes(unsigned char a, unsigned char b, unsigned char c);
    std::string getInstructionBytes() const;

    void setAddress(const char *format, ...);
    std::string getAddress() const;

    std::string toString() const;

    void setAdditionalInstruction(const char* format, ...);
    std::string getAdditionalInstruction() const;

    const InstructionMetadata& metadata() const { return m_metadata; }

private:
    InstructionMetadata m_metadata;
    std::ostringstream instruction_bytes;
    char address[80];
    char additional_instruction[80];
    bool m_accum_16;
    bool m_index_16;
};

