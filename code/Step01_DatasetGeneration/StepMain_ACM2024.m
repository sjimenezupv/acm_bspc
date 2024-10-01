close all;
clear all;
clc;

%% GLOBAL VARIABLES
RootDir = 'D:/GitHub/acm_bspc/'; %Root code/data/results folder
alpha   = 0.01;                  % Statistical significance


%% Comment/Uncomment depending on the dataset to be used


%% ALL DATA
%SaveDir   = [RootDir, 'results/'];
%SheetName = 'PAPER2024_ACM_ALL';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% MEN DATA
% SaveDir   = [RootDir, 'results/MEN/'];
% SheetName = 'PAPER2024_ACM_MEN';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% WOMEN DATA
% SaveDir   = [RootDir, 'results/WOMEN/'];
% SheetName = 'PAPER2024_ACM_WOM';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Program
Step00_Generate_ECG_DB;
Step01_Params;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%