using LeaveManagementService as service from '../../srv/service';

annotate service.Departments with @(
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'DeptCode',
                Value: DeptCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'DeptName',
                Value: DeptName,
            },
            {
                $Type: 'UI.DataField',
                Label: 'BudgetLimit',
                Value: BudgetLimit,
            },
        ],
    },
    UI.Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'General Information',
        Target: '@UI.FieldGroup#GeneratedGroup',
    }, ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'DeptCode',
            Value: DeptCode,
        },
        {
            $Type: 'UI.DataField',
            Label: 'DeptName',
            Value: DeptName,
        },
        {
            $Type: 'UI.DataField',
            Label: 'BudgetLimit',
            Value: BudgetLimit,
        },
    ],
);

annotate service.Departments with @(
    UI.HeaderInfo     : {
        TypeName      : 'Department',
        TypeNamePlural: 'Departments',
        Title         : {
            $Type: 'UI.DataField',
            Value: DeptName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: DeptCode
        }
    },

    UI.SelectionFields: [
        DeptCode,
        DeptName
    ]
);

annotate service.Departments with {
    DeptCode    @Common.Label: 'Department Code';
    DeptName    @Common.Label: 'Department Name';
    BudgetLimit @Common.Label: 'Budget Limit';
};

annotate service.Departments with {
    DeptCode    @Common.FieldControl: #Mandatory;
    DeptName    @Common.FieldControl: #Mandatory;
    BudgetLimit @Common.FieldControl: #Mandatory;
};

annotate service.Departments with {
    DeptName @UI.MultiLineText: true;
};

annotate service.Departments with {
    ID @UI.Hidden;
};

annotate service.Departments with {
    Employees @UI.Hidden;
};

annotate service.Departments with {
    BudgetLimit @Measures.ISOCurrency: 'INR';
};

annotate service.Departments with {
    DeptCode @Common.Text: DeptName;
};
