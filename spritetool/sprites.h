#include <fstream>
#include <string>

class SpriteTool{
 public:
 SpriteTool(std::fstream& rom_file, std::ifstream& sprite_list) :
  m_rom_file(rom_file),
  m_sprite_list(sprite_list)
  {}
  
  // private:
  void clean_rom();
  
 private:
  std::fstream& m_rom_file;
  std::ifstream& m_sprite_list;
};
