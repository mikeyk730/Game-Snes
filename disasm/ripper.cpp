#include <iostream>
#include <sstream>
#include <fstream>
#include <iomanip>

using namespace std;

bool has_symbol(const string& line, string* label)
{
    istringstream ss(line);
    if((ss >> *label) && (*label)[label->length()-1] == ':') return true;

    return false;
}

int get_addr(const string& line){
    if (line.length() < 8) return 0;
    string addr_string = line.substr(0,8);
    if (addr_string[0] == '$' && addr_string[3] == '/'){
        string trimmed_addr_string = 
            addr_string.substr(1,2) + addr_string.substr(4,4);
        istringstream ss(trimmed_addr_string);
        int hex_addr;
        if (ss >> hex >> hex_addr)
            return hex_addr;
    }
    return 0;
}


int find_next_addr(ifstream& in)
{
    string line;
    while(getline(in, line)){
        int addr = get_addr(line);
        if (addr) return addr;
    }
    return 0;
}

int main(int argc, char** argv)
{
    if (argc < 2){
        cout << argv[0] << " -c <filename>" << endl;
        return -1;
    }

    bool comment_mode = (string(argv[1]) == "-c");

    ifstream in(argv[argc-1]);
    string line;
    while(getline(in, line)){
        if (comment_mode){
            size_t comment_start = line.find_first_of(';');
            if (comment_start == string::npos) continue;
            string comment = line.substr(comment_start+1);
            if (comment.find_first_not_of(' ') == string::npos) continue;

            int addr = get_addr(line);
            if (!addr) continue;

            cout << setfill('0') << setw(6) << hex << addr << " " << comment << endl;
        }
        else{
            string label;
            if(!has_symbol(line, &label)) continue;
            int addr = find_next_addr(in);
            cout << setfill('0') << setw(6) << hex << addr << " " << label << endl;
        }
    }

    return 0;
}

