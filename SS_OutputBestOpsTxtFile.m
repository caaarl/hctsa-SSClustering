function SS_OutputBestOpsTxtFile(fName)

load('HCTSA_N.mat');
load('linkage_clusters_with_member_corrs.mat');

if nargin < 1
    fName = 'cluster_info.txt';
end

fprintf('Saving clustering information to %s \n',fName);

fID = fopen(fName,'w');
fprintf(fID,['Output from kmedoids clustering (k = %i) followed by ',...
    'linkage clustering (corr_dist_threshold = %f)\n\n'],kmedoidsClusters.k,corr_dist_threshold);

for i = 1:length(linkageClusters)
    dists = linkageClusters(i).memDists;
    mems = linkageClusters(i).memIdxs;
    kmedCentres = linkageClusters(i).kmedCentres;
    ops = Operations(mems);
    
    % Sort by increasing distance
    [sortedDists sortIdx] = sort(dists);
    sortedMems = mems(sortIdx);
    sortedOps = ops(sortIdx);
    
    kmCentreOps = Operations(kmedoidsClusters.CCi(kmedCentres));
    kmCentreNames = {kmCentreOps.Name};
    
    % Print all centres associated with cluster
    fprintf(fID,'CLUSTER %i: ',i);
    for j = 1:length(kmCentreNames)
        fprintf(fID,'%s , ',kmCentreNames{j}); 
    end
    fprintf(fID,'\n');
    
    % Print top 10 operations highly correlated with cluster centre
    for j = 1:min(length(sortedOps),10)
        fprintf(fID,'(%f) %s - %s\n',1-sortedDists(j),sortedOps(j).Name,...
            sortedOps(j).Keywords);
    end
    
    fprintf(fID,'\n');
end

fclose(fID);

end
