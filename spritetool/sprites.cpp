#include <iostream>
#include <string>
#include <fstream>
#include <cassert>

using namespace std;

const int START_ASM_TABLE = 0x87CC;
const int START_INIT_TABLE = 0x837D;
const int START_1656_TABLE = 0x3F46C;
const int START_1662_TABLE = 0x3F535;
const int START_166E_TABLE = 0x3F5FE;
const int START_167A_TABLE = 0x3F6C7;
const int START_1686_TABLE = 0x3F790;
const int START_190F_TABLE = 0x3F859;


const int BANK_SIZE = 0x8000;
const int HEADER_SIZE = 0x200;
const int TAG_SIZE = 0xB;		//S T A R X X X X M D K
const int SPRITE_TABLE_SIZE = 0x1000;

const string LOCAL = ".\\";

const char * BAD_NUM = "Custom sprite numbers E0-FF are undefined.  Please check your sprite list.  See the readme for more information";

/********************************************************************
 declarations
********************************************************************/

struct Error{
	Error(const string & s_){s=s_;}
	string s;
};

struct Location{
	/*Location(int pc, int off, int bank, int snes)
		: full_PC_addr(pc), offset_from_bank_start(off), bank_number(bank),
		bank_SNES_addr(snes) {}*/
	Location(int bank, int off) : bank_number(bank), offset_from_bank_start(off)
	{
		bank_SNES_addr = offset_from_bank_start + 0x8000;
		full_PC_addr = BANK_SIZE*bank_number + HEADER_SIZE + offset_from_bank_start;
	}

	void print()
	{
		cout << hex << "PC: 0x" << full_PC_addr;
		cout << "  (SNES: " << bank_number << ":" << bank_SNES_addr << ")" << endl;
	}

	int full_PC_addr;
	int offset_from_bank_start;
	int bank_number;
	int bank_SNES_addr;
};

void main_function(fstream & rom_file, ifstream & sprites_in);
int get_file_size(fstream & fs);
Location find_free_space(fstream & rom_file, int space_needed);
void relocate(char* code_buffer, int reloc_offset, Location inserted_location, int code_offset=0);
void write_to_rom(fstream & rom_file, Location location, char* buffer, int size);
void clean_rom(fstream & rom_file);
char get_hex_digit(int digit);

string get_filename(const string& prompt)
{
    string filename;
    cout << prompt;
    getline(cin, filename);
    //if the user didn't specify a full path, prepend the filename with .\ 
    //this really shouldn't have to be done, but apparently this helped some people
    if (filename.size() <= 1 || !(filename[1]==':' || (filename[0]=='\\' && filename[1]=='\\')))
        filename = LOCAL + filename;
    return filename;
}

/********************************************************************
 program
********************************************************************/

int main(int argc, char** argv)
{
	cout << "\nSprite Tool public test v1.22, by mikeyk" << endl;
	cout << "\nATTENTION: If you don't know what to do at this screen, read the readme.\n";
	cout << "If you get an error when running the program, read the readme for tips.\n";
	cout << "Keep in mind that sprites will not appear correctly in Lunar Magic.\n\n";
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

        ifstream sprites_in;
        do{
            sprites_in.clear();
            string sprite_list_filename;
            if (argc == 2){
                argc--;
                sprite_list_filename = string(argv[2]);
            }
            else
                sprite_list_filename = get_filename("enter sprite list filename: ");
            sprites_in.open(sprite_list_filename.c_str());
            if (!sprites_in){
                cout << "Error: couldn't open sprite list " << sprite_list_filename << endl;
                continue;
            }
        } while(!sprites_in);

		main_function(rom_file, sprites_in);

		cout<<"\nSprites inserted successfully\n\n";
	}
	catch (Error & err){
		cout << "\n************ERROR************\n" << err.s << "\n*****************************\n\n";
	}
	system("pause");
	return 0;
}

void patch_location(fstream & rom_file,
                    ifstream & main_cfg,
                    const Location & main_location,
                    int write_location,
                    int num_bytes = 5,
                    bool is_jump = false)
{
   	int location;
	char patch[5] = {0x022, 0x0, 0x0, 0x0, 0x0EA};

    if (is_jump)
        patch[0] = 0x05C;
           
    main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(write_location);
	rom_file.write(patch, num_bytes);
}

