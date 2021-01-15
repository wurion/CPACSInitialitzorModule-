function createFuselageSections(obj)
    % precision = 4 decimals
    % need to fix element scaling!!!!!!!!!!!!!!!!!!!!!!!
    
    
    path = '/cpacs/vehicles/aircraft/model/fuselages/fuselage/sections' ;
    tixiAddTextAttribute(obj.tixiHandle,path,'xsi:type','fuselageSectionsType')
    fuselageSec_table   = readtable(['.\AircraftInputs\fuselageInput.csv'],'HeaderLines',1);
    fuselageSec_table = fuselageSec_table(1:3,5:12) ;
    [row , ~] = size(fuselageSec_table) ;
    for i = 1:row 
        Sections(i).name    = table2cell (fuselageSec_table(i,1)) ;
        Sections(i).count   = table2array(fuselageSec_table(i,2)) ;
        Sections(i).profile = table2cell (fuselageSec_table(i,3)) ;
        Sections(i).contour = table2cell (fuselageSec_table(i,4)) ;
        Sections(i).length  = table2array(fuselageSec_table(i,5)) ;
        Sections(i).sweep   = table2array(fuselageSec_table(i,6)) ;
        Sections(i).dimY    = table2array(fuselageSec_table(i,7)) ;
        Sections(i).dimZ    = table2array(fuselageSec_table(i,8)) ;
    end
    cumsum_temp = cumsum([Sections(:).count]) ;
    for i = 1:row
        FrameCount = Sections(i).count ;
        
        for j = 1:FrameCount
            if i == 1
                index = j+(i-1)*FrameCount ;
            else
                index = j+cumsum_temp(i-1) ;
            end
            %YZ element scaling
            switch char(Sections(i).contour)
                case 'straight'
                    scaleY = Sections(i).dimY ;
                    scaleZ = Sections(i).dimZ ;
                case 'parabolic'
                    scaleY_coeff = Sections(i).length / (Sections(i).dimY)^2 ;
                    scaleZ_coeff = Sections(i).length / (Sections(i).dimZ)^2 ;
                    switch char(Sections(i).name)
                        case 'Front'
                            if j == 1
                                scaleY = 0.000001 ;
                                scaleZ = 0.000001 ;
                            else
                                minDistY = (0.000001 / scaleY_coeff)^0.5 ;
                                minDistZ = (0.000001 / scaleZ_coeff)^0.5 ;
                                DistY = minDistY+(Sections(i).length / FrameCount)*j ;
                                DistZ = minDistZ+(Sections(i).length / FrameCount)*j ;
                                scaleY = (DistY / scaleY_coeff)^0.5 ;
                                scaleZ = (DistZ / scaleZ_coeff)^0.5 ;
                            end
                        case 'Back'
                            if j == FrameCount
                                scaleY = 0.000001 ;
                                scaleZ = 0.000001 ;
                            else
                                minDistY = (0.000001 / scaleY_coeff)^0.5 ;
                                minDistZ = (0.000001 / scaleZ_coeff)^0.5 ;
                                DistY = minDistY+(Sections(i).length / FrameCount)*(FrameCount-j) ;
                                DistZ = minDistZ+(Sections(i).length / FrameCount)*(FrameCount-j) ;
                                scaleY = (DistY / scaleY_coeff)^0.5 ;
                                scaleZ = (DistZ / scaleZ_coeff)^0.5 ;
                            end
                    end
                case 'powerlaw'
                    log_coeff = 0.4 ;
