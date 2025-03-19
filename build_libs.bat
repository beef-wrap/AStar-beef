mkdir libs
mkdir libs\debug
mkdir libs\release

clang -c -O0 -g -gcodeview -o astar.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall AStar\AStar.c
move astar.lib libs\debug

clang -c -O3 -o astar.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall AStar\AStar.c
move astar.lib libs\release