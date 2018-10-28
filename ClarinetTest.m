%% Test importing symphony v1

disp(['Importing file coming from Sympohony version: ' num2str(SymphonyParser.getVersion('symphony_v1.h5'))]);
ref = SymphonyV1Parser('symphony_v1.h5');
ref.parse;
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
epoch.get('devices')

%% Test importing symphony v2

disp(['Importing file coming from Sympohony version: ' num2str(SymphonyParser.getVersion('symphony_v2.h5'))]);
ref = SymphonyV2Parser('symphony_v2.h5');
ref.parse; % find out where is tree(), now it conflicts with tree.m in one deprecated matlab toolbox, check using "which tree"
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
epoch.get('devices')
