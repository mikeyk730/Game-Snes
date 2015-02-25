struct DisasmState;
struct DisassemblerContext;
struct InstructionOutput;

namespace InstructionHandler
{
    void Implied(DisassemblerContext* context, InstructionOutput* output);
    void Accumulator(DisassemblerContext* context, InstructionOutput* output);
    /* Accum  #$xx or #$xxxx */
    void Immediate(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxx */
    void Absolute(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxxxx */
    void AbsoluteLong(DisassemblerContext* context, InstructionOutput* output);
    /* $xx */
    void DirectPage(DisassemblerContext* context, InstructionOutput* output);
    /* ($xx),Y */
    void DPIndirectIndexedY(DisassemblerContext* context, InstructionOutput* output);
    /* [$xx],Y */
    void DPIndirectLongIndexedY(DisassemblerContext* context, InstructionOutput* output);
    /* ($xx,X) */
    void DPIndexedIndirectX(DisassemblerContext* context, InstructionOutput* output);
    /* $xx,X */
    void DPIndexedX(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxx,X */
    void AbsoluteIndexedX(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxxxx,X */
    void AbsoluteLongIndexedX(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxx,Y */
    void AbsoluteIndexedY(DisassemblerContext* context, InstructionOutput* output);
    /* ($xx) */
    void DPIndirect(DisassemblerContext* context, InstructionOutput* output);
    /* [$xx] */
    void DPIndirectLong(DisassemblerContext* context, InstructionOutput* output);
    /* $xx,S */
    void StackRelative(DisassemblerContext* context, InstructionOutput* output);
    /* ($xx,S),Y */
    void SRIndirectIndexedY(DisassemblerContext* context, InstructionOutput* output);
    /* relative */
    void ProgramCounterRelative(DisassemblerContext* context, InstructionOutput* output);
    /* relative long */
    void ProgramCounterRelativeLong(DisassemblerContext* context, InstructionOutput* output);
    /* PER/PEA $xxxx */
    void StackPCRelativeLong(DisassemblerContext* context, InstructionOutput* output);
    /* [$xxxx] */
    void AbsoluteIndirectLong(DisassemblerContext* context, InstructionOutput* output);
    /* ($xxxx) */
    void AbsoluteIndirect(DisassemblerContext* context, InstructionOutput* output);
    /* ($xxxx,X) */
    void AbsoluteIndexedIndirect(DisassemblerContext* context, InstructionOutput* output);
    /* $xx,Y */
    void DPIndexedY(DisassemblerContext* context, InstructionOutput* output);
    /* #$xx */
    void StackDPIndirect(DisassemblerContext* context, InstructionOutput* output);
    /* REP */
    void ImmediateREP(DisassemblerContext* context, InstructionOutput* output);
    /* SEP */
    void ImmediateSEP(DisassemblerContext* context, InstructionOutput* output);
    /* Index  #$xx or #$xxxx */
    void ImmediateXY(DisassemblerContext* context, InstructionOutput* output);
    /* MVN/MVP */
    void BlockMove(DisassemblerContext* context, InstructionOutput* output);
    /* $xxxxxx, .db :$xxxxxx */
    void LongPointer(DisassemblerContext* context, InstructionOutput* output);
}
