# evenmorelua
A terminal text reader.

This program is an alternative to the standard "more" program mean to read text in a terminal window.

This program let you choose the color theme you want and include word-warping to ensure a comfortable reading experience.

![Alt text](https://i.imgur.com/bXeO2bS.png "Reading a file")

## Installation
To install evenmorelua you need the library cursedLua, available here: https://github.com/Arkaeriit/cursedLua.

When the library is installed, this just use: 
```bash
make && sudo make install
```

## User manual
To use it do  `envenmorelua file.txt` to display file.txt or do `some-commands | evemorelua` to read the result from some-commands in the nice display from evenmorelua.

Use up/down and page-up/page-down to navigate in a file.

Use left/right to change the text color and use the keys 'b' and 'n' to change the background color. 

Use the key 'p' to show your position in the text.

Use the key 'q' to quit

