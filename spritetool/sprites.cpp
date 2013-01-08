/********************************************************************
 Sprite Tool
********************************************************************/

#include <iostream>
#include <string>
#include <fstream>
#include <cassert>

#include "sprites.h"

using namespace std;

/********************************************************************
  Helpers
********************************************************************/
namespace{
  struct Error{
    Error(const string & s_){s=s_;}
    string s;
  };

  ostream& operator<<(ostream& os, const Location& location)
  {
    os << hex << "PC: 0x" << location.pc_address() << "  (SNES: "
       << location.bank() << ":" << location.snes_address() << ")" ;
    return os;
  }

  Location operator+(const Location& orig, int offset)
  {
    assert(orig.offset_from_bank_start() + offset < BANK_SIZE);
    return Location(orig.bank(), orig.offset_from_bank_start() + offset);    
  }

  //returns the filesize, doesn't preserve the get pointer
  int get_file_size(fstream & fs)
  {
    fs.seekg (0, ios::end);
    return fs.tellg();
  }
  
  char get_hex_digit(int digit)
  {
    static const char * hex_digits = "0123456789ABCDEF";
    assert(digit >= 0 && digit <= 15);
    return hex_digits[digit];
  }
  
  string get_filename(const string& prompt)
  {
    string filename;
    cout << prompt;
    getline(cin, filename);
    //if the user didn't specify a full path, prepend the filename with .\ 
    //this really shouldn't have to be done, but apparently this helped some people
    if (filename.size() <= 1 || !(filename[1]==':' || (filename[0]=='\\' && filename[1]=='\\')))
      filename = ".\\" + filename;
    return filename;
  }
}


/********************************************************************
   Main
 ********************************************************************/

int main(int argc, char** argv)
{
  cout << endl << WELCOME_MESSAGE << endl << endl;

  try{
    fstream rom_file;
    do {
      rom_file.clear();
      string rom_filename;       
      if (argc == 3){
	argc--;
	rom_filename = string(argv[1]);
      }
      else
	rom_filename = get_filename("enter rom filename: ");
      rom_file.open(rom_filename.c_str(), ios::in | ios::out | ios::binary);
      if (!rom_file){
	cout << "Error: couldn't open ROM " << rom_filename << endl;
	continue;
      }
    } while(!rom_file);

    ifstream sprite_file;
    do{
      sprite_file.clear();
      string sprite_list_filename;
      if (argc == 2){
	argc--;
	sprite_list_filename = string(argv[2]);
      }
      else
	sprite_list_filename = get_filename("enter sprite list filename: ");
      sprite_file.open(sprite_list_filename.c_str());
      if (!sprite_file){
	cout << "Error: couldn't open sprite list " << sprite_list_filename << endl;
	continue;
      }
    } while(!sprite_file);

    SpriteTool st(rom_file, sprite_file);
    //get rid of anything sprite tool may have inserted in the past
    st.clean_rom();
    //insert and hook up the sprite execution code
    st.insert_main_routine();
    //now we can go through in all the sprites listed in sprites.txt
    st.insert_sprites();    

    cout << endl
	 << "Sprites inserted successfully" << endl
	 << endl;
  }
  catch (Error & err){
    cout << endl
	 << "************ERROR************" << endl
	 << err.s << endl
	 << "*****************************" << endl
	 << endl;
  }
  system("pause");
  return 0;
}


/********************************************************************
   SpriteTool
 ********************************************************************/

