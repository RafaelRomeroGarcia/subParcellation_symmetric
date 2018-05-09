function subParcellation_symetric(parcellation,path_subject,outName)
parcellation=num2str(parcellation);
path_annot_lh=[path_subject '/label/temp/lh.' parcellation '_temp.aparc.annot'];
path_annot_rh=[path_subject '/label/temp/rh.' parcellation '_temp.aparc.annot'];

path_dk_lh=[path_subject '/label/lh.aparc.annot'];
path_dk_rh=[path_subject '/label/rh.aparc.annot'];

path_pial_lh=[path_subject  '/surf/lh.inflated'];
path_pial_rh=[path_subject  '/surf/rh.inflated'];
[coor_lh, faces_lh] = read_surf(path_pial_lh);
[coor_rh, faces_rh] = read_surf(path_pial_rh);

[vertices_lh, label_lh, colortable_lh] = read_annotation(path_annot_lh);
[vertices_rh, label_rh, colortable_rh] = read_annotation(path_annot_rh);

vertices_lh_out=vertices_lh;
label_lh_out=zeros(numel(vertices_lh),1);
colortable_lh_out=[];
colortable_lh_out.numEntries=1;
colortable_lh_out.orig_tab=colortable_lh.orig_tab;
colortable_lh_out.struct_names{1}=colortable_lh.struct_names{1};
colortable_lh_out.table=colortable_lh.table(1,:);

vertices_rh_out=vertices_rh;
label_rh_out=zeros(numel(vertices_rh),1);
colortable_rh_out=[];
colortable_rh_out.numEntries=1;
colortable_rh_out.orig_tab=colortable_rh.orig_tab;
colortable_rh_out.struct_names{1}=colortable_rh.struct_names{1};
colortable_rh_out.table=colortable_rh.table(1,:);

[vertices_dk_lh, label_dk_lh, colortable_dk_lh] = read_annotation(path_dk_lh);

valid=[];
for ie=1:numel(colortable_dk_lh.struct_names)
     name=colortable_dk_lh.struct_names(ie);
     valid(ie)=not(isempty(name{1}));
end
colortable_dk_lh.numEntries=sum(valid);
colortable_dk_lh.struct_names=colortable_dk_lh.struct_names(find(valid));
colortable_dk_lh.table=colortable_dk_lh.table(find(valid),:);



[vertices_dk_rh, label_dk_rh, colortable_dk_rh] = read_annotation(path_dk_rh);

valid=[]
for ie=1:numel(colortable_dk_rh.struct_names)
     name=colortable_dk_rh.struct_names(ie);
     valid(ie)=not(isempty(name{1}));
end
colortable_dk_rh.numEntries=sum(valid);
colortable_dk_rh.struct_names=colortable_dk_rh.struct_names(find(valid));
colortable_dk_rh.table=colortable_dk_rh.table(find(valid),:);



for id=2:colortable_dk_lh.numEntries
    %odd regions will be extracted from left
    if mod(id,2)==0
        colortable_xh=colortable_lh;
        colortable_dk_yh=colortable_dk_rh;
        label_dk_xh=label_dk_lh;
        label_dk_yh=label_dk_rh;
        label_xh=label_lh;
        coor_xh=coor_lh;
        coor_yh=coor_rh;
        colortable_xh_out=colortable_lh_out;
        colortable_yh_out=colortable_rh_out;
        label_xh_out=label_lh_out;
        label_yh_out=label_rh_out;
    else
        colortable_xh=colortable_rh;
        colortable_dk_yh=colortable_dk_lh;
        label_dk_xh=label_dk_rh;
        label_dk_yh=label_dk_lh;
        label_xh=label_rh;
        coor_xh=coor_rh;
        coor_yh=coor_lh;
        colortable_xh_out=colortable_rh_out;
        colortable_yh_out=colortable_lh_out;
        label_xh_out=label_rh_out;
        label_yh_out=label_lh_out;  
    end
    
    color=colortable_dk_yh.table(id,5);
    struct_name=colortable_dk_yh.struct_names{id};
    region_v=find(label_dk_yh==color);
  
   
    ir_dk=[];label_xy_ir=[];
    for ir=1:numel(colortable_xh.struct_names)
        if strfind(colortable_xh.struct_names{ir},[struct_name '_part'])==1
            display([struct_name ' -| ' colortable_xh.struct_names{ir}]);
            colortable_xh_out.numEntries=1+colortable_xh_out.numEntries;
            colortable_xh_out.struct_names{end+1}=colortable_xh.struct_names{ir};
            colortable_xh_out.table=[colortable_xh_out.table; colortable_xh.table(ir,:)];
            colortable_yh_out.numEntries=1+colortable_yh_out.numEntries;
            colortable_yh_out.struct_names{end+1}=colortable_xh.struct_names{ir};
            colortable_yh_out.table=[colortable_yh_out.table; colortable_xh.table(ir,:)];
            ir_dk(end+1)=ir;
            label_xy_ir=[label_xy_ir ; find(label_xh==colortable_xh.table(ir,5))];
            
        end
    end
    coor_xy_ir=coor_xh(label_xy_ir,:);
    %coor_xy_ir=coor_xh;
    n_ver=size(coor_xy_ir,1);
    %n_ver=size(coor_xh,1);
    
    %label_xy_ir=label_xh;
    for iv=1:numel(region_v)
            vertex=region_v(iv);
            vertex_coor=coor_yh(vertex,:);
            vertex_coor_inv=[-vertex_coor(1) vertex_coor(2) vertex_coor(3)];
            vertex_coor_inv_rep=repmat(vertex_coor_inv,n_ver,1);
            [dummy vertex_contra_pos]=min(sum((vertex_coor_inv_rep-coor_xy_ir).^2,2));
            vertex_contra=label_xy_ir(vertex_contra_pos);

            new_color=label_xh(vertex_contra);
            
            label_xh_out(vertex_contra)=new_color;
            label_yh_out(vertex)=new_color;
    end
    
    new_colors=unique(label_xh(label_dk_xh==color));
    for ic=1:numel(new_colors)
        new_color=new_colors(ic);
        label_xh_out(label_xh==new_color)=new_color;
    end
    
    if mod(id,2)==0
        colortable_lh_out=colortable_xh_out;
        colortable_rh_out=colortable_yh_out;
        label_lh_out=label_xh_out;
        label_rh_out=label_yh_out;
    else
        colortable_rh_out=colortable_xh_out;
        colortable_lh_out=colortable_yh_out;
        label_rh_out=label_xh_out;
        label_lh_out=label_yh_out;
    end
    
end


colortable_lh_out.struct_names=colortable_lh_out.struct_names';
colortable_rh_out.struct_names=colortable_rh_out.struct_names';

write_annotation([path_subject '/label/lh.' parcellation '_' num2str(outName) '.aparc.annot'],vertices_lh_out,label_lh_out,colortable_lh_out);
write_annotation([path_subject '/label/rh.' parcellation '_' num2str(outName) '.aparc.annot'],vertices_rh_out,label_rh_out,colortable_rh_out);
end
