function Coords = generateFuselageProfile(profile,PointsCount,fillet_radius,YZ_ratio,ZY_ratio)
    % generates fuselage profile on YZ plane, X coordinates are zero
    %% Calc
    Coords_X = zeros(1,PointsCount) ;
    switch profile
        case 'rounded_rectangle'
            PointsCount_quarter = PointsCount /4 ;
            nofillet = 1 - fillet_radius ;
            if fillet_radius>0.5
                PointCount_line   = ceil(PointsCount_quarter * (nofillet)) ;
                PointCount_fillet = floor(PointsCount_quarter * (fillet_radius)) ;
            else
                PointCount_line   = floor(PointsCount_quarter * (nofillet)) ;
                PointCount_fillet = ceil(PointsCount_quarter * (fillet_radius)) ;
            end
            if PointCount_line+PointCount_fillet ~=PointsCount_quarter
                error('calculation error')
            end
            arc1 = linspace(2*pi*(1/4) ,2*pi*(0/4),PointCount_fillet) ;
            arc2 = linspace(2*pi*(4/4) ,2*pi*(3/4),PointCount_fillet) ;
            arc3 = linspace(2*pi*(3/4) ,2*pi*(2/4),PointCount_fillet) ;
            arc4 = linspace(2*pi*(2/4) ,2*pi*(1/4),PointCount_fillet) ;
            Coords_Y = [linspace(-1+fillet_radius,1-fillet_radius,PointCount_line)  rescale(abs(cos(arc1)),(1-fillet_radius)+0.0001,0.9999)...
                        ones(1,PointCount_line)                                     rescale(abs(cos(arc2)),(1-fillet_radius)+0.0001,0.9999)...
                        linspace(1-fillet_radius,-1+fillet_radius,PointCount_line) -rescale(abs(cos(arc3)),(1-fillet_radius)+0.0001,0.9999)...
                        ones(1,PointCount_line)*(-1)                               -rescale(abs(cos(arc4)),(1-fillet_radius)+0.0001,0.9999)...
            ].*ZY_ratio ;
            Coords_Z = [ones(1,PointCount_line)                                     rescale(abs(sin(arc1)),(1-fillet_radius)+0.0001,0.9999)...
                        linspace(1-fillet_radius,-1+fillet_radius,PointCount_line) -rescale(abs(sin(arc2)),(1-fillet_radius)+0.0001,0.9999)...
                        ones(1,PointCount_line)*(-1)                               -rescale(abs(sin(arc3)),(1-fillet_radius)+0.0001,0.9999)...
                        linspace(-1+fillet_radius,1-fillet_radius,PointCount_line)  rescale(abs(sin(arc4)),(1-fillet_radius)+0.0001,0.9999)...
            ].*YZ_ratio ;
        otherwise
            error('no profile')
    end
    Coords = [Coords_X ; Coords_Y ; Coords_Z] ;
end