//remove everything from a previous run of sprite tool
void SpriteTool::clean_rom()
{
  cout << "cleaning up data from previous runs:" << endl;
  int rom_size = get_file_size(m_rom_file);
  int number_of_banks = (rom_size - HEADER_SIZE)/BANK_SIZE;
  if (number_of_banks <= 0x10)
    throw Error("Your ROM must be expanded");

  //revert poison mushroom changes back to the original rom's values
  //TODO: i probably should do some sort of check first.  if someone has manually
  // modified the portion of the powerup routine i'm reverting, it could cause 
  // corruption.
  char mush[4] = {0x0C9, 0x021, 0x0D0, 0x069};
  write_to_rom(0x0C6CB, mush, 4);
  char mush_gfx[4] = {0x0AA, 0x0BD, 0x009, 0x0C6};
  write_to_rom(0x0C8D6, mush_gfx, 4);

  char empty_buffer[BANK_SIZE];
  memset(empty_buffer, 0, BANK_SIZE);
  char bank_buffer[BANK_SIZE];
  
  //removes all STAR####MDK tags
  for (int i = 0x10; i < number_of_banks; ++i){ 
    //get whole bank into a string
    m_rom_file.seekg(i*BANK_SIZE + HEADER_SIZE, ios::beg);
    m_rom_file.read(bank_buffer, BANK_SIZE);
    string current_bank_contents(bank_buffer, BANK_SIZE);

    //look for data inserted on previous uses
    size_t offset = current_bank_contents.find(SPRITE_TOOL_LABEL, 0);
    if( offset == string::npos || offset < 8)
      continue;
    if (current_bank_contents.substr(offset-8, 4) != RATS_TAG_LABEL)
      continue;
		
    //delete the amount that the RATS tag is protecting
    int size = (int(unsigned char(current_bank_contents[offset-3])) << 8)
      + int(unsigned char(current_bank_contents[offset-4])) + 8;
    int pc_address = HEADER_SIZE + (i * BANK_SIZE) + offset - 8;
    write_to_rom(pc_address, empty_buffer, size);
    cout << hex << "deleted " << size << " bytes from PC 0x" << pc_address << endl;

    //try this bank again
    --i;		
  }
}


