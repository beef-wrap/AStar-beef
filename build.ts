import { type Build } from 'xbuild';

const build: Build = {
    common: {
        project: 'astar',
        archs: ['x64'],
        variables: [],
        defines: [],
        options: [],
        copy: {},
        libraries: {
            astar: {
                sources: ['AStar/AStar.c']
            },
        },
        subdirectories: [],
        buildDir: 'build',
        buildOutDir: 'libs',
        buildFlags: [],
    },
    platforms: {
        win32: {
            windows: {
                buildFlags: ['-T ClangCl']
            },
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {},
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;