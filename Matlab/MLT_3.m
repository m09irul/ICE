clear all;
clc;
bit = [0 1 0 0 1 0 1 1];

v = 2;

fs = 200;
fm = 2;
bit_duration = 1;
T = bit_duration * length(bit);
t = 0:1/fs:T;

x_digital = zeros(1, length(t));

lastState = 0;
lastNonZeroState = -v;

%encoding
for i = 1:length(bit)
    if bit(i) == 0 % if 0. do nothing
        x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = lastState;
    else % found 1
        if lastState ~= 0 % if last bit non zero: go to 0
            x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = 0;
            lastState = 0;
        else % asi 0 te, paisi 1
               x_digital((i-1)*fs*bit_duration+1 : i*fs*bit_duration) = -lastNonZeroState;
               lastState = -lastNonZeroState;
               lastNonZeroState = -lastNonZeroState;
        end
            
    end
end

plot(t, x_digital);
xlim([0, T]);
ylim([-5, 5]);
grid on;

%demodulation
counter = 0;
data = zeros(1, length(bit));

lastState = 0;
lastNonZeroState = -v;

for i=1:length(t)
    if t(i) > counter*bit_duration
        counter = counter  + 1;
        % if 0 and last state == 0, 
        if x_digital(i) == 0
            if lastState == 0
                data(counter) = 0;
            else
                data(counter) = 1;
            end
            lastState = 0;
        else
            if lastState == 0
                data(counter) = 1;
            else
                data(counter) = 0;
            end
            lastState = 1;
        end
    end
end

disp(data)


