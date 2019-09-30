#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "cursedLua.h"
#include "readSTDIN.h"

#define devel 0

int main(int argc,char** argv){
    lua_State* L;
    // initialize Lua interpreter
    L = luaL_newstate();

    // load Lua base libraries (print / math / etc)
    luaL_openlibs(L);

    //On charge les fonctions custom
    cl_include(L);

    //On charge le fichier
#if devel == 1
    luaL_dofile(L,"evenmore.lua");
#else
    luaL_dofile(L,"/usr/local/share/evenmorelua/evenmore.luac");
#endif

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
