function createFuselagePositionings(obj)
    % need to fix the lengths and the sweep angles!!!!!!!!!!!!!!!
    path = '/cpacs/vehicles/aircraft/model/fuselages/fuselage/positionings' ;
    fuselageSec_table   = readtable(['.\AircraftInputs\fuselageInput.csv'],'HeaderLines',1);
    fuselageSec_table = fuselageSec_table(1:3,5:10) ;
    [row , ~] = size(fuselageSec_table) ;
    for i = 1:row 
        Positionings(i).name    = table2cell (fuselageSec_table(i,1)) ;
        Positionings(i).count   = table2array(fuselageSec_table(i,2)) ;
        Positionings(i).profile = table2cell (fuselageSec_table(i,3)) ;
        Positionings(i).contour = table2cell (fuselageSec_table(i,4)) ;
        Positionings(i).length  = table2array(fuselageSec_table(i,5)) ;
        Positionings(i).sweep   = table2array(fuselageSec_table(i,6)) ;
    end
    cumsum_temp = cumsum([Positionings(:).count]) ;
    for i = 1:row
        FrameCount = Positionings(i).count ;
        switch char(Positionings(i).contour)
            case 'powerlaw'
                Frame_ds = Positionings(i).length/FrameCount ;
            case 'logarithmic'
                Frame_ds = Positionings(i).length/FrameCount ;
            case 'parabolic'
                Frame_ds = Positionings(i).length/FrameCount ;
            case 'straight'
                Frame_ds = Positionings(i).length/FrameCount ;
        end
        if Positionings(i).sweep == 90 
            dihedral = 0 ;
        else 
            dihedral = 90 ;
        end
        for j = 1:FrameCount
            if i == 1
                index = j+(i-1)*FrameCount ;
            else
                index = j+cumsum_temp(i-1) ;
            end
            positioning_path = [path '/positioning[' num2str(index) ']'] ;
            % Add Positionings
            tixiCreateElement(obj.tixiHandle,path,'positioning')
            tixiAddTextAttribute(obj.tixiHandle,positioning_path,'uID', ['FuselagePositioningFrame' num2str(index)])
            tixiAddTextElement  (obj.tixiHandle,positioning_path,'name',['FuselagePositioningFrame' num2str(index)])
            tixiAddDoubleElement(obj.tixiHandle,positioning_path,'dihedralAngle',dihedral,'%.0f')
            if index == 1
                tixiAddDoubleElement(obj.tixiHandle,positioning_path,'length',0.000001,'%.6f')
            else
                tixiAddDoubleElement(obj.tixiHandle,positioning_path,'length',Frame_ds,'%.6f')
            end
            if index ~= 1
                tixiAddTextElement(obj.tixiHandle,positioning_path,'fromSectionUID',['FuselageFrame' num2str(index-1)])
            end
            tixiAddDoubleElement(obj.tixiHandle,positioning_path,'sweepAngle',Positionings(i).sweep,'%.1f')
            tixiAddTextElement(obj.tixiHandle,positioning_path,'toSectionUID',['FuselageFrame' num2str(index)])
        end
    end
end