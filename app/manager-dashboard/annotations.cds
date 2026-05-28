using LeaveManagementService as service from '../../srv/service';

annotate service.Manager_LeaveRequests with @(

    UI.HeaderInfo             : {
        TypeName      : 'Manager Request',
        TypeNamePlural: 'Manager Requests',
        Title         : {
            $Type: 'UI.DataField',
            Value: Employee.Name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Status
        },
        ImageUrl      : 'sap-icon://person-placeholder',

    },

    UI.SelectionFields        : [
        Employee_ID,
        LeaveType,
        Status,
        StartDate
    ],

    UI.PresentationVariant    : {SortOrder: [{
        Property  : createdAt,
        Descending: true
    }]},

    UI.LineItem               : [
        {
            $Type: 'UI.DataField',
            Label: 'Employee',
            Value: Employee.Name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Leave Type',
            Value: LeaveType
        },
        {
            $Type: 'UI.DataField',
            Label: 'Start Date',
            Value: StartDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'End Date',
            Value: EndDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Number Of Days',
            Value: NumberOfDays
        },
        {
            $Type       : 'UI.DataField',
            Label       : 'Status',
            Value       : Status,
            Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : 0)
        },
        {
            $Type: 'UI.DataField',
            Label: 'Approved By',
            Value: ApprovedBy.Name
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.approveLeave',
            Label : 'Approve Leave'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.rejectLeave',
            Label : 'Reject Leave'
        }
    ],

    UI.FieldGroup #GeneralInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Request ID',
                Value: ID
            },
            {
                $Type: 'UI.DataField',
                Label: 'Employee',
                Value: Employee.Name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Leave Type',
                Value: LeaveType
            },
            {
                $Type: 'UI.DataField',
                Label: 'Reason',
                Value: Reason
            }
        ]
    },

    UI.FieldGroup #LeaveInfo  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Start Date',
                Value: StartDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'End Date',
                Value: EndDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Number Of Days',
                Value: NumberOfDays
            },
            {
                $Type       : 'UI.DataField',
                Label       : 'Status',
                Value       : Status,
                Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : 0)
            },
            {
                $Type: 'UI.DataField',
                Label: 'Approved By',
                Value: ApprovedBy.Name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Approval Date',
                Value: ApprovalDate
            }
        ]
    },

    UI.FieldGroup #AuditInfo  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Created At',
                Value: createdAt
            },
            {
                $Type: 'UI.DataField',
                Label: 'Created By',
                Value: createdBy
            },
            {
                $Type: 'UI.DataField',
                Label: 'Modified At',
                Value: modifiedAt
            },
            {
                $Type: 'UI.DataField',
                Label: 'Modified By',
                Value: modifiedBy
            }
        ]
    },

    UI.HeaderFacets           : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Details',
        Target: '@UI.FieldGroup#LeaveInfo'
    },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LeaveType',
            Target : '@UI.DataPoint#LeaveType',
        },],

    UI.Facets                 : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneralFacet',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneralInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'LeaveInfoFacet',
            Label : 'Leave Information',
            Target: '@UI.FieldGroup#LeaveInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AuditFacet',
            Label : 'Audit Information',
            Target: '@UI.FieldGroup#AuditInfo'
        }
    ],

    UI.Identification         : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.approveLeave',
            Label : 'Approve Leave',
            Criticality: 3

        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.rejectLeave',
            Label : 'Reject Leave',
            Criticality: 1
        }
    ],
    UI.DataPoint #LeaveType : {
        $Type : 'UI.DataPointType',
        Value : LeaveType,
        Title : 'LeaveType',
        Criticality: 1
    },

);

annotate service.Manager_LeaveRequests with {
    Employee @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Employees',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Employee_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'EmpNo'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Email'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'HireDate'
                }
            ]
        },
        Common.ValueListWithFixedValues: false,
        Common.Text                    : Employee.Name,
        UI.TextArrangement             : #TextFirst
    )
};

annotate service.Manager_LeaveRequests with {
    ApprovedBy @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Employees',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ApprovedBy_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'EmpNo'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Email'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'HireDate'
                }
            ]
        },
        Common.ValueListWithFixedValues: false,
        Common.Text                    : ApprovedBy.Name,
        UI.TextArrangement             : #TextFirst
    )
};

annotate service.Manager_LeaveRequests with {
    LeaveType @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'LeaveTypeView',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: LeaveType,
                ValueListProperty: 'LeaveType'
            }]
        },
        Common.ValueListWithFixedValues: true
    )
};

annotate service.Manager_LeaveRequests with {
    Status @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StatusTypeView',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Status,
                ValueListProperty: 'Status'
            }]
        },
        Common.ValueListWithFixedValues: true
    )
};

annotate service.Manager_LeaveRequests with {
    Status       @Common.FieldControl: #ReadOnly;
    NumberOfDays @Common.FieldControl: #ReadOnly;
    ApprovedBy   @Common.FieldControl: #ReadOnly
};

annotate service.Manager_LeaveRequests with {
    Reason @Common.MultiLineText: true
};

annotate service.Manager_LeaveRequests with @Capabilities.SearchRestrictions: {Searchable: true};

annotate service.LeaveRequests with {
    ApprovedBy @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Employees',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ApprovedBy_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'EmpNo'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Email'
                }
            ]
        },
        Common.ValueListWithFixedValues: true
    )
};
