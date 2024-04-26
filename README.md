# Project README

## Overview
This document details the usage of the `geo2` Prolog program implemented in scryer prolog. The examples demonstrate how to perform various operations with trees, such as insertion and querying.

### How to Load the Program
To start using the program, load the `geo2.pl` file into your Prolog environment:

```prolog
?- [geo2].
true.
```

### Examples
Examples
Inserting Elements

To insert elements into the tree, use the insert predicate:
```
?- insert(50, 60).
true
```

### Querying Right Children

To find the right children in the tree, use the right_child predicate. It returns pairs where the first element is a node and the second element is its right child:

```
?- right_child(X, Y).
X = 100, Y = 150;
X = 50, Y = 60.
```

### Inserting Random Elements

To insert a random element within a specified range and then fail (to prevent backtracking from undoing the insertion):

```
?- use_module(library(random)). % optional to set the seed
   true.
?- set_random(seed(439)). % optional to change results each time choose a random number
   true.
?- between(1,20,_), insert_random(50), fail.
false.
```

### Generating SVG Output

To generate an SVG file from the current state of the tree:

```
?- write_file("my_binary_tree.svg").
```

### Notes

The write_file command does not produce a Prolog query result but will write the output to the specified SVG file.