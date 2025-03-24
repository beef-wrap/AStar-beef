cmake -S . -B AStar/build -DCMAKE_BUILD_TYPE=Debug
cmake --build AStar/build --config Debug

cmake -S . -B AStar/build -DCMAKE_BUILD_TYPE=Release
cmake --build AStar/build --config Release