//gotta love this design... one long function :)  maybe if i had just
//made a simple class 
void main_function(fstream & rom_file, ifstream & sprites_in)
{	
    //get rid of anything sprite tool may have inserted in the past
	clean_rom(rom_file);
	
    //we will eventually be inserting main.bin and the sprite table
    // into the rom.  the first thing we need to figure out is where
    // in the rom it will go.  everything else relies on this location
    cout << "\nmain code and table:\n";
	fstream main_code(".\\main.bin", ios::in | ios::binary);
	if (!main_code) throw Error("couldn't open .\\main.bin");
    //figure out how much space is needed
    int main_code_size = get_file_size(main_code);
	int total_size = main_code_size + SPRITE_TABLE_SIZE;
	//find a free spot in the rom
    Location main_location = find_free_space(rom_file, total_size);
	main_location.print();
	int table_start = main_location.full_PC_addr + main_code_size + TAG_SIZE;
	cout << "sprite table start " << table_start << endl;

    //main.off is a file that contains two groups of offsets.
    // the first group of offsets tells where the 


    //everytime you re-assemble main.asm into main.bin, you must remember to update this file if any offsets have changed!!


    //TODO: i could use TRASM and eliminate the need for the file completely. 
    // but then again, nobody else has to deal with this file, and it's not too
    // hard to maintain
	ifstream main_cfg(".\\main.off");
	if (!main_cfg) throw Error("couldn't open .\\main.off");



	//patch locations that call sprite tool code
	
	// 1 - patch level loading
    patch_location(rom_file, main_cfg, main_location, 0x12B63);
	// 2 - patch init routine
	patch_location(rom_file, main_cfg, main_location, 0x08372);
	// 3 - patch code routine
	patch_location(rom_file, main_cfg, main_location, 0x087C3);
	// 4 - patch eraser routine
	patch_location(rom_file, main_cfg, main_location, 0x3F985);
	// 5 - patch eraser routine 2
	patch_location(rom_file, main_cfg, main_location, 0x08351);
	// 6 - patch verical level loading
    patch_location(rom_file, main_cfg, main_location, 0x12B4B);
    // 7 - patch root of sprite loader
    patch_location(rom_file, main_cfg, main_location, 0x12A66, 4, true);
    // 8 - patch shooter loader
    patch_location(rom_file, main_cfg, main_location, 0x12DA0);
    // 9 - patch generator handler
    patch_location(rom_file, main_cfg, main_location, 0x13595, 5, true);
    // 10 - patch shooter handler
    patch_location(rom_file, main_cfg, main_location, 0x131FE);
    // 11 - patch table filler
    patch_location(rom_file, main_cfg, main_location, 0x089A7, 4, true);

    char hammer_patch[2] = {0x0C2, 0x085};
    rom_file.seekp(0x084B3);
	rom_file.write(hammer_patch, 2);

	//patch goal tape init to get extra bits in $187B
	char goal_patch[11] = {0x0BF, 0x010, 0x0AB, 0x07F, 0x0EA, 0x0EA, 0x0EA, 0x0EA, 0x09D, 0x07B, 0x018};
	rom_file.seekp(0x0C289);
	rom_file.write(goal_patch, 11);

	//Now that we know where we can insert this buffer that will hold exactly what 
	char * main_buffer = new char[total_size];
	memset(main_buffer, 0xFF, total_size);

    //load in the code from main.bin
	main_code.seekg(0, ios::beg);
	main_code.read(main_buffer, main_code_size);
    //construct a default sprite table
    for(int i = main_code_size; i < total_size; i += 0x10){
		main_buffer[i+0] = 0;
		main_buffer[i+1] = 0;
        main_buffer[i+8] = 0x21;
        main_buffer[i+9] = 0x080;
        main_buffer[i+10] = 0x01;
        main_buffer[i+11] = 0x21;
        main_buffer[i+12] = 0x080;
        main_buffer[i+13] = 0x01;
	}

	//change the bytes that need relocating
	int current_reloc;
	cout << "reloc offsets:";
	while (main_cfg >> hex >> current_reloc){
		cout << " " << current_reloc;
		relocate(main_buffer, current_reloc, main_location);
	}
	cout << endl;

	//write the main code and sprite table to rom
	write_to_rom(rom_file, main_location, main_buffer, total_size);
	delete [] main_buffer;
    
	int sprite_number;
	while (sprites_in >> hex >> sprite_number){

        string PATH;
		//if (sprite_number > 0x0C8)
		//	throw Error("Valid sprite numbers are 00 through C8.  Please check your sprite list");
        if (sprite_number >= 0x0E0)
            throw Error(BAD_NUM);
        else if (sprite_number >= 0x0D0)
            PATH = ".\\generators\\";
        else if (sprite_number >= 0x0C0)
            PATH = ".\\shooters\\";
        else
            PATH = ".\\sprites\\";
        

        cout << "\nsprite: " << sprite_number << endl;

		string sprite_cfg_filename;
		sprites_in >> sprite_cfg_filename;
        if (!sprites_in) throw Error("sprite list contains invalid data");
		sprite_cfg_filename = PATH + sprite_cfg_filename;
		ifstream sprite_cfg(sprite_cfg_filename.c_str());
		if (!sprite_cfg) throw Error("couldn't open cfg file " + sprite_cfg_filename);
		cout << sprite_cfg_filename << endl;

		//write type, acts like, and tweaker values
		int table_row_start = table_start + (0x10 * sprite_number);
		char table_row[0x10];
		memset(table_row, 0, 0x10);
		int value;
		for (int i=0; i<8; ++i){
			sprite_cfg >> hex >> value;
            if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
			table_row[i] = char(value);            
		}
		
		int type = int(unsigned char(table_row[0]));
		if (type == 1 || type == 3){
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
            // until after it is assembled.  call up yossarian, sprite tool is finished!
            
            //as a workaround we can make two passes.  during the first pass we assemble the 
            // source and get the size of the binary.  we can now find a place in the rom to insert
            // it.  we can't *actually* insert it, because all the subroutine addresses are 
            // incorrect.  What we can do is make a second pass.  we now know where the code will
            // be inserted, so we can go back and re-assemble the source with this information.
            
            //The down side of doing this is that it is slooooooow.  The calls to TRASM are the
            // most expensive part, and we're doing it twice.


            //We're going to inject the line "org $008000" into the source file before we assemble
            //On the first pass we'll assemble with $008000 as our starting address
			char asm_addr_line[13] = {'o','r','g',' ','$','0','0','8','0','0','0', 0x0D, 0x0A};
			
            //load the entire source file into a buffer
            fstream sprite_asm_file(sprite_asm_filename.c_str(), ios::in | ios::binary);
			if (!sprite_asm_file) throw Error("couldn't open asm file " + sprite_asm_filename);
			int sprite_asm_size = get_file_size(sprite_asm_file);
            char * asm_file_contents = new char[sprite_asm_size];
			sprite_asm_file.seekp(0, ios::beg);
			sprite_asm_file.read(asm_file_contents, sprite_asm_size);
			sprite_asm_file.close();
			
            //
			fstream sprite_asm_tmp(".\\tmpasm.asm", ios::out | ios::binary);
			if (!sprite_asm_tmp) throw Error("couldn't create .\\tmpasm.asm");
			sprite_asm_tmp.write(asm_addr_line, 13);
            sprite_asm_tmp.write(asm_file_contents, sprite_asm_size);
			sprite_asm_tmp.close();

            cout << "running TRASM.EXE" << endl;
			system("trasm.exe tmpasm.asm -f > temp.log");
			//system("trasm.exe tmpasm.asm -f");

            //get the size of the binary file
			fstream sprite_bin(".\\tmpasm.bin", ios::in | ios::binary);
			if (!sprite_bin) throw Error("couldn't open .\\tmpasm.bin.  Make sure TRASM.EXE is in the same directory and that it can run on your system.");
			int sprite_bin_size = get_file_size(sprite_bin);
            //find a location in the rom for the binary file
			Location sprite_location = find_free_space(rom_file, sprite_bin_size);
			sprite_bin.close();
			sprite_location.print();

            // change the org line 
			asm_addr_line[10] = get_hex_digit((TAG_SIZE + sprite_location.bank_SNES_addr) % 16);
			asm_addr_line[9] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 4) % 16);
			asm_addr_line[8] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 8) % 16);
			asm_addr_line[7] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 12) % 16);
			asm_addr_line[6] = get_hex_digit((TAG_SIZE + sprite_location.bank_number) % 16);
			asm_addr_line[5] = get_hex_digit(((TAG_SIZE + sprite_location.bank_number) >> 4) % 16);

			sprite_asm_tmp.open(".\\tmpasm.asm", ios::out | ios::binary);
			if (!sprite_asm_tmp) throw Error("couldn't create .\\tmpasm.asm on second pass");
			sprite_asm_tmp.write(asm_addr_line, 13);
            sprite_asm_tmp.write(asm_file_contents, sprite_asm_size);
			sprite_asm_tmp.close();

            cout << "running TRASM.EXE" << endl;
			system("trasm.exe tmpasm.asm -f > temp.log");
			//system("trasm.exe tmpasm.asm -f");

            //make sure the binaries from the two passes had equal size
            // ...that was our assumption, and it'd better be true.
			sprite_bin.open(".\\tmpasm.bin", ios::in | ios::binary);
			if (!sprite_bin) throw Error("couldn't open .\\tmpasm.bin on second pass");
			int sprite_bin_size2 = get_file_size(sprite_bin);            
			if (sprite_bin_size2 != sprite_bin_size)
				throw Error("second pass yielded a different file size.  wtf, mate??");


            //We actually have the code

			//open binary file into buffer
			char * bin_buffer = new char[sprite_bin_size];
			sprite_bin.seekg(0, ios::beg);
			sprite_bin.read(bin_buffer, sprite_bin_size);

			string bin_contents(bin_buffer, sprite_bin_size);
			int init_offset, code_offset;			
			init_offset = bin_contents.find("INIT", 0);
			code_offset = bin_contents.find("MAIN", 0);
			
			if (init_offset == string::npos)
				throw Error("dcb \"INIT\" not found in " + sprite_asm_filename);
			if (code_offset == string::npos)
				throw Error("dcb \"MAIN\" not found in " + sprite_asm_filename);

			//compensate for the INIT and MAIN tags
			init_offset += 4;
			code_offset += 4;

			cout << "init offset: " << init_offset << endl;
			cout << "main offset: " << code_offset << endl;

			table_row[10] = sprite_location.bank_number;
			table_row[9] = 0x080;
			relocate(table_row, 8, sprite_location, init_offset);

			table_row[13] = sprite_location.bank_number;
			table_row[12] = 0x080;
			relocate(table_row, 11, sprite_location, code_offset);
			
			//write jsl locations to rom
			rom_file.seekp(table_row_start);
			rom_file.write(table_row, 16);
			
            //Usinge TRASM now!  No more keeping track of reloc offsets :) 
            // Seriously, those would have been a *bitch* for sprite development
			/*//change the bytes that need relocating
			int current_reloc;
			cout << "sprite relocs: ";
			while (sprite_cfg >> hex >> current_reloc){
				cout << current_reloc <<" ";
				relocate(bin_buffer, current_reloc, sprite_location);
			}
			cout << endl;*/
			ifstream error_file(".\\TMPASM.ERR");
			string word;
			while (error_file>>word){
                if (word == "Although")
					throw Error(sprite_asm_filename + " didn't assemble correctly.");
			}

			write_to_rom(rom_file, sprite_location, bin_buffer, sprite_bin_size);
			
			delete [] bin_buffer;
			delete [] asm_file_contents;
			sprite_bin.close();

		}
		else if (type == 0) {
			rom_file.seekp(table_row_start);
			rom_file.write(table_row, 8);
		}

        //Wow, all this crap just for the poison mushroom?  I should have just made
        // it a custom sprite... apparently all this was easier.
		else if (type == 255){
			cout << "\ninserting poison mushroom\n";
			
			int poison_num = int(unsigned char(table_row[1]));
			cout << poison_num << endl;
			
			//set the tweaker bytes
			rom_file.seekp(START_1656_TABLE + poison_num);
			rom_file.write(&table_row[2], 1);
			rom_file.seekp(START_1662_TABLE + poison_num);
			rom_file.write(&table_row[3], 1);
			rom_file.seekp(START_166E_TABLE + poison_num);
			rom_file.write(&table_row[4], 1);
			rom_file.seekp(START_167A_TABLE + poison_num);
			rom_file.write(&table_row[5], 1);
			rom_file.seekp(START_1686_TABLE + poison_num);
			rom_file.write(&table_row[6], 1);
			rom_file.seekp(START_190F_TABLE + poison_num);
			rom_file.write(&table_row[7], 1);

			//change the asm pointers
			for (int i=8; i<12; ++i){
				sprite_cfg >> hex >> value;
                if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
				table_row[i] = char(value);
			}
			rom_file.seekp(START_ASM_TABLE + 2*poison_num);
			rom_file.write(&table_row[8], 2);
			rom_file.seekp(START_INIT_TABLE + 2*poison_num);
			rom_file.write(&table_row[10], 2);

			// now deal with the .bin file
			string mush_bin_file;
			sprite_cfg >> mush_bin_file;
            if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
			mush_bin_file = PATH + mush_bin_file;

			fstream mush_code(mush_bin_file.c_str(), ios::in | ios::binary);
			if (!mush_code) throw Error("couldn't open " + mush_bin_file);
			int code_size = get_file_size(mush_code);
			Location mush_location = find_free_space(rom_file, code_size);
			mush_location.print();
			int code_start = mush_location.full_PC_addr + TAG_SIZE;
		
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
			write_to_rom(rom_file, mush_location, mush_buffer, code_size);
			delete [] mush_buffer;

			//patch original code
			char mush[4];

			int location, jump_type;
			sprite_cfg >> jump_type >> location;
            if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
			location += (mush_location.bank_SNES_addr + TAG_SIZE);

			mush[0] = char(jump_type);
			mush[1] = location & 0x0FF;
			mush[2] = (location >> 8) & 0x0FF;
			mush[3] = mush_location.bank_number;	
			rom_file.seekp(0x0C6CB, ios::beg);
			rom_file.write(mush, 4);

			sprite_cfg >> jump_type >> location;
            if (!sprite_cfg) throw Error(sprite_cfg_filename + " contains invalid data");
			location += (mush_location.bank_SNES_addr + TAG_SIZE);

			mush[0] = char(jump_type);
			mush[1] = location & 0x0FF;
			mush[2] = (location >> 8) & 0x0FF;
			mush[3] = mush_location.bank_number;	
			rom_file.seekp(0x0C8D6, ios::beg);
			rom_file.write(mush, 4);

		}
		else{
			throw Error("Invalid type number in " + sprite_cfg_filename);
		}
			
		
		sprite_cfg.close();
	}


    if (!sprites_in.eof()) throw Error("sprite list contains invalid data");
}


