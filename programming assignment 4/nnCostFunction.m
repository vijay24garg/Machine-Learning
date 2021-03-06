function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% for i = 1:m
%     cost = 
% end

%recoding y as Y
% Y = zeros(m,num_labels);
% for i = 1:m
%     switch y(i)
%         case 1
%             Y(i,:) = [1 0 0 0 0 0 0 0 0 0];
%         case 2
%             Y(i,:) = [0 1 0 0 0 0 0 0 0 0];
%         case 3
%             Y(i,:) = [0 0 1 0 0 0 0 0 0 0];
%         case 4
%             Y(i,:) = [0 0 0 1 0 0 0 0 0 0];
%         case 5
%             Y(i,:) = [0 0 0 0 1 0 0 0 0 0];
%         case 6
%             Y(i,:) = [0 0 0 0 0 1 0 0 0 0];
%         case 7
%             Y(i,:) = [0 0 0 0 0 0 1 0 0 0];
%         case 8
%             Y(i,:) = [0 0 0 0 0 0 0 1 0 0];
%         case 9
%             Y(i,:) = [0 0 0 0 0 0 0 0 1 0];
%         case 10
%             Y(i,:) = [0 0 0 0 0 0 0 0 0 1];
%         otherwise
%             disp('somthing went wrong')
%     end
% end

%recoding y generic code!------------------------------------------------
I = eye(num_labels);
Y = zeros(m,num_labels);
for i = 1:m
    Y(i,:) = I(y(i),:);
end
%-------------------------------------------------------------------

%Calculating hypothesis h------------------------------------------------
X = [ones(m,1) X];        % introducing bias in input layer
A1 = X;
Z2 =  Theta1 * X' ;       % 5000x401  25x401
A2 = sigmoid(Z2);          % 25x5000  
size(A2);
A2 = [ones(1,m); A2];     % introducing bias in hidden layer
Z3 = Theta2 * A2;         % 10x26 26x5000
h = sigmoid(Z3);          % 10x5000
A3 = h;

%Y 5000x10  
J = 0;
for i = 1:m
    J = J + (-1/m) * (Y(i,:) * log(h(:,i)) + (1-Y(i,:)) * log(1-h(:,i)));
end
%-------------------------------------------------------------------------



%Computing regularisation term--------------------------------------------
sum1 = 0;
for j =1:hidden_layer_size
   for k = 2:input_layer_size + 1
      sum1 = sum1 + Theta1(j,k)^2; 
   end
end


sum2 = 0;
for j = 1:num_labels
   for k = 2:hidden_layer_size + 1   %we dont regularise the bias terms
      sum2 = sum2 + Theta2(j,k)^2; 
   end
end

reg_term = (lambda / (2 * m)) * (sum1 + sum2);

J = J + reg_term;

%-------------------------------------------------------------------------
% % step 2 Regularized cost function
% penalty = (lambda / (2 * m)) * (sum(sum(Theta1(:, 2:end) .^ 2, 2)) + sum(sum(Theta2(:, 2:end) .^ 2, 2)))
% J2 = J + penalty;

% -------------------------------------------------------------

% step 3 Neural Network Gradient (Backpropagation)
Y = Y';
for t = 1:m
    delta3 = h(:,t) - Y(:,t); %delta3: 10x1
    delta2 = Theta2' * delta3 .* sigmoidGradient([1;Z2(:,t)]) ; %delta2: 26x1      
    delta2 = delta2(2:end);
    
    Theta2_grad = Theta2_grad + delta3 * A2(:,t)'; %10x26
    Theta1_grad = Theta1_grad + delta2 * A1(t,:);  %25x401
end

Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + lambda / m * Theta1(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + lambda / m * Theta2(:, 2:end);


% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
