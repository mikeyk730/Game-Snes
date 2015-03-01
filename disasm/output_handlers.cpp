#include <vector>
#include <string>
#include <iomanip>
#include <iostream>
#include "output_handlers.h"
#include "instruction.h"

using namespace std;


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

    if (flags != 0){
        if (!comment.empty()){
            comment += " ; ";
        }
        if (flags & 0x10) comment += "Index (16 bit) ";
        if (flags & 0x20) comment += "Accum (16 bit) ";
        if (flags & 0x01) comment += "Index (8 bit) ";
        if (flags & 0x02) comment += "Accum (8 bit) ";
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
