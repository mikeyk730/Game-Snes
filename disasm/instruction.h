#include <string>
#include <sstream>

struct InstructionOutput
{
    InstructionOutput();
    
    void addInstructionBytes(unsigned char a);
    void addInstructionBytes(unsigned char a, unsigned char b);
    void addInstructionBytes(unsigned char a, unsigned char b, unsigned char c);
    std::string getInstructionBytes();

    void setAddress(const char *format, ...);
    std::string getAddress() const;

    void setAdditionalInstruction(const char* format, ...);
    std::string getAdditionalInstruction() const;

private:
    std::ostringstream instruction_bytes;
    char address[80];
    char additional_instruction[80];
};

