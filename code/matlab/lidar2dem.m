function INFO = lidar2dem(LidarCoords)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEM coordinates from h5 grid
demfile = '/mnt/geog/aa812/RDF/NED_DEM_harvard.h5';
fileinfo = hdf5info(demfile);
demlat = hdf5read(fileinfo.GroupHierarchy.Datasets(2),'V71Dimensions',true);
demlon = hdf5read(fileinfo.GroupHierarchy.Datasets(3),'V71Dimensions',true);
DEM = hdf5read(fileinfo.GroupHierarchy.Datasets(1),'V71Dimensions',true);
demlat = demlat(:); demlon = demlon(:); DEM = DEM(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:size(LidarCoords,1)
    (i/size(LidarCoords,1)).*100 % how much of process is done

    % DEM class
zlat = find(demlat>(LidarCoords(i,1)-0.00038889) & demlat<(LidarCoords(i,1)+0.00038889)); % 1D
zlon = find(demlon>(LidarCoords(i,2)-0.00038889) & demlon<(LidarCoords(i,2)+0.00038889)); % 1D
zz = ismember(zlat,zlon); dempixels = zlat(zz); % pixel ID
DEMclass = double(DEM(dempixels)); % ACTUALLY FINDS COORDINATES within the NED DEM file
size(dempixels)
zlat = []; zlon = []; dempixels = []; % clean the loop
    

INFO(i,1) = LidarCoords(i,1); % lat
INFO(i,2) = LidarCoords(i,2); % lon
INFO(i,3) = nanmean(DEMclass); % mean elevation of the surrounding pixels
INFO(i,4) = max(DEMclass)-min(DEMclass); % elevation range

end