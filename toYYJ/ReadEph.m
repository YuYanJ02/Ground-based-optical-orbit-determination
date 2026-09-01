%%%%%%%%%%%%%%%%%%%%%%%
%
% 本程序用于读取星历文件
% dataFolder为星历文件所在文件夹路径
% idx为文件编号（A星或B星）
%
% 作者：尹永辰
% 单位：中国科学院空间应用工程与技术中心，空间探索室
% 时间：2024年07月01日
%%%%%%%%%%%%%%%%%%%%%%%

inputFolder = 'D:\documents\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\toYYJ\EphAll';
% inputFolder = ['BACCData\',inputFolder];
dataFolder = inputFolder;
satODList  = [];

%% 读取星历文件

% 读取文件名
resultFolder  = dir(dataFolder);
iiOD = 1;
for ii = 1:size(resultFolder, 1)
    if contains(resultFolder(ii).name, 'P14Z') && contains(resultFolder(ii).name, '.xml')
        file_name_od = resultFolder(ii).name; % .mat

        % 打开文件，读取定轨数据
        fid = fopen([dataFolder , '\' , file_name_od] , 'r');
        xxOD = zeros(7, 1); xxPost = zeros(7,1);
        while ~feof(fid)
            tline = fgets(fid);
            if contains(tline,'<OBJECT_NAME>')
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                ObjName = strip(xxNow, 'right');
            end

            if contains(tline,'<EPOCH>')
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                Date = double(strsplit(xxNow, {'-','T',':'}));
                xxOD(1) = juliandate(Date(1), Date(2), Date(3), Date(4)-8, Date(5), Date(6));
                tline = fgets(fid);
                for iLoop = 1:6
                    xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                    xxOD(1+iLoop) = double(xxNow);
                    tline = fgets(fid);
                end
                xxOD(2:7) = xxOD(2:7)/1000;
            end
            if contains(tline,'<SRP_CR>')
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                SRP_cr = double(xxNow);
                tline = fgets(fid);
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                drag_cd = double(xxNow);
            end
            if contains(tline,'MASS')
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                mass = double(xxNow);
            end
            if contains(tline,'DRAG_AREA')
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                drag_area = double(xxNow);
                tline = fgets(fid);
                xxNow = eraseBetween(string(tline),"<",">",'Boundaries','inclusive');
                SRP_area = double(xxNow);
                break;
            end
        end
        fclose(fid);
        satOD.ObjName = ObjName;
        satOD.orb = xxOD;
        satOD.satPara.mass = mass;
        satOD.satPara.drag_area = drag_area;
        satOD.satPara.drag_cd = drag_cd;
        satOD.satPara.SRP_area = SRP_area;
        satOD.satPara.SRP_cr = SRP_cr;

        satODList{iiOD,1} = satOD;
        iiOD = iiOD+1;
    end

end







