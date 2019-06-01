% This function computes 3 binarizations of the input image, and computes
% 27 statistics, 9 for each binarized image

function [ETAS_stats E1 E2 E3 E4 E5 E6 E7] = ETAS(img, threshold)
    
    I = img;
    VAL = threshold;

    %calcolo intensità media
    media=mean(mean(I(find(I>VAL))));

%% Equation1: meo to 255
    %nuova soglia
    II=I.*0;
    II(find(I>(media)))=1;
    [a,b]=find(II==1);
    conta(1:9)=0;
    
    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M)=conta(M)+1;
    end
    
    conta(1:9)=conta(1:9)./(size(a,1)+0.0001);
    
    II(find(I>(media))) =  255;
%     imgE1 = II;
%     imshow(imgE1)
        
%% Equation2: meo - theta to 255
    %nuova soglia
    II=I.*0;
    II(find(I>(media-VAL)))=1;
    conta(10:18)=0;
    [a,b]=find(II==1);
    
    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+9)=conta(M+9)+1;
    end
    conta(10:18)=conta(10:18)./(size(a,1)+0.0001);

    II(find(I>(media-VAL))) =  255;
    imgE2 = II;
%     figure,
%     imshow(imgE2)
%% Equation3: meo - theta to meo + theta
     %binarizzo
    II=I.*0;
    II(find(I>(media-VAL) & I<(media+VAL)))=1;

    %ordare devo contare n° di pixel bianchi in ogni intorno
    [a,b]=find(II==1);
    conta(19:27)=0;
    
    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+18)=conta(M+18)+1;
    end
    conta(19:27)=conta(19:27)./(size(a,1)+0.0001);
    
    II(find(I>(media-VAL) & I<(media+VAL))) =  255;
    imgE3 = II;
%     figure,
%     imshow(imgE3)
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %========================================================================
  %                 ETAS START HERE
  %========================================================================
  %% Equation4:  meo to 255-theta 
    II=I.*0;
     %-------------------First segment-----------------------    
   II(find(I>(media) & I<(255-VAL)))=1;
   
    %count number of white pixels in each round
    [a,b]=find(II==1);
    conta(28:36)=0;
    
    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+27)=conta(M+27)+1;
    end
    
    conta(28:36)=conta(28:36)./(size(a,1)+0.0001);
    
    II(find(I>(media) & I<(255-VAL))) =  255;
    imgE4 = II;
%     figure,
%     imshow(imgE4)

 %% Equation5: meo-theta to 255-theta
      II=I.*0;
   %---------------Second segment-----------------------------
   II(find(I>(media-VAL) & I<(255-VAL)))=1;
    conta(37:45)=0;
    [a,b]=find(II==1);
    
    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+36)=conta(M+36)+1;
    end
    conta(37:45)=conta(37:45)./(size(a,1)+0.0001);
    
    II(find(I>(media-VAL) & I<(255-VAL))) =  255;
    imgE5 = II;
%     figure,
%     imshow(imgE5)

  %% Equation6: meo+theta to 255-theta
    
    II=I.*0;
   %--------------------------Third segment----------------------   
   II(find(I>(media+VAL)& I<(255-VAL)))=1;
    conta(46:54)=0;
    [a,b]=find(II==1);

    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+45)=conta(M+45)+1;
    end
    
    conta(46:54)=conta(46:54)./(size(a,1)+0.0001);
    
    II(find(I>(media+VAL)& I<(255-VAL))) =  255;
    imgE6 = II;
%     figure,
%     imshow(imgE6)
    
    %% Equation7: meo+theta to 255
    
   
    II=I.*0;
  %-------------------------Fourth Segment------------------   
   II(find(I>(media+VAL)))=1;
    conta(55:63)=0;
    [a,b]=find(II==1);

    for i=1:size(a,1)
        M=sum(sum( II(max([a(i)-1 1]):min([a(i)+1 size(I,1)]),max([b(i)-1 1]):min([b(i)+1 size(I,2)]))));
        conta(M+54)=conta(M+54)+1;
    end
    
    conta(55:63)=conta(55:63)./(size(a,1)+0.0001);
    
    II(find(I>(media+VAL))) =  255;
    imgE7 = II;
%     figure,
%     imshow(imgE7)
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ETAS_stats = conta;
        E1 = conta(1:9);
        E2 = conta(10:18);
        E3 = conta(19:27);
        E4 = conta(28:36);
        E5 = conta(37:45);
        E6 = conta(46:54);
        E7 = conta(55:63);
end