function createFuselageProfiles(obj)
    % precision = 6 decimals
    path = '/cpacs/vehicles' ;
    tixiCreateElement(obj.tixiHandle,[path '/profiles'],'fuselageProfiles')
    tixiAddTextAttribute(obj.tixiHandle,[path '/profiles/fuselageProfiles'],'xsi:type','fuselageProfilesType')
    fuselageProfiles_table          = readtable(['.\AircraftInputs\fuselageProfiles.csv']);
    fuselageProfile_names_temp      = table2cell(fuselageProfiles_table(:,1)) ;
    fuselageProfile_names_indx      = find(~cellfun(@isempty,fuselageProfile_names_temp)) ;
    numberOfProfiles = length(fuselageProfile_names_indx) ;
    fuselageProfile_names{numberOfProfiles,1} = [] ;
    % get profile names
    for i = 1:numberOfProfiles
        fuselageProfile_names{i,1} = fuselageProfile_names_temp{fuselageProfile_names_indx(i)} ;
    end
    % cut empty lines from table
    fuselageProfiles_table = fuselageProfiles_table(1:fuselageProfile_names_indx(end)+2,:) ;
    for i = 1:numberOfProfiles
        index = fuselageProfile_names_indx(i) ;
        temp_table = fuselageProfiles_table(index:index+2,3:end) ;
        temp_mat = table2array(temp_table) ;
        array_len = length(temp_mat(1,:))-sum(isnan(temp_mat(1,:))) ;
        temp_mat = temp_mat(:,1:array_len) ;
        if sum(sum(isnan(temp_mat))) ~= 0
            error('NaN in fuselage profile input')
        end
        tixiCreateElement(obj.tixiHandle,[path '/profiles/fuselageProfiles'],'fuselageProfile') ;
        tixiAddTextElement(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']'],...
                                    'name',['Fuselage' fuselageProfile_names{i,1}]) ;
        tixiAddTextAttribute(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']'],...
                                    'uID',['Fuselage' fuselageProfile_names{i,1}]) ;
        tixiAddTextAttribute(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']'],...
                                    'xsi:type','profileGeometryType') ;
        tixiCreateElement(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']'],'pointList') ;
        tixiAddFloatVector(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']/pointList'],...
                                        'x',temp_mat(1,:),'%.6f') ;
        tixiAddFloatVector(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']/pointList'],...
                                        'y',temp_mat(2,:),'%.6f') ;
        tixiAddFloatVector(obj.tixiHandle,[path '/profiles/fuselageProfiles/fuselageProfile[' num2str(i) ']/pointList'],...
                                        'z',temp_mat(3,:),'%.6f') ;
    end
end