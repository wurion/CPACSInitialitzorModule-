function createXmlTreeMold(obj)
    % ToDo: Add subsections to ToolSpecific


    % The internal structure of the CPACS Tree is defined here. Refer here (or the document) for paths.
    
    %% Main Sections
    tixiCreateElement(obj.tixiHandle,'/cpacs','Hardware')           % For Hardware Data, no Analyses!!
                                                                    %   This section should only contain information necessary 
                                                                    %   to buy and build the vehicle!
    tixiCreateElement(obj.tixiHandle,'/cpacs','Analyses')           % Analyses of Modules go here.. (its internal structure is fixed!)
    tixiCreateElement(obj.tixiHandle,'/cpacs','DesignParameters')   % Design Inputs and selection of databases go here 
                                                                    %  (they should be the only inputs we should require!)
    tixiCreateElement(obj.tixiHandle,'/cpacs','ToolSpecific')       % Specific paths of modules go here
    
    %% Adding Aircraft
    % For any additional paths (such as ground station etc, 
    %    rename path_subsection and call tixiCreateElement(obj.tixiHandle,path_systems,path_subsection) and add components)
    path_systems = ['/cpacs/','Hardware'] ;
    % Creating Aircraft path 
    path_subsection = 'Aircraft' ;
    tixiCreateElement(obj.tixiHandle,path_systems,path_subsection) 
    tixiAddTextAttribute(obj.tixiHandle,[path_systems '/' path_subsection],'uID',[obj.aircraft_info.Name '_Hardware'])
    % Creating Aircraft components
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Info')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Wing')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Fuselage')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Stabilizers')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Drives')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'LandingGears')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Avionics')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Instruments')
    tixiCreateElement(obj.tixiHandle,[path_systems '/' path_subsection],'Payload')
    % Add Aircraft Info
    tixiAddTextElement(obj.tixiHandle,[path_systems '/' path_subsection '/Info'],'Name',        obj.aircraft_info.Name)
    tixiAddTextElement(obj.tixiHandle,[path_systems '/' path_subsection '/Info'],'Version',     obj.aircraft_info.Version)
    tixiAddTextElement(obj.tixiHandle,[path_systems '/' path_subsection '/Info'],'Description', obj.aircraft_info.Description)
    
    clearvars path_systems path_subsection
    
    %% Adding Analyses subsections
    path_systems = ['/cpacs/','Analyses'] ;
    tixiCreateElement(obj.tixiHandle,path_systems,'AerodynamicsData') 
    tixiCreateElement(obj.tixiHandle,path_systems,'PerformanceData')  
    tixiCreateElement(obj.tixiHandle,path_systems,'TrajectoryData') 
    tixiCreateElement(obj.tixiHandle,path_systems,'StructureData') 
    tixiCreateElement(obj.tixiHandle,path_systems,'MassBreakdown') 
    tixiCreateElement(obj.tixiHandle,path_systems,'OffDesignData') 

    clearvars path_systems
    
    %% Adding DesignParameters subsections
    path_systems = ['/cpacs/','DesignParameters'] ;
    tixiCreateElement(obj.tixiHandle,path_systems,'MissionParameters') 
    tixiCreateElement(obj.tixiHandle,path_systems,'DesignInputs') 
    tixiCreateElement(obj.tixiHandle,path_systems,'Databases') 
    
    clearvars path_systems
    
    %% Adding ToolSpecific subsections
    path_systems = ['/cpacs/','ToolSpecific'] ;
    tixiCreateElement(obj.tixiHandle,path_systems,'AerodynamicsModule')
    tixiCreateElement(obj.tixiHandle,path_systems,'BatteryShiftModule') 
    tixiCreateElement(obj.tixiHandle,path_systems,'FlightStateModule')
    tixiCreateElement(obj.tixiHandle,path_systems,'FlightBoxModule')
    tixiCreateElement(obj.tixiHandle,path_systems,'GeometryModule')
    tixiCreateElement(obj.tixiHandle,path_systems,'PerformanceModule') 
    tixiCreateElement(obj.tixiHandle,path_systems,'StructureModule') 
    
end