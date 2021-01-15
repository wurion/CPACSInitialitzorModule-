function createFuselageSegments(obj)
    path = '/cpacs/vehicles/aircraft/model/fuselages/fuselage/segments' ;
    tixiAddTextAttribute(obj.tixiHandle,path,'xsi:type','fuselageSegmentsType')
    fuselageSec_table   = readtable(['.\AircraftInputs\fuselageInput.csv'],'HeaderLines',1);
    fuselageSec_table = fuselageSec_table(1:3,5:9) ;
    [row , ~] = size(fuselageSec_table) ;
    for i = 1:row 
        Segments(i).name    = table2cell (fuselageSec_table(i,1)) ;
        Segments(i).count   = table2array(fuselageSec_table(i,2)) ;
        Segments(i).profile = table2cell (fuselageSec_table(i,3)) ;
        Segments(i).contour = table2cell (fuselageSec_table(i,4)) ;
        Segments(i).length  = table2array(fuselageSec_table(i,5)) ;
    end
    cumsum_temp = cumsum([Segments(:).count]) ;
    for i = 1:row
        FrameCount = Segments(i).count ;
        for j = 1:FrameCount
            if i == 1
                index = j+(i-1)*FrameCount ;
            else
                index = j+cumsum_temp(i-1) ;
            end
            if index == cumsum_temp(end)
                return
            end
            segment_path = [path '/segment[' num2str(index) ']'] ;
            % Add Segment
            tixiCreateElement(obj.tixiHandle,path,'segment')
            tixiAddTextAttribute(obj.tixiHandle,segment_path,'xsi:type','fuselageSegmentType')
            tixiAddTextAttribute(obj.tixiHandle,segment_path,'uID', ['FuselageSegment' num2str(index)])
            tixiAddTextElement  (obj.tixiHandle,segment_path,'name',['FuselageSegment' num2str(index)])
            tixiAddTextElement  (obj.tixiHandle,segment_path,'fromElementUID',['FuselageFrame' num2str(index) '_Elem'])
            tixiAddTextElement  (obj.tixiHandle,segment_path,'toElementUID',['FuselageFrame' num2str(index+1) '_Elem'])
        end
    end
end