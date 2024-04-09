% CSI2520: SimilaritySearch project in Prolog
% Name: Mor Fall Sylla
% Student number: 300218857


% dataset(DirectoryName)
% Specifies the location of the image dataset.


% You may need the relative path to the dataset directory or your full path to the dataset directory when you run code.


queryDataset('/Users/morfallsylla/Desktop/SimilaritySearch_Prolog/queryImages').
dataset('/Users/morfallsylla/Desktop/SimilaritySearch_Prolog/imageDataset2_15_20').

% directory_textfiles(DirectoryName, ListOfTextfiles)
% Produces the list of text files in a directory.
directory_textfiles(D, Textfiles) :-
    directory_files(D, Files),
    include(isTextFile, Files, Textfiles).

% isTextFile(Filename)
% Checks if a file has a .txt extension.
isTextFile(Filename) :-
    string_concat(_, '.txt', Filename).

% read_hist_file(Filename, ListOfNumbers)
% Reads a histogram file and produces a list of numbers (bin values).
read_hist_file(Filename, Numbers) :-
    open(Filename, read, Stream),
    read_line_to_string(Stream, _),
    read_line_to_string(Stream, String),
    close(Stream),
    atomic_list_concat(List, ' ', String),
    atoms_numbers(List, Numbers).

% similarity_search(QueryFile, SimilarImageList)
% Returns the list of images similar to the query image.
similarity_search(QueryFile, SimilarList) :-
    dataset(D),
    directory_textfiles(D, TxtFiles),
    queryDataset(D1),
    atomic_list_concat([D1, QueryFile], '/', FullQueryFile),
    similarity_search(FullQueryFile, D, TxtFiles, SimilarList).

% similarity_search(QueryFile, DatasetDirectory, HistoFileList, SimilarImageList)
% Initiates the similarity search process.
similarity_search(FullQueryFile, DatasetDirectory, DatasetFiles, Best) :-
    read_hist_file(FullQueryFile, QueryHisto),
    compare_histograms(QueryHisto, DatasetDirectory, DatasetFiles, Scores),
    sort(2, @>, Scores, Sorted),
    take(Sorted, 5, Best).

% compare_histograms(QueryHisto, DatasetDirectory, DatasetFiles, Scores)
% Compares a query histogram with histograms of dataset files and returns the similarity scores.
compare_histograms(_, _, [], []).
compare_histograms(QueryHistogram, DatasetDirectory, [File | RestFiles], [(File, SimilarityScore) | RestScores]) :-
    atomic_list_concat([DatasetDirectory, File], '/', FullPath),
    read_hist_file(FullPath, DatasetHistogram),
    sum_list(QueryHistogram, TotalQueryPixels),
    sum_list(DatasetHistogram, TotalDatasetPixels), 
    histogram_intersection(QueryHistogram, TotalQueryPixels, DatasetHistogram, TotalDatasetPixels, SimilarityScore),
    compare_histograms(QueryHistogram, DatasetDirectory, RestFiles, RestScores).

% histogram_intersection(Histogram1, Histogram2, Score)
% Computes the intersection similarity score between two histograms.
% Score is between 0.0 and 1.0 (1.0 for identical histograms).
histogram_intersection([], _, [], _, 0.0).
histogram_intersection([Bin1 | RestBins1], TotalPixels1, [Bin2 | RestBins2], TotalPixels2, IntersectionScore) :-
    histogram_intersection(RestBins1, TotalPixels1, RestBins2, TotalPixels2, RestIntersectionScore),
    NormalizedBin1 is Bin1 / TotalPixels1,
    NormalizedBin2 is Bin2 / TotalPixels2,
    SmallestNormalizedBin is min(NormalizedBin1, NormalizedBin2),
    IntersectionScore is SmallestNormalizedBin + RestIntersectionScore.

% take(List, K, KList)
% Extracts the first K items in a list.
take(Src, N, L) :- findall(E, (nth1(I, Src, E), I =< N), L).

% atoms_numbers(ListOfAtoms, ListOfNumbers)
% Converts a list of atoms into a list of numbers.
atoms_numbers([], []).
atoms_numbers([X | L], [Y | T]) :- atom_number(X, Y), atoms_numbers(L, T).
atoms_numbers([X | L], T) :- \+ atom_number(X, _), atoms_numbers(L, T).