void SpriteTool::insert_main_routine()
{
  //we will eventually be inserting main.bin and the sprite table
  // into the rom.  the first thing we need to figure out is where
  // in the rom it will go.  everything else relies on this location
  cout << "\ninserting main code and table:\n";
  fstream main_code(".\\main.bin", ios::in | ios::binary);
  if (!main_code) throw Error("couldn't open .\\main.bin");
  //figure out how much space is needed
  int main_code_size = get_file_size(main_code);
  int total_size = main_code_size + SPRITE_TABLE_SIZE;
  //find a free spot in the rom
  m_main_location = find_free_space(total_size);
  cout << m_main_location << endl;
  m_table_start = m_main_location.pc_address() + main_code_size + TAG_SIZE;
  cout << "sprite table start PC 0x" << hex << m_table_start << endl;

  
  //main.off is a file that contains two groups (lines) of offsets.
  // 1) the first group of offsets tell where different subroutines start in main.bin.
  // they are use in calls to "setup_call_to_asm" to get smw code to call my code
  //
  // 2) the second group of offsets are very similar to reloc offsets in blocktool.
  // they make sure calls within my code are linked up properly
  //
  //NOTE: everytime you re-assemble main.asm, remember to update this file if
  // any offsets have changed!!
  ifstream main_cfg(".\\main.off");
  if (!main_cfg) throw Error("couldn't open .\\main.off");

  //patch locations that call sprite tool code
  // patch 1 - level loading
  setup_call_to_asm(main_cfg, 0x12B63);
  // patch 2 - init routine
  setup_call_to_asm(main_cfg, 0x08372);
  // patch 3 - code routine
  setup_call_to_asm(main_cfg, 0x087C3);
  // patch 4 - bit reset routine
  setup_call_to_asm(main_cfg, 0x3F985);
  // patch 5 - bit reset routine 2
  setup_call_to_asm(main_cfg, 0x08351);
  // patch 6 - verical level loading
  setup_call_to_asm(main_cfg, 0x12B4B);
  // patch 7 - root of sprite loader
  setup_call_to_asm(main_cfg, 0x12A66, 4, true);
  // patch 8 - shooter loader
  setup_call_to_asm(main_cfg, 0x12DA0);
  // patch 9 - generator handler
  setup_call_to_asm(main_cfg, 0x13595, 5, true);
  // patch 10 - shooter handler
  setup_call_to_asm(main_cfg, 0x131FE);
  // patch 11 - table filler
  setup_call_to_asm(main_cfg, 0x089A7, 4, true);

  // 
  char hammer_patch[2] = {0x0C2, 0x085};
  write_to_rom(0x084B3, hammer_patch, 2);

  // patch goal tape init to get extra bits in $187B
  char goal_patch[11] = {0x0BF, 0x010, 0x0AB, 0x07F, 0x0EA, 0x0EA,
			 0x0EA, 0x0EA, 0x09D, 0x07B, 0x018};
  write_to_rom(0x0C289, goal_patch, 11);


  //create a buffer containing my custom code and the sprite table.  we will write
  // this directly to the rom
  char * main_buffer = new char[total_size];
  memset(main_buffer, 0xFF, total_size);
  //load in the code from main.bin
  main_code.seekg(0, ios::beg);
  main_code.read(main_buffer, main_code_size);
  //construct a default sprite table
  for(int i = main_code_size; i < total_size; i += 0x10){
    main_buffer[i+0] = 0;
    main_buffer[i+1] = 0;
    //make the asm pointers default to an RTL
    main_buffer[i+8] = 0x21;
    main_buffer[i+9] = 0x080;
    main_buffer[i+10] = 0x01;
    main_buffer[i+11] = 0x21;
    main_buffer[i+12] = 0x080;
    main_buffer[i+13] = 0x01;
  }

  //we are done patching, so the rest of the offsets in the file must be reloc
  // offsets.  we go ahead and apply those.
  //TODO: i could use TRASM and eliminate the need to do this, but then again 
  // nobody else has to deal with this file, and it's not too hard to maintain.
  int current_reloc;
  cout << "reloc offsets:";
  while (main_cfg >> hex >> current_reloc){
    cout << " " << current_reloc;
    relocate(main_buffer, current_reloc, m_main_location);
  }
  cout << endl;

  //write the main code and empty sprite table to rom
  write_to_rom_with_tags(m_main_location.pc_address(), main_buffer, total_size);
  delete [] main_buffer;
}


