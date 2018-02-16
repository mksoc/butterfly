clearvars
clc

%define min and max values
minVal = -(1-2^(-23));
maxVal = 1-2^(-23);

% define test vectors
testVectorNum = 10;
vectorType = 0; % 0 = random; 1 = extremes

switch vectorType
    case 0
        % generate random vectors
        Ar = -1 + 2.*rand(testVectorNum,1);
        Ai = -1 + 2.*rand(testVectorNum,1);
        Br = -1 + 2.*rand(testVectorNum,1);
        Bi = -1 + 2.*rand(testVectorNum,1);

        angle = 2*pi.*rand(testVectorNum,1); % generate random angles
        W = exp(-1i.*angle);
        Wr = real(W);
        Wi = imag(W);
        
    case 1
        % generate extremes vector
        extremeCases = [maxVal minVal 0];
        extremeVectors = permn(extremeCases, 6);
        Ar = extremeVectors(:,5);
        Ai = extremeVectors(:,6);
        Br = extremeVectors(:,1);
        Bi = extremeVectors(:,3);
        Wr = extremeVectors(:,2);
        Wi = extremeVectors(:,4);
end

% generate integers for Butterfly (Q1.23)
Ar_int = int64(floor(Ar.*2^23 + 0.5));
Ai_int = int64(floor(Ai.*2^23 + 0.5));
Br_int = int64(floor(Br.*2^23 + 0.5));
Bi_int = int64(floor(Bi.*2^23 + 0.5));
Wr_int = int64(floor(Wr.*2^23 + 0.5));
Wi_int = int64(floor(Wi.*2^23 + 0.5));

% swap out of range values with minVal/maxVal
Ar_int(Ar_int == 2^23) = maxVal;
Ai_int(Ai_int == 2^23) = maxVal;
Br_int(Br_int == 2^23) = maxVal;
Bi_int(Bi_int == 2^23) = maxVal;
Wr_int(Wr_int == 2^23) = maxVal;
Wi_int(Wi_int == 2^23) = maxVal;
Ar_int(Ar_int == -2^23) = minVal;
Ai_int(Ai_int == -2^23) = minVal;
Br_int(Br_int == -2^23) = minVal;
Bi_int(Bi_int == -2^23) = minVal;
Wr_int(Wr_int == -2^23) = minVal;
Wi_int(Wi_int == -2^23) = minVal;

% generate quatized float versions for Matlab
Ar_q = double(Ar_int)./2^23;
Ai_q = double(Ai_int)./2^23;
Br_q = double(Br_int)./2^23;
Bi_q = double(Bi_int)./2^23;
Wr_q = double(Wr_int)./2^23;
Wi_q = double(Wi_int)./2^23;

% write test vectors to file
outFile = fopen('inputVectors.txt','w');
for i = 1:length(Ar_int)
    fprintf(outFile, '%d %d %d %d %d %d\n', Br_int(i), Wr_int(i), Bi_int(i), Wi_int(i), Ar_int(i), Ai_int(i));
end
fclose(outFile);

% perform algorithm
Ar_out = Ar_q + Br_q.*Wr_q - Bi_q.*Wi_q;
Ai_out = Ai_q + Br_q.*Wi_q + Bi_q.*Wr_q;
Br_out = Ar_q - Br_q.*Wr_q + Bi_q.*Wi_q;
Bi_out = Ai_q - Br_q.*Wi_q - Bi_q.*Wr_q;

% scale 2 positions
Ar_out = Ar_out ./ 4;
Ai_out = Ai_out ./ 4;
Br_out = Br_out ./ 4;
Bi_out = Bi_out ./ 4;

% convert to int, round half up
Ar_out = floor(Ar_out.*2^23 + 0.5);
Ai_out = floor(Ai_out.*2^23 + 0.5);
Br_out = floor(Br_out.*2^23 + 0.5);
Bi_out = floor(Bi_out.*2^23 + 0.5);

% write to file
outFile = fopen('outputFromMatlab.txt','w');
for i = 1:length(Ar_out)
    format long g
    fprintf(outFile, '%d %d %d %d\n', Br_out(i), Bi_out(i), Ar_out(i), Ai_out(i));
end
fclose(outFile);