#include <string>
#include <sstream>

#include "proto.h"

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

