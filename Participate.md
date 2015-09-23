# How To Participate #

## Comment ##

There are a number of places you can send your comments/concerns/suggestions/offers of help/etc.

  * Comment on a wiki page (like this one)
  * Send a comment to the [google group](http://groups.google.com/group/ifcsoft).
  * Comment on the [blog](http://ifcsoft.blogspot.com/).
  * E-mail me at kyle.thayer AT gmail.com.


## Submit a bug report ##

There are plenty of things that don't work great in the current version. First see if it is already listed [here](http://code.google.com/p/ifcsoft/issues/list). If not, add a bug report.

## Help with the code ##

What you need:
  * [Java SDK with JavaFX 1.3](http://www.oracle.com/technetwork/java/javase/downloads/jdk-javafx-download-365541.html) (Not 2.0)
  * [Netbeans 6.9](http://netbeans.org/community/releases/69/) (Not V. 7)
  * Netbeans JavaFX plug-ins (search in Tools->Plugins)
  * [Mercurial](http://mercurial.selenic.com/)

If you want to just look at the code on your own computer, you can either look through it online [here](http://code.google.com/p/ifcsoft/source/browse/#hg%2Fsrc). Or if you have [Mercurial](http://mercurial.selenic.com/) installed you can download it by typing "`hg clone https://ifcsoft.googlecode.com/hg/ ifcsoft`" in the directory where you want it.

If you dowload the code, it is set up to be run in Netbeans (The JavaFX plugin only works in the older [Netbeans 6.9 release](http://netbeans.org/community/releases/69/)), but you will need to resolve 2 conflicts because the libraries don't get linked properly for some reason (they are in the "lib" directory). You should be able to get it to work in Eclipse or on the command line, but I'm not sure what you need to do to get the libraries linked properly.

If you want to make changes and have those incorporated into the main branch, first make your own clone [here](http://code.google.com/p/ifcsoft/source/checkout). Then check out your clone on Mercurial, make your changes, commit them and push them back up to your clone. Then you need to inform me that you've made a change that you think should go in the main branch. I will pull the change from your clone and if I like it, I will push it up into the main branch. For more information on how Mercurial works, start with [this website](http://hginit.com/). If you consistently offer good changes and show yourself reasonable in discussions, at some point I will add you to the official committer list.