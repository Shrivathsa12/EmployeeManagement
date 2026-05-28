using TravelManagementService as service from '../../srv/service';

annotate service.TravelRequests with @(

    UI.HeaderInfo             : {
        TypeName      : 'Travel Request',
        TypeNamePlural: 'Travel Requests',
        Title         : {
            $Type: 'UI.DataField',
            Value: Employee.Name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Status
        },
        ImageUrl      : 'sap-icon://flight'
    },

    UI.SelectionFields        : [
        Status,
        DepartureDate,
        ReturnDate
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
            $Type       : 'UI.DataField',
            Label       : 'Status',
            Value       : Status,
            Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Completed' ? 5 : 0)
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.completeTravel',
            Label : 'Complete Travel'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.updateActualBudget',
            Label : 'Update Actual Budget'
        }
    ],

    UI.FieldGroup #GeneralInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [

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
                Label: 'Estimated Budget',
                Value: EstimatedBudget
            },
            {
                $Type: 'UI.DataField',
                Label: 'Actual Budget',
                Value: ActualBudget
            },

        ]
    },

    UI.FieldGroup #TravelInfo : {
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
                $Type       : 'UI.DataField',
                Label       : 'Status',
                Value       : Status,
                Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Completed' ? 5 : 0)
            },
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

            },
        ]
    },

    UI.HeaderFacets           : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Travel Details',
        Target: '@UI.FieldGroup#TravelInfo'
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
            ID    : 'TravelInfoFacet',
            Label : 'Travel Information',
            Target: '@UI.FieldGroup#TravelInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AuditFacet',
            Label : 'Audit Information',
            Target: '@UI.FieldGroup#AuditInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'DocumentsFacet',
            Label : 'Travel Documents',
            Target: 'Documents/@UI.LineItem#TravelDocuments'
        }
    ],

    UI.Identification         : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.completeTravel',
            Label : 'Complete Travel',
            Criticality : 5
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelManagementService.updateActualBudget',
            Label : 'Update Actual Budget',
            Criticality : 2
        }
    ]

);

annotate service.TravelRequests with @(odata.draft.enabled);


annotate service.TravelRequests with {
    Status @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StatusTypeViewforTravel',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Status,
                ValueListProperty: 'Status'
            }]
        },
        Common.ValueListWithFixedValues: true
    )
};


annotate service.TravelRequests with {
    Purpose @Common.MultiLineText: true
};

annotate service.TravelRequests with @Capabilities.SearchRestrictions: {Searchable: true};

annotate service.TravelDocuments with @(UI.LineItem #TravelDocuments: [
    {
        $Type: 'UI.DataField',
        Label: 'File Name',
        Value: FileName
    },
    {
        $Type: 'UI.DataField',
        Label: 'File URL',
        Value: FileURL
    },
    {
        $Type: 'UI.DataField',
        Label: 'Uploaded On',
        Value: UploadedOn
    },
]);


annotate service.TravelRequests with {
    Status       @Common.FieldControl: #ReadOnly;
    Approver     @Common.FieldControl: #ReadOnly;
    ActualBudget @Common.FieldControl: #ReadOnly;
    Employee     @Common.FieldControl: #ReadOnly;
};
