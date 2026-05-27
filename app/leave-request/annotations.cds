using LeaveManagementService as service from '../../srv/service';

annotate service.LeaveRequests with @(

    UI.HeaderInfo             : {
        TypeName      : 'Leave Request',
        TypeNamePlural: 'Leave Requests',
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
            Value: Employee.Name,


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
            Label: 'Days',
            Value: NumberOfDays
        },
        {
            $Type       : 'UI.DataField',
            Label       : 'Status',
            Value       : Status,
            Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Cancelled' ? 1 : 0)
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.submitLeaveRequest',
            Label : 'Submit Leave'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'LeaveManagementService.cancelLeave',
            Label : 'Cancel Leave'
        }
    ],

    UI.FieldGroup #GeneralInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Leave Type',
                Value: LeaveType
            },
            {
                $Type: 'UI.DataField',
                Label: 'Reason',
                Value: Reason
            },

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
                Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Cancelled' ? 1 : 0)
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
                $Type                  : 'UI.DataField',
                Label                  : 'Created By',
                Value                  : Employee.Name,
                ![@Common.FieldControl]: #ReadOnly

            },
            {
                $Type: 'UI.DataField',
                Label: 'Modified At',
                Value: modifiedAt
            },
            {
                $Type                  : 'UI.DataField',
                Label                  : 'Modified By',
                Value                  : Employee.Name,
                ![@Common.FieldControl]: #ReadOnly

            }
        ]
    },

    UI.HeaderFacets           : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Details',
        Target: '@UI.FieldGroup#LeaveInfo'
    }],

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
            $Type      : 'UI.DataFieldForAction',
            Action     : 'LeaveManagementService.submitLeaveRequest',
            Label      : 'Submit Leave',
            Criticality: 3

        },
        {
            $Type      : 'UI.DataFieldForAction',
            Action     : 'LeaveManagementService.cancelLeave',
            Label      : 'Cancel Leave',
            Criticality: 1

        }
    ]

);

annotate service.LeaveRequests with @(odata.draft.enabled);

annotate service.LeaveRequests with {
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

annotate service.LeaveRequests with {
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

annotate service.LeaveRequests with {
    Status       @Common.FieldControl: #ReadOnly;
    NumberOfDays @Common.FieldControl: #ReadOnly
};

annotate service.LeaveRequests with {
    Reason @(Common.MultiLineText: true,
    )
};

annotate service.LeaveRequests with @Capabilities.SearchRestrictions: {Searchable: true};
