function subParcellationHemi(subject,surface,hemi)
    if exist([subject '/label/temp/subParcellation' hemi '_temp.mat']),
        closeVertex=load([subject '/label/temp/subParcellation' hemi '_temp']);
        closeVertex=closeVertex.closeVertex;
    else
        closeVertex=closerVertex(subject,hemi);
        [s1 s2 s3]=mkdir([subject '/label/temp/']);
        save([subject '/label/temp/subParcellation' hemi '_temp' ],'closeVertex');
    end
    backtrackParcellation(subject,surface,closeVertex,hemi);
    checkParcels(hemi,subject,closeVertex,surface);    
end