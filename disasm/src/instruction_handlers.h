struct DisassemblerContext;
struct Instruction;

namespace InstructionHandler
{
    void Implied(DisassemblerContext* context, Instruction* output);
    void Accumulator(DisassemblerContext* context, Instruction* output);
    /* Accum  #$xx or #$xxxx */
    void Immediate(DisassemblerContext* context, Instruction* output);
    /* $xxxx */
    void Absolute(DisassemblerContext* context, Instruction* output);
    /* $xxxxxx */
    void AbsoluteLong(DisassemblerContext* context, Instruction* output);
    /* $xx */
    void DirectPage(DisassemblerContext* context, Instruction* output);
    /* ($xx),Y */
    void DPIndirectIndexedY(DisassemblerContext* context, Instruction* output);
    /* [$xx],Y */
    void DPIndirectLongIndexedY(DisassemblerContext* context, Instruction* output);
    /* ($xx,X) */
    void DPIndexedIndirectX(DisassemblerContext* context, Instruction* output);
    /* $xx,X */
    void DPIndexedX(DisassemblerContext* context, Instruction* output);
    /* $xxxx,X */
    void AbsoluteIndexedX(DisassemblerContext* context, Instruction* output);
    /* $xxxxxx,X */
    void AbsoluteLongIndexedX(DisassemblerContext* context, Instruction* output);
    /* $xxxx,Y */
    void AbsoluteIndexedY(DisassemblerContext* context, Instruction* output);
    /* ($xx) */
    void DPIndirect(DisassemblerContext* context, Instruction* output);
    /* [$xx] */
    void DPIndirectLong(DisassemblerContext* context, Instruction* output);
    /* $xx,S */
    void StackRelative(DisassemblerContext* context, Instruction* output);
    /* ($xx,S),Y */
    void SRIndirectIndexedY(DisassemblerContext* context, Instruction* output);
    /* relative */
    void ProgramCounterRelative(DisassemblerContext* context, Instruction* output);
    /* relative long */
    void ProgramCounterRelativeLong(DisassemblerContext* context, Instruction* output);
    /* PER/PEA $xxxx */
    void StackPCRelativeLong(DisassemblerContext* context, Instruction* output);
    /* [$xxxx] */
    void AbsoluteIndirectLong(DisassemblerContext* context, Instruction* output);
    /* ($xxxx) */
    void AbsoluteIndirect(DisassemblerContext* context, Instruction* output);
    /* ($xxxx,X) */
    void AbsoluteIndexedIndirect(DisassemblerContext* context, Instruction* output);
    /* $xx,Y */
    void DPIndexedY(DisassemblerContext* context, Instruction* output);
    /* #$xx */
    void StackDPIndirect(DisassemblerContext* context, Instruction* output);
    /* REP */
    void ImmediateREP(DisassemblerContext* context, Instruction* output);
    /* SEP */
    void ImmediateSEP(DisassemblerContext* context, Instruction* output);
    /* Index  #$xx or #$xxxx */
    void ImmediateXY(DisassemblerContext* context, Instruction* output);
    /* MVN/MVP */
    void BlockMove(DisassemblerContext* context, Instruction* output);
    /* $xxxxxx, .db :$xxxxxx */
    void LongPointer(DisassemblerContext* context, Instruction* output);
}
