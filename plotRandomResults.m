function plotYBekirogluResults(res)

nO=length(res);
sz=[100 100 1000 800];
font_size = 10;

%%%%%%%%%%%%%%%%%%%%%% Data massaging  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q_m=[];
q_u=[];

 for i=1:nO
	q_m=[q_m; res(i).q_m(:)];
	q_u=[q_u; res(i).q_u(:)];

	if i==1
		continue;
	end
 end

%%%%%%%%%%%%%%%%%%%%%% Boxplot quality criterion Minkowski %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f(1)=figure;
group=[];
data=[];
positions=[];

for i=1:nO
	n_m=numel(res(i).q_m(:));
	n_u=numel(res(i).q_u(:));
	data=[data; res(i).q_m(:); res(i).q_u(:)];
	group=[group; repmat(2*i-1,n_m,1); repmat(2*i,n_u,1)];
	positions=[positions i i+0.35];
	xlabels{i}=res(i).obj.name;
	
	color(2*i-1)='m';
	color(2*i)='b';
end
%ylabels={'0.0'; '0.5'; '1.0'; '1.5'; '2.0'; '2.5'; '3.0'};

boxplot(data,group, 'positions', positions, 'notch','on','medianstyle','target','symbol','r+','DataLim',[0 3],'ExtremeMode','clip');hold on; grid on;

ax=axis;
plot([0 ax(2)],[1 1],'k','LineWidth',1.5);

h = findobj(gca,'Tag','Box');
for i=1:length(h)
	patch(get(h(i),'XData'),get(h(i),'YData'),color(i),'FaceAlpha',1);
end

[h,icons,plots,str] = legend('a','b','c');
h=legend(flipud(plots(2:3)),'Minkowski Sum','Union','Location','NorthWest');
set(h,'Interpreter','latex','FontSize',font_size);
ylabel('$q^*$','interpreter','latex','fontsize',font_size);

h = get(gca,'ylabel');
set(h,'Position',get(h,'Position')+[-0.1 0 0]);
set(gca,'XTickLabel',{' '});
%set(gca,'YTickLabel',{' '});
pos=[1.05 1.9 2.8 3.9];
for i=1:length(xlabels)
	text(pos(i),0,0,xlabels(i),'Interpreter','Latex','fontsize',font_size);
end
% for i=1:length(ylabels)
% 	text(0.65,(i-1)*0.5,0,ylabels(i),'Interpreter','Latex','fontsize',font_size);
% end
%ylim([0 3.25]);
pbaspect([1.8,1,1]);

set(gcf,'PaperPositionMode','auto')
print(gcf,'grasp_quality_random','-dpdf','-r450');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q_m=[res(:).q_m];
q_u=[res(:).q_u];
fprintf('\n');
disp(['q_m: ', num2str(mean(q_m)),'+/-',num2str(std(q_m)),', q_u: ',num2str(mean(q_u)),'+/-',num2str(std(q_u)), ', (mean diff: ', num2str(mean(q_u)/mean(q_m)*100),'%).']); fprintf('\n');

tq_m=[res(:).tq_m];
tq_u=[res(:).tq_u];
disp(['tq_m: ', num2str(mean(tq_m)),'+/-',num2str(std(tq_m)),', tq_u: ',num2str(mean(tq_u)),'+/-',num2str(std(tq_u)), ', (mean diff: ', num2str(mean(tq_u)/mean(tq_m)*100),'%).']); fprintf('\n');

tgws_m=[res(:).tgws_m];
tgws_u=[res(:).tgws_u];
disp(['tgws_m: ', num2str(mean(tgws_m)),'+/-',num2str(std(tgws_m)),', tgws_u: ',num2str(mean(tgws_u)),'+/-',num2str(std(tgws_u)), ', (mean diff: ', num2str(mean(tgws_u)/mean(tgws_m)*100),'%).']); fprintf('\n');

V_m=[res(:).V_m];
V_u=[res(:).V_u];
disp(['V_m: ', num2str(mean(V_m)),'+/-',num2str(std(V_m)),', V_u: ',num2str(mean(V_u)),'+/-',num2str(std(V_u)), ', (mean diff: ', num2str(mean(V_u)/mean(V_m)*100),'%).']); fprintf('\n');

fc_m=[res(:).fc_m];
fc_u=[res(:).fc_u];
fc=find(fc_u > 0);
disp([num2str(length(fc)), ' of ', num2str(length(fc_u)), ' grasps are force closure (', num2str(length(fc)/length(fc_u)*100), '%).']); fprintf('\n');

eps_m=[res(:).eps_m]; eps_m=eps_m(fc);
eps_u=[res(:).eps_u]; eps_u=eps_u(fc);
disp(['eps_m: ', num2str(mean(eps_m)),'+/-',num2str(std(eps_m)),', eps_u: ',num2str(mean(eps_u)),'+/-',num2str(std(eps_u)), ', (mean diff: ', num2str(mean(eps_u)/mean(eps_m)*100),'%).']); fprintf('\n');

