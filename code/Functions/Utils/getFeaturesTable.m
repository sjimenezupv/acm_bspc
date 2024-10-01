function [ TFeatures ] = getFeaturesTable( Table, Vars, class, class_str, RowNames )
    

    NVars = length(Vars);
    
    TFeatures = table();
   
    for i = 1 : NVars
        
        if istable(Table.(Vars{i}))        
            TFeatures = [TFeatures, Table.(Vars{i})];
            TFeatures.Properties.VariableNames{i} = Vars{i};
        else
            taux = table(Table.(Vars{i}));
            taux.Properties.VariableNames{1} = Vars{i};
            TFeatures = [TFeatures, taux];
        end
        
    end
    
    class = table(class);
    class_str = table(class_str);
    TFeatures = [TFeatures, class, class_str];  
    TFeatures.Properties.RowNames = RowNames;
	
end

