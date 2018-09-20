function X = convertRadiantsToVectors(Xrad)
    X(:,1) = cos(Xrad);
    X(:,2) = sin(Xrad);
end