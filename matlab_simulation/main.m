linear_quadratic_regulator;
%x, x_dot, theta, theta_dot, phi, phi_dot
state = [0 0 0.349 0. .0 0];
%control time, initial and final time
dt = 0.01;
t = 0;
t_f = 50;

cost = [];
x_acc = 0;
total = 0;
state_array = state';
control_input = [0 0]';

% state_d = state(3:end);
% state_d(1) = 0.0;
% state_d(2) = 0.;
% state_d(3) = 0;
% state_d(4) = 0.;
state_d = state;
state_d(1) = 1.5;
state_d(2) = 0.;
state_d(3) = 0;
state_d(4) = 0.;
state_d(5) = 1.;
state_d(6) = 0.;

while t < t_f
    %calculate ILQR 
    %[u_l,u_r] = ilqr_fun(state,state_d,P_f,u_ff);
    %u_l = u_l + u_ff*0;
    %u_r = u_r + u_ff*0;
    
    %calculate LQR without pos
    %u = -k_lqr*(state(3:end)' - state_d');
    %calculate LQR with pos
    u = -K_withx*(state' - state_d');
    u_l = u(1) + u_ff;
    u_r = u(2) + u_ff;
    
    control_input = [control_input [u_l u_r]'];

    Q = eye(4);
    R = eye(2);
    cost = [cost,state(3:end)*Q*state(3:end)']; 
    total = total + state(3:end)*Q*state(3:end)';
    
    %forward dynamics
    [theta_ddot,phi_ddot,x_ddot] = forward_dynamic_fun(u_l,u_r,state);
    x_acc = [x_acc,x_ddot];
    %integration
    state = euler_integration_fun(theta_ddot,phi_ddot,x_ddot,state,dt);
    %next step
    t = t + dt;
    
    state_array = [state_array, state'];

%      figure(1);
%      plot(state_array(1,:))
%      figure(2);
%      plot(state_array(5,:))
%     figure(3);
%     plot(control_input(1,:))
%     hold on;
%     plot(control_input(2,:))


    
end
 figure(1);
 plot(state_array(3,:))
 figure(2);
 plot(state_array(5,:))
% figure(3);
% plot(control_input(1,:))
% hold on;
% plot(control_input(2,:))