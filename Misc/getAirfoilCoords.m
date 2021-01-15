function Coords = getAirfoilCoords(filename)
    table = readtable(filename,'HeaderLines',1) ; % need to rework this
    Coords(1,:) = table2array(table(:,1))       ; % X coordinates
    Coords(2,:) = zeros(1,length(Coords(1,:)))  ; % Y coordinates, always 0 in dimensionless form
    Coords(3,:) = table2array(table(:,2))       ; % Z coordinates
end