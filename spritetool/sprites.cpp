#include <iostream>
#include <string>
#include <fstream>
#include <cassert>

using namespace std;

const int BANK_SIZE = 0x8000;
const int HEADER_SIZE = 0x200;
const int TAG_SIZE = 0xB;		//S T A R X X X X M D K
const int SPRITE_TABLE_SIZE = 0xC90;
const string PATH = "./sprites/";

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
		cout << hex << "SNES: " << bank_number << ":" << bank_SNES_addr << endl;
		cout << hex << "PC: " << full_PC_addr << endl;
	}

	int full_PC_addr;
	int offset_from_bank_start;
	int bank_number;
	int bank_SNES_addr;
};

void main_function(string rom_filename, string sprite_list_filename);
int get_file_size(fstream & fs);
Location find_free_space(fstream & rom_file, int space_needed);
void relocate(char* code_buffer, int reloc_offset, Location inserted_location, int code_offset=0);
void write_to_rom(fstream & rom_file, Location location, char* buffer, int size);
void clean_rom(fstream & rom_file);
char get_hex_digit(int digit);


/********************************************************************
 program
********************************************************************/

int main()
{
	try{
		string rom_filename;
		rom_filename = "smw.smc";
		cout << "enter rom filename: ";
		getline(cin, rom_filename);

		string sprite_list;
		sprite_list = "sprites.txt";
		cout << "enter sprite list filename: ";
		getline(cin, sprite_list);

		main_function(rom_filename, sprite_list);
	}
	catch (Error & err){
		cout << "\n************ERROR************\n" << err.s << "\n*****************************\n";
	}

	return 0;
}

