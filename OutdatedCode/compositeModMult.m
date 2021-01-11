clear z1;
clear Z1;

[z1,n1] = hist(A, 1024);
z1 = z1/length(A)/2;
z1(1) = z1(1)+0.5;
Z1 = z1;
for(i = 1:1023)
    Z1 = conv(Z1,z1);
end
disp("finished generating Z1");