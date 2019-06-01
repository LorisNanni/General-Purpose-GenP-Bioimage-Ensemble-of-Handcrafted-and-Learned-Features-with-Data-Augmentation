function LOCATE_Main
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Endogenous Path
 repository = 'G:\Research\ETAS\SubCellLoc\Endogenous/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Image Links for LOCATE Endogenous dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            actinFiles = dir([repository 'Actin/*_myc.tif']);
            endosomeFiles = dir([repository 'Endosome/*_myc.tif']);
            erFiles = dir([repository 'Er/*_myc.tif']);
            golgiFiles = dir([repository 'Golgi/*_myc.tif']);
            lysosomeFiles = dir([repository 'Lysosome/*_myc.tif']);
            microtubuleFiles = dir([repository 'Microtubule/*_myc.tif']);
            mitochondriaFiles = dir([repository 'Mitochondria/*_myc.tif']);
            nucleusFiles = dir([repository 'Nucleus/*_myc.tif']);
            peroxisomeFiles = dir([repository 'Peroxisome/*_myc.tif']);
            pmFiles = dir([repository 'PM/*_myc.tif']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Storing all the Image Links into a single variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            files = [ strcat('Actin/',{actinFiles.name}) ...
                      strcat('Endosome/',{endosomeFiles.name})...
                      strcat('Er/',{erFiles.name})...
                      strcat('Golgi/',{golgiFiles.name})...
                      strcat('Lysosome/',{lysosomeFiles.name})...
                      strcat('Microtubule/',{microtubuleFiles.name})...
                      strcat('Mitochondria/',{mitochondriaFiles.name})...
                      strcat('Nucleus/',{nucleusFiles.name})...
                      strcat('Peroxisome/',{peroxisomeFiles.name})...
                      strcat('PM/',{pmFiles.name})];
%% Transfected Path
% repository = 'D:/Research/Datasets/SubCellLoc/Transfected/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Image Links for LOCATE Transfected dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             actinFiles = dir([repository 'Actin/*_myc.tif']);
%             cytoplasmFiles = dir([repository 'Cytoplasm/*_myc.tif']);
%             endosomeFiles = dir([repository 'Endosome/*_myc.tif']);
%             erFiles = dir([repository 'Er/*_myc.tif']);
%             golgiFiles = dir([repository 'Golgi/*_myc.tif']);
%             lysosomeFiles = dir([repository 'Lysosome/*_myc.tif']);
%             microtubuleFiles = dir([repository 'Microtubule/*_myc.tif']);
%             mitochondriaFiles = dir([repository 'Mitochondria/*_myc.tif']);
%             nucleusFiles = dir([repository 'Nucleus/*_myc.tif']);
%             peroxisomeFiles = dir([repository 'Peroxisome/*_myc.tif']);
%             pmFiles = dir([repository 'PM/*_myc.tif']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Storing all the Image Links into a single variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             files = [ strcat('Actin/',{actinFiles.name}) ...
%                       strcat('Cytoplasm/',{cytoplasmFiles.name})...
%                       strcat('Endosome/',{endosomeFiles.name})...
%                       strcat('Er/',{erFiles.name})...
%                       strcat('Golgi/',{golgiFiles.name})...
%                       strcat('Lysosome/',{lysosomeFiles.name})...
%                       strcat('Microtubule/',{microtubuleFiles.name})...
%                       strcat('Mitochondria/',{mitochondriaFiles.name})...
%                       strcat('Nucleus/',{nucleusFiles.name})...
%                       strcat('Peroxisome/',{peroxisomeFiles.name})...
%                       strcat('PM/',{pmFiles.name})];
                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Variable Arrays for features storage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 M_2_255 = [];
 M_minus_T_2_255 = [];
 M_minus_T_2_M_plus_T = [];
 M_2_255_minus_T = [];
 M_minus_T_2_255_minus_T = [];
 M_plus_T_2_255_minus_T = [];
 M_plus_T_2_255 = [];
 
 ETAS_stats = [];
                 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    count = length(files);
    
    for im = 1: count
%%  Original Image Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                im
                I = imread([repository files{im}]);
                %J = imresize(I, [512 512]);
                disp([': Computing ',files{im}]);
%                 img = uint16(I);
img = I;
%% Threshold Adjacency Statistics
            threshold = 40;

            [t_adjacency E1 E2 E3 E4 E5 E6 E7] = ETAS(img, threshold);
 
            ETAS_stats = [ETAS_stats; t_adjacency];
            M_2_255 = [M_2_255; E1];
            M_minus_T_2_255 = [M_minus_T_2_255; E2];
            M_minus_T_2_M_plus_T = [M_minus_T_2_M_plus_T; E3];
            M_2_255_minus_T = [M_2_255_minus_T; E4];
            M_minus_T_2_255_minus_T = [M_minus_T_2_255_minus_T; E5];
            M_plus_T_2_255_minus_T = [M_plus_T_2_255_minus_T; E6];
            M_plus_T_2_255 = [M_plus_T_2_255; E7];
 
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Concatenation

%% Scaling the Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Scaling the Features End
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%% Saving Features in a mat file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save filename content;    stores the available content in new file filename.
%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Saving the features into mat file...');

 save E1 M_2_255;
 save E2 M_minus_T_2_255;
 save E3 M_minus_T_2_M_plus_T;
 save E4 M_2_255_minus_T;
 save E5 M_minus_T_2_255_minus_T;
 save E6 M_plus_T_2_255_minus_T;
 save E7 M_plus_T_2_255;
 
 save ETAS_feat ETAS_stats;
    
disp('Saving Done!');
%% Saving Done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc
end