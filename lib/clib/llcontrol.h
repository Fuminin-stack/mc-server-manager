#ifndef LOWLEVELINTERACTION
#define LOWLEVELINTERACTION
#include <lauxlib.h>
#include <lualib.h>
#include <lua.h>
static int enableRawMode(lua_State *L);
static int disableRawMode(lua_State *L);
static int packFunctions(lua_State *L);
int resgisterToLua(lua_State *L);
#endif
