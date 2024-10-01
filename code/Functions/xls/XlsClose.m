function XlsClose( )
%XLSCLOSE Close any excel process
%   Close any excel process
%
%  http://www.mathworks.com/matlabcentral/fileexchange/10465-xlswrite1
%Description 	
%
% This code increases the speed of the xlswrite function when used in loops
% or multiple times. The problem with the original function is that it 
% opens and closes the Excel server every time the function is used. 
% To increase the speed I have just edited the original function by 
% removing the server open and close function from the xlswrite function 
% and moved them outside of the function. To use this first run the 
% following code which opens the activex server and checks to see if the 
% file already exists (creates if it doesnt):
% 
% Excel = actxserver ('Excel.Application');
% File='C:\YourFileFolder\FileName';
% if ~exist(File,'file')
%     ExcelWorkbook = Excel.workbooks.Add;
%     ExcelWorkbook.SaveAs(File,1);
%     ExcelWorkbook.Close(false);
% end
% invoke(Excel.Workbooks,'Open',File);
% 
% Then run the new xlswrite1 function as many times as needed or in a loop 
% (for example xlswrite1(File,data,location). 
% Then run the following code to close the activex server:
% 
% invoke(Excel.ActiveWorkbook,'Save');
% Excel.Quit
% Excel.delete
% clear Excel

    Excel = actxserver ('Excel.Application');
    %Excel.ActiveWorkbook.Save;
    Excel.Quit
    Excel.delete
    clear Excel

    % http://www.mathworks.com/matlabcentral/answers/98261-why-do-some-excel-processes-fail-to-terminate-after-using-xlsread-xlswrite-or-xlsfinfo-in-matlab
    system('taskkill /F /IM EXCEL.EXE');



end

