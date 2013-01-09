#ifndef REQUEST_H
#define REQUEST_H

#include <iostream>
#include "proto.h"

struct Request{
    Request(DisassemblerProperties properties = DisassemblerProperties()) : 
    m_type(Smart),
    m_properties(properties),
    m_quit(false)
  {}

  enum Type { Asm, Dcb, Smart};

  bool get(std::istream & in, bool hirom);

  Type m_type;
  bool m_quit;
  DisassemblerProperties m_properties;
};

#endif