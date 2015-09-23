

# JavaFX Script / Java: #

> The program is written in JavaFX script and Java (to compile you need the JDKs for Java and JavaFX, located [here](http://www.oracle.com/technetwork/java/javase/downloads/index.html)). We wanted the program to be a [Rich Internet Application](http://en.wikipedia.org/wiki/Rich_Internet_application), but we also needed to do a lot of heavy computation for the large datasets, so I chose JavaFX and Java since it allowed us to make a multi-threaded RIA. As JavaFX script will [no longer be supported](http://weblogs.java.net/blog/fabriziogiudici/archive/2010/09/27/javafx-script-dead-long-live-visage), the JavaFX script code will probably be ported to [visage](http://code.google.com/p/visage/) once JavaFX 2.0 comes out.

> JavaFX can easily use Java objects and classes, but for a Java class or object to hold and call a JavaFX object, the JavaFX object needs to implement a Java interface with those functions. Therefore many JavaFX files have a Java interface tied to them (eg. MainApp.fx and MainAppI.java).

# Model/View: #
> The program is generally built with the Model and View from the [Model-View-Control paradigm](http://en.wikipedia.org/wiki/Model%E2%80%93View%E2%80%93Controller). I started the program with intentions of using [pureMVC](http://puremvc.org/), though I didn’t end up making up much use of it.

# Initialization of the Program: #
> The program starts in the file ifcSoft.MainApp.fx with the function run(). This creates a new MainApp object and calls the start function in the MainApp. This function creates the menus and tabs, creates the facade, and creates the stage. It then calls the initialization function on the facade, which initializes the PureMVC framework and sends a message that there is no data loaded. The MainApp then continues by building the content blocks for the program.

> After this process is done, the program should simply wait for user input and act from there.

# Slide-Out Menus (File, Data, Display): (view) #
> The three slide-out menus are handled in the Menus.fx file. File should have options like loading, saving and exporting as well as preferences. Data should be for loading, saving and processing data. Display should be for displaying the data and options for the general display of the program.

# Internal Data Set Storage: (model.dataSet, model.dataSet.dataSetScalar, model.dataSet.summaryData) #
> Every data set inherits the abstract DataSet class so that the view and other parts of the model can access any data set the same way. Additionally, a DataSetScalar can be made from a data set so that the model or view can get the data points scaled in some fashion.

> Since data sets can be large and there might be several steps of removing a small number of outliers from a data set, every DataSet has an optional DataSetMask. The DataSetMask keeps a list of indices back into the DataSet along with which data points have been removed at which steps. After the first creation of a DataSetMask, any subsequent removal of outliers shouldn’t take much additional space.

  * The RawData sets are just the raw data values. They are stored in arrays of size DataSet.SEGSIZE so that no block takes up too much space, and changes to a block are localized.

  * UnionData sets are stored as a list of the data sets used to comprise it.

  * SubsetData sets are stored as an array of integers into the data set it’s a subset of. This works similarly to the DataSetMask, except each level of subsets has an additional array.

  * SummaryData sets are for storing statistics about clusters of a group of data sets. For example, if on an SOM of 10 DataSets, I select a cluster and save the stats, it will put the amount of data points in each cluster into the SummaryData set.

## Bugs: ##
  1. When a data point is removed from a data set that another depends on (ie. Subset), have the point removed from the children as well. (I tried, but there is a bug with the code I had).
## Features Needed: ##
  1. The view currently sometimes accesses data through the DataSetProxy and sometimes through the DataSet itself. Either eliminate DataSetProxy or make a more complete use of PureMVC.

# Dialog Box: (view.dialogBox) #
> I wrote a custom dialog box system to make it easier to write dialog boxes. The main class is ifcDialogBox which extends CustomNode and the content defines a list of ifcDialogItems needed in the dialog box (such as checkboxes, integer inputs, etc.).

> In order to use an ifcDialogBox, declare class variables for the ifcDialogBox object and all the ifcDialogItems you need in it. Give the ifcDialogBox a name, set its content as the ifcDialogItems and set its ok and cancel functions. In the ok function you can access each of the ifcDialogItem objects to get their values. Look at MakeHistogramDialog.fx for an short example of it being used.
## Features Needed: ##
  1. Minimize, maximize.
  1. Prevent moving dialog box off screen.
  1. Make sure all dialog boxes use this library.
  1. Add more ifcDialogItems as they are needed.
  1. Improve items such as ifcDialogDataSetSelect and ifcDialogDataTable

# Job Queues: (view, model.thread, model.som, model.som.jobs) #
> Eventually there should be a central job queue to do all computations in separate threads. Currently MainMediator has a single thread job queue to handle loading files and removing outliers, while each SOM object has 4 job threads to handle SOM calculations.
## Features Needed: ##
  1. Centralized Job Queue
  1. Allow viewing and canceling active jobs
  1. Allow prioritizing of jobs

# Tabs: (view) #
> Each tab has a Tab object that is used by the main application for tabbing, and each Tab object has a TabMediator (interface) that handles displaying and swapping the different tabs themselves.

> To make a new tab type, Tab.java needs to be updated to include that type, and a new class inheriting TabMediator must be made to control the tab. The new TabMediator type will need a JavaFX file to handle the GUI for the internals of the tab. Additionally MainApp.fx will need a function to create a tab of that type. Normally there will be an additional dialog box creator for making a new tab of that type and classes in the model to do any computation.

## Features Needed: ##
  1. Save dialog boxes open when tab swapped out.
  1. Tab label sizing and handling of too many tabs to fit on the screen.
  1. Allow re-arranging of tabs
  1. The tab label should have a way of indicating computation progress on that tab, so you can see how one tab is doing if you have a different one open.

## Current Tab Types: ##
  1. Blank Tab: (view.blankTab)
    * If no data set is loaded, there will only be a button to load data. If data is loaded, it will give you options for displaying the data.
    * Features Needed:
      1. It would be good to have a data set viewer as the default when you have one loaded (with options of displaying the data sets).

  1. Histogram: (view.histogram, model.histogram)
    * Displays a histogram of a data set or combination of data sets
    * Features Needed:
      1. Vertical scale
      1. Select portion of histogram and save/remove data points
      1. Display multiple histograms on same page (especially when histogram is of multiple sets)

  1. Scatter Plot: (view.scatterplot, model.scatterplot)
    * Displays a scatter plot of a data set over two dimensions
    * Features Needed:
      1. Scale
      1. Resize graph according to window size
      1. Allow selection of points on scatter plot
      1. Display multiple scatter plots on the same page

  1. [Self-Organizing Map](http://code.google.com/p/ifcsoft/wiki/SOMAlgorithm) (view.som, model.som)
    * Creates and displays a Self-Organizing Map of a data set or combination of data sets.
    * Other than the initial creation in CalcSOMDialog, all communication between the view and the model pass through the SOMMediator and SOMProxy.
    * In the view side, the overall GUI is built by the SOMvc. This uses SOMMaps which places the SOM map tiles and handles the right click menu. Each SOM Map tile inherits from SOMTile (they are in view.som.somtile).
    * In the model, the SOM object holds all the information of the SOM (eg. the map nodes and the data sets used). The map nodes are SOMNode objects. The computation algorithms are in separate files (SOMCalcFns, SOMHelperFns, SOMInitFns, and SOMRetrieveFns). Four SOMThreads handle the creation of the SOM and finding the placement of data points on it using the job objects in model.som.jobs.

  * Bugs:
    1. The right-click menu will display on the other side of the screen if there isn’t room for it. Also, allow access to right click menu even if click is not on a tile
    1. Allows saving cluster even if finding membership isn’t done.
    1. Pressing “Cancel SOM” leaves tab content disabled.
    1. SOM progress in Batch SOM does not go linearly. It should first calculate the total number of points to place in all steps and calculate progress using that.
    1. Cross-hairs should turn off when moving tile and drawing selection.
  * Features Needed:
    1. Scales on maps.
    1. Select individual Map Tiles. Particularly, allow selecting two for making scatter plot.
    1. Invert Selection
    1. Better auto-clustering options
    1. Place important options as buttons on the display, rather than hidden in right-click menus.
  1. Wind Rose Chart (view.windrose)
    * Displays a data set with wind-rose charts [link](link.md). The advantage of wind-rose charts over pie charts is that 1) the human eye is not good at comparing angle sizes and 2) each wedge being in the same spot on each chart makes it much easier to compare wr charts quickly. Since no special calculations need to be made, there is no model object associated with this.
    * Bugs:
      1. For some reason I can’t get it to center properly.
      1. Since the legend is done with PieChart, there is an “= 1.0” with each label that I can’t get rid of.
    * Features Needed:
      1. It is currently not well laid out.
      1. Fit more WRCs on a page.
      1. Allow reorganization of the wedges and spinning of the charts.
      1. Allow handling of separate times and such.
      1. Possibly base them off of JavaFX PieCharts.



# Other bugs: #
  1. What I have for log scale currently probably isn’t the best way to do it. I first scale it so the min is 1 and the max is 10, then I take the log base 10 of it.
# Other Features Needed: #
  1. Unit Testing
  1. Data Analysis
  1. Save/Load for Tabs (SOM, etc.), datasets, sessions, etc.
  1. Export images and other doc types.
  1. Full Screen Button (Note: Current problem is that right-click menus won’t show up when using the JavaFX fullscreen command).
  1. When loading a file, if a row has a missing value, it is skipped. Instead the program should keep it as a missing value and handle that properly in SOMs and other graphs.
  1. Some files are particularly large and should be split up if possible (eg. SOMMediator)
  1. Check Memory Management. For example, I think when you close a SOM tab, not all references to it are removed (in particular it is registered in pureMVC). Also allow things such as deleting a data set from the program.
  1. Document Fully