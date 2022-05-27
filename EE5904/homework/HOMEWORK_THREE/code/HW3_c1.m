%% Clear all
close all
clear
clc
tic

%% Load labels and data

mkdir q3_c1_image
%load 
load('characters10.mat');

train_data=im2single(train_data);
test_data=im2single(test_data);
test_data=test_data';
train_data=train_data';

trainIdx = find(train_label ==0 | train_label== 1|train_label == 3 | train_label ==4|train_label == 6 | train_label == 7|train_label == 8 | train_label == 9);
testIdx = find(test_label == 0 | test_label== 1|test_label == 3 | test_label ==4|test_label == 6 | test_label == 7|test_label == 8 | test_label == 9);

train_label=train_label';
test_label=test_label';

train_data = train_data(:,trainIdx);
train_label = train_label(:,trainIdx);

test_data = test_data(:,testIdx);
test_label = test_label(:,testIdx);

trainX = train_data;
%% Initialise 
N = 784;                                    % dimnension of input vector
vert_M = 10;                                % vertical neurons
hor_M = 10;                                 % horizontal neurons
M = vert_M * hor_M;                         % number of output neurons
iter = 200;                                % number of iterations
som_width = 10;                             % size of SOM (width)
som_height = 10;                            % size of SOM (height)
init_rate = 2;                            % initial rate
init_width = sqrt( (10^2 + 10^2)) / 2;      % initial width
init_w = rand(N,M);                         % initial weight
w = init_w;                                 % initial weight
grid = getgrid(vert_M,hor_M);               % initialise grid
label(1:vert_M,1:hor_M) = inf;              % initialise label matrix

%% Algorithm start
for n = 0:iter
    disp(strcat('Iteration: ', int2str(n))) 
    [rate, width] = getparam(init_rate, init_width,n,iter);
    for idx = 1:600
        sample = trainX(:,idx);     % get a sample vector
        [winner,grid_col,grid_row,dis] = getwinner(w,sample,M,vert_M,hor_M);    % get winning neuron
        h = getneighbourhood(vert_M,hor_M,grid_row,grid_col,width);             % find influence neighbourhood
        label(grid_row,grid_col) = train_label(:,idx);
        reshape_h = reshape(h',[1,100]);
        for i = 1:M
            w(:,i) = w(:,i) + rate * reshape_h(1,i) * (sample - w(:,i));        % calculate new weight
        end
    end
end


%% Plot SOM
reshaped_label = reshape(label',[1 100]);
for A = 1:100
    subplot(10,10,A)
    graph = reshape(2*(w(:,A)),[28 28]);
    imshow(graph');
    title(sprintf('%0d',reshaped_label(1,A)));
end

%% Calculate training and test accuracy
test_acc = getacc(test_data,test_label,w,reshaped_label);
train_acc = getacc(train_data,train_label,w,reshaped_label);

toc

%% Functions
function accuracy = getacc(data,data_label,w,som_labels)
num_inputs = size(data,2);
num_weights = size(w,2);
for i = 1:num_inputs
    min = inf;
    for j = 1:num_weights
    diff = norm(data(:,i) - w(:,j));
    if diff < min
        min = diff;
        min_idx = j;
    end
    end
    test_grid(1,i) = som_labels(1,min_idx);
end
counter = 0;
for i = 1:num_inputs
    if test_grid(1,i) == double(data_label(1,i))
        counter = counter + 1;
    end
end
accuracy = counter/num_inputs;
end

function grid = getgrid(x, y)
num = 1;
for i=1:x
    for j=1:y
        grid(i,j) = num;
        num = num + 1;
    end
end
end

function [rate, width] = getparam(init_rate, init_width,n,iter)
    rate = init_rate * exp(-n/iter);
    T1 = iter/(log(init_width));
    width = init_width * exp(-n /T1);
end

function [winner,grid_col,grid_row,dis] = getwinner(w,sample,M,vert_M,hor_M)
for i = 1:M
    dis(1,i) = getnorm(w(:,i),sample);
end
winner = find(dis==min(dis));
winner = winner(1,1);
grid_col = mod(winner,hor_M);
if grid_col == 0
    grid_col = 10;
end
grid_row = ceil(winner/vert_M);
end

function h = getneighbourhood(vert_M,hor_M,grid_row,grid_col,width)
for i = 1:vert_M
    for j = 1:hor_M
        d(i,j) = -1 * (getnorm( [i j] , [grid_row grid_col] ) )^2;
        h(i,j) = exp(d(i,j) / (2*width^2));
    end
end
end

function dist = getnorm(a,b)
dist = norm(a-b);
end