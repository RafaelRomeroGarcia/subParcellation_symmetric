function checkParcels(hemi,path_subj,vecinos,surface)

[vertices, label, colortable]=read_annotation([path_subj 'label/temp/' hemi '.' int2str(surface) '_temp.aparc.annot']);
path_surf_inflated=[path_subj 'surf/' hemi '.inflated'];
[vertCoor, faceInflated]=read_surf(path_surf_inflated);    
labelList=colortable.table(:,5);
numLabels=size(labelList,1);
for i=2:numLabels  
    numLabel=labelList(i);
    vertexRegion=extractRegion(numLabel,label); 
    [joint vertexIn]=checkJoint(vertexRegion,vecinos,label);
    while not(joint)
        colortable.struct_names(i)
        [result label]=reJoint(vertexRegion,vecinos,label,vertexIn,vertCoor);
        vertexRegion=extractRegion(numLabel,label); 
        if result
            [joint vertexIn]=checkJoint(vertexRegion,vecinos,label);
        else
            joint=true;
        end
    end
 
end
Write_Brain_Annotation([path_subj 'label/temp/' hemi '.' int2str(surface) '_temp.aparc.annot'],vertices, label, colortable);
end

