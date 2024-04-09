

# SimilaritySearch Prolog Project

## Overview
This Prolog project implements an image similarity search algorithm using histograms. Given an image query, the algorithm finds the most similar images from a dataset based on their histogram representations.

## Project Structure
- `projet24.pl`: Main Prolog file containing the implementation of the similarity search algorithm.
- `queryImages/`: Directory containing image query files.
- `imageDataset2_15_20/`: Directory containing the dataset of images.
- `README.md`: This file providing an overview of the project.

## Usage
1. Ensure you have SWI-Prolog installed on your system.
2. Run SWI-Prolog and consult the `projet24.pl` file.
3. Use the `similarity_search/2` predicate to perform image similarity search. Example: `similarity_search('q00.jpg.txt', SimilarImagesList)`.

## Example Output
Sample output for a few image queries:

```prolog
?- similarity_search('q00.jpg.txt', SimilarImagesList).
SimilarImagesList = [('1144.jpg.txt', 0.9999999999999998), ('3806.jpg.txt', 0.707453703703704), ('3714.jpg.txt', 0.668431712962963), ...].
```


## Author
Mor Fall SYlla

