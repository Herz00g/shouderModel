function WayPoints = MUSCLE_TOOL_spline_build(AnchorPoints, Type, NbSeg)
% UICONTROL Callback constructs the spline for the muscle wrapping
%--------------------------------------------------------------------------
% Syntax :
% WayPoints = MUSCLE_TOOL_spline_build(AnchorPoints, Type, NbSeg)
%--------------------------------------------------------------------------
%
% File Description :
% This function is generates the splines for the muscle insertions and
% origins.
%--------------------------------------------------------------------------


% Initialise the outputs
WayPoints = [];

%--------------------------------------------------------------------------
% First Order linear interpolation between end-points only
if isequal(Type, 'Linear')
    P0 = AnchorPoints{1,1};
    P1 = AnchorPoints{1,2};
    P2 = AnchorPoints{1,3};
    
    mu = 1/(NbSeg*2);
    for i = 1:NbSeg
        WayPoints = [WayPoints, P0 + mu*(P2 - P0)];
        mu = mu + 1/NbSeg;
    end
%--------------------------------------------------------------------------
% First Order Piecewise linear interpolation    
elseif isequal(Type, 'Bi-Linear')
    P0 = AnchorPoints{1,1};
    P1 = AnchorPoints{1,2};
    P2 = AnchorPoints{1,3};
    
    mu = 1/(NbSeg*2);
    for i = 1:NbSeg
        if mu < 0.5
            WayPoints = [WayPoints, P0 + 2*mu*(P1 - P0)];
        else
            WayPoints = [WayPoints, P1 + 2*(mu-0.5)*(P2 - P1)];
        end
        mu = mu + 1/NbSeg;
    end
    
%--------------------------------------------------------------------------    
% Third Order Spline interpolation
elseif isequal(Type, '3rd Order')
    P0 = AnchorPoints{1,1};
    P1 = AnchorPoints{1,2};
    P2 = AnchorPoints{1,3};
    
    s = 1/2;
    Ma = [ -s, 2-s,   s-2,  s;
          2*s, s-3, 3-2*s, -s;
           -s,   0,     s,  0;
            0,   1,     0,  0];
        
    Mb = [P0'; P0'; P1'; P2'];
    Mc = [P0'; P1'; P2'; P2'];
    
    mu = 1/(NbSeg*2);
    for i = 1:NbSeg
        if mu < 0.5
            muk = 2*mu;
            Mu = [muk^3, muk^2, muk, 1];
            WayPoints = [WayPoints, (Mu*Ma*Mb)'];
        else
            muk = 2*(mu - 0.5);
            Mu = [muk^3, muk^2, muk, 1];
            WayPoints = [WayPoints, (Mu*Ma*Mc)'];
        end
        mu = mu + 1/NbSeg;
    end
end
return;