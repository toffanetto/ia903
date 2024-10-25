%---------------------------------------------------------------------
% This function computes the parameters (r, alpha) of a line passing
% through input points that minimize the total-least-square error.
%
% Input:   XY - [2,N] : Input points
%
% Output:  alpha, r: paramters of the fitted line

function [alpha, r] = fitLine(XY)
% Compute the centroid of the point set (xmw, ymw) considering that
% the centroid of a finite set of points can be computed as
% the arithmetic mean of each coordinate of the points.

% XY(1,:) contains x position of the points
% XY(2,:) contains y position of the points


    xc = sum(XY(1,:))/length(XY(1,:));
    yc = sum(XY(2,:))/length(XY(2,:));

    % compute parameter alpha (see exercise pages)
    nom   = -2*(sum((XY(1,:)-xc).*(XY(2,:)-yc)));
    denom = sum(((XY(2,:)-yc).^2) - ((XY(1,:)-xc).^2));
    alpha = atan2(nom,denom)/2;

    % compute parameter r (see exercise pages)
    % Once r - xi cos \alpha - yi sin \alpha = -\ro cos( \thetai - \alpha)
    % + r, -\ro cos( \thetai - \alpha) = - xi cos \alpha - yi sin \alpha,
    % thus:
    
    r = sum((XY(1,:).*cos(alpha)) + (XY(2,:).*sin(alpha)))/length(XY(1,:));


% Eliminate negative radii
if r < 0,
    alpha = alpha + pi;
    if alpha > pi, alpha = alpha - 2 * pi; end
    r = -r;
end

end
