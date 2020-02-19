% Lab 4

clear all
close all

% Simulation of object motion

rng(5)
N=100; % number of time instants
Delta=1.5; % velocity
A=[1 0 Delta 0; 0 1 0 Delta; 0 0 1 0; 0 0 0 1]; % matrix of the states
sigma_Qx= 0.005;
sigma_Qv= 0.005; % variance of the true observation noise
epsilon=zeros(4,N);
epsilon(1:2,:)=sigma_Qx*randn(2,N);
epsilon(3:4,:)=sigma_Qv*randn(2,N);
z=zeros(4,N); % state vector (over time)
z(:,1)=[0 0 Delta Delta].'; % Initial state: coordinates at time 0 are (0,0)
for i=2:N
    z(:,i)=A*z(:,i-1)+epsilon(:,i);
end


C=[1 0 0 0 ; 0 1 0 0];
sigma_R=2;
delta=sigma_R*randn(2,N);
y=zeros(2,N);
y(:,1)=[0 0].';
Rt = [sigma_R 0; 0 sigma_R];
for i=2:N
    y(:,i)=C*z(:,i)+delta(:,i);
end


mu_0 = [0, 0, 1.5, 1.5]';
mu = mu_0
sigma_0 = [sigma_Qx 0 0 0 ; 0 sigma_Qx 0 0 ; 0 0 sigma_Qv 0 ; 0 0 0 sigma_Qv];
sigma = eye(4);
nostro_z = zeros(N, 2);
for i=1:N
    mu = A*mu;% in this case, B is always zero
    sigma = A*sigma*A' + sigma_0;
    
    y_hat = C*mu + 0; % because D is always zero
    
    Kt = sigma*C'*(C*sigma*C' + Rt)^-1;
    
    rt = y(:,i) - y_hat;
    
    mu = mu + Kt*rt;
    
    sigma = (eye(4) - Kt*C)*sigma;
    nostro_z(i, :) = y_hat;
end
% This figure plots object motion trajectory
figure
plot(z(1,:),z(2,:), 'g')
hold on 
plot(y(1,:), y(2,:), 'b')
plot(nostro_z(:, 1), nostro_z(:, 2), '-r')
grid minor
legend({'true corrdinate', 'observed coordinate', 'estimated coordinate'})
xlabel('x')
ylabel('y')

%%%%%%
figure()
plot(1:N, z(1,:), 'g')
hold on
plot(1:N, y(1,:), 'b')
plot(1:N, nostro_z(:, 1), '-r')
legend({'true corrdinate', 'observed coordinate', 'estimated coordinate'})
xlabel('time')
ylabel('x coordinate')
grid minor

%%
% Try to change the value of delta
% Play with the parameters of sigma Qx and sigma_Qv
% Try to change sigma into a random diagonal matrix to see how the
% behaviour changes