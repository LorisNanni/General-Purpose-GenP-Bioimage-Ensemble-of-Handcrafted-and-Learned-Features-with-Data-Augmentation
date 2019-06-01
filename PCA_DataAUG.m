function [IMGset,y]=PCA_DataAUG(IMGset,y,append,NumberEigen)

for banda=1:3 %one the three bands (RGB)
    clear I
    I(:,:)=im2double(IMGset(:,:,banda,1)); % convert image to gray scale and then to double precision
    [r,c] = size(I);
    AllImage=single(zeros(r*c,size(IMGset,4)));
    for img=1:size(IMGset,4) %for all the images of the trainig set
        clear I
        I(:,:)=im2double(IMGset(:,:,banda,img)); % convert image to gray scale and then to double precision
        [r,c] = size(I); % get number of rows and columns in image
        AllImage(:,img) = single(I(:)); % convert image to vector and store as column in matrix I
    end
    M=size(IMGset,4);
    % calculate mean image
    I_mean = mean(AllImage,2);
    % subtract mean image from the set of images
    I_shifted = AllImage-repmat(I_mean,1,M);
    %perform PCA. Matrix I was used as input instead of I_shifted because Matlab documentation states that pca function centers the data
    [coeff,score,latent,~,explained,mu] = pca(AllImage);
    eigFaces{banda} = I_shifted*coeff;
end
[IMGset,y]=PCA_reconstruct(IMGset,eigFaces,NumberEigen,y,append,I_mean,I_shifted);