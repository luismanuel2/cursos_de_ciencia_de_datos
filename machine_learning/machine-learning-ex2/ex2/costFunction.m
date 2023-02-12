function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
h=sigmoid(X*theta);
J=1/m*(-y'*log(h)-(1-y)'*log(1-h));
grad = 1/m*X'*(h-y);
%grad = ones(length(theta), 1);

%grad(1)=theta(1)-(alpha/m)*sum((h-y).*X(:,1));
%grad(2)=theta(2)-(alpha/m)*sum((h-y).*X(:,2));
%grad(3)=theta(3)-(alpha/m)*sum((h-y).*X(:,3));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%








% =============================================================

end
