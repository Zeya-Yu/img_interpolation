
plot(x,y,'k:','linewidth',2);
hold on;

for K = 2:5
    a = linspace(0,1,K);
    index = 0;
    % find x index lies in each section
    for i = 2:K
        temp = find(x<=a(i));
        index = [index,temp(end)];
    end
    
    % cvx
    cvx_begin
        variables alpha_fit(K-1) beta_fit(K-1)
        F = [];
        
        % define the vector of constraint 1 (convex)
        C1 = alpha_fit(2:K-1) - alpha_fit(1:K-2);
        
        % Calculate each piecewise function
        for i = 1:K-1
            f = alpha_fit(i) .* x((index(i)+1):index(i+1)) + beta_fit(i);
            F = [F;f];
        end
        
        % define the vector of constraint 2 (continous)
        %lhs = alpha_fit(1:K-2) .* a(2:K-1) + beta_fit(1:K-2)
        %rhs = alpha_fit(2:K-1) .* a(2:K-1) + beta_fit(2:K-1)
        lhs = [];
        rhs = [];
        for i = 1:K-2
            lhs = [lhs;alpha_fit(i) * a(i+1) + beta_fit(i)];
            rhs = [rhs;alpha_fit(i+1) * a(i+1) + beta_fit(i+1)];
        end

        
        % define minimize function
        minimize(norm(F-y))
        subject to
            C1 >= 0;
            lhs == rhs;
    cvx_end
    
    alpha_fit
    beta_fit
    
    if K==2
        plot(x,F,'y','linewidth',2)
    elseif K==3
        plot(x,F,'r','linewidth',2)
    elseif K==4
        plot(x,F,'g','linewidth',2)
    else
        plot(x,F,'b','linewidth',2)
    end
end
xlabel('x');
ylabel('y');
legend({'original','affine fit','1 internal knot point' , '2 internal knot point3', ...
'3 internal knot points'} , 'Location' , 'NorthWest');
