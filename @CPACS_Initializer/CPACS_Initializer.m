classdef CPACS_Initializer < handle
    % This class creates a predetermined CPACS structure (i.e. some paths are fixed and should not be changed later on!)
    % It doesn't open and read an existing file!
    % Any preexisting files with the same name and path will be deleted!
    % This is where Design Loop begins!
    properties
        file_name
        file_header
        aircraft_info
        tixiHandle
        tiglHandle
        FSM_Table
        FBM_Table
    end
    methods
        function obj = CPACS_Initializer(file_name,header,aircraft_info)
            obj.file_name       = file_name     ;
            obj.file_header     = header        ;
            obj.aircraft_info   = aircraft_info ;
            file_full_path = ['.\Output\' file_name '.xml'] ;
            if isfile(file_full_path)
                delete(file_full_path)
            end
            disp('Creating a new CPACS file...')
            tixiHandle     = tixiCreateDocument('cpacs') ;
            tixiAddCpacsHeader(tixiHandle,header.name,...
                                          header.creator,...
                                          header.version,...
                                          header.description,...
                                          header.cpacs_ver) ;
            % these are needed for namespace reasons
            tixiDeclareNamespace(tixiHandle,'/cpacs','http://www.w3.org/2001/XMLSchema-instance','xsi')
            tixiAddTextAttribute(tixiHandle,'/cpacs/header','xsi:type','headerType') 
            % Create necessary parent element structure (or tigl gives errors) (for v3.0.0)#
            tixiCreateElement(tixiHandle,'/cpacs','vehicles')
            tixiCreateElement(tixiHandle,'/cpacs/vehicles','aircraft')
            tixiCreateElement(tixiHandle,'/cpacs/vehicles/aircraft','model')
            tixiAddTextAttribute(tixiHandle,'/cpacs/vehicles','xsi:type','vehiclesType') 
            tixiAddTextAttribute(tixiHandle,'/cpacs/vehicles/aircraft','xsi:type','aircraftType') 
            tixiAddTextAttribute(tixiHandle,'/cpacs/vehicles/aircraft/model','xsi:type','aircraftModelType') 
            tixiAddTextAttribute(tixiHandle,'/cpacs/vehicles/aircraft/model','uID',aircraft_info.Name)
            tixiAddTextElement(tixiHandle,'/cpacs/vehicles/aircraft/model','name',aircraft_info.Name)
            tixiAddTextElement(tixiHandle,'/cpacs/vehicles/aircraft/model','description',aircraft_info.Description)
            
            tixiCreateElement(tixiHandle,'/cpacs/vehicles','profiles')
            tixiAddTextAttribute(tixiHandle,'/cpacs/vehicles/profiles','xsi:type','profilesType')
            tixiSaveDocument(tixiHandle,file_full_path)
            tixiCloseDocument(tixiHandle) 
            obj.tixiHandle = tixiOpenDocument(file_full_path) ;
            obj.tiglHandle = tiglOpenCPACSConfiguration(obj.tixiHandle,obj.aircraft_info.Name) ;
        end
        function SaveNClose(obj)
            tixiSaveDocument(obj.tixiHandle,['.\Output\' obj.file_name '.xml'])
%             tiglSaveCPACSConfiguration(obj.aircraft_info.Name,obj.tiglHandle)
            tiglCloseCPACSConfiguration(obj.tiglHandle)
            tixiCloseDocument(obj.tixiHandle)
            tixiCloseAllDocuments
            disp('   ...done.')
        end
    end
end