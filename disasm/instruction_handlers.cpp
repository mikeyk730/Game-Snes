#include <string>
#include "instruction_handlers.h"
#include "disassembler_context.h"
#include "instruction.h"
#include "utils.h"

using namespace std;
using namespace Address;

namespace InstructionHandler
{
    void Implied(DisassemblerContext* context, Instruction* output)
    { }

    void Accumulator(DisassemblerContext* context, Instruction* output)
    {
        output->setAddress("A");
    }

    /* Accum  #$xx or #$xxxx */
    void Immediate(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        if (context->is_accum_16()) {
            unsigned char j = context->read_next_byte(NULL);
            output->addInstructionBytes(j);

            output->setAddress("#$%.4X", address_16bit(i, j));
        }
        else{
            output->setAddress("#$%.2X", i);
        }
    }

    /* $xxxx */
    void Absolute(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));

        if (msg.empty())
            output->setAddress("$%.4X", address_16bit(i, j));
        else
            output->setAddress(msg.c_str());

        context->set_range(i, j);
    }

    /* $xxxxxx */
    void AbsoluteLong(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        string msg = context->get_label(k, address_16bit(i, j));
        if (msg.empty())
            output->setAddress("$%.6X", address_24bit(i, j, k));
        else
            output->setAddress(msg.c_str());
    }

    /* $xx */
    void DirectPage(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("$%.2X", i);
        else
            output->setAddress(msg.c_str());
    }

    /* ($xx),Y */
    void DPIndirectIndexedY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("($%.2X),Y", i);
        else
            output->setAddress("(%s),Y", msg.c_str());
    }

    /* [$xx],Y */
    void DPIndirectLongIndexedY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("[$%.2X],Y", i);
        else
            output->setAddress("[%s],Y", msg.c_str());
    }

    /* ($xx,X) */
    void DPIndexedIndirectX(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("($%.2X,X)", i);
        else
            output->setAddress("(%s,X)", msg.c_str());
    }

    /* $xx,X */
    void DPIndexedX(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("$%.2X,X", i);
        else
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxx,X */
    void AbsoluteIndexedX(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));
        if (msg.empty())
            output->setAddress("$%.4X,X", address_16bit(i, j));
        else
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxxxx,X */
    void AbsoluteLongIndexedX(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        string msg = context->get_label(k, address_16bit(i, j));
        if (msg.empty())
            output->setAddress("$%.6X,X", address_24bit(i, j, k));
        else
            output->setAddress("%s,X", msg.c_str());
    }

    /* $xxxx,Y */
    void AbsoluteIndexedY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));
        if (msg.empty())
            output->setAddress("$%.4X,Y", address_16bit(i, j));
        else
            output->setAddress("%s,Y", msg.c_str());
    }

    /* ($xx) */
    void DPIndirect(DisassemblerContext* context, Instruction* output)
    {
        unsigned char  i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("($%.2X)", i);
        else
            output->setAddress("(%s)", msg.c_str());
    }

    /* [$xx] */
    void DPIndirectLong(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("[$%.2X]", i);
        else
            output->setAddress("[%s]", msg.c_str());
    }

    /* $xx,S */
    void StackRelative(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("$%.x,S", i);
        else
            output->setAddress("%s,S", msg.c_str());
    }

    /* ($xx,S),Y */
    void SRIndirectIndexedY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("($%.2X,S),Y", i);
        else
            output->setAddress("(%s,S),Y", msg.c_str());
    }

    /* relative */
    void ProgramCounterRelative(DisassemblerContext* context, Instruction* output)
    {
        int pc;
        char r = context->read_next_byte(&pc);
        output->addInstructionBytes((unsigned char)r);

        string msg = context->get_label(context->address_bank(), pc + r);
        if (msg.empty())
            output->setAddress("$%.4X", pc + r);
        else
            output->setAddress("%s", msg.c_str());
    }

    /* relative long */
    void ProgramCounterRelativeLong(DisassemblerContext* context, Instruction* output)
    {
        int pc;
        unsigned char i = context->read_next_byte(&pc);
        unsigned char j = context->read_next_byte(&pc);
        output->addInstructionBytes(i, j);

        long ll = address_16bit(i, j);
        if (ll > 32767) ll = -(65536 - ll);
        long xx = full_address(context->address_bank(), pc) + ll;
        string msg = context->get_label(bank_from_addr24(xx), addr16_from_addr24(xx));
        if (msg.empty())
            output->setAddress("$%.6x", xx);
        else
            output->setAddress("%s", msg.c_str());
    }

    /* PER/PEA $xxxx */
    void StackPCRelativeLong(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        output->setAddress("$%.4X", address_16bit(i, j));
    }

    /* [$xxxx] */
    void AbsoluteIndirectLong(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));
        if (msg.empty())
            output->setAddress("[$%.4X]", address_16bit(i, j));
        else
            output->setAddress("[%s]", msg.c_str());
    }

    /* ($xxxx) */
    void AbsoluteIndirect(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));
        if (msg.empty())
            output->setAddress("($%.4X)", address_16bit(i, j));
        else
            output->setAddress("(%s)", msg.c_str());
    }

    /* ($xxxx,X) */
    void AbsoluteIndexedIndirect(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        string msg = context->get_label(context->address_bank(), address_16bit(i, j));
        if (msg.empty())
            output->setAddress("($%.4X,X)", address_16bit(i, j));
        else
            output->setAddress("(%s,X)", msg.c_str());
    }

    /* $xx,Y */
    void DPIndexedY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        string msg = context->get_label(context->address_bank(), i);
        if (msg.empty())
            output->setAddress("$%.2X,Y", i);
        else
            output->setAddress("%s,Y", msg.c_str());
    }

    /* #$xx */
    void StackDPIndirect(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        output->setAddress("#$%.2X", i);
    }

    /* REP */
    void ImmediateREP(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        output->setAddress("#$%.2X", i);

        if (i & 0x20) { context->set_accum_16(1); context->set_flag(0x20); }
        if (i & 0x10) { context->set_index_16(1); context->set_flag(0x10); }
    }

    /* SEP */
    void ImmediateSEP(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        output->setAddress("#$%.2X", i);

        if (i & 0x20) { context->set_accum_16(0); context->set_flag(0x02); }
        if (i & 0x10) { context->set_index_16(0); context->set_flag(0x01); }
    }

    /* Index  #$xx or #$xxxx */
    void ImmediateXY(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        output->addInstructionBytes(i);

        if (context->is_index_16()) {
            unsigned char j = context->read_next_byte(NULL);
            output->addInstructionBytes(j);

            output->setAddress("#$%.4X", address_16bit(i, j));
        }
        else
            output->setAddress("#$%.2X", i);
    }

    /* MVN/MVP */
    void BlockMove(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j);

        output->setAddress("$%.2X,$%.2X", i, j);
    }

    /* $xxxxxx, .db :$xxxxxx */
    void LongPointer(DisassemblerContext* context, Instruction* output)
    {
        unsigned char i = context->read_next_byte(NULL);
        unsigned char j = context->read_next_byte(NULL);
        unsigned char k = context->read_next_byte(NULL);
        output->addInstructionBytes(i, j, k);

        unsigned char oldk = k;
        if (k == 0xFF)
            k = context->address_bank();

        string msg = context->get_label(k, address_16bit(i, j));
        if (msg.empty()){
            output->setAddress("$%.6X", address_24bit(i, j, k));
            if (i == 0 && j == 0 && k == 0){
                output->setAdditionalInstruction(".db $00");  //WLA cannot take bank of $000000
            }
            else{
                output->setAdditionalInstruction(".db :$%.6X", address_24bit(i, j, k));
            }
        }
        else {
            output->setAddress(".%s", msg.c_str());
            if (oldk == 0xFF){
                output->setAdditionalInstruction(".db $%.2X", oldk);
            }
            else{
                output->setAdditionalInstruction(".db :%s", msg.c_str());
            }
        }
    }
}