Location find_free_space(fstream & rom_file, int space_needed)
{
	space_needed += TAG_SIZE;

	if (space_needed > 0x8000)
		throw Error("Your file won't fit in a bank.  Perhaps a stray org in the .asm file?");
	int rom_size = get_file_size(rom_file);
	int number_of_banks = (rom_size - HEADER_SIZE)/BANK_SIZE;
	if (number_of_banks <= 0x10)
		throw Error("Your ROM must be expanded");

	char bank_buffer[BANK_SIZE];

	for (int i = 0x10; i < number_of_banks; ++i){

		//get whole bank into a string
		rom_file.seekg(i*BANK_SIZE + HEADER_SIZE, ios::beg);
		rom_file.read(bank_buffer, BANK_SIZE);
		string current_bank_contents(bank_buffer, BANK_SIZE);

		//look for free space
		string free_space(space_needed,'\0');
		size_t loc = current_bank_contents.find(free_space, 0);
		if( loc != string::npos )
			return Location(i,loc);
		
	}

	throw Error("Unable to find free space in yout ROM");
}


//returns the filesize, doesn't preserve the get pointer
int get_file_size(fstream & fs){
	fs.seekg (0, ios::end);
	return fs.tellg();
}


void relocate(char* code_buffer, int reloc_offset, Location inserted_location, int code_offset)
{
	int new_value = (unsigned char(code_buffer[reloc_offset+1]) << 8)
		+ unsigned char(code_buffer[reloc_offset]);
	//cout << hex << endl << new_value << endl;
	new_value += (inserted_location.offset_from_bank_start + TAG_SIZE + code_offset);
	//cout<<inserted_location.offset_from_bank_start << endl << new_value << endl;
	code_buffer[reloc_offset] = new_value & 0x0FF;
	code_buffer[reloc_offset+1] = (new_value >> 8) & 0x0FF;
}