%                     scaleY_coeff = Sections(i).dimY ;
%                     scaleZ_coeff = Sections(i).dimZ ;
                    switch char(Sections(i).name)
                        case 'Front'
                            if j == 1
                                scaleY = 0.000001 ;
                                scaleZ = 0.000001 ;
                            else
                                minDistY = 0.000001 ;%exp(abs(0.000001 - scaleY_coeff) / log_coeff) ;%*Sections(i).length ;
                                minDistZ = 0.000001 ; %exp((0.000001 - scaleZ_coeff) / log_coeff)*Sections(i).length ;
                                DistY = minDistY+(Sections(i).length / FrameCount)*(j-1) ;
                                DistZ = minDistZ+(Sections(i).length / FrameCount)*(j-1) ;
                                scaleY = (DistY/Sections(i).length)^log_coeff *Sections(i).dimY ;
                                scaleZ = (DistZ/Sections(i).length)^log_coeff *Sections(i).dimZ ;
                                
                            end
                    end
            end
            frame_path = [path '/section[' num2str(index) ']'] ;
            % Add Frame
            tixiCreateElement(obj.tixiHandle,path,'section')
            tixiAddTextAttribute(obj.tixiHandle,frame_path,'xsi:type','fuselageSectionType')
            tixiAddTextAttribute(obj.tixiHandle,frame_path,'uID', ['FuselageFrame' num2str(index)])
            tixiAddTextElement  (obj.tixiHandle,frame_path,'name',['FuselageFrame' num2str(index)])
            tixiCreateElement(obj.tixiHandle,frame_path,'transformation')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation'],'uID',['FuselageFrame' num2str(index) '_Transformation'])
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation'],'xsi:type','transformationType')
            tixiCreateElement(obj.tixiHandle,[frame_path '/transformation'],'scaling')
            tixiCreateElement(obj.tixiHandle,[frame_path '/transformation'],'rotation')
            tixiCreateElement(obj.tixiHandle,[frame_path '/transformation'],'translation')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/scaling'],'type','pointType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/rotation'],'type','pointType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/translation'],'type','pointType')
            tixiAddPoint(obj.tixiHandle,[frame_path '/transformation/scaling'],      1,1,1,'%.0f')
            tixiAddPoint(obj.tixiHandle,[frame_path '/transformation/rotation'],     -0,0,-0,'%.0f')
            tixiAddPoint(obj.tixiHandle,[frame_path '/transformation/translation'],  0,0,0,'%.0f')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/scaling'],...
                    'uID',['Frame' num2str(index) '_Transformation_Scaling'])
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/rotation'],...
                    'uID',['Frame' num2str(index) '_Transformation_Rotation'])
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/transformation/translation'],...
                    'uID',['Frame' num2str(index) '_Transformation_Translation'])
            % Add Frame Element
            tixiCreateElement(obj.tixiHandle,frame_path,'elements')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements'],'xsi:type','fuselageElementsType')
            tixiCreateElement(obj.tixiHandle,[frame_path '/elements'],'element')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element'],'xsi:type','fuselageElementType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element'],'uID', ['FuselageFrame' num2str(index) '_Elem'])
            tixiAddTextElement(obj.tixiHandle,[frame_path '/elements/element'],'name',['FuselageFrame' num2str(index) '_Elem'])
            tixiAddTextElement(obj.tixiHandle,[frame_path '/elements/element'],'profileUID',['Fuselage' char(Sections(i).profile)])
            tixiCreateElement(obj.tixiHandle,[frame_path '/elements/element'],'transformation')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation'],'xsi:type','transformationType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation'],'uID',...
                                    ['FuselageFrame' num2str(index) '_ElemTransformation'])
            tixiCreateElement(obj.tixiHandle,[frame_path '/elements/element/transformation'],'scaling')
            tixiCreateElement(obj.tixiHandle,[frame_path '/elements/element/transformation'],'rotation')
            tixiCreateElement(obj.tixiHandle,[frame_path '/elements/element/transformation'],'translation')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/scaling'],'type','pointType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/rotation'],'type','pointType')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/translation'],'type','pointType')
            tixiAddPoint(obj.tixiHandle,[frame_path '/elements/element/transformation/scaling'],    1,scaleY,scaleZ,'%.6f')
            tixiAddPoint(obj.tixiHandle,[frame_path '/elements/element/transformation/rotation'],   0,0,0,'%.0f')
            tixiAddPoint(obj.tixiHandle,[frame_path '/elements/element/transformation/translation'],0,0,0,'%.0f')
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/scaling'],...
                    'uID',['Frame' num2str(index) 'Elem_Transformation_Scaling'])
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/rotation'],...
                    'uID',['Frame' num2str(index) 'Elem_Transformation_Rotation'])
            tixiAddTextAttribute(obj.tixiHandle,[frame_path '/elements/element/transformation/translation'],...
                    'uID',['Frame' num2str(index) 'Elem_Transformation_Translation'])
        end
    end
end