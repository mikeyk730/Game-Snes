#include <memory>
#include <string>
#include <vector>

struct Instruction;

struct OutputHandler{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk) = 0;
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags) = 0;
    virtual void BankStart(int bank) = 0;
    virtual void PassStart() = 0;
    virtual void CodeBlockStart() = 0;
    virtual void CodeBlockEnd() = 0;
    virtual void PtrBlockStart() = 0;
    virtual void PtrBlockEnd() = 0;
    virtual void DataBlockStart() = 0;
    virtual void DataBlockEnd() = 0;
};

struct DefaultOutput : public OutputHandler
{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk);
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags);
    virtual void BankStart(int bank);
    virtual void PassStart();
    virtual void CodeBlockStart();
    virtual void CodeBlockEnd();
    virtual void PtrBlockStart();
    virtual void PtrBlockEnd();
    virtual void DataBlockStart();
    virtual void DataBlockEnd();
};

struct SmasOutput : public OutputHandler
{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk);
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags);
    virtual void BankStart(int bank);
    virtual void PassStart();
    virtual void CodeBlockStart();
    virtual void CodeBlockEnd();
    virtual void PtrBlockStart();
    virtual void PtrBlockEnd();
    virtual void DataBlockStart();
    virtual void DataBlockEnd();
};

struct NoOutput : public OutputHandler
{
    virtual void PrintData(const std::vector<unsigned char>& bytes, const std::string& label, const std::string& comment, bool print_bytes, bool end_of_chunk) {}
    virtual void PrintInstruction(const Instruction& instr, const std::string& label, const std::string& comment, bool print_bytes, int flags) {}
    virtual void BankStart(int bank) {}
    virtual void PassStart() {}
    virtual void CodeBlockStart() {}
    virtual void CodeBlockEnd() {}
    virtual void PtrBlockStart() {}
    virtual void PtrBlockEnd() {}
    virtual void DataBlockStart() {}
    virtual void DataBlockEnd() {}
};

std::shared_ptr<OutputHandler> CreateOutputHandler(const std::string& type);