void SpriteTool::insert_sprites(){
  int sprite_number;
  while (m_sprite_list >> hex >> sprite_number){

    string PATH;
    if (sprite_number >= 0x0E0)
      throw Error(BAD_NUM);
    else if (sprite_number >= 0x0D0)
      PATH = GENERATOR_PATH;
    else if (sprite_number >= 0x0C0)
      PATH = SHOOTER_PATH;
    else
      PATH = SPRITE_PATH;

    cout << "\ninserting sprite: " << sprite_number << endl;

    //open the .cfg file for the sprite
    string sprite_cfg_filename;
    m_sprite_list >> sprite_cfg_filename;
    if (!m_sprite_list) throw Error("sprite list contains invalid data");
    sprite_cfg_filename = PATH + sprite_cfg_filename;
    ifstream sprite_cfg(sprite_cfg_filename.c_str());
    if (!sprite_cfg) throw Error("couldn't open cfg file " + sprite_cfg_filename);
    cout << sprite_cfg_filename << endl;

    //based on the sprite number, we can get the location of the current sprite's 
    // table entry
    int table_row_start = m_table_start + (0x10 * sprite_number);

    //table layout
    // 00: type {0=tweak,1=custom,3=generator/shooter}
    // 01: "acts like"
    // 02-07: tweaker bytes
    // 08-10: init pointer
    // 11-13: main pointer
    // 14: extra property byte 1
    // 15: extra property byte 2
    char table_row[0x10];
    memset(table_row, 0, 0x10);

    //get type, "acts like", and tweaker values
    int value;
    for (int i=0; i<8; ++i){
      sprite_cfg >> hex >> value;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      table_row[i] = char(value);            
    }

    int type = int(unsigned char(table_row[0]));
    //if it's just a tweaked sprite, we just write the table entry to the rom
    if (type == 0) {
      write_to_rom(table_row_start, table_row, 8);
    }
    //real custom sprites are going to be more work
    else if (type == 1 || type == 3){
      //get the extra property bytes
      for (int i=14; i<16; ++i){
	sprite_cfg >> hex >> value;
	if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
	table_row[i] = char(value);
      }

      //get the path to the source file from the cfg file
      string sprite_asm_filename;
      sprite_cfg >> sprite_asm_filename;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      sprite_asm_filename = PATH + sprite_asm_filename;

      //hmmm... we have a problem.  when it's time to assemble the source file, we need
      // to know where the resulting binary file will be inserted.  but we CAN'T know 
      // where the binary will be inserted, because we don't know the filesize of the sucker
      // until after it is assembled.  call up yossarian, it's a classic catch-22!
            
      //as a workaround we can make two passes.  during the first pass we assemble the 
      // source and get the size of the binary.  we can now find a place in the rom to insert
      // it.  we can't *actually* insert it, because all the subroutine addresses are 
      // incorrect.  we must make a second pass.  knowing where the code will go, we
      // re-assemble the source with this information.
            
      //The down side of doing this is that it is slooooooow.  The calls to TRASM are the
      // most expensive part of the program, and we're doing it times 2.


      //On the first pass we'll arbitrarily use $008000 as the starting address
      //We do this by injecting the line "org $008000" into the source file before we assemble
      char org_line[13] = {'o','r','g',' ','$','0','0','8','0','0','0', 0x0D, 0x0A};
			
      //load the entire source file into a buffer
      fstream sprite_asm_file(sprite_asm_filename.c_str(), ios::in | ios::binary);
      if (!sprite_asm_file) throw Error("couldn't open asm file " + sprite_asm_filename);
      int sprite_asm_size = get_file_size(sprite_asm_file);
      char * asm_file_contents = new char[sprite_asm_size];
      sprite_asm_file.seekg(0, ios::beg);
      sprite_asm_file.read(asm_file_contents, sprite_asm_size);
      sprite_asm_file.close();
			
      //create tmpasm.asm which is just the original source file with the org line prepended to it
      fstream sprite_asm_tmp(".\\tmpasm.asm", ios::out | ios::binary);
      if (!sprite_asm_tmp) throw Error("couldn't create .\\tmpasm.asm");
      sprite_asm_tmp.write(org_line, 13);
      sprite_asm_tmp.write(asm_file_contents, sprite_asm_size);
      sprite_asm_tmp.close();

      //run TRASM.  redirect the output, so it doesn't clutter my own output
      cout << "running TRASM.EXE" << endl;
      system("trasm.exe tmpasm.asm -f > temp.log");

      //get the size of the binary file
      fstream sprite_bin(".\\tmpasm.bin", ios::in | ios::binary);
      if (!sprite_bin) throw Error(NO_BIN_FILE);
      int sprite_bin_size = get_file_size(sprite_bin);
      sprite_bin.close();
      //find a location in the rom for the binary file
      Location sprite_location = find_free_space(sprite_bin_size);
      cout << sprite_location << endl;

      //change the org line to contain the address of where this code is actually going to go
      Location code_start = sprite_location + TAG_SIZE;
      org_line[10] = get_hex_digit(code_start.snes_address() % 16);
      org_line[9] = get_hex_digit((code_start.snes_address() >> 4) % 16);
      org_line[8] = get_hex_digit((code_start.snes_address() >> 8) % 16);
      org_line[7] = get_hex_digit((code_start.snes_address() >> 12) % 16);
      org_line[6] = get_hex_digit(code_start.bank() % 16);
      org_line[5] = get_hex_digit((code_start.bank() >> 4) % 16);

      //create tmpasm.asm as before
      sprite_asm_tmp.open(".\\tmpasm.asm", ios::out | ios::binary);
      if (!sprite_asm_tmp) throw Error("couldn't create .\\tmpasm.asm on second pass");
      sprite_asm_tmp.write(org_line, 13);
      sprite_asm_tmp.write(asm_file_contents, sprite_asm_size);
      sprite_asm_tmp.close();

      cout << "running TRASM.EXE" << endl;
      system("trasm.exe tmpasm.asm -f > temp.log");

      //make sure the binaries from the two passes had equal size ...that was our assumption, 
      // and it'd better be true.
      sprite_bin.open(".\\tmpasm.bin", ios::in | ios::binary);
      if (!sprite_bin) throw Error("couldn't open .\\tmpasm.bin on second pass");
      int sprite_bin_size2 = get_file_size(sprite_bin);            
      if (sprite_bin_size2 != sprite_bin_size)
	throw Error("second pass yielded a different file size.  wtf, mate??");

      //HACK ALERT!!  In 3... 2... 1...
      //if there was a problem in TRASM we don't want to try to insert anything into the rom.
      // Since we can really communicate with TRASM, we have to look at the log file it 
      // generates.  we bail if it contains the word "although"... again, huge hack.
      ifstream error_file(".\\TMPASM.ERR");
      string word;
      while (error_file>>word){
	if (word == "Although"){
	  //MiOr was doing some pretty complicated stuff with asm.  So much that TRASM
	  // was reporting an error when there really wasn't.  I added the option to
	  // ignore this warning solely for him.
	  //TODO: I should make this a command line flag
	  cout << "\n*****************************" << endl
	       << "Error detected in assembling " << sprite_asm_filename << endl
	       << ABORT_MESSAGE << endl;
	  string should_i_abort;
	  cin >> should_i_abort;
	  if (should_i_abort != "no" && should_i_abort != "NO" &&
	      should_i_abort != "No" && should_i_abort != "nO")
	    throw Error(sprite_asm_filename + " didn't assemble correctly.");
	}
      }
            
      //it's peanut butter jelly time! we have the binary code to insert and no messy offsets
      // to deal with.  all that's left to do is set up the asm pointers in the table.
            
      //open binary file into buffer
      char * bin_buffer = new char[sprite_bin_size];
      sprite_bin.seekg(0, ios::beg);
      sprite_bin.read(bin_buffer, sprite_bin_size);

      //determine where the INIT routine and the MAIN routine actually start
      string bin_contents(bin_buffer, sprite_bin_size);
      int init_offset, code_offset;			
      init_offset = bin_contents.find(INIT_LABEL, 0);
      code_offset = bin_contents.find(MAIN_LABEL, 0);
			
      if (init_offset == string::npos)
	throw Error("dcb \"INIT\" not found in " + sprite_asm_filename);
      if (code_offset == string::npos)
	throw Error("dcb \"MAIN\" not found in " + sprite_asm_filename);

      //compensate for the INIT and MAIN tags... the actual code starts 4 bytes later
      init_offset += 4;
      code_offset += 4;

      cout << "init offset: " << init_offset << endl;
      cout << "main offset: " << code_offset << endl;

      //calculate the asm pointers
      table_row[10] = sprite_location.bank();
      table_row[9] = 0x080;
      relocate(table_row, 8, sprite_location, init_offset);

      table_row[13] = sprite_location.bank();
      table_row[12] = 0x080;
      relocate(table_row, 11, sprite_location, code_offset);
			
      //write the current sprite's table entry to the rom
      write_to_rom(table_row_start, table_row, 16);
			
      //write the sprite's binary code to the rom
      write_to_rom_with_tags(sprite_location.pc_address(), bin_buffer, sprite_bin_size);

      delete [] bin_buffer;
      delete [] asm_file_contents;
      sprite_bin.close();
    }

    //and now for the biggest hack...
    //wow, all this crap just for the poison mushroom?  I should have just made
    // it a custom sprite... apparently this was easier.
    else if (type == 255){
      int poison_num = int(unsigned char(table_row[1]));
      cout << "poison mushroom to replace sprite " << poison_num << endl;
			
      //set the tweaker bytes
      write_to_rom(START_1656_TABLE + poison_num, &table_row[2], 1);
      write_to_rom(START_1662_TABLE + poison_num, &table_row[3], 1);
      write_to_rom(START_166E_TABLE + poison_num, &table_row[4], 1);
      write_to_rom(START_167A_TABLE + poison_num, &table_row[5], 1);
      write_to_rom(START_1686_TABLE + poison_num, &table_row[6], 1);
      write_to_rom(START_190F_TABLE + poison_num, &table_row[7], 1);

      //change the asm pointers
      for (int i=8; i<12; ++i){
	sprite_cfg >> hex >> value;
	if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
	table_row[i] = char(value);
      }
      write_to_rom(START_ASM_TABLE + 2*poison_num, &table_row[8], 2);
      write_to_rom(START_INIT_TABLE + 2*poison_num, &table_row[10], 2);

      // now deal with the .bin file
      string mush_bin_file;
      sprite_cfg >> mush_bin_file;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      mush_bin_file = PATH + mush_bin_file;

      fstream mush_code(mush_bin_file.c_str(), ios::in | ios::binary);
      if (!mush_code) throw Error("couldn't open " + mush_bin_file);
      int code_size = get_file_size(mush_code);
      Location mush_location = find_free_space(code_size);
      cout << mush_location << endl;
      int code_start = mush_location.pc_address() + TAG_SIZE;
		
      //put the mushroom code in memory
      char * mush_buffer = new char[code_size];
      mush_code.seekg(0, ios::beg);
      mush_code.read(mush_buffer, code_size);

      //change bytes the are sprite number checks
      int num_sprite_refs;
      sprite_cfg >> hex >> num_sprite_refs;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      for (int i=0; i<num_sprite_refs; ++i){
	int sprite_ref_location;
	sprite_cfg >> hex >> sprite_ref_location;
	if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
	mush_buffer[sprite_ref_location] = char(poison_num);
      }

      //write the bin file to the rom
      write_to_rom_with_tags(mush_location.pc_address(), mush_buffer, code_size);
      delete [] mush_buffer;

      //patch original code
      char mush[4];

      int location, jump_type;
      sprite_cfg >> jump_type >> location;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      location += (mush_location.snes_address() + TAG_SIZE);

      mush[0] = char(jump_type);
      mush[1] = location & 0x0FF;
      mush[2] = (location >> 8) & 0x0FF;
      mush[3] = mush_location.bank();	
      write_to_rom(0x0C6CB, mush, 4);

      sprite_cfg >> jump_type >> location;
      if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
      location += (mush_location.snes_address() + TAG_SIZE);

      mush[0] = char(jump_type);
      mush[1] = location & 0x0FF;
      mush[2] = (location >> 8) & 0x0FF;
      mush[3] = mush_location.bank();	
      write_to_rom(0x0C8D6, mush, 4);

    }
    else{
      throw Error("Invalid type number in " + sprite_cfg_filename);
    }			
		
    sprite_cfg.close();
  }

  if (!m_sprite_list.eof()) throw Error("sprite list contains invalid data");
}


