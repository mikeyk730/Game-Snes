#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>

#include "proto.h"

using namespace std;

void Disassembler::handleRequest(const Request& request)
{
    m_properties = request.m_properties;

    m_current_bank = m_properties.m_start_bank;
    m_current_addr = m_properties.m_start_addr;

        fseek(srcfile, 512, 0);
        for(int cc=0; cc<m_current_bank; cc++)  /* skip over each bank */
            if (m_hirom)
                fseek(srcfile, 65536, 1);
            else
                fseek(srcfile, 32768, 1);

        if (m_hirom)
            fseek(srcfile, m_current_addr, 1);
        else
            fseek(srcfile, m_current_addr - 0x8000, 1);



   if (request.m_dcb)
       dodcb();
   else
       dodisasm();
}

void Disassembler::dodisasm()
{
    char s2[80];

      unsigned int& pc = m_current_addr;
      unsigned char& bank = m_current_bank;
      
      unsigned int pc_end = m_properties.m_end_addr;
      unsigned char end_bank = m_properties.m_end_bank;

    while( (!feof(srcfile)) && (bank * 65536 + pc < end_bank * 65536 + pc_end) ){

            unsigned char code = read_char(srcfile);
            Instruction instr = m_instruction_lookup[code];

            if (!feof(srcfile)){

                //adjust pc address
                sprintf(s2, "%.4X", pc);
                if (strlen(s2) == 5){
                    bank++;
                    if (m_hirom)
                        pc -= 0x10000;
                    else
                        pc -= 0x8000;
                }

                string label = get_label(Instruction("",0,ALWAYS_USE_LABEL), bank, pc);
                cout << left << setw(20) << label;

                if (!m_properties.m_quiet) cout << to_string(code, 2) << " ";

                sprintf(buff2, "%s ", instr.name(m_properties.m_accum_16).c_str());

                pc++;
                high = 0; low = 0; flag = 0;
                dotype(instr, bank);
                if (!m_properties.m_quiet) printf("  ");
                cout << buff2;
                if (!m_properties.m_quiet) printf("     ");
                if (instr.name() == "RTS" || instr.name() == "RTI" || instr.name() == "RTL" ){
                    printf("\t\t; Return\n");
                    if(m_properties.m_stop_at_rts) break;
                }
                if (high) printComment(low, high);
                if (flag > 0){

                    printf("\t;");
                    if (flag & 0x10) printf(" Index (16 bit)");
                    if (flag & 0x20) printf(" Accum (16 bit)");
                }
                else if (flag < 0){

                    printf("\t;");
                    if ( (-flag) & 0x10) printf(" Index (8 bit)");
                    if ( (-flag) & 0x20) printf(" Accum (8 bit)");
                }
                printf("\n");
            }
            if (feof(srcfile)) printf("; End of file.\n");
        }
}

void Disassembler::load_symbols(char *fname)
{
  fstream in(fname);
  string line;
  while (getline(in, line)){
    //skip comments
      if (line.length() < 1 || line[0] == ';')
      continue;

    int fulladdr;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> fulladdr >> label))
      continue;
    
    unsigned int addr = (fulladdr & 0x0FFFF);   
    unsigned char bank = ((fulladdr >> 16) & 0x0FF);

    add_label(bank, addr, label);
  }
}

void Disassembler::load_data(char *fname)
{
  fstream in(fname);
  string line;
  while (getline(in, line)){
    //skip comments
      if (line.length() < 1 || line[0] == ';')
      continue;

    int full;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> full))
      continue;

    unsigned int addr = (full & 0x0FFFF);
    unsigned char bank = ((full >> 16) & 0x0FF);

    //no label, create one
    if(!(line_stream >> label >> label))
        label = "DATA_" + to_string(bank,2) + "_" + to_string(addr,4);
     
    add_label(bank, addr, label);
  }
}

void Disassembler::add_label(int bank, int pc, const string& label)
{
    int full_addr = full_address(bank,pc);
    m_label_lookup.insert(make_pair(full_addr, label));
}

string Disassembler::get_label(const Instruction& instr, unsigned char bank, int pc)
{
  string label;

  map<int, string>::iterator it = m_label_lookup.find(full_address(bank,pc));
  if (it != m_label_lookup.end())
      label = it->second;

  else if(!instr.neverUseLabel() && (instr.alwaysUseLabel() || pc >= 32768) &&
      !instr.neverUseAddrLabel() && bank < 126)
        label = "ADDR_" + to_string(bank, 2) + /*"_" +*/ to_string(pc, 4);
  
  return label;
}


