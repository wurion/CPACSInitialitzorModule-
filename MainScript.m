clear all
close all
clc

tigl_path = 'C:\Program Files\TIGL 3.0.0' ;
tixi_path = 'C:\Program Files\TIXI 3.0.3' ;

%% Add TiXi & TiGL paths
addpath(genpath(tigl_path))
addpath(genpath(tixi_path))

%% --File inputs
file_name           = 'cpacs' ;
% Header Info
header.name         = 'muster' ; 
header.creator      = 'muster' ; 
header.version      = '0.2' ; 
header.description  = 'muster' ; 
header.cpacs_ver    = '3.0'	; 
% --

%% --Aircraft Info
Aircraft_Info.Name          = 'HORYZN_Delta' ;
Aircraft_Info.Version       = '0.0.2' ;
Aircraft_Info.Description   = 'New Tree for aircraft components.' ;
% --

%% -- Fuselage Info
Fuselage_Info.Name          = 'Regular' ; % regular - modified etc
Fuselage_Info.Description   = 'Just a regular sausage' ; % regular - modified etc


%% Creating CPACS File
CPACS = CPACS_Initializer(file_name,header,Aircraft_Info) ;
CPACS.createXmlTreeMold                  ;
CPACS.createFuselage(Fuselage_Info) ;
% CPACS.createWing        ;
% CPACS.createStabilizer ;
CPACS.enterInputFSM(csv_nameFSM) ;
CPACS.enterInputFBM(csv_nameFBM) ;
CPACS.SaveNClose ;


%% Remove TiXi & TiGL paths
rmpath(genpath(tigl_path))
rmpath(genpath(tixi_path))
