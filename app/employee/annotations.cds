using LeaveManagementService as service from '../../srv/service';

annotate service.Employees with @(

    UI.HeaderInfo             : {
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
        Title         : {
            $Type: 'UI.DataField',
            Value: Name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: EmpNo
        },
        ImageUrl      : 'sap-icon://person-placeholder',
    },

    UI.SelectionFields        : [
        EmpNo,
        Name,
        Email,
        //Department_ID
    ],

    UI.PresentationVariant    : {SortOrder: [{
        Property  : Name,
        Descending: false
    }]},

    UI.LineItem               : [
        {
            $Type: 'UI.DataField',
            Label: 'Emp No',
            Value: EmpNo
        },
        {
            $Type: 'UI.DataField',
            Label: 'Name',
            Value: Name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: Email
        },
        {
            $Type: 'UI.DataField',
            Label: 'Hire Date',
            Value: HireDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Department',
            Value: Department.DeptName
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.getLeaveBalance',
            Label : 'Check Leave Balance'
        }
    ],

    UI.FieldGroup #GeneralInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Emp No',
                Value: EmpNo
            },
            {
                $Type : 'UI.DataField',
                Value : Name,
                Label : 'Name',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email',
                Value: Email
            },
            {
                $Type: 'UI.DataField',
                Label: 'Hire Date',
                Value: HireDate
            },
        ]
    },

    UI.FieldGroup #OrgInfo    : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Manager',
                Value: Manager_ID
            },
            {
                $Type : 'UI.DataField',
                Value : Department_ID,
                Label : 'Department_ID',
            },
        ]
    },

    UI.Facets                 : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneralFacet',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneralInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'OrgFacet',
            Label : 'Organisation Information',
            Target: '@UI.FieldGroup#OrgInfo'
        }
    ],

    UI.Identification         : [{
        $Type : 'UI.DataFieldForAction',
        Action: 'LeaveManagementService.getLeaveBalance',
        Label : 'Check Leave Balance'
    }],
);

 annotate service.Employees with {
    Department @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Departments',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Department_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'DeptCode'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'DeptName'
                }
            ]
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : Department.DeptName,
        UI.TextArrangement             : #TextFirst
    )
};

annotate service.Employees with {
    Manager @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Employees',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Manager_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'EmpNo'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                }
            ]
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : Manager.Name,
        UI.TextArrangement             : #TextFirst
    )
}; 

annotate service.Employees with {
    Email        @Communication.IsEmailAddress: true;
    HireDate     @Common.IsCalendarDate       : true;
    LeaveBalance @Measures.Unit               : 'days';
};

annotate service.Employees with @(odata.draft.enabled);