void Disassembler::dodcb()
{
  char s2[10];

  int bank = m_properties.m_start_bank;
  int pc = m_properties.m_start_addr;
  int end_bank = m_properties.m_end_bank;
  int pc_end = m_properties.m_end_addr;

  for(int i=0; bank * 65536 + pc < end_bank * 65536 + pc_end; ++i){
    if (i%8 == 0){
      cout << endl;
      string label = get_label(Instruction("",0,ALWAYS_USE_LABEL | NO_ADDR_LABEL), bank, pc);
      cout << setw(20) << left << label;
      if (!m_properties.m_quiet) cout << string(14, ' ');
      cout << "dcb ";
    }

    //adjust address if necessary
    pc++;
    sprintf(s2, "%.4X", pc);
    if (strlen(s2) == 5){
      bank++;
      if (m_hirom)
	pc -= 0x10000;
      else
	pc -= 0x8000;
    }

    //read and print byte
    unsigned char c = read_char(srcfile);
    printf("$%.2X", c);
    if (i%8 != 7 && (bank * 65536 + pc < end_bank * 65536 + pc_end)) printf(",");
  }
}



void Disassembler::dotype(const Instruction& instr, unsigned char bank)
{

  unsigned int& pc = m_current_addr;
  bool accum16 = m_properties.m_accum_16;
  bool index16 = m_properties.m_index_16;

  unsigned char t = instr.addressMode();
  unsigned char i, j, k;
  long ll;
  unsigned char h;
  char r;
  string msg;

  switch (t)
  {
    case 0 : if (!m_properties.m_quiet) printf("         "); break;
    case 1 : i = read_char(srcfile); pc++; if (!m_properties.m_quiet) printf("%.2X ", i);
/* Accum  #$xx or #$xxxx */
             ll = i; strcat(buff2,"#");
             if (accum16 == 1) { j = read_char(srcfile); pc++; ll = j * 256 + ll;
               if (!m_properties.m_quiet) printf("%.2X ", j); }
             msg = get_label(instr, bank, ll); if (msg == "") if (accum16 == 0)
             sprintf(buff1, "$%.2X", ll); else sprintf(buff1, "$%.4X", ll);
             else sprintf(buff1, "%s", msg.c_str()); strcat(buff2, buff1);
             if (!m_properties.m_quiet) { printf("   "); if (accum16 == 0) printf("   "); }
             break;
    case 2 : i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx */  if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); 
             if (msg == "") sprintf(buff1, "$%.2X%.2X", j, i); 
             else sprintf(buff1, "%s",msg.c_str());
             strcat(buff2, buff1);
             pc += 2; high = j; low = i; break;
    case 3 : i = read_char(srcfile); j = read_char(srcfile); k = read_char(srcfile);
/* $xxxxxx */ if (!m_properties.m_quiet) printf("%.2X %.2X %.2X ", i, j, k);
             msg = get_label(instr, k, j * 256 + i); if (msg == "")
             sprintf(buff1, "$%.2X%.2X%.2X", k, j, i);
             else sprintf(buff1, "%s", msg.c_str());  strcat(buff2, buff1); 
             pc += 3; break;
    case 4 : i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* $xx */    msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "$%.2X", i);
             else sprintf(buff1, "%s", msg.c_str()); strcat(buff2, buff1);
             pc++; break;
    case 5 : i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* ($xx),Y */ msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "($%.2X),Y", i);
             else sprintf(buff1, "(%s),Y" ,msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 6 : i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* [$xx],Y */ msg = get_label(instr, bank, i);  if (msg == "")
             sprintf(buff1, "[$%.2X],Y", i);
             else sprintf(buff1,"[%s],Y",msg.c_str());
             strcat(buff2, buff1); pc++; break; 
    case 7 : i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* ($xx,X) */ msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "($%.2X,X)", i);
             else sprintf(buff1, "(%s,X)", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 8 : i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* $xx,X */  msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "$%.2X,X", i);
             else sprintf(buff1, "%s,X", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 9 : i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx,X */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
             sprintf(buff1, "$%.2X%.2X,X", j, i);
             else sprintf(buff1, "%s,X", msg.c_str());
             strcat(buff2, buff1); pc += 2; break;
    case 10: i = read_char(srcfile); j = read_char(srcfile); k = read_char(srcfile);
/* $xxxxxx,X */ if (!m_properties.m_quiet) printf("%.2X %.2X %.2X ", i, j, k);
             msg = get_label(instr, k, j * 256 + i); if (msg == "")
             sprintf(buff1, "$%.2X%.2X%.2X,X", k, j, i);
             else sprintf(buff1, "%s,X", msg.c_str());
             strcat(buff2, buff1); pc += 3; break;
    case 11: i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx,Y */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
             sprintf(buff1, "$%.2X%.2X,Y", j, i);
             else sprintf(buff1, "%s,Y", msg.c_str());
             strcat(buff2, buff1);
             pc += 2; break;
    case 12: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* ($xx) */  msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "($%.2X)", i); else sprintf(buff1, "(%s)", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 13: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* [$xx] */  msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "[$%.2X]", i); else sprintf(buff1, "[%s]", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 14: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* $xx,S */  msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "$%.x,S", i); else sprintf(buff1, "%s,S", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 15: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i);
