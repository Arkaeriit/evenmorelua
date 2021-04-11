#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "readSTDIN.h"
#include "cursedLua.h"

int main(int argc,char** argv){
    lua_State* L;
    // initialize Lua interpreter
    L = luaL_newstate();

    // load Lua base libraries (print / math / etc)
    luaL_openlibs(L);
    luaopen_cursedLua(L);
    lua_setglobal(L, "nc");

    //On charge le fichier
    luaL_dofile(L,"/usr/local/share/evenmorelua/evenmore.luac");
    luaL_dofile(L,"evenmore.lua");

    if(argc == 2){ //On lit un fichier
        //On appelle la fonction
        lua_getglobal(L,"main");

        //On apelle l'argument
        lua_pushstring(L,*(argv+1));
        //On execute la fonction
        lua_call(L,1,0);
    }else{ //On essaye de lire stdin
        if(detectSTDIN()){
            lua_getglobal(L,"main");
            lua_pushstring(L,"/tmp/evenmorelua.tmp");
            lua_call(L,1,0);
            clearcopy();
        }else{
            lua_getglobal(L,"informations");
            lua_call(L,0,0);
            lua_close(L);
            return 1;
        }
    }
    // Cleanup
    lua_close(L);

    return 0;
}
