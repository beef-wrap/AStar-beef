using System;
using System.Interop;

namespace AStar;

public static class AStar
{
	typealias size_t = uint;

	public struct ASNeighborList;
	public struct ASPath;

	[CRepr] public struct ASPathNodeSource
	{
		/// the size of the structure being used for the nodes - important since nodes are copied into the resulting path
		public size_t  nodeSize;
		/// add nodes to the neighbor list if they are connected to this node
		public function void(ASNeighborList* neighbors, void* node, void* context) nodeNeighbors;
		/// estimated cost to transition from the first node to the second node -- optional, uses 0 if not specified
		public function float(void* fromNode, void* toNode, void* context) pathCostHeuristic;
		/// early termination, return 1 for success, -1 for failure, 0 to continue searching -- optional
		public function c_int(size_t visitedCount, void* visitingNode, void* goalNode, void* context) earlyExit;
		/// must return a sort order for the nodes (-1, 0, 1) -- optional, uses memcmp if not specified
		public function c_int(void* node1, void* node2, void* context) nodeComparator;
	}

	/// use in the nodeNeighbors callback to return neighbors
	[CLink] public static extern void ASNeighborListAdd(ASNeighborList* neighbors, void* node, float edgeCost);

	/// if goalNode is NULL, it searches the entire graph and returns the cheapest deepest path
	/// context is optional and is simply passed through to the callback functions
	/// startNode and nodeSource is required
	/// as a path is created, the relevant nodes are copied into the path
	[CLink] public static extern ASPath* ASPathCreate(ASPathNodeSource* nodeSource, void* context, void* startNode, void* goalNode);

	/// paths created with ASPathCreate() must be destroyed or else it will leak memory
	[CLink] public static extern void ASPathDestroy(ASPath* path);

	/// if you want to make a copy of a path result, this function will do the job
	/// you must call ASPathDestroy() with the resulting path to clean it up or it will cause a leak
	[CLink] public static extern ASPath* ASPathCopy(ASPath* path);

	/// fetches the total cost of the path
	[CLink] public static extern float ASPathGetCost(ASPath* path);

	/// fetches the number of nodes in the path
	[CLink] public static extern size_t ASPathGetCount(ASPath* path);

	/// returns a pointer to the given node in the path
	[CLink] public static extern void* ASPathGetNode(ASPath* path, size_t index);
}