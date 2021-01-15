function createFuselageTransformation(obj)
    % precision = 4 decimals
    path = '/cpacs/vehicles/aircraft/model/fuselages/fuselage/transformation' ;
    tixiAddTextAttribute(obj.tixiHandle,path,'xsi:type','transformationType')
    tixiAddTextAttribute(obj.tixiHandle,path,'uID','Fuselage_Transformation')
    fuselageTrafo_table   = readtable(['.\AircraftInputs\fuselageInput.csv'],'HeaderLines',1);
    fuselageTrafo_mat     = table2array(fuselageTrafo_table(1:3,2:4)) ;
    if sum(sum(isnan(fuselageTrafo_mat))) ~= 0
        error('NaN in fuselage trafo input')
    end
    if fuselageTrafo_mat(3,1) == 0
        fuselageTrafo_mat(3,1) = 0.000001 ; %otherwise tigl crashes
    end
    tixiCreateElement(obj.tixiHandle,path,'scaling')
    tixiCreateElement(obj.tixiHandle,path,'rotation')
    tixiCreateElement(obj.tixiHandle,path,'translation')
    tixiAddPoint(obj.tixiHandle,[path '/scaling'],      fuselageTrafo_mat(1,1),fuselageTrafo_mat(1,2),fuselageTrafo_mat(1,3),'%.6f')
    tixiAddPoint(obj.tixiHandle,[path '/rotation'],     fuselageTrafo_mat(2,1),fuselageTrafo_mat(2,2),fuselageTrafo_mat(2,3),'%.6f')
    tixiAddPoint(obj.tixiHandle,[path '/translation'],  fuselageTrafo_mat(3,1),fuselageTrafo_mat(3,2),fuselageTrafo_mat(3,3),'%.6f')
    tixiAddTextAttribute(obj.tixiHandle,[path '/scaling'],'type','pointType')
    tixiAddTextAttribute(obj.tixiHandle,[path '/rotation'],'type','pointType')
    tixiAddTextAttribute(obj.tixiHandle,[path '/translation'],'type','pointType')
    tixiAddTextAttribute(obj.tixiHandle,[path '/scaling'],'uID','Fuselage_Transformation_Scaling')
    tixiAddTextAttribute(obj.tixiHandle,[path '/rotation'],'uID','Fuselage_Transformation_Rotation')
    tixiAddTextAttribute(obj.tixiHandle,[path '/translation'],'uID','Fuselage_Transformation_Translation')
end