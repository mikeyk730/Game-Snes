#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>

using namespace std;

void do_command(int start, int end, bool data=false);
void doit(int start, int end, ifstream& in);
void make_sym_file(ifstream& in);

bool quiet;
bool test;
string flags;

void main (int argc, char *argv[])
{
  string s_start, s_end;

  quiet = false;
  test = false;

  for (--argc ;argc > 0; --argc){
    if (string(argv[argc]) == "-q")
      quiet = true;
    else if (string(argv[argc]) == "-t")
      test = true;
    else if (argv[argc][0] == '-')
      flags += " " + string(argv[argc]);
    else if (s_end == "")      
      s_end = string(argv[argc]);
    else if (s_start == "")
      s_start = string(argv[argc]);
    else{
      cout << "unknown arg: " << argv[argc] << endl;
      return;
    }
  }

  int start;
  if (s_start == ""){
      if (s_end == ""){
        cout << "no starting address specified" << endl;
        return;
      }
      s_start = s_end;
      s_end = "";

  }
  istringstream ss1(s_start);
  ss1 >> hex >> start;

  int end;
  if (s_end == ""){
    end = start + 0x080;
  }
  else{
    istringstream ss2(s_end);
    ss2 >> hex >> end;
  }

  if (start > end){
      cout << "start greater than end" << endl;
      return;
  }
  //cout << hex << start << " to " << end << endl;

    ifstream in("data.txt");
    doit(start, end, in);
  
}

void doit(int start, int end, ifstream& in)
{
  int data_start, data_end;
  string line;
  while (getline(in, line)){
    if (line.length() < 1 || line[0] == ';')
      continue;
    
    istringstream line_stream(line);
    if(!(line_stream >> hex >> data_start >> data_end))
      continue;

    --data_end;

    if (data_start > data_end){
      cout << "start greater than end in data file" << endl;
      return;
    }
    
    if (start > data_end) continue;
    //the next chunk of data is past our stopping point
    if (end < data_start) break;

    if (data_end > end) data_end = end;
    if (start > data_start) data_start = start;
    
    if (data_start > start)
      do_command(start, data_start-1);
    do_command(data_start, data_end, true);
    
    start = data_end + 1;
  }
  if (end > start)
    do_command(start,end);
}

void do_command(int start, int end, bool data)
{
  stringstream ss;
  ss << "disasm.exe -skip -c2";
  if (quiet)
    ss << " -q";    
  if (data)
    ss << " -d";
  ss << flags;
  ss << " -b" << hex << setfill('0') << setw(6) << start
     << " -e" << hex << setfill('0') << setw(6) << end + 1
     << " -su data.txt -sy symbol.txt mario.smc";
  
  if (test)
    cout << ss.str() << endl;
  else
    system(ss.str().c_str());

}

void make_sym_file(ifstream& in)
{
  ofstream out("sym.s");
  string line;
  while (getline(in, line)){
    if (line.length() < 1 || line[0] == ';')
      continue;
    int addr;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> addr >> label >> label))
      continue;
    out << label << "=$" << setfill('0') << setw(6) << hex << addr << endl;
  }
}