/* ($xx,S),Y */ msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "($%.2X,S),Y", i);
             else sprintf(buff1, "(%s,S),Y", msg.c_str());
             strcat(buff2, buff1); pc++; break;
    case 16: r = read_char(srcfile); h = r; if (!m_properties.m_quiet) printf("%.2X       ", h);
/* relative */ pc++; msg = get_label(instr, bank, pc+r); if (msg == "")
             sprintf(buff1, "$%.4X", pc+r); else sprintf(buff1, "%s", msg.c_str());
             strcat(buff2, buff1); break;
    case 17: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* relative long */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             ll = j * 256 + i; if (ll > 32767) ll = -(65536-ll);
      msg = get_label(instr, (bank*65536+pc+ll)/0x10000, (bank*65536+pc+ll)&0xffff);
             if (msg == "") sprintf(buff1, "$%.6x", bank*65536+pc+ll);
             else sprintf(buff1, "%s", msg.c_str());
             strcat(buff2, buff1); break;
    case 18: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* #$xxxx */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
            sprintf(buff1, "#$%.2X%.2X", j, i); else sprintf(buff1,"#%s",msg.c_str());
             strcat(buff2, buff1); break;
/*    case 19: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* [$xxxx]  if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
             sprintf(buff1, "[$%.2X%.2X]", j, i);
             else sprintf(buff1,"[%s]",msg.c_str());
             strcat(buff2, buff1); break;
don't really need this anymore.  will just comment it out before deleting
it */
    case 20: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* ($xxxx) */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
         sprintf(buff1, "($%.2X%.2X)", j, i); else sprintf(buff1, "(%s)", msg.c_str());
             strcat(buff2, buff1); break;
    case 21: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* ($xxxx,X) */ if (!m_properties.m_quiet) printf("%.2X %.2X    ",i,j);
             msg = get_label(instr, bank, j * 256 + i); if (msg == "")
             sprintf(buff1, "($%.2X%.2X,X)", j, i);
             else sprintf(buff1, "(%s,X)", msg.c_str());
             strcat(buff2,buff1); break;
    case 22: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i); pc++;
/* $xx,Y */  msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "$%.2X,Y", i); else sprintf(buff1, "%s,Y", msg.c_str());
             strcat(buff2, buff1); break;
    case 23: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i); pc++;
/* #$xx */   msg = get_label(instr, bank, i); if (msg == "")
             sprintf(buff1, "#$%.2X", i); else sprintf(buff1, "#%s", msg.c_str());
             strcat(buff2, buff1); break;
    case 24: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i); pc++;
/* REP */    sprintf(buff1,"#$%.2X", i); strcat(buff2, buff1);
             if (i & 0x20) { accum16 = 1; flag = i; }
             if (i & 0x10) { index16 = 1; flag = i; }
             break;
    case 25: i = read_char(srcfile); if (!m_properties.m_quiet) printf("%.2X       ", i); pc++;
/* SEP */    sprintf(buff1, "#$%.2X", i); strcat(buff2, buff1);
             if (i & 0x20) { accum16 = 0; flag = -i; }
             if (i & 0x10) { index16 = 0; flag = -i; }
             break;
    case 26: i = read_char(srcfile); pc++; if (!m_properties.m_quiet) printf("%.2X ", i);
/* Index  #$xx or #$xxxx */
             ll = i; strcat(buff2,"#");
             if (index16 == 1) { j = read_char(srcfile); pc++; ll = j * 256 + ll;
               if (!m_properties.m_quiet) printf("%.2X ", j); }
             msg = get_label(instr, bank, ll); if (msg == "") if (index16 == 0)
             sprintf(buff1, "$%.2X", ll); else sprintf(buff1, "$%.4X", ll);
             else sprintf(buff1, "%s", msg.c_str()); strcat(buff2, buff1);
             if (!m_properties.m_quiet) { printf("   "); if (index16 == 0) printf("   "); }
             break;
    case 27: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* MVN / MVP */ if (!m_properties.m_quiet) printf("%.2X %.2X    ", i, j);
             sprintf(buff1, "$%.2X,$%.2X", i, j); strcat(buff2, buff1); break;
    default: sprintf(buff2, "???"); break;
  }
}



