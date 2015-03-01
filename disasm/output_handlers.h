#include <string>
#include <vector>

struct Instruction;

struct OutputHandler{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk) = 0;
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags) = 0;
};

struct DefaultOutput : public OutputHandler
{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk);
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags);
};

struct NoOutput : public OutputHandler
{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk);
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags);
};
