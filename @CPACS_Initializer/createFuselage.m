function createFuselage(obj,fuselage_info)
    %% Add name and description
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model','fuselages')
    tixiAddTextAttribute(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages','xsi:type','fuselagesType') 
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages','fuselage')
    tixiAddTextAttribute(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','xsi:type','fuselageType')
    tixiAddTextAttribute(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','uID',fuselage_info.Name)  
    tixiAddTextElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','name',fuselage_info.Name)
    tixiAddTextElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','description',fuselage_info.Description)
    %% Create Parent Elements
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','transformation')
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','sections')
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','segments')
    tixiCreateElement(obj.tixiHandle,'/cpacs/vehicles/aircraft/model/fuselages/fuselage','positionings')
    %% Create transformation
    obj.createFuselageTransformation ;
    %% Create profiles
    obj.createFuselageProfiles ;
    %% Create sections
    obj.createFuselageSections ;
    %% Create segments
    obj.createFuselageSegments ;
    %% Create segments
    obj.createFuselagePositionings ;
end