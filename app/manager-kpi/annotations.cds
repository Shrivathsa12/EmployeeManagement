using LeaveManagementService as service from '../../srv/service';
using from './annotations';


annotate service.LeaveAnalytics with @(

    UI.HeaderInfo                 : {
        TypeName      : 'Leave Analytics',
        TypeNamePlural: 'Leave Analytics',
        Title         : {Value: Status}
    },

    Analytics.AggregatedProperties: [{
        Name                : 'TotalRequests',
        AggregationMethod   : 'sum',
        AggregatableProperty: TotalRequests
    }],

    UI.Chart #LeaveStatusChart    : {
        $Type              : 'UI.ChartDefinitionType',
        Title              : 'Approval Statistics',
        ChartType          : #Column,
        Dimensions         : [Status],
        Measures           : [TotalRequests],
        DimensionAttributes: [{
            Dimension: Status,
            Role     : #Category
        }],
        MeasureAttributes  : [{
            Measure: TotalRequests,
            Role   : #Axis1
        }]
    },

    UI.PresentationVariant        : {Visualizations: ['@UI.Chart#LeaveStatusChart']},

    UI.LineItem                   : [
        {
            $Type       : 'UI.DataField',
            Label       : 'Status',
            Value       : Status,
            Criticality : (Status = 'Approved' ? 3 : Status = 'Pending' ? 2 : Status = 'Rejected' ? 1 : Status = 'Cancelled' ? 1 : 0)

        },
        {
            $Type: 'UI.DataField',
            Label: 'Total Requests',
            Value: TotalRequests
        }
    ],

    UI.DataPoint #Pending         : {
        Value      : TotalRequests,
        Title      : 'Pending',
        Description: 'Pending Requests'
    },

    UI.DataPoint #Approved        : {
        Value      : TotalRequests,
        Title      : 'Approved',
        Description: 'Approved Requests'
    },

    UI.DataPoint #Rejected        : {
        Value      : TotalRequests,
        Title      : 'Rejected',
        Description: 'Rejected Requests'
    },

    UI.KPI #PendingRequests       : {
        DataPoint       : ![@UI.DataPoint#Pending],
        Detail          : {DefaultPresentationVariant: {Visualizations: ['@UI.Chart#LeaveStatusChart']}},
        SelectionVariant: {
            Text         : 'Pending',
            SelectOptions: [{
                PropertyName: 'Status',
                Ranges      : [{
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'Pending'
                }]
            }]
        }
    },

    UI.KPI #ApprovedRequests      : {
        DataPoint       : ![@UI.DataPoint#Approved],
        Detail          : {DefaultPresentationVariant: {Visualizations: ['@UI.Chart#LeaveStatusChart']}},
        SelectionVariant: {
            Text         : 'Approved',
            SelectOptions: [{
                PropertyName: 'Status',
                Ranges      : [{
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'Approved'
                }]
            }]
        }
    },

    UI.KPI #RejectedRequests      : {
        DataPoint       : ![@UI.DataPoint#Rejected],
        Detail          : {DefaultPresentationVariant: {Visualizations: ['@UI.Chart#LeaveStatusChart']}},
        SelectionVariant: {
            Text         : 'Rejected',
            SelectOptions: [{
                PropertyName: 'Status',
                Ranges      : [{
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'Rejected'
                }]
            }]
        }
    },
    UI.Facets                     : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'DashBoard',
        ID    : 'DashBoard',
        Target: '@UI.FieldGroup#DashBoard',
    }, ],
    UI.FieldGroup #DashBoard      : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Status,
                Label: 'Status',
            },
            {
                $Type: 'UI.DataField',
                Value: TotalRequests,
                Label: 'TotalRequests',
            },
        ],
    },

);
