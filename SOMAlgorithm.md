

# Understanding Self-Organizing Maps #

See the page on the user website for [Understanding Self-Organizing Maps](http://mathcs.emory.edu/~kthayer/ifcsoft/som.html).

For more information on Self-Organizing Maps, see:

  * http://en.wikipedia.org/wiki/Self-organizing_map
  * http://davis.wpi.edu/~matt/courses/soms/
  * http://www.ai-junkie.com/ann/som/som1.html


# The SOM Algorithm #

There are three steps to the SOM algorithm:
  1. Initializing the map
  1. Computing the SOM
  1. Placing the data points on the SOM

## 1) Initializing the SOM ##

### Nodes ###
[SOMNode.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMNode.java)

In IFCSoft, SOMs are 2D hexagonal arrays of nodes (some code is in place to allow for square arrays). Every node has a value for its weight in each dimension.

### SOM Array ###

The array of nodes is held in the [SOM class](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOM.java). Each Node borders up to 6 other nodes. [SOMHelperFns.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMHelperFns.java) has a function (_neighborsAtDistance_) to return nodes at a given distance from a given node.

### Initial Values ###
[SOMInitFns.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMInitFns.java)

The SOM map nodes can be initialized with random values, or they can be initialized linearly. The second finds the two larges eigenvectors of the auto-correlation matrix of the data set, sets one to the x axis, the other to the y, and gives initial values in all dimensions according to those. There is also an unused function to load initial values from a file (I used this to import maps made by the [SOM Toolbox](http://www.cis.hut.fi/somtoolbox/) in Matlab).


## 2) The Self-Organization Process ##

### Best Matching Unit (BMU) ###
The function _findBMU_ in [SOMHelperFns.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMHelperFns.java).

For a given vector of weights (eg. a data point with its values in each dimension), the Best Matching Unit (BMU) is the node in the Self-Organizing Map that is most similar to the input vector. The measure used for similarity in IFCSoft is [Euclidean Distance](http://mathworld.wolfram.com/Distance.html). The function _findBMU_ takes a vector as an input and searches the nodes one by one, finding the node that has the smallest Euclidean distance to the input vector.


### Classic (Incremental) SOM ###
The _calculateSOM_ function in [SOMCalcFns.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMCalcFns.java).

In the classic SOM, the organization is achieved through a large number of iterations, each with a single data point.

For each iteration, a data point is picked randomly from the input data set and its BMU is found. The weights of the BMU node and the nodes surrounding it are shifted towards the weights of the data point (imagine throwing a splotch of data-point colored paint at the area where the data point landed).

When the algorithm starts, the neighborhood that is influenced is very large and the amount that the nodes are pulled towards the data point value is large. As the algorithm continues, the neighborhood shrinks so that only a few nodes are changed, and they are only changed a very small amount until the map stabilizes (the amount it's changed is calculated by the function _getAlpha_).

### Batch SOM ###
The _calculateBatchSOM_ function in [SOMCalcFns.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMCalcFns.java).

The batch SOM needs a much smaller number of iterations than the classic SOM does, and each iteration uses a large number of input data points.

For each iteration, the BMU is calculated for a large number of data points randomly picked from the data set. Each node then has a set of data points that "belong" to it. After all the points have been placed for the iteration, each node's weights are replaced with the average of all the points that belong to itself and the nodes in its neighborhood.

At the start of the algorithm, the neighborhood is large. This means that not many data points are needed since the average of all data points that landed in the neighborhood of the node are averaged together, and that could be hundreds of nodes. At the end of the algorithm, the neighborhood will be small and the number of points needed will be large so that a reasonable average can be taken of the points in a node's neighborhood. This also makes the Batch SOM not work as well with small data sets (at least within IFCSoft).

## 3) Placing Data Points ##

The function _findMemberships_ in [SOMThread.java](http://code.google.com/p/ifcsoft/source/browse/src/ifcSoft/model/som/SOMThread.java)

After the SOM organization is complete, the algorithm then goes back through all points in the data set and finds their BMU. Each node will get a list of its "members" or the data points that had the node as its BMU. This information on members of nodes is used to show the density map and also for choosing subsets of the data based on the SOM.