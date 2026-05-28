using TravelManagementService as service from '../../srv/service';

annotate service.Manager_TravelRequests with @(

    UI.HeaderInfo             : {
        TypeName      : 'Manager Travel Request',
        TypeNamePlural: 'Manager Travel Requests',
        Title         : {
            $Type: 'UI.DataField',
            Value: Employee.Name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Status
        },
        ImageUrl      : 'sap-icon://travel-expense',
    },

    UI.SelectionFields        : [
        Employee_ID,
        Status,
        DepartureDate,
        Destination
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
            Label: 'Destination',
            Value: Destination
        },
        {
            $Type: 'UI.DataField',
            Label: 'Purpose',
            Value: Purpose
        },
        {
            $Type: 'UI.DataField',
            Label: 'Departure Date',
            Value: DepartureDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Return Date',
            Value: ReturnDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Estimated Budget',
            Value: EstimatedBudget
        },
        {
            $Type       : 'UI.DataField',
            Label       : 'Status',
            Value       : Status,
            Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Completed' ? 5 : 0)
        },
        {
            $Type: 'UI.DataField',
            Label: 'Approved By',
            Value: Approver.Name
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.approveTravel',
            Label : 'Approve Travel'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.rejectTravel',
            Label : 'Reject Travel'
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
                Label: 'Destination',
                Value: Destination
            },
            {
                $Type: 'UI.DataField',
                Label: 'Purpose',
                Value: Purpose
            }
        ]
    },

    UI.FieldGroup #TravelInfo  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Departure Date',
                Value: DepartureDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Return Date',
                Value: ReturnDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Estimated Budget',
                Value: EstimatedBudget
            },
            {
                $Type: 'UI.DataField',
                Label: 'Actual Budget',
                Value: ActualBudget
            },
            {
                $Type: 'UI.DataField',
                Label: 'Approval Date',
                Value:  ApprovalDate
            },
            {
                $Type       : 'UI.DataField',
                Label       : 'Status',
                Value       : Status,
                Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Completed' ? 5 : 0)
            },
            {
                $Type: 'UI.DataField',
                Label: 'Approved By',
                Value: Approver.Name
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
        Label : 'Travel Details',
        Target: '@UI.FieldGroup#TravelInfo'
    },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Destination',
            Target : '@UI.DataPoint#Destination',
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
            ID    : 'TravelInfoFacet',
            Label : 'Travel Information',
            Target: '@UI.FieldGroup#TravelInfo'
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
            Action     : 'TravelManagementService.approveTravel',
            Label      : 'Approve Travel',
            Criticality: 3
        },
        {
            $Type      : 'UI.DataFieldForAction',
            Action     : 'TravelManagementService.rejectTravel',
            Label      : 'Reject Travel',
            Criticality: 1
        }
    ],
    UI.DataPoint #Destination : {
        $Type : 'UI.DataPointType',
        Value : Destination,
        Title : 'Destination',
        Criticality : 1
    },

);

annotate service.Manager_TravelRequests with {
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

annotate service.Manager_TravelRequests with {
    Approver @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Employees',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Approver_ID,
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
        Common.Text                    : Approver.Name,
        UI.TextArrangement             : #TextFirst
    )
};

annotate service.Manager_TravelRequests with {
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

annotate service.Manager_TravelRequests with {
    Status      @Common.FieldControl: #ReadOnly;
    ActualBudget @Common.FieldControl: #ReadOnly;
    Approver    @Common.FieldControl: #ReadOnly;
    ApprovalDate @Common.FieldControl: #ReadOnly
};

annotate service.Manager_TravelRequests with {
    Purpose @Common.MultiLineText: true
};

annotate service.Manager_TravelRequests with @Capabilities.SearchRestrictions: {Searchable: true};