void Disassembler::initialize_instruction_lookup()
{
  m_instruction_lookup.insert(make_pair(0x69, Instruction("ADC", 1)));
  m_instruction_lookup.insert(make_pair(0x6D, Instruction("ADC", 2)));
  m_instruction_lookup.insert(make_pair(0x6F, Instruction("ADC", 3)));
  m_instruction_lookup.insert(make_pair(0x65, Instruction("ADC", 4)));
  m_instruction_lookup.insert(make_pair(0x71, Instruction("ADC", 5)));
  m_instruction_lookup.insert(make_pair(0x77, Instruction("ADC", 6)));
  m_instruction_lookup.insert(make_pair(0x61, Instruction("ADC", 7)));
  m_instruction_lookup.insert(make_pair(0x75, Instruction("ADC", 8)));
  m_instruction_lookup.insert(make_pair(0x7D, Instruction("ADC", 9)));
  m_instruction_lookup.insert(make_pair(0x7F, Instruction("ADC", 10)));
  m_instruction_lookup.insert(make_pair(0x79, Instruction("ADC", 11)));
  m_instruction_lookup.insert(make_pair(0x72, Instruction("ADC", 12)));
  m_instruction_lookup.insert(make_pair(0x67, Instruction("ADC", 13)));
  m_instruction_lookup.insert(make_pair(0x63, Instruction("ADC", 14)));
  m_instruction_lookup.insert(make_pair(0x73, Instruction("ADC", 15)));
  m_instruction_lookup.insert(make_pair(0x29, Instruction("AND", 1)));
  m_instruction_lookup.insert(make_pair(0x2D, Instruction("AND", 2)));
  m_instruction_lookup.insert(make_pair(0x2F, Instruction("AND", 3)));
  m_instruction_lookup.insert(make_pair(0x25, Instruction("AND", 4)));
  m_instruction_lookup.insert(make_pair(0x31, Instruction("AND", 5)));
  m_instruction_lookup.insert(make_pair(0x37, Instruction("AND", 6)));
  m_instruction_lookup.insert(make_pair(0x21, Instruction("AND", 7)));
  m_instruction_lookup.insert(make_pair(0x35, Instruction("AND", 8)));
  m_instruction_lookup.insert(make_pair(0x3D, Instruction("AND", 9)));
  m_instruction_lookup.insert(make_pair(0x3F, Instruction("AND", 10)));
  m_instruction_lookup.insert(make_pair(0x39, Instruction("AND", 11)));
  m_instruction_lookup.insert(make_pair(0x32, Instruction("AND", 12)));
  m_instruction_lookup.insert(make_pair(0x27, Instruction("AND", 13)));
  m_instruction_lookup.insert(make_pair(0x23, Instruction("AND", 14)));
  m_instruction_lookup.insert(make_pair(0x33, Instruction("AND", 15)));
  m_instruction_lookup.insert(make_pair(0x0E, Instruction("ASL", 2)));
  m_instruction_lookup.insert(make_pair(0x06, Instruction("ASL", 4)));
  m_instruction_lookup.insert(make_pair(0x0A, Instruction("ASL", 0)));
  m_instruction_lookup.insert(make_pair(0x16, Instruction("ASL", 8)));
  m_instruction_lookup.insert(make_pair(0x1E, Instruction("ASL", 9)));
  m_instruction_lookup.insert(make_pair(0x90, Instruction("BCC", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xB0, Instruction("BCS", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xF0, Instruction("BEQ", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x30, Instruction("BMI", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xD0, Instruction("BNE", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x10, Instruction("BPL", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x80, Instruction("BRA", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x82, Instruction("BRL", 17)));
  m_instruction_lookup.insert(make_pair(0x50, Instruction("BVC", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x70, Instruction("BVS", 16, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x89, Instruction("BIT", 1)));
  m_instruction_lookup.insert(make_pair(0x2C, Instruction("BIT", 2)));
  m_instruction_lookup.insert(make_pair(0x24, Instruction("BIT", 4)));
  m_instruction_lookup.insert(make_pair(0x34, Instruction("BIT", 8)));
  m_instruction_lookup.insert(make_pair(0x3C, Instruction("BIT", 9)));
  m_instruction_lookup.insert(make_pair(0x00, Instruction("BRK", 0)));
  m_instruction_lookup.insert(make_pair(0x18, Instruction("CLC", 0)));
  m_instruction_lookup.insert(make_pair(0xD8, Instruction("CLD", 0)));
  m_instruction_lookup.insert(make_pair(0x58, Instruction("CLI", 0)));
  m_instruction_lookup.insert(make_pair(0xB8, Instruction("CLV", 0)));
  m_instruction_lookup.insert(make_pair(0xC9, Instruction("CMP", 1)));
  m_instruction_lookup.insert(make_pair(0xCD, Instruction("CMP", 2)));
  m_instruction_lookup.insert(make_pair(0xCF, Instruction("CMP", 3)));
  m_instruction_lookup.insert(make_pair(0xC5, Instruction("CMP", 4)));
  m_instruction_lookup.insert(make_pair(0xD1, Instruction("CMP", 5)));
  m_instruction_lookup.insert(make_pair(0xD7, Instruction("CMP", 6)));
  m_instruction_lookup.insert(make_pair(0xC1, Instruction("CMP", 7)));
  m_instruction_lookup.insert(make_pair(0xD5, Instruction("CMP", 8)));
  m_instruction_lookup.insert(make_pair(0xDD, Instruction("CMP", 9)));
  m_instruction_lookup.insert(make_pair(0xDF, Instruction("CMP", 10)));
  m_instruction_lookup.insert(make_pair(0xD9, Instruction("CMP", 11)));
  m_instruction_lookup.insert(make_pair(0xD2, Instruction("CMP", 12)));
  m_instruction_lookup.insert(make_pair(0xC7, Instruction("CMP", 13)));
  m_instruction_lookup.insert(make_pair(0xC3, Instruction("CMP", 14)));
  m_instruction_lookup.insert(make_pair(0xD3, Instruction("CMP", 15)));
  m_instruction_lookup.insert(make_pair(0xE0, Instruction("CPX", 26)));
  m_instruction_lookup.insert(make_pair(0xEC, Instruction("CPX", 2)));
  m_instruction_lookup.insert(make_pair(0xE4, Instruction("CPX", 4)));
  m_instruction_lookup.insert(make_pair(0xC0, Instruction("CPY", 26)));
  m_instruction_lookup.insert(make_pair(0xCC, Instruction("CPY", 2)));
  m_instruction_lookup.insert(make_pair(0xC4, Instruction("CPY", 4)));
  m_instruction_lookup.insert(make_pair(0xCE, Instruction("DEC", 2)));
  m_instruction_lookup.insert(make_pair(0xC6, Instruction("DEC", 4)));
  m_instruction_lookup.insert(make_pair(0x3A, Instruction("DEC", 0)));
  m_instruction_lookup.insert(make_pair(0xD6, Instruction("DEC", 8)));
  m_instruction_lookup.insert(make_pair(0xDE, Instruction("DEC", 9)));
  m_instruction_lookup.insert(make_pair(0xCA, Instruction("DEX", 0)));
  m_instruction_lookup.insert(make_pair(0x88, Instruction("DEY", 0)));
  m_instruction_lookup.insert(make_pair(0x49, Instruction("EOR", 1)));
  m_instruction_lookup.insert(make_pair(0x4D, Instruction("EOR", 2)));
  m_instruction_lookup.insert(make_pair(0x4F, Instruction("EOR", 3)));
  m_instruction_lookup.insert(make_pair(0x45, Instruction("EOR", 4)));
  m_instruction_lookup.insert(make_pair(0x51, Instruction("EOR", 5)));
  m_instruction_lookup.insert(make_pair(0x57, Instruction("EOR", 6)));
  m_instruction_lookup.insert(make_pair(0x41, Instruction("EOR", 7)));
  m_instruction_lookup.insert(make_pair(0x55, Instruction("EOR", 8)));
  m_instruction_lookup.insert(make_pair(0x5D, Instruction("EOR", 9)));
  m_instruction_lookup.insert(make_pair(0x5F, Instruction("EOR", 10)));
  m_instruction_lookup.insert(make_pair(0x59, Instruction("EOR", 11)));
  m_instruction_lookup.insert(make_pair(0x52, Instruction("EOR", 12)));
  m_instruction_lookup.insert(make_pair(0x47, Instruction("EOR", 13)));
  m_instruction_lookup.insert(make_pair(0x43, Instruction("EOR", 14)));
  m_instruction_lookup.insert(make_pair(0x53, Instruction("EOR", 15)));
  m_instruction_lookup.insert(make_pair(0xEE, Instruction("INC", 2)));
  m_instruction_lookup.insert(make_pair(0xE6, Instruction("INC", 4)));
  m_instruction_lookup.insert(make_pair(0x1A, Instruction("INC", 0)));
  m_instruction_lookup.insert(make_pair(0xF6, Instruction("INC", 8)));
  m_instruction_lookup.insert(make_pair(0xFE, Instruction("INC", 9)));
  m_instruction_lookup.insert(make_pair(0xE8, Instruction("INX", 0)));
  m_instruction_lookup.insert(make_pair(0xC8, Instruction("INY", 0)));
  m_instruction_lookup.insert(make_pair(0x5C, Instruction("JMP", 3, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xDC, Instruction("JML", 20, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x4C, Instruction("JMP", 2, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x6C, Instruction("JMP", 20, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x7C, Instruction("JMP", 21, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x22, Instruction("JSL", 3, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0x20, Instruction("JSR", 2, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xFC, Instruction("JSR", 21, ALWAYS_USE_LABEL)));
  m_instruction_lookup.insert(make_pair(0xA9, Instruction("LDA", 1)));
  m_instruction_lookup.insert(make_pair(0xAD, Instruction("LDA", 2)));
  m_instruction_lookup.insert(make_pair(0xAF, Instruction("LDA", 3)));
  m_instruction_lookup.insert(make_pair(0xA5, Instruction("LDA", 4)));
  m_instruction_lookup.insert(make_pair(0xB1, Instruction("LDA", 5)));
  m_instruction_lookup.insert(make_pair(0xB7, Instruction("LDA", 6)));
  m_instruction_lookup.insert(make_pair(0xA1, Instruction("LDA", 7)));
  m_instruction_lookup.insert(make_pair(0xB5, Instruction("LDA", 8)));
  m_instruction_lookup.insert(make_pair(0xBD, Instruction("LDA", 9)));
  m_instruction_lookup.insert(make_pair(0xBF, Instruction("LDA", 10)));
  m_instruction_lookup.insert(make_pair(0xB9, Instruction("LDA", 11)));
  m_instruction_lookup.insert(make_pair(0xB2, Instruction("LDA", 12)));
  m_instruction_lookup.insert(make_pair(0xA7, Instruction("LDA", 13)));
  m_instruction_lookup.insert(make_pair(0xA3, Instruction("LDA", 14)));
  m_instruction_lookup.insert(make_pair(0xB3, Instruction("LDA", 15)));
  m_instruction_lookup.insert(make_pair(0xA2, Instruction("LDX", 26)));
  m_instruction_lookup.insert(make_pair(0xAE, Instruction("LDX", 2)));
  m_instruction_lookup.insert(make_pair(0xA6, Instruction("LDX", 4)));
  m_instruction_lookup.insert(make_pair(0xB6, Instruction("LDX", 22)));
  m_instruction_lookup.insert(make_pair(0xBE, Instruction("LDX", 11)));
  m_instruction_lookup.insert(make_pair(0xA0, Instruction("LDY", 26)));
  m_instruction_lookup.insert(make_pair(0xAC, Instruction("LDY", 2)));
  m_instruction_lookup.insert(make_pair(0xA4, Instruction("LDY", 4)));
  m_instruction_lookup.insert(make_pair(0xB4, Instruction("LDY", 8)));
  m_instruction_lookup.insert(make_pair(0xBC, Instruction("LDY", 9)));
  m_instruction_lookup.insert(make_pair(0x4E, Instruction("LSR", 2)));
  m_instruction_lookup.insert(make_pair(0x46, Instruction("LSR", 4)));
  m_instruction_lookup.insert(make_pair(0x4A, Instruction("LSR", 0)));
  m_instruction_lookup.insert(make_pair(0x56, Instruction("LSR", 8)));
  m_instruction_lookup.insert(make_pair(0x5E, Instruction("LSR", 9)));
  m_instruction_lookup.insert(make_pair(0xEA, Instruction("NOP", 0)));
  m_instruction_lookup.insert(make_pair(0x09, Instruction("ORA", 1)));
  m_instruction_lookup.insert(make_pair(0x0D, Instruction("ORA", 2)));
  m_instruction_lookup.insert(make_pair(0x0F, Instruction("ORA", 3)));
  m_instruction_lookup.insert(make_pair(0x05, Instruction("ORA", 4)));
  m_instruction_lookup.insert(make_pair(0x11, Instruction("ORA", 5)));
  m_instruction_lookup.insert(make_pair(0x17, Instruction("ORA", 6)));
  m_instruction_lookup.insert(make_pair(0x01, Instruction("ORA", 7)));
  m_instruction_lookup.insert(make_pair(0x15, Instruction("ORA", 8)));
  m_instruction_lookup.insert(make_pair(0x1D, Instruction("ORA", 9)));
  m_instruction_lookup.insert(make_pair(0x1F, Instruction("ORA", 10)));
  m_instruction_lookup.insert(make_pair(0x19, Instruction("ORA", 11)));
  m_instruction_lookup.insert(make_pair(0x12, Instruction("ORA", 12)));
  m_instruction_lookup.insert(make_pair(0x07, Instruction("ORA", 13)));
  m_instruction_lookup.insert(make_pair(0x03, Instruction("ORA", 14)));
  m_instruction_lookup.insert(make_pair(0x13, Instruction("ORA", 15)));
  m_instruction_lookup.insert(make_pair(0xF4, Instruction("PEA", 18)));
  m_instruction_lookup.insert(make_pair(0xD4, Instruction("PEI", 23)));
  m_instruction_lookup.insert(make_pair(0x62, Instruction("PER", 18)));
  m_instruction_lookup.insert(make_pair(0x48, Instruction("PHA", 0)));
  m_instruction_lookup.insert(make_pair(0x8B, Instruction("PHB", 0)));
  m_instruction_lookup.insert(make_pair(0x0B, Instruction("PHD", 0)));
  m_instruction_lookup.insert(make_pair(0x4B, Instruction("PHK", 0)));
  m_instruction_lookup.insert(make_pair(0x08, Instruction("PHP", 0)));
  m_instruction_lookup.insert(make_pair(0xDA, Instruction("PHX", 0)));
  m_instruction_lookup.insert(make_pair(0x5A, Instruction("PHY", 0)));
  m_instruction_lookup.insert(make_pair(0x68, Instruction("PLA", 0)));
  m_instruction_lookup.insert(make_pair(0xAB, Instruction("PLB", 0)));
  m_instruction_lookup.insert(make_pair(0x2B, Instruction("PLD", 0)));
  m_instruction_lookup.insert(make_pair(0x28, Instruction("PLP", 0)));
  m_instruction_lookup.insert(make_pair(0xFA, Instruction("PLX", 0)));
  m_instruction_lookup.insert(make_pair(0x7A, Instruction("PLY", 0)));
  m_instruction_lookup.insert(make_pair(0xC2, Instruction("REP", 24)));
  m_instruction_lookup.insert(make_pair(0x2E, Instruction("ROL", 1)));
  m_instruction_lookup.insert(make_pair(0x26, Instruction("ROL", 4)));
  m_instruction_lookup.insert(make_pair(0x2A, Instruction("ROL", 0)));
  m_instruction_lookup.insert(make_pair(0x36, Instruction("ROL", 8)));
  m_instruction_lookup.insert(make_pair(0x3E, Instruction("ROL", 9)));
  m_instruction_lookup.insert(make_pair(0x6E, Instruction("ROR", 1)));
  m_instruction_lookup.insert(make_pair(0x66, Instruction("ROR", 4)));
  m_instruction_lookup.insert(make_pair(0x6A, Instruction("ROR", 0)));
  m_instruction_lookup.insert(make_pair(0x76, Instruction("ROR", 8)));
  m_instruction_lookup.insert(make_pair(0x7E, Instruction("ROR", 9)));
  m_instruction_lookup.insert(make_pair(0x40, Instruction("RTI", 0)));
  m_instruction_lookup.insert(make_pair(0x6B, Instruction("RTL", 0)));
  m_instruction_lookup.insert(make_pair(0x60, Instruction("RTS", 0)));
  m_instruction_lookup.insert(make_pair(0xE9, Instruction("SBC", 1)));
  m_instruction_lookup.insert(make_pair(0xED, Instruction("SBC", 2)));
  m_instruction_lookup.insert(make_pair(0xEF, Instruction("SBC", 3)));
  m_instruction_lookup.insert(make_pair(0xE5, Instruction("SBC", 4)));
  m_instruction_lookup.insert(make_pair(0xF1, Instruction("SBC", 5)));
  m_instruction_lookup.insert(make_pair(0xF7, Instruction("SBC", 6)));
  m_instruction_lookup.insert(make_pair(0xE1, Instruction("SBC", 7)));
  m_instruction_lookup.insert(make_pair(0xF5, Instruction("SBC", 8)));
  m_instruction_lookup.insert(make_pair(0xFD, Instruction("SBC", 9)));
  m_instruction_lookup.insert(make_pair(0xFF, Instruction("SBC", 10)));
  m_instruction_lookup.insert(make_pair(0xF9, Instruction("SBC", 11)));
  m_instruction_lookup.insert(make_pair(0xF2, Instruction("SBC", 12)));
  m_instruction_lookup.insert(make_pair(0xE7, Instruction("SBC", 13)));
  m_instruction_lookup.insert(make_pair(0xE3, Instruction("SBC", 14)));
  m_instruction_lookup.insert(make_pair(0xF3, Instruction("SBC", 15)));
  m_instruction_lookup.insert(make_pair(0x38, Instruction("SEC", 0)));
  m_instruction_lookup.insert(make_pair(0xF8, Instruction("SED", 0)));
  m_instruction_lookup.insert(make_pair(0x78, Instruction("SEI", 0)));
  m_instruction_lookup.insert(make_pair(0xE2, Instruction("SEP", 25)));
  m_instruction_lookup.insert(make_pair(0x8D, Instruction("STA", 2)));
  m_instruction_lookup.insert(make_pair(0x8F, Instruction("STA", 3)));
  m_instruction_lookup.insert(make_pair(0x85, Instruction("STA", 4)));
  m_instruction_lookup.insert(make_pair(0x91, Instruction("STA", 5)));
  m_instruction_lookup.insert(make_pair(0x97, Instruction("STA", 6)));
  m_instruction_lookup.insert(make_pair(0x81, Instruction("STA", 7)));
  m_instruction_lookup.insert(make_pair(0x95, Instruction("STA", 8)));
  m_instruction_lookup.insert(make_pair(0x9D, Instruction("STA", 9)));
  m_instruction_lookup.insert(make_pair(0x9F, Instruction("STA", 10)));
  m_instruction_lookup.insert(make_pair(0x99, Instruction("STA", 11)));
  m_instruction_lookup.insert(make_pair(0x92, Instruction("STA", 12)));
  m_instruction_lookup.insert(make_pair(0x87, Instruction("STA", 13)));
  m_instruction_lookup.insert(make_pair(0x83, Instruction("STA", 14)));
  m_instruction_lookup.insert(make_pair(0x93, Instruction("STA", 15)));
  m_instruction_lookup.insert(make_pair(0xDB, Instruction("STP", 0)));
  m_instruction_lookup.insert(make_pair(0x8E, Instruction("STX", 2)));
  m_instruction_lookup.insert(make_pair(0x86, Instruction("STX", 4)));
  m_instruction_lookup.insert(make_pair(0x96, Instruction("STX", 8)));
  m_instruction_lookup.insert(make_pair(0x8C, Instruction("STY", 2)));
  m_instruction_lookup.insert(make_pair(0x84, Instruction("STY", 4)));
  m_instruction_lookup.insert(make_pair(0x94, Instruction("STY", 8)));
  m_instruction_lookup.insert(make_pair(0x9C, Instruction("STZ", 2)));
  m_instruction_lookup.insert(make_pair(0x64, Instruction("STZ", 4)));
  m_instruction_lookup.insert(make_pair(0x74, Instruction("STZ", 8)));
  m_instruction_lookup.insert(make_pair(0x9E, Instruction("STZ", 9)));
  m_instruction_lookup.insert(make_pair(0xAA, Instruction("TAX", 0)));
  m_instruction_lookup.insert(make_pair(0xA8, Instruction("TAY", 0)));
  m_instruction_lookup.insert(make_pair(0x5B, Instruction("TCD", 0)));
  m_instruction_lookup.insert(make_pair(0x1B, Instruction("TCS", 0)));
  m_instruction_lookup.insert(make_pair(0x7B, Instruction("TDC", 0)));
  m_instruction_lookup.insert(make_pair(0x1C, Instruction("TRB", 2)));
  m_instruction_lookup.insert(make_pair(0x14, Instruction("TRB", 4)));
  m_instruction_lookup.insert(make_pair(0x0C, Instruction("TSB", 2)));
  m_instruction_lookup.insert(make_pair(0x04, Instruction("TSB", 4)));
  m_instruction_lookup.insert(make_pair(0x3B, Instruction("TSC", 0)));
  m_instruction_lookup.insert(make_pair(0xBA, Instruction("TSX", 0)));
  m_instruction_lookup.insert(make_pair(0x8A, Instruction("TXA", 0)));
  m_instruction_lookup.insert(make_pair(0x9A, Instruction("TXS", 0)));
  m_instruction_lookup.insert(make_pair(0x9B, Instruction("TXY", 0)));
  m_instruction_lookup.insert(make_pair(0x98, Instruction("TYA", 0)));
  m_instruction_lookup.insert(make_pair(0xBB, Instruction("TYX", 0)));
  m_instruction_lookup.insert(make_pair(0xCB, Instruction("WAI", 0)));
  m_instruction_lookup.insert(make_pair(0xEB, Instruction("XBA", 0)));
  m_instruction_lookup.insert(make_pair(0xFB, Instruction("XCE", 0)));
  m_instruction_lookup.insert(make_pair(0x02, Instruction("COP", 0)));
  m_instruction_lookup.insert(make_pair(0x54, Instruction("MVN", 27)));
  m_instruction_lookup.insert(make_pair(0x44, Instruction("MVP", 27)));
}