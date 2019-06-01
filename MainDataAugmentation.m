%the pre-trained CNNs are available at:
%https://it.mathworks.com/matlabcentral/profile/authors/8743315-mathworks-deep-learning-toolbox-team

%e.g. if you use ResNet50:
net = resnet50;
siz=[224 224];%input size of the CNN

%e.g. if you use DenseNet:
net = densenet201;
siz=[224 224];%input size of the CNN

%if you use AlexNet:
net = alexnet;  %load AlexNet
siz=[227 227];

%if you use googlenet:
net = googlenet;  %load googlenet
siz=[224 224];

%if you use vgg16:
net = vgg16;
siz=[224 224];

%if you use vgg19:
net = vgg19;
siz=[224 224];

%if you use resnet101:
net = resnet101;
siz=[224 224];

%if you use inceptionv3:
net = inceptionv3;
siz=[299 299];

%if you use inceptionresnetv2:
net = inceptionresnetv2;
siz=[299 299];

        
%training options
%set the two parameters BatchSize & learningRate, for each different couple
%we train a different CNN, then the CNN are combined by sum rule (i.e. to
%sum their scores)
% we have tested two different learning rates {0.001, 0.0001} 
% and four different batch sizes {10, 30, 50, 70}). 
metodoOptim='sgdm';
options = trainingOptions(metodoOptim,...
    'MiniBatchSize',BatchSize,...
    'MaxEpochs',20,...
    'InitialLearnRate',learningRate,...
    'Verbose',false,...
    'Plots','training-progress');

  
% To build training set, let us suppose that the cell array TR stores the
% training images
%let us suppose that y store the training labels
clear trainingImages
%we suggest to initialize trainingImages to reduce computation time
for pattern=1:length(TR)
    IM=TR{pattern};
    trainingImages(:,:,:,pattern)=IM;
end
imageSize=size(IM);
tolgo=find(y==0);
y(tolgo)=[];
trainingImages(:,:,:,tolgo)=[];

   

%data augmentation 1 
if approccio==1
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true);
elseif approccio==2
    %data augmentation 2
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXScale',[1 2], ...
        'RandYReflection',true, ...
        'RandYScale',[1 2]);
elseif approccio==3
    %data augmentation 3
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXScale',[1 2], ...
        'RandYReflection',true, ...
        'RandYScale',[1 2],...
        'RandRotation',[-10 10],...
        'RandXShear', [0 30], ...
        'RandYShear', [0 30], ...
        'RandXTranslation',[0 5],...
        'RandYTranslation', [0 5]);
elseif approccio==4
    %data augmentation 4
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXScale',[1 2], ...
        'RandYReflection',true, ...
        'RandYScale',[1 2],...
        'RandRotation',[-10 10],...
        'RandXTranslation',[0 5],...
        'RandYTranslation', [0 5]);
elseif approccio==5
    [trainingImages,y]=DataAugmentation(trainingImages,'PCA',1,y,length(y)*0.95);%remember that y stores the training labels
elseif approccio==6
    [trainingImages,y]=DataAugmentation(trainingImages,'DCT',1,y);
end
    
%tuning step (for details:
% https://it.mathworks.com/help/deeplearning/ref/resnet50.html
% https://it.mathworks.com/help/deeplearning/ref/densenet201.html)
%To retrain the network on a new classification task, follow the steps of Transfer Learning
%         remove the 'ClassificationLayer_fc1000', 'fc1000_softmax', and 'fc1000'layers, and connect to the 'avg_pool' layer.
trainingImages = augmentedImageDatastore(imageSize,trainingImages,categorical(y'),'DataAugmentation',imageAugmenter);
lgraph = layerGraph(net);
lgraph = removeLayers(lgraph, {'ClassificationLayer_fc1000','fc1000_softmax','fc1000'});
numClasses = max(y);
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',20,'BiasLearnRateFactor', 20)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'avg_pool','fc');
try netTransfer = trainNetwork(trainingImages,lgraph,options);
catch
    return
end
%NOTICE THAT the code for tuning a pretrained networks is different if you
%don't use Resnet50 or densenet, since the different names of the layers.
%Anyway the documentation of mathwork clearly explains how to tune each
%network
   
    
%to classify test images, let us suppose that the cell array TE stores the
% test images
clear score testImages
for pattern=1:length(TE)
    IM=TE{pattern};%IM is a given image
    IM=imresize(IM,[siz(1) siz(2)]);
    testImages(:,:,:,1)=uint8(IM);
    [outclass, score(pattern,:)] =  classify(netTransfer,testImages);%to classify the image
    %score stores the similarities of each image to all the classes of the
    %classification problem.
end
