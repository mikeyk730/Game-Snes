#include <vector>
#include <string>
#include <iomanip>
#include <iostream>
#include "output_handlers.h"
#include "instruction.h"

using namespace std;


std::shared_ptr<OutputHandler> CreateOutputHandler(const std::string& type)
{
    if (type == "smas")
        return make_shared<SmasOutput>();
    return make_shared<DefaultOutput>();
}


void DefaultOutput::PrintData(const vector<unsigned char>& bytes, const string& label, const string& comment, bool print_bytes, bool end_of_chunk)
{
    if (!label.empty()){
        cout << left << setw(20) << label + ":";
    }
    else {
        cout << setw(20) << "";
    }

    if (print_bytes) cout << string(14, ' ');
    cout << ".db ";

    for (int i = 0; i < bytes.size(); ++i){
        printf("$%.2X", bytes[i]);
        if (i + 1 < bytes.size())
        {
            cout << ",";
        }
    }

    if (!comment.empty())
        cout << "     ; " << comment;
    cout << endl;
    if (end_of_chunk)
        cout << endl;
}

void DefaultOutput::PrintInstruction(const Instruction& instr, const string& label, const string& user_comment, bool print_bytes, int flags)
{
    if (!label.empty()){
        cout << left << setw(20) << label + ":";
    }
    else {
        cout << left << setw(20) << "";
    }

    if (print_bytes){
        cout << setw(14) << instr.getInstructionBytes();
    }

    string comment = user_comment;

    string flag_comment = instr.flag_comment(flags);
    if (!flag_comment.empty()){
        if (!comment.empty()){
            comment += " ; ";
        }
        comment += flag_comment;
    }

    string ram_comment = instr.ram_comment();
    if (!ram_comment.empty()){
        if (!comment.empty()){
            comment += " ; ";
        }
        comment += ram_comment;
    }

    cout << setw(26) << instr.toString() << (comment.empty() ? "" : "; ") << comment << endl;

    string additional_instruction = instr.getAdditionalInstruction();
    if (!additional_instruction.empty()){
        cout << setw(print_bytes ? 34 : 20) << "" << additional_instruction << endl;
    }

    if (instr.metadata().isCodeBreak()){
        cout << endl;
    }
}

void DefaultOutput::BankStart(int bank)
{
    cout << ".BANK " << bank << endl;
}

void DefaultOutput::PassStart()
{
    cout << ".INCLUDE \"snes.cfg\"" << endl;
}

void DefaultOutput::CodeBlockStart()
{

}

void DefaultOutput::CodeBlockEnd()
{

}

void DefaultOutput::PtrBlockStart()
{
    cout << endl;
}

void DefaultOutput::PtrBlockEnd()
{
    cout << endl;
}

void DefaultOutput::DataBlockStart()
{

}

void DefaultOutput::DataBlockEnd()
{

}

void SmasOutput::PrintData(const vector<unsigned char>& bytes, const string& label, const string& comment, bool print_bytes, bool end_of_chunk)
{
    if (!label.empty()){
        cout << left << setw(20) << label + ":";
    }
    else {
        cout << setw(20) << "";
    }

    cout << "db ";

    for (int i = 0; i < bytes.size(); ++i){
        printf("$%.2X", bytes[i]);
        if (i + 1 < bytes.size())
        {
            cout << ",";
        }
    }

    if (!comment.empty())
        cout << "     ;" << comment;
    cout << endl;
    if (end_of_chunk)
        cout << endl;
}

void SmasOutput::PrintInstruction(const Instruction& instr, const string& label, const string& user_comment, bool print_bytes, int flags)
{
    if (!label.empty()){
        cout << left << setw(20) << label + ":";
    }
    else {
        cout << left << setw(20) << "";
    }

    if (print_bytes && instr.metadata().is_snes_instruction()){
        cout << setw(14) << instr.getInstructionBytes();
    }

    string comment = user_comment;

    string flag_comment = instr.flag_comment(flags);
    if (!flag_comment.empty()){
        if (!comment.empty()){
            comment += " ; ";
        }
        comment += flag_comment;
    }

    string ram_comment = instr.ram_comment();
    if (!ram_comment.empty()){
        if (!comment.empty()){
            comment += " ; ";
        }
        comment += ram_comment;
    }

    cout << setw(26) << instr.toString();
    if (instr.comment_level() > 0){
        cout << (comment.empty() ? "" : ";") << comment;
        //cout << ";" << comment;
    }
    cout << endl;

    string additional_instruction = instr.getAdditionalInstruction();
    if (!additional_instruction.empty()){
        cout << setw(print_bytes ? 34 : 20) << "" << additional_instruction << endl;
    }

    if (instr.metadata().isCodeBreak()){
        cout << endl;
    }
}

void SmasOutput::BankStart(int bank)
{
    cout << ".BANK " << bank << endl;
}

void SmasOutput::PassStart()
{
    cout << ".INCLUDE \"snes.cfg\"" << endl;
}

void SmasOutput::CodeBlockStart()
{

}

void SmasOutput::CodeBlockEnd()
{

}

void SmasOutput::PtrBlockStart()
{
}

void SmasOutput::PtrBlockEnd()
{
    cout << endl;
}

void SmasOutput::DataBlockStart()
{

}

void SmasOutput::DataBlockEnd()
{

}
