clear all
% close all
clc

% filename = 'SD7037.dat' ;
% Coords = getAirfoilCoords(filename) ;
% figure
% plot3(Coords(1,:),Coords(2,:),Coords(3,:),'LineWidth',1.2)
% axis equal

WingLocXZ = [1 0.15] ; % Wing location in XZ [m]
% WingLocXZ = [2.8 0.18] ; % Wing location in XZ [m]
Sections = {'Center';'Mid';'Tip'}    ;
SectionAirfoils = {'SD7037.dat';'SD7037.dat';'SD7037.dat'} ;
SectionFrameCount   = [40;40;40]                ; % number of profile frames in the given section (higher=finer)
SectionLenghtsType  = {'uniform';'uniform';'uniform'} ; % type of frame distribution in section (could use rework!)
SectionLenghts      = [1;0.5;0.5]               ; % lenghts of individual sections in x[m]
% SectionLenghts      = [0.2;0.1;0.1]               ; % lenghts of individual sections in x[m]
SectionColors       = {'b';'r';'g'}             ; % for plotting only
SectionPlotCheck    = {true;true;true}          ; % for plotting only
SectionChordLenghts = [0.4 0.4 ; 0.4 0.3; 0.3 0.1] ; % chord in x[m] (beginnings and ends of each section) (actually just scales the airfoil)
% SectionChordLenghts = [0.2 0.2 ; 0.2 0.175; 0.175 0.15] ; % chord in x[m] (beginnings and ends of each section) (actually just scales the airfoil)
SweepType = 'deg' ; % 'deg' - 'meter'
SectionSweepX       = [90 ; 80 ; 70 ] ; % sweep in X[deg] (90° is no sweep! 90> is backward, 90< is forward sweep)
DihedralType = 'deg' ; % 'deg' - 'meter'
SectionDihedral     = [0 0; 0 2; 2 5] ; % dihedral in Z[deg]
% SectionTwist        = []

SaveCoordsCheck = true ;
%%
Section_lengths_Cumsum = cumsum(SectionLenghts) ;

SectionSweepXEnd = 0 ;
figure(1)
for ii = 1:length(Sections)
    FrameCount = SectionFrameCount(ii) ;
    % Get sweep
    switch SweepType
        case 'deg'
            if ii == 1
                SweepX_begin = 0  ;
            else
                SweepX_begin = SweepX(end) ;
            end
            SweepX_end   = cosd(SectionSweepX(ii))*Section_lengths_Cumsum(ii)  ;
            SweepX = linspace(SweepX_begin,SweepX_end,FrameCount) ;
            SectionSweepXEnd = SweepX(end) ;
    end
    % Get dihedral
    switch DihedralType
        case 'deg'
            Dihedral_begin  = sind(SectionDihedral(ii,1)) ;
            Dihedral_end    = sind(SectionDihedral(ii,2)) ;
            Dihedral        = linspace(Dihedral_begin,Dihedral_end,FrameCount) ;
    end
    % Get Y coordinates
    switch SectionLenghtsType{ii}
        case 'uniform'
            if ii ~=1
                Y_Coords = linspace(Section_lengths_Cumsum(ii-1)+0.001,Section_lengths_Cumsum(ii),FrameCount) ;
            else
                Y_Coords = linspace(0,Section_lengths_Cumsum(ii),FrameCount) ;
            end
    end
    % Get Chord lengths
    Chords = linspace(SectionChordLenghts(ii,1),SectionChordLenghts(ii,2),FrameCount) ;
    % Calculate Frames
    for i = 1:FrameCount
        % Get Frame in dimensionless form
        FrameCoords_dimless(i).([Sections{ii}]).Coords = getAirfoilCoords(SectionAirfoils{ii}) ; %#ok<SAGROW>
        airfoilPoints = length(FrameCoords_dimless(i).([Sections{ii}]).Coords(1,:)) ;
        % Get Frame with dimensions
        FrameCoords_Real(i).([Sections{ii}]).Coords =[FrameCoords_dimless(i).([Sections{ii}]).Coords(1,:).*Chords(i)+SweepX(i)+WingLocXZ(1) ;...
                                                  ones(1,airfoilPoints).*Y_Coords(i) ;...
                                                  FrameCoords_dimless(i).([Sections{ii}]).Coords(3,:).*Chords(i)+Dihedral(i)+WingLocXZ(2);...
                                                      ] ; %#ok<SAGROW>
        % Plot Frame                               
        if SectionPlotCheck{ii}
            plot3(FrameCoords_Real(i).([Sections{ii}]).Coords(1,:),... % X [m]
                  FrameCoords_Real(i).([Sections{ii}]).Coords(2,:),... % Y [m]
                  FrameCoords_Real(i).([Sections{ii}]).Coords(3,:),... % Z [m]
                  SectionColors{ii},'LineWidth',1.2) ;
            hold on
            plot3(FrameCoords_Real(i).([Sections{ii}]).Coords(1,:),... % X [m]
                 -FrameCoords_Real(i).([Sections{ii}]).Coords(2,:),... % Y [m]
                  FrameCoords_Real(i).([Sections{ii}]).Coords(3,:),... % Z [m]
                  'k','LineWidth',1.2) ;
        end        
    end
end
axis equal
view(0,90)





