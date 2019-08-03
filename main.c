//exemple d'appel de fonctions lua par du C


#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "cursedLua.h"

int main(int argc,char** argv){
    lua_State* L;
    // initialize Lua interpreter
    L = luaL_newstate();

    // load Lua base libraries (print / math / etc)
    luaL_openlibs(L);

    //On charge les fonctions custom
    cl_include(L);

    //On charge le fichier
    luaL_dofile(L,"evenmore.lua");

    //On appelle la fonction
    lua_getglobal(L,"main");

    //On apelle l'argument
    lua_pushstring(L,*(argv+1));
    //On execute la fonction
    lua_call(L,1,0);

    // Cleanup:  Deallocate all space assocatated with the lua state */
    lua_close(L);

    return 0;
}