void write_to_rom(fstream & rom_file, Location location, char* buffer, int size)
{
	rom_file.seekp(location.full_PC_addr, ios::beg);

	//write RATS tag
	char current_byte[1];
	int full_size = size + 3;
	rom_file.write("STAR", 4);
	current_byte[0] = char(full_size & 0x0FF);
	rom_file.write(current_byte, 1);
	current_byte[0] = char((full_size>>8) & 0x0FF);
	rom_file.write(current_byte, 1);
	full_size = (full_size ^ 0x0FFFF) + 1;
	current_byte[0] = char(full_size & 0x0FF);
	rom_file.write(current_byte, 1);
	current_byte[0] = char((full_size>>8) & 0x0FF);
	rom_file.write(current_byte, 1);
	rom_file.write("MDK", 3);
	cout << "wrote 8 bytes" << endl;
	
	//write data
	rom_file.write(buffer, size);
	cout << "wrote " << size << " bytes" << endl;
}


void clean_rom(fstream & rom_file){

	int rom_size = get_file_size(rom_file);
	int number_of_banks = (rom_size - HEADER_SIZE)/BANK_SIZE;
	if (number_of_banks <= 0x10)
		throw Error("Your ROM must be expanded");

	char bank_buffer[BANK_SIZE];

	//undo poison mushroom changes
	char mush[4] = {0x0C9, 0x021, 0x0D0, 0x069};
	char mush_gfx[4] = {0x0AA, 0x0BD, 0x009, 0x0C6};
	rom_file.seekp(0x0C6CB, ios::beg);
	rom_file.write(mush, 4);
	rom_file.seekp(0x0C8D6, ios::beg);
	rom_file.write(mush_gfx, 4);
	
	for (int i = 0x10; i < number_of_banks; ++i){

		//get whole bank into a string
		rom_file.seekg(i*BANK_SIZE + HEADER_SIZE, ios::beg);
		rom_file.read(bank_buffer, BANK_SIZE);
		string current_bank_contents(bank_buffer, BANK_SIZE);

		//look for data inserted on previous uses
		size_t loc = current_bank_contents.find("MDK", 0);
		if( loc == string::npos || loc < 8)
			continue;
		if (current_bank_contents.substr(loc-8, 4) != "STAR")
			continue;
		
		//delete the amount that the RATS tag is protecting
		int size = (int(unsigned char(current_bank_contents[loc-3])) << 8)
			+ int(unsigned char(current_bank_contents[loc-4])) + 8;
		cout << "deleted " << hex << size << " bytes" << endl;
		memset(&bank_buffer[loc-8], 0, size);
		rom_file.seekp(i*BANK_SIZE + HEADER_SIZE, ios::beg);
		rom_file.write(bank_buffer, BANK_SIZE);
		--i;		
	}
}

char get_hex_digit(int digit){
    static const char * hex_digits = "0123456789ABCDEF";
    if (digit < 0 || digit > 15){
        cout << "Warning: get_hex_digit was passed a value of " << digit << endl;
        return 0;
    }
    return hex_digits[digit];
}