Location SpriteTool::find_free_space(int space_needed)
{
  space_needed += TAG_SIZE;

  if (space_needed > 0x8000)
    throw Error(TOO_LARGE);
  int rom_size = get_file_size(m_rom_file);
  int number_of_banks = (rom_size - HEADER_SIZE)/BANK_SIZE;
  if (number_of_banks <= 0x10)
    throw Error("Your ROM must be expanded");

  char bank_buffer[BANK_SIZE];

  for (int i = 0x10; i < number_of_banks; ++i){

    //get whole bank into a string
    m_rom_file.seekg(i*BANK_SIZE + HEADER_SIZE, ios::beg);
    m_rom_file.read(bank_buffer, BANK_SIZE);
    string current_bank_contents(bank_buffer, BANK_SIZE);

    //look for free space
    string free_space(space_needed,'\0');
    size_t loc = current_bank_contents.find(free_space, 0);
    if( loc != string::npos )
      return Location(i,loc);
		
  }

  throw Error("Unable to find free space in yout ROM");
}


// Main.bin contains all the routines to handle custom sprites.  It has
// already been inserted into the rom, but it is not linked up with the SMW
// code at this point.  The purpose of this function is to insert an
// instruction that will get a particular sprite tool asm routine called.
//
// We determine where the routine is in the rom, we go to the supplied PC
// address, and overwrite the the supplied number of bytes with a call
// into the routine.
void SpriteTool::setup_call_to_asm(ifstream & main_cfg, int pc_address,
				    int num_bytes /*= 5*/, bool is_jump /*= false*/)
{
  //By default the call is a JSL, but it can be specified to be a JMP
  char instruction[5] = {0x022, 0x0EA, 0x0EA, 0x0EA, 0x0EA};
  if (is_jump) instruction[0] = 0x05C;

  //We read in the next offset from main.off.  This tells us where the next
  // routine starts in main.bin.  
  int offset;
  main_cfg >> hex >> offset;

  //Since we've kept track of where main.bin was inserted into the rom, we can
  // figure out the SNES address of the routine we want to call.  We put this
  // address into the JSL/JMP instruction.
  int routine_location = (m_main_location.snes_address() + TAG_SIZE) + offset;
  instruction[1] = routine_location & 0x0FF;
  instruction[2] = (routine_location >> 8) & 0x0FF;
  instruction[3] = m_main_location.bank();

  //Lastly, we put the instruction into the rom.  We are now linked up.
  write_to_rom(pc_address, instruction, num_bytes);
}


