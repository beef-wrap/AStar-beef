using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Interop;
using System.Text;

using static AStar.AStar;

namespace example;

static class Program
{
	const int blockSize = 50;
	const int worldWidth = 20;
	const int worldHeight = 13;
	const int[worldWidth * worldHeight] world =
		.(
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0,
		0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0,
		0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
		1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
		);

	static PathNode pathFrom = .() { x = 0, y = 0 };
	static PathNode pathTo = .() { x = 6, y = 5 };

	struct PathNode
	{
		public int x;
		public int y;
	};

	static int WorldAt(int x, int y)
	{
		if (x >= 0 && x < worldWidth && y >= 0 && y < worldHeight)
		{
			return world[y * worldWidth + x];
		} else
		{
			return -1;
		}
	}

	static void PathNodeNeighbors(ASNeighborList* neighbors, void* node, void* context)
	{
		PathNode* pathNode = (PathNode*)node;

		if (WorldAt(pathNode.x + 1, pathNode.y) == 0)
		{
			ASNeighborListAdd(neighbors, &PathNode { x = pathNode.x + 1, y = pathNode.y }, 1);
		}
		if (WorldAt(pathNode.x - 1, pathNode.y) == 0)
		{
			ASNeighborListAdd(neighbors, &PathNode { x = pathNode.x - 1, y = pathNode.y }, 1);
		}
		if (WorldAt(pathNode.x, pathNode.y + 1) == 0)
		{
			ASNeighborListAdd(neighbors, &PathNode { x =  pathNode.x, y = pathNode.y + 1 }, 1);
		}
		if (WorldAt(pathNode.x, pathNode.y - 1) == 0)
		{
			ASNeighborListAdd(neighbors, &PathNode { x = pathNode.x,  y = pathNode.y - 1 }, 1);
		}
	}

	static float PathNodeHeuristic(void* fromNode, void* toNode, void* context)
	{
		PathNode* from = (PathNode*)fromNode;
		PathNode* to = (PathNode*)toNode;

		// using the manhatten distance since this is a simple grid and you can only move in 4 directions
		return (Math.Abs(from.x - to.x) + Math.Abs(from.y - to.y));
	}

	static ASPathNodeSource PathNodeSource = .()
		{
			nodeSize = sizeof(PathNode),
			nodeNeighbors = => PathNodeNeighbors,
			pathCostHeuristic = => PathNodeHeuristic,
			earlyExit = null,
			nodeComparator = null
		};

	static int Main(params String[] args)
	{
		ASPath* path = ASPathCreate(&PathNodeSource, null, &pathFrom, &pathTo);

		let pathCount = ASPathGetCount(path);

		Debug.WriteLine($"traveling from ({pathFrom.x}, {pathFrom.y}) to ({pathTo.x}, {pathTo.y})");

		if (pathCount > 1)
		{
			Debug.WriteLine($"path count: {pathCount}");

			for (let i < pathCount)
			{
				let n = (PathNode*)ASPathGetNode(path, i);
				Debug.WriteLine($"step{i} ({n.x}, {n.y})");
			}
		}

		return 0;
	}
}