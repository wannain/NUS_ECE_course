%% RL Project -  Task 1
clc;
clear;
load task1.mat;
%%
goal_reach = 0;
run_iteration = 10;
time = zeros(run_iteration,1);
% set gamma
gamma = 0.9; %%discount factor
%gamma = 0.5;

% 10 runs
for run = 1:run_iteration
    fprintf('Running iteration: %d.\n', run);
    tic;
    [policy, Q, total_reward, state, state_list] = Q_learning(reward, gamma);
    total_reward_list(run)=total_reward;
    time(run) = toc;
    if state == 100
        goal_reach = goal_reach + 1;
    else
        goal_reach = goal_reach + 0;
    end
end
total_reward_ave=mean(total_reward_list);
time_ave = mean(time);
fprintf('Average total reward: %f\n', total_reward_ave);
fprintf('Average iteration time: %f\n', time_ave);
fprintf('Goal-reach runs: %d.\n', goal_reach);

%% Q Learning function
function [policy, Q, total_reward, state, state_list] = Q_learning(reward, gamma)
    Q = zeros(100,4);
    Q0 = zeros(100,4);
    trial = 1;
    threshold = 0.005;
    max_ite = 3000;

    while trial <= max_ite
        s = 1;%% start state
        k = 1;%% 
        alphak = 1;

        while alphak > threshold
            n = [1, 2, 3, 4];
            %choose exploration probability setting
            %epsilon_k = 1/k;
            epsilon_k = 100/(100+k);
            %epsilon_k = 120/(120+k);
            %epsilon_k = (1+log(k))/k;
            %epsilon_k = (1+5*log(k))/k;

            alphak = epsilon_k; %learning rate
            k = k + 1;
            %if action's reward is -1,means this is the bounder
            %so we delete the action -1
            n(reward(s,:) == -1)=[];
            [~,a_max] = max(Q(s,n)); %return max_value_index
            a_max = n(a_max); %get action 
            rand_num = rand(1); %to set a value 
        
            %To choose exploration or exploitation
        
            % exploration
            if rand_num < epsilon_k
                n(n==a_max) =[];
                rand_index = randperm(length(n));
                a = n(rand_index(1)); 
            % exploitation
            else
                a = a_max;
            end  
            % Update state
            switch a 
            case 1 %%left
                s_new = s-1;
            case 2 %%down
                s_new = s+10;
            case 3 %%right
                s_new = s+1;
            case 4 %%up
                s_new = s-10;
            end

            % Update the Q value
            Q(s,a) = Q(s,a) + alphak * (reward(s,a) + gamma * max(Q(s_new,:)) - Q(s,a));
            s = s_new;
        end

        if  mean((Q(:) - Q0(:)) .^ 2)<0.001  %%Q_function reach the optimal result
            break
        end
        Q0 = Q;
        trial = trial + 1;
    end

    [~,policy] = max(Q,[],2); 

    %% Plot the path
    figure;
    grid on;hold on;
    axis([0 10 0 10]);
    ax=gca;
    ax.GridColor='k';
    ax.GridAlpha=0.5;
    state = 1;
    total_reward = 0;
    step = 0;

    while((state < 100) && (step < 100))
        x=ceil(state/10)-0.5;
        y=10.5-mod(state,10);
        if y>10
            y=y-10;
        end
        switch policy(state)
            case 1
                scatter(x,y,75,'^','r'), hold on;
                total_reward=total_reward+gamma.^(step-1)*reward(state,1);
                state=state-1;
            case 2
                scatter(x,y,75,'>','r'), hold on;
                total_reward=total_reward+gamma.^(step-1)*reward(state,2);
                state=state+10;
            case 3
                scatter(x,y,75,'v','r'), hold on;
                total_reward=total_reward+gamma.^(step-1)*reward(state,3);
                state=state+1;
            case 4
                scatter(x,y,75,'<','r'), hold on;
                total_reward=total_reward+gamma.^(step-1)*reward(state,4);
                state=state-10;
        end
    step=step+1;
    state_list(step) = state;
    end
end

