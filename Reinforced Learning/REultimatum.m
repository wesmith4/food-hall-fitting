clc;
clear all;

numplayers=10; %numplayers of each type

%Initializing starting propensities
S1=10;
Q1M=S1*ones(numplayers,9);

S2=10;
Q2M=S2*ones(numplayers,9);


epsilon=0.01;
mu=0.02;
phi=0.001;

%Total number of games to play
numgames=10000;

%Arrays that store number of games played by each player of each type
countgames1=zeros(numplayers,1);
countgames2=zeros(numplayers,1);

%Arrays that store the history for each player
hist1=zeros(numplayers,round(numgames/numplayers));
hist2=zeros(numplayers,round(numgames/numplayers));

for games=1:numgames
    
    %picking a couple of random players
    player1=randi(numplayers);
    player2=randi(numplayers);
    
    %Storing their propensities for use within the loop
    Q1=Q1M(player1,:);
    Q2=Q2M(player2,:);
    
    %Updating the number of games played by each of those players
    countgames1(player1)= countgames1(player1)+1;
    countgames2(player2)= countgames2(player2)+1;

    tempP1=Q1/sum(Q1);
    tempP2=Q2/sum(Q2);
    
    %if p less than mu set to 0.
    Q1(tempP1<mu)=0;
    Q2(tempP2<mu)=0;   
    
    %Finding cumulative probabilities
    P1=cumsum(Q1)/sum(Q1);
    P2=cumsum(Q2)/sum(Q2);

    %Choosing random numbers to implement Roth Erev.  Based on random
    %number, will choose action.  The higher the propensity of an action,
    %the greater the likelihood of it being chosen.
    x1=rand;
    x2=rand;
    
    act1=1;
    act2=1;
    for i=2:9
        if x1>=P1(i-1) && x1<P1(i)
            act1=i;
        end

        if x2>=P2(i-1) && x2<P2(i)
            act2=i;
        end

    end
    %By the end of this part, player 1 has chosen act1 and player2 has
    %chosen act2
    
    
    %Storing players' action histories
    hist1(player1,countgames1(player1))=act1;
    hist2(player2,countgames2(player2))=act2;

    %play the game and update propensities; modify this loop if you want to
    %add experimentation
    if act1<=act2
        Q1(act1)=Q1(act1)+(1-epsilon)*act1;
        Q2(act2)=Q2(act2)+ (1-epsilon)*(10-act1);
        
        %taking epsilons into account; note if action is a corner action,
        %all of the epsilon goes to the sole adjacent action
        if act1>1
            Q1(act1-1)=Q1(act1-1)+(epsilon/2)*act1;
        else
            Q1(act1+1)=Q1(act1+1)+(epsilon/2)*act1;
        end
        
        if act1<9
            Q1(act1+1)=Q1(act1+1)+(epsilon/2)*act1;
        else
            Q1(act1-1)=Q1(act1-1)+(epsilon/2)*act1;
        end
        
        if act2>1
            Q2(act2-1)=Q2(act2-1)+(epsilon/2)*(10-act1);
        else
            Q2(act2+1)=Q2(act2+1)+(epsilon/2)*(10-act1);
        end
        
        if act2<9
            Q2(act2+1)=Q2(act2+1)+(epsilon/2)*(10-act1);
        else
            Q2(act2-1)=Q2(act2-1)+(epsilon/2)*(10-act1);
        end
        
        
        
    end
    
    %introduce forgetting
    Q1M(player1,:)=(1-phi)*Q1;
    Q2M(player2,:)=(1-phi)*Q2;



end

%finding last moves of players to check for convergence to Nash
lasthist1=zeros(numplayers,1);
lasthist2=zeros(numplayers,1);
for i=1:numplayers
    
    lasthist1(i)=hist1(i,countgames1(i));
    lasthist2(i)=hist2(i,countgames2(i));
end



