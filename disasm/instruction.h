#include <string>
#include <sstream>

#include "proto.h"

struct Instruction
{
    Instruction(const InstructionMetadata& metadata);
    
    void addInstructionBytes(unsigned char a);
    void addInstructionBytes(unsigned char a, unsigned char b);
    void addInstructionBytes(unsigned char a, unsigned char b, unsigned char c);
    std::string getInstructionBytes();

    void setAddress(const char *format, ...);
    std::string getAddress() const;

    std::string toString(bool is_accum_16, bool is_index_16) const;

    void setAdditionalInstruction(const char* format, ...);
    std::string getAdditionalInstruction() const;

    const InstructionMetadata& metadata() const { return m_metadata; }

private:
    InstructionMetadata m_metadata;
    std::ostringstream instruction_bytes;
    char address[80];
    char additional_instruction[80];
};

