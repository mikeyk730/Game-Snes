#include <map>
#include <memory>
#include <string>
#include <sstream>

struct DisassemblerContext;
struct DisassemblerState;
struct Instruction;
struct AnnotationProvider;

struct InstructionNameProvider
{
    InstructionNameProvider(std::istream& input);
    std::string get_name(int opcode) const;

private:
    std::map<int, std::string> m_names;
};


class InstructionMetadata{
    typedef void(*InstructionHandlerPtr)(DisassemblerContext*, Instruction*);
public:
    InstructionMetadata();
    InstructionMetadata(const std::string& internal_name, unsigned int opcode, InstructionHandlerPtr address_mode_handler);

    std::string internal_name() const {
        return m_internal_name;
    }

    bool is_snes_instruction() const
    {
        return m_opcode < 0x100;
    }

    unsigned int opcode() const
    {
        return m_opcode;
    }

    bool isBranch() const;
    bool isJump() const;
    bool isCall() const;
    bool isReturn() const;
    bool isCodeBreak() const { return isReturn() || isJump(); }

    InstructionHandlerPtr handler() const { return m_instruction_handler; }

private:
    std::string m_internal_name;
    unsigned int m_opcode;

    InstructionHandlerPtr m_instruction_handler;
};

struct Instruction
{
    Instruction(const InstructionMetadata& metadata, std::shared_ptr<InstructionNameProvider> name_provider, std::shared_ptr<AnnotationProvider> annotation_provider, const DisassemblerState& state, int comment_level);
    
    void addInstructionBytes(unsigned char a);
    void addInstructionBytes(unsigned char a, unsigned char b);
    void addInstructionBytes(unsigned char a, unsigned char b, unsigned char c);
    std::string getInstructionBytes() const;

    void setDirectAddress(const char *format, ...);
    void setSymbolicAddress(const char *format, ...);
    std::string getAddress() const;
    bool isAddressSymbolic() const { return m_is_address_symbolic;  }

    std::string annotatedName() const;
    std::string toString() const;

    void setAdditionalInstruction(const char* format, ...);
    std::string getAdditionalInstruction() const;

    void set_ram_comment(const std::string& ram_comment) { m_ram_comment = ram_comment; }
    std::string ram_comment() const { return m_ram_comment; }
    std::string flag_comment(int flags) const;

    int comment_level() const { return m_comment_level; }

    const InstructionMetadata& metadata() const { return m_metadata; }

private:
    InstructionMetadata m_metadata;
    std::ostringstream instruction_bytes;
    char address[80];
    bool m_is_address_symbolic;
    char additional_instruction[80];
    bool m_initial_accum_16;
    bool m_initial_index_16;
    int m_comment_level;
    std::string m_ram_comment;
    std::shared_ptr<InstructionNameProvider> m_name_provider;
    std::shared_ptr<AnnotationProvider> m_annotation_provider;
};