void main_function(string rom_filename, string sprite_list_filename)
{
	//open the rom
	fstream rom_file(rom_filename.c_str(), ios::in | ios::out | ios::binary);
	if (!rom_file.is_open()) throw Error("couldn't open ROM");

	clean_rom(rom_file);

	cout << "\nmain code and table:\n";
	//find a place in rom to put the main code and sprite table
	fstream main_code("main.bin", ios::in | ios::binary);
	if (!main_code) throw Error("couldn't open main.bin");
	int main_code_size = get_file_size(main_code);
	int total_size = main_code_size + SPRITE_TABLE_SIZE;
	Location main_location = find_free_space(rom_file, total_size);
	main_location.print();
	int table_start = main_location.full_PC_addr + main_code_size + TAG_SIZE;
	cout << "sprite table start " << table_start << endl;
	
	//put the main code and sprite table in memory
	char * main_buffer = new char[total_size];
	memset(main_buffer, 0xFF, total_size);
	for(int i = main_code_size; i < total_size; i += 0x10){
		main_buffer[i+0] = 0;
		main_buffer[i+1] = 0;
	}

	main_code.seekg(0, ios::beg);
	main_code.read(main_buffer, main_code_size);

	ifstream main_cfg("main.off");
	if (!main_cfg) throw Error("couldn't open main.off");

	//patch locations that call sprite tool code
	int location;
	char patch[5] = {0x022, 0x0, 0x0, 0x0, 0x0EA};
	
	//patch level loading
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x12B63);
	rom_file.write(patch, 5);
	
	//patch init routine
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x08372);
	rom_file.write(patch, 5);

	//patch code routine
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x087C3);
	rom_file.write(patch, 5);

	//patch eraser routine
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x3F985);
	rom_file.write(patch, 5);

	//patch eraser routine 2
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x08351);
	rom_file.write(patch, 5);

	//patch verical level loading
	main_cfg >> hex >> location;
	location += (main_location.bank_SNES_addr + TAG_SIZE);
	patch[1] = location & 0x0FF;
	patch[2] = (location >> 8) & 0x0FF;
	patch[3] = main_location.bank_number;
	rom_file.seekp(0x12B4B);
	rom_file.write(patch, 5);

	//patch goal tape init to get extra bits in $187B
	char goal_patch[11] = {0x0BF, 0x010, 0x0AB, 0x07F, 0x0EA, 0x0EA, 0x0EA, 0x0EA, 0x09D, 0x07B, 0x018};
	rom_file.seekp(0x0C289);
	rom_file.write(goal_patch, 11);

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
	
	ifstream sprites_in(sprite_list_filename.c_str());
	if (!sprites_in) throw Error("couldn't open " + sprite_list_filename);

	int sprite_number;
	while (sprites_in >> hex >> sprite_number){
					
		string sprite_cfg_filename;
		sprites_in >> sprite_cfg_filename;
		sprite_cfg_filename = PATH + sprite_cfg_filename;
		ifstream sprite_cfg(sprite_cfg_filename.c_str());
		if (!sprite_cfg) throw Error("couldn't open " + sprite_cfg_filename);
		
		//write type, acts like, and tweaker values
		int table_row_start = table_start + (0x10 * sprite_number);
		char table_row[0x10];
		memset(table_row, 0, 0x10);
		int value;
		for (int i=0; i<8; ++i){
			sprite_cfg >> hex >> value;
			table_row[i] = char(value);
		}
		
		int type = int(unsigned char(table_row[0]));
		if (type & 1){
			string sprite_asm_filename;
			sprite_cfg >> sprite_asm_filename;
			sprite_asm_filename = PATH + sprite_asm_filename;
			fstream sprite_asm_file(sprite_asm_filename.c_str(), ios::in | ios::binary);
			if (!sprite_asm_file) throw Error("couldn't open  " + sprite_asm_filename);
			int sprite_asm_size = get_file_size(sprite_asm_file);

			char line_addition[13] = {'o','r','g',' ','$','0','0','8','0','0','0', 0x0D, 0x0A};
			char * asm_file_contents = new char[sprite_asm_size + 13];
			memcpy(asm_file_contents, line_addition, 13);
			sprite_asm_file.seekp(0, ios::beg);
			sprite_asm_file.read(&asm_file_contents[13], sprite_asm_size);
			sprite_asm_file.close();
			
			fstream sprite_asm_tmp("tmpasm.asm", ios::out | ios::binary);
			if (!sprite_asm_tmp) throw Error("couldn't open tmpasm.asm");
			sprite_asm_tmp.write(asm_file_contents, sprite_asm_size + 13);
			sprite_asm_tmp.close();

			system("trasm.exe tmpasm.asm -f");

			fstream sprite_bin("tmpasm.bin", ios::in | ios::binary);
			if (!sprite_bin) throw Error("couldn't open tmpasm.bin");
			int sprite_bin_size = get_file_size(sprite_bin);
			Location sprite_location = find_free_space(rom_file, sprite_bin_size);
			sprite_bin.close();
			cout << "\nsprite: " << sprite_number << endl;
			sprite_location.print();

			asm_file_contents[10] = get_hex_digit((TAG_SIZE + sprite_location.bank_SNES_addr) % 16);
			asm_file_contents[9] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 4) % 16);
			asm_file_contents[8] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 8) % 16);
			asm_file_contents[7] = get_hex_digit(((TAG_SIZE + sprite_location.bank_SNES_addr) >> 12) % 16);
			asm_file_contents[6] = get_hex_digit((TAG_SIZE + sprite_location.bank_number) % 16);
			asm_file_contents[5] = get_hex_digit(((TAG_SIZE + sprite_location.bank_number) >> 4) % 16);

			sprite_asm_tmp.open("tmpasm.asm", ios::out | ios::binary);
			if (!sprite_asm_tmp) throw Error("couldn't open tmpasm.asm on second pass");
			sprite_asm_tmp.write(asm_file_contents, sprite_asm_size + 13);
			sprite_asm_tmp.close();

			system("trasm.exe tmpasm.asm -f");

			sprite_bin.open("tmpasm.bin", ios::in | ios::binary);
			if (!sprite_bin) throw Error("couldn't open tmpasm.bin on second pass");
			int sprite_bin_size2 = get_file_size(sprite_bin);

			if (sprite_bin_size2 != sprite_bin_size)
				throw Error("second pass yielded a different file size");

			//open binary file into buffer
			char * bin_buffer = new char[sprite_bin_size];
			sprite_bin.seekg(0, ios::beg);
			sprite_bin.read(bin_buffer, sprite_bin_size);

			string bin_contents(bin_buffer, sprite_bin_size);
			int init_offset, code_offset;			
			init_offset = bin_contents.find("INIT", 0);
			code_offset = bin_contents.find("MAIN", 0);
			
			if (init_offset == string::npos)
				throw Error("init offset not found in " + sprite_asm_filename);
			if (code_offset == string::npos)
				throw Error("main offset not found in " + sprite_asm_filename);

			//compensate for the INIT and MAIN tags
			init_offset += 4;
			code_offset += 4;

			cout << "init offset: " << init_offset << endl;
			cout << "code offset: " << code_offset << endl;

			table_row[10] = sprite_location.bank_number;
			table_row[9] = 0x080;
			relocate(table_row, 8, sprite_location, init_offset);

			table_row[13] = sprite_location.bank_number;
			table_row[12] = 0x080;
			relocate(table_row, 11, sprite_location, code_offset);
			
			//write jsl locations to rom
			rom_file.seekp(table_row_start);
			rom_file.write(table_row, 14);
			
			//change the bytes that need relocating
			/*int current_reloc;
			cout << "sprite relocs: ";
			while (sprite_cfg >> hex >> current_reloc){
				cout << current_reloc <<" ";
				relocate(bin_buffer, current_reloc, sprite_location);
			}
			cout << endl;*/

			write_to_rom(rom_file, sprite_location, bin_buffer, sprite_bin_size);
			
			delete [] bin_buffer;
			delete [] asm_file_contents;
			sprite_bin.close();

		}
		else{
			rom_file.seekp(table_row_start);
			rom_file.write(table_row, 8);
		}
			
		
		sprite_cfg.close();
	}

}


Location find_free_space(fstream & rom_file, int space_needed)
{
	space_needed += TAG_SIZE;

	if (space_needed > 0x8000)
		throw Error("Your file won't fit in a bank");
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
	switch (digit){
		case 0:
			return '0';
		case 1:
			return '1';
		case 2:
			return '2';
		case 3:
			return '3';
		case 4:
			return '4';
		case 5:
			return '5';
		case 6:
			return '6';
		case 7:
			return '7';
		case 8:
			return '8';
		case 9:
			return '9';
		case 10:
			return 'A';
		case 11:
			return 'B';
		case 12:
			return 'C';
		case 13:
			return 'D';
		case 14:
			return 'E';
		case 15:
			return 'F';

	}
	return 0;

}