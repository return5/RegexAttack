
//-------------------------------- includes ---------------------------------------------------
#include <regex.h>
#include <string.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

//-------------------------------- function prototypes ----------------------------------------

static int checkMatch(const lua_State *const L);
//-------------------------------- code -------------------------------------------------------

int luaopen_regexlib(lua_State *L) {
    lua_register(L,"checkMatch",checkMatch);
    return 0;
}



static int checkMatch(const lua_State *const L) {
    const char *const str     = lua_tostring(L,1);
    const char *const pattern = lua_tostring(L,2);
    regex_t regex;
    if(!regcomp(&regex,pattern,REG_EXTENDED)) {
        regmatch_t match[2];
        if(!regexec(&regex,str,2,match,0)) {
            lua_pushlstring(L,str + match[0].rm_so,match[0].rm_eo - match[0].rm_so);
            regfree(&regex);
            return 1;
        }
    }
    lua_pushstring(L,"NULL\0");
    regfree(&regex);
    return 1;
}



