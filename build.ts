import os from "node:os";
import { mkdir } from "node:fs/promises";
import { $ } from "bun";

$.nothrow();

const PLATFORMS = { win32: 'windows', linux: 'linux', darwin: 'macos' }
const PLATFORM = PLATFORMS[os.platform()];
const ARCH = os.arch();
const DEBUG = "debug";
const RELEASE = "release";

const prepare = async () => {
    for (const config of [DEBUG, RELEASE]) {
        await mkdir(`libs/${config}/${PLATFORM}_${ARCH}`, { recursive: true });
    }
}

const buildDebug = async () => await $`
    cmake -S . -B AStar/build -DCMAKE_BUILD_TYPE=Debug -T ClangCl
    cmake --build AStar/build --config Debug
`

const copyDebug = async () => await $`
    cp astar/build/Debug/astar.lib libs/${DEBUG}/${PLATFORM}_${ARCH}
    cp astar/build/Debug/astar.pdb libs/${DEBUG}/${PLATFORM}_${ARCH}
    cp astar/build/astar.a libs/${DEBUG}/${PLATFORM}_${ARCH}
`

const buildRelease = async () => await $`
    cmake -S . -B AStar/build -DCMAKE_BUILD_TYPE=Release 
    cmake --build AStar/build --config Release
`

const copyRelease = async () => await $`
    cp AStar/build/Release/astar.lib libs/${RELEASE}/${PLATFORM}_${ARCH}
    cp AStar/build/astar.a libs/${RELEASE}/${PLATFORM}_${ARCH}
`

await prepare();
await buildDebug();
await copyDebug();
await buildRelease();
await copyRelease();