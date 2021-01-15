clear all
% close all
clc

%% Section inputs
MaxDimYZ = [0.2 0.2] ; % maximum dimensions of fuselage in Y and Z [m]
Sections            = {'Front';'Mid';'Back'}    ;
SectionFrameCount   = [100;100;100]                ; % number of profile frames in the given section (higher=finer)
SectionLenghtsType  = {'logarithmic';'uniform';'revlogarithmic'} ; % type of frame distribution in section (could use rework!)
SectionLenghts      = [0.5;1.5;1]               ; % lenghts of individual sections in x[m]
SectionColors       = {'b';'r';'g'}             ; % for plotting only
SectionPlotCheck    = {true;true;true}          ; % for plotting only
SectionYZRatioType  = {'logarithmic';'linear';'logarithmic'} ; % 'logarithmic', 'linear'
SectionYZRatios     = [0.0002 0.8 0.0002 1; 0.8 0.8 1 1; 0.8 0.1 1 0.3] ; % no bigger than 1!!!!!!!!
%0.0002 =< fillet_radius =< 1
SectionsFillets     = [1 0.5; 0.5 0.5;0.5 0.3]  ; % fillet radius from beginning of section to end (real radius=SectionsFillets*MaxDimYZ)
SweepType = 'deg' ; % 'deg' - 'meter'
% SectionsSweepZ      = [-0.15 0 ; 0 0 ; 0 0.2]  ; % sweep in Z [m]
% SectionsSweepY      = [0 0 ; 0 0 ; 0 0]         ; % sweep in Y [m] (breaks symmetry, not advised)x
SectionsSweepZ      = [120 90 ; 90 90 ; 90 40]  ; % sweep in Z [deg]  (90° is no sweep! 90> is down, 90< is up sweep)
SectionsSweepY      = [90 90 ; 90 90 ; 90 90] ;
%% Profile detail inputs
profile = 'rounded_rectangle' ; % works for circles too, just set fillet to 1;
PointsCount = 200 ; % multitude of 4! (number of coordinate points for any given profile 

SaveCoordsCheck = true ;
%% Calc
Section_lengths_Cumsum = cumsum(SectionLenghts) ;
figure(1)
for ii = 1:length(Sections)
    FrameCount = SectionFrameCount(ii) ;
    % Get YZ & ZY Ratios
    switch SectionYZRatioType{ii}
        case 'logarithmic'
            YZ_ratio = log(linspace(exp(SectionYZRatios(ii,1)),exp(SectionYZRatios(ii,2)),FrameCount)) ;
            ZY_ratio = log(linspace(exp(SectionYZRatios(ii,3)),exp(SectionYZRatios(ii,4)),FrameCount)) ;
        case 'linear'
            YZ_ratio = linspace(SectionYZRatios(ii,1),SectionYZRatios(ii,2),FrameCount) ;
            ZY_ratio = linspace(SectionYZRatios(ii,3),SectionYZRatios(ii,4),FrameCount) ;
    end
    % Get fillets
    fillets = linspace(SectionsFillets(ii,1),SectionsFillets(ii,2),FrameCount) ;
    % Get sweep
    switch SweepType
        case 'deg'
            SweepY_begin  = cosd(SectionsSweepY(ii,1))*MaxDimYZ(1) ;
            SweepY_end    = cosd(SectionsSweepY(ii,2))*MaxDimYZ(1) ;
            SweepY = linspace(SweepY_begin,SweepY_end,FrameCount) ;
            SweepZ_begin  = cosd(SectionsSweepZ(ii,1))*MaxDimYZ(2) ;
            SweepZ_end    = cosd(SectionsSweepZ(ii,2))*MaxDimYZ(2) ;
            SweepZ = linspace(SweepZ_begin,SweepZ_end,FrameCount) ;
        case 'meter'
            SweepZ = linspace(SectionsSweepZ(ii,1),SectionsSweepZ(ii,2),FrameCount) ;
            SweepY = linspace(SectionsSweepY(ii,1),SectionsSweepY(ii,2),FrameCount) ;
    end
    % Get X coordinates
    switch SectionLenghtsType{ii}
        case 'logarithmic'
            X_Coords = linspace(0,SectionLenghts(ii),FrameCount) ;
            for j = 2:FrameCount-1
                X_Coords(j) = X_Coords(j)*(j/(FrameCount-1));
            end
            if ii ~=1
                X_Coords = rescale(X_Coords,Section_lengths_Cumsum(ii-1)+0.001,Section_lengths_Cumsum(ii)) ;
            else 
                X_Coords = rescale(X_Coords,0,Section_lengths_Cumsum(ii)) ;
            end
        case 'uniform'
            if ii ~=1
                X_Coords = linspace(Section_lengths_Cumsum(ii-1)+0.001,Section_lengths_Cumsum(ii),FrameCount) ;
            else
                X_Coords = linspace(0,Section_lengths_Cumsum(ii),FrameCount) ;
            end
        case 'revlogarithmic'
            X_Coords = linspace(0,SectionLenghts(ii),FrameCount) ;
            x_res = ((SectionLenghts(ii))/(FrameCount-1)).*linspace((FrameCount-1),1,(FrameCount-1))./(FrameCount-1).*200 ;
            X_Coords(1) = 0.001 ;
            for j = 1:FrameCount-1
                X_Coords(j+1) = X_Coords(j) + x_res(j) ;
            end
            if ii ~=1
                X_Coords = rescale(X_Coords,Section_lengths_Cumsum(ii-1)+0.00001,Section_lengths_Cumsum(ii)) ;
            else 
                X_Coords = rescale(X_Coords,0,Section_lengths_Cumsum(ii)) ;
            end
    end
        
    % Calculate Frames
    for i = 1:FrameCount
        % Get Frame in dimensionless form
        FrameCoords_dimless(i).([Sections{ii}]).Coords = generateFuselageProfile(   profile         ,...
                                                                                    PointsCount     ,...
                                                                                    fillets(i)      ,...
                                                                                    YZ_ratio(i)     ,...
                                                                                    ZY_ratio(i)     ) ; %#ok<SAGROW>
        % Get Frame with dimensions
        FrameCoords_Real(i).([Sections{ii}]).Coords  = [ones(1,PointsCount).*X_Coords(i) ;...
                                                        FrameCoords_dimless(i).([Sections{ii}]).Coords(2,:).*MaxDimYZ(1)+SweepY(i) ;...
                                                        FrameCoords_dimless(i).([Sections{ii}]).Coords(3,:).*MaxDimYZ(2)+SweepZ(i) ;...
                                                        ] ; %#ok<SAGROW>
        % Plot Frame                                
        if SectionPlotCheck{ii}
            plot3(FrameCoords_Real(i).([Sections{ii}]).Coords(1,:),... % X [m]
                  FrameCoords_Real(i).([Sections{ii}]).Coords(2,:),... % Y [m]
                  FrameCoords_Real(i).([Sections{ii}]).Coords(3,:),... % Z [m]
                  SectionColors{ii},'LineWidth',1.2) ;
            hold on
        end
    end
end
axis equal
view(0,0)
if SaveCoordsCheck
    for ii = 1:length(Sections)
        FrameCount = SectionFrameCount(ii) ;
        for i = 1:FrameCount
            if i == 1 && ii == 1
                matDimless = FrameCoords_dimless(i).([Sections{ii}]).Coords ;
                matReal    = FrameCoords_Real(i).([Sections{ii}]).Coords ;
            else
                matDimless = vertcat(matDimless,FrameCoords_dimless(i).([Sections{ii}]).Coords) ; %#ok<AGROW>
                matReal    = vertcat(matReal,FrameCoords_Real(i).([Sections{ii}]).Coords) ; %#ok<AGROW>
            end
        end
    end
end
% Write matrices into files
writematrix(matDimless      ,'FuselageCoordsDimless.csv')
writematrix(matReal         ,'FuselageCoordsReal.csv')