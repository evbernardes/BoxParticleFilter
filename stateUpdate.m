%% Resampling
% New boxes affected by neighbouring old boxes
function [w_boxes_new] = stateUpdate(w_boxes,Boxes,stateFunction,stateInput,ts)
%     persistent T;
%     if(isempty(T))
%         T = zeros(8,1);
%     end
%     m1=T(1); m2=T(2); m3=T(3); m4=T(4); m5=T(5); m6=T(6); m7=T(7); m8=T(8);

%     Box11 = Boxes(1,:);
%     Box22 = Boxes(end,:);
%     Box12 = [Box11(1),Box22(2)];
%     Box21 = [Box22(1),Box11(2)];
%     Corners = {Box11,Box12;Box21,Box22};
%     TotalBox = [Box11(1,1) | Box22(1,1) , Box11(1,2) | Box22(1,2)];

    Corners = Boxes([1,end],[1,end]);
    LB = Boxes{1,1}.low; UB = Boxes{end,end}.high;
    TotalBox = Interval([LB(1) UB(1)], [LB(2) UB(2)]);
    
    [i_max,j_max]=size(w_boxes);
    w_boxes_new=zeros(size(w_boxes));
    
%     BigBoxes = cellfun(@(B) stateFunction(B,stateInput,ts),Boxes,'UniformOutput',false);
%     BigBoxesC = cellfun(@(B) B&TotalBox,BigBoxes,'UniformOutput',false);
%     
    BigBoxes = cell(size(Boxes));
    BigBoxesC = cell(size(Boxes));
%     BigBoxes = [0*Boxes; 0*Boxes]';
%     BigBoxesC = BigBoxes;
%     for k=1:length(Boxes),
%             BigBoxes(k,:) = stateFunction(Boxes(k,:),stateInput,ts);
%             BigBoxesC(k,:) = TotalBox&BigBoxes(k,:);
%             
%             % if contracted box is not inside the enclosed area, find the
%             % nearest box
%             if(sum(BigBoxesC(k,:).isempty) > 0)
%                 [i_corner,j_corner] = findClosestCorner(Corners,BigBoxes(k,:));
%                 if(BigBoxesC(k,1).isempty)
%                     BigBoxesC(k,1) = Corners{i_corner,j_corner}(1);
%                 end
%                 if(BigBoxesC(k,2).isempty)
%                     BigBoxesC(k,2) = Corners{i_corner,j_corner}(2);
%                 end
%             end
%             % select indexes to be affected by box at the center
%             %tic
%             %[i_idx2,j_idx2] = findIndexes3(BigBoxesC{i,j},Boxes); m1 = m1+toc; tic;
%             [i_idx,j_idx,k_idx] = findIndexes2(BigBoxesC(k,:),Boxes,grid_size); %m2 = m2+toc;
% %             if(~isequal(i_idx,i_idx2) || ~isequal(j_idx,j_idx2))
% %                 error('HALT')
% %             end
%             
% %             A = cell(length(i_idx),length(j_idx));
%             A = cell(length(k_idx),1);
%             for n = 1:length(k_idx)
%                 A{n} = quickBoxAnd(Boxes(n,:),BigBoxesC(k,:));
%                 % SAME BUT A LOT SLOWER: 
%                 %  A{n,m} = Boxes{i_idx(n),j_idx(m)}&BigBoxesC{i,j};
%             end
%             
%             % SAME BUT A LITTLE SLOWER:
% %             B = cell(length(i_idx),length(j_idx)); B(:) = {BigBoxesC{i,j}};
% %             B = cellfun(@and,Boxes(i_idx,j_idx),B,'UniformOutput',false); % intersection of each box with big contracted box
%             A = cellfun(@vol,A)/vol(BigBoxesC(k,:)); % area of each intersection DIVIDED by total area
%             w_boxes_new(k_idx)=w_boxes_new(k_idx)+A.*w_boxes(k);
%     end
    
    for i=1:i_max,
        for j=1:j_max,
            BigBoxes{i,j} = stateFunction(Boxes{i,j},stateInput,ts);
            BigBoxes{i,j} = BigBoxes{i,j}(1:2);
            BigBoxesC{i,j} = TotalBox&BigBoxes{i,j};
            
            % if contracted box is not inside the enclosed area, find the
            % nearest box
            if(sum(BigBoxesC{i,j}.isempty) > 0)
                [i_corner,j_corner] = findClosestCorner(Corners,BigBoxes{i,j});
                if(BigBoxesC{i,j}(1).isempty)
                    BigBoxesC{i,j}(1) = Corners{i_corner,j_corner}(1);
                end
                if(BigBoxesC{i,j}(2).isempty)
                    BigBoxesC{i,j}(2) = Corners{i_corner,j_corner}(2);
                end
            end
            % select indexes to be affected by box at the center
            [i_idx,j_idx] = findIndexes(BigBoxesC{i,j},Boxes); %m2 = m2+toc;
            
            A = cell(length(i_idx),length(j_idx));
            for n = 1:length(i_idx)
                for m = 1:length(j_idx)
                    A{n,m} = quickBoxAnd(Boxes{i_idx(n),j_idx(m)},BigBoxesC{i,j});
                    % SAME BUT A LOT SLOWER: 
                    %  A{n,m} = Boxes{i_idx(n),j_idx(m)}&BigBoxesC{i,j};
                end
            end
            
            % SAME BUT A LITTLE SLOWER:
%             B = cell(length(i_idx),length(j_idx)); B(:) = {BigBoxesC{i,j}};
%             B = cellfun(@and,Boxes(i_idx,j_idx),B,'UniformOutput',false); % intersection of each box with big contracted box
            A = cellfun(@vol,A)/vol(BigBoxesC{i,j}); % area of each intersection DIVIDED by total area
            w_boxes_new(i_idx,j_idx)=w_boxes_new(i_idx,j_idx)+A.*w_boxes(i,j);
        end
        
    end
%     T = [m1,m2,m3,m4,m5,m6,m7,m8]
end