//applies reloc offsets
void SpriteTool::relocate(char* code_buffer, int reloc_offset,
			  Location inserted_location, int code_offset)
{
  int new_value = (unsigned char(code_buffer[reloc_offset+1]) << 8)
    + unsigned char(code_buffer[reloc_offset]);
  new_value += (inserted_location.offset_from_bank_start() + TAG_SIZE + code_offset);
  code_buffer[reloc_offset] = new_value & 0x0FF;
  code_buffer[reloc_offset+1] = (new_value >> 8) & 0x0FF;
}


void SpriteTool::write_to_rom(int pc_address, char* buffer, int size)
{
  m_rom_file.seekp(pc_address, ios::beg);
  m_rom_file.write(buffer, size);
}


//write some data to the rom with the STAR###MDK tag
void SpriteTool::write_to_rom_with_tags(int pc_address, char* buffer, int size)
{
  m_rom_file.seekp(pc_address, ios::beg);

  //write RATS tag
  char current_byte[1];
  m_rom_file.write(RATS_TAG_LABEL, 4);
  
  //calculate and write size/inverse size
  int full_size = size + 3;
  current_byte[0] = char(full_size & 0x0FF);
  m_rom_file.write(current_byte, 1);
  current_byte[0] = char((full_size>>8) & 0x0FF);
  m_rom_file.write(current_byte, 1);
  full_size = (full_size ^ 0x0FFFF) + 1;
  current_byte[0] = char(full_size & 0x0FF);
  m_rom_file.write(current_byte, 1);
  current_byte[0] = char((full_size>>8) & 0x0FF);
  m_rom_file.write(current_byte, 1);
  
  //add sprite tool label, so it can be easily identified for clean up
  m_rom_file.write(SPRITE_TOOL_LABEL, 3);
	
  //write data
  m_rom_file.write(buffer, size);
  cout << "wrote " << size + TAG_SIZE << " bytes" << endl;
}

//-mikeyk
