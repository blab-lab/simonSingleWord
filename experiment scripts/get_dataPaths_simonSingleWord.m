function [dataPaths] = get_dataPaths_simonSingleWord
% Get data paths for simonSingleWord expt.

svec = [355 354 358 360 363 359 352 364 365 366 353 356 367 371 372 373 369 368 322 375];
dataPaths = get_acoustLoadPaths('simonSingleWord',svec);
