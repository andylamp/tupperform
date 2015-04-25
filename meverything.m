%%
%
% Description:
%
%       This is a fairly simplistic implementation of the 'everything' 
%       formula (otherwise known as the Tupper's self-referential formula).
%
%       This little inequality maps a specific 17x107 grid to the x-y
%       axis drawing the desired pattern if one generates a representative
%       k value for that pattern.
%
%       What this formula practically does, is to encode the starting
%       location of the bitmap in the x-y axis in that representative k
%       value that is generated using the desired bitmap.
%
%       The bitmap has to be 17x107 and we have to convert it to a 
%       black & white image before doing the conversion (0 indicating
%       that we don't color the cell, 1 indicating that we have to color
%       it). We then pad each column of ones and zeros (from bottom to
%       top) into a (very) large binary number that we then have to convert
%       to base-10. Finally in order to get the final k value we multiply
%       the converted to base-10 number with the said offset (17).
%
%
% Version: 1.0 - 25/4/2015 (just made it.)
%
% References:
%
%   [1] Tupper, Jeff. "Reliable Two-Dimensional Graphing Methods for 
%                       Mathematical Formulae with Two Free Variables"
%
% TL;DR: The 'everything' formula, in a quick & dirty MatLab implementation
%
% 
%  
%

%% initialization
clc;
clear;
close all;
digits(1000000);

%% choice
str = ['\nSelect: ' ...
             '\n    1) Import image' ...
             '\n    2) Print-self' ...
             '\nChoice: '];
sel = input(str);

% some error checking
while(not(isnumeric(sel)) || sel < 1 || sel > 2)
    fprintf('\nWrong, try again');
    sel = input(str);
end

%% grab input.
bwimg = 0;
if(sel == 1)
    fname = input('\nEnter a filename to read: ', 's');
    fprintf('\nReading %s and processing...', fname);
    [bwimg, map] = imread(fname);
    bwimg = im2bw(bwimg, map);
    % show the image
    figure, imshow(bwimg);
    % reverse polarity
    for i=1:size(bwimg,1)
        for j=1:size(bwimg,2)
            if(bwimg(i, j) == 0)
                bwimg(i, j) = 1;
            else
                bwimg(i, j) = 0;
            end
        end
    end
    
    % check dimensions
    [x, y] = size(bwimg);
    if(x > 17 || y > 107)
        fprintf(['\nWe only support 17x107 bitmap grid' ...
                 ' we will truncate to these dimensions\n\n']);
        bwimg = bwimg(1:17,1:107);
    end
    
    % convert to binary number
    nbin = bwimg(size(bwimg,1):-1:1,1)';
    for i=2:size(bwimg,2)
        nbin = [nbin, bwimg(size(bwimg,1):-1:1,i)'];
    end

    % convert to decimal
    k = java.math.BigInteger('0');
    p = java.math.BigInteger('2');
    offset = java.math.BigInteger('17');
    j = 0;
    for i=size(nbin,2):-1:1
        if(nbin(i) ~= 0)
            k = k.add(p.pow(j));
        end
        j = j + 1;
    end
    k = k.multiply(offset);
    k = sym(char(k.toString()));
else
    % this is the self-replicating number; for reference.
    k = sym(['960939379918958884971672962127852754715004339' ... 
            '6601293066515055192717028023952664246896428421' ...
            '7435071812126715378277062335599323728087414430' ...
            '7891325963941337723487857735749823926629715517' ...
            '1737169951652328905382216124032388558661840132' ...
            '3558513604882869333790249145422928866708109618' ...
            '4496091705183454067827731551705405381627380967' ...
            '6025656250169814820834187831638491155902256100' ...
            '0365235137034387446184837873723819822484986346' ...
            '5033159410054974700593138339226497249461751545' ...
            '7283667023697454610146559979337985374831437868' ...
            '41806593422227898388722980000748404719']);
end

fprintf('\nValue of k is: \n');
disp(k);


          
%% formula
y = k:1:(k+16);
x = 1:107;

grid = ones(size(y,2), size(x,2));

for i=1:size(y,2)
    for j=1:size(x,2)
        if(sym(0.5) < ...
                floor(mod(floor((y(i))/17) *  ...
                2^(-17*floor(x(j)-1)-mod(floor(y(i)),17)), 2)))
            grid(i,(size(x,2)+1)-j) = 0;
        end
    end
end

% save the result
% this the default save where the replica is.
%save('grid.mat', 'grid');
save('grid_myrun.mat', 'grid');

%% finally plot the result
figure;
imshow(grid);


