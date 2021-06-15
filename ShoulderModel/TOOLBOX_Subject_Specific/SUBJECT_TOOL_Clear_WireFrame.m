function SUBJECT_TOOL_Clear_WireFrame(SPlotHandles)

if isfield(SPlotHandles,'Scaled') == 1
    
    delete(SPlotHandles.Scaled.WireFrameHandle);
    delete(SPlotHandles.Scaled.Glenoid);
    delete(SPlotHandles.Ellipsoid_scaled);
end
           